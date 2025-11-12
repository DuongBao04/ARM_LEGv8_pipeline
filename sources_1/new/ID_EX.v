`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 02:47:26 PM
// Design Name: 
// Module Name: ID_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_EX(
    input clk, reset,
    input ID_EX_Flush,
    input [31:0] instruction_D,
    input [9:0] current_pc_D,
    
    // Signal from WriteBack
    input [63:0] Result_W,
    input RegWrite_W,
    input [4:0] DestinationReg_W,
    
    output reg ALUSrc_E, MemToReg_E, RegWrite_E, MemRead_E, MemWrite_E, Branch_E,
    output reg [1:0] ALUOp_E,
    output reg [63:0] ReadData1_E, ReadData2_E, signExtendedData_E,
    output reg [10:0] opcode_E,
    output reg [4:0] DestinationReg_E, Rs1_E, Rs2_E,
    output reg [9:0] current_pc_E
);

    wire Reg2Loc, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch;
    wire [1:0] ALUOp;
    wire [63:0] ReadData1, ReadData2, signExtendedData;
    wire [4:0] rs2_muxdata;

    ControlUnit cu_inst (
        .opcode(instruction_D[31:21]),
        .Reg2Loc(Reg2Loc),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );
    
    mux2X1 #(.DATA_BITS(5)) rs2Mux_inst (
        .a(instruction_D[20:16]),
        .b(instruction_D[4:0]),
        .sel(Reg2Loc),
        .data_out(rs2_muxdata)
    );
    
    RegisterFile regfile (
        .clk(clk), .reset(reset),
        .rs1(instruction_D[9:5]), .rs2(rs2_muxdata), 
        .WriteReg(DestinationReg_W), .RegWrite(RegWrite_W), .WriteData(Result_W),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );
    
    SignExtend signex_inst (
        .instruction(instruction_D),
        .signExtendedData(signExtendedData)
    );
    
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_E     <= 0;
            ALUSrc_E       <= 0;
            MemWrite_E     <= 0;
            MemToReg_E     <= 0;
            Branch_E       <= 0;
            MemRead_E      <= 0;
            ALUOp_E        <= 2'b00;
            current_pc_E   <= 10'd0;
            DestinationReg_E    <= 5'b0;
            Rs1_E               <= 5'b0;
            Rs2_E               <= 5'b0;
            signExtendedData_E <= 64'b0;
            ReadData1_E     <= 64'd0;
            ReadData2_E     <= 64'd0;
            opcode_E        <= 11'b0;
        end else if (ID_EX_Flush) begin
            RegWrite_E     <= 1'b0;
            ALUSrc_E       <= 1'b0;
            MemWrite_E     <= 1'b0;
            MemToReg_E     <= 1'b0;
            Branch_E       <= 1'b0;
            MemRead_E      <= 1'b0;
            ALUOp_E        <= 2'b00;
        end else begin
            RegWrite_E     <= RegWrite  ;
            ALUSrc_E       <= ALUSrc    ;
            MemWrite_E     <= MemWrite  ;
            MemToReg_E     <= MemToReg  ;
            Branch_E       <= Branch    ;
            MemRead_E      <= MemRead   ;
            ALUOp_E        <= ALUOp     ;
            current_pc_E    <= current_pc_D;
            opcode_E        <= instruction_D[31:21];
            DestinationReg_E <= instruction_D[4:0];
            Rs1_E               <= instruction_D[9:5];
            Rs2_E               <= instruction_D[20:16];
            signExtendedData_E <= signExtendedData;
            
            ReadData1_E     <= ReadData1;
            ReadData2_E     <= ReadData2;
        end
    end
    
    
endmodule
