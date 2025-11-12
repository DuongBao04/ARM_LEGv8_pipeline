`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 05:01:19 PM
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input clk, reset,
    // From ID_EX
    input ALUSrc_E, MemToReg_E, RegWrite_E, MemRead_E, MemWrite_E, Branch_E,
    input [1:0] ALUOp_E,    
    input [10:0] opcode_E,
    input [63:0] ReadData1_E, ReadData2_E , signExtendedData_E,
    input [4:0] DestinationReg_E,
    input [9:0] current_pc_E,
    
    // Data_Forwarding
    input [63:0] Result_W,    
    input [1:0] ForwardA, ForwardB,    
    
    output [9:0] PCTarget,
    output PCSrc,
    output reg [63:0] ALUResult_M,
    output reg RegWrite_M, MemWrite_M, MemToReg_M, MemRead_M,
    output reg [4:0] DestinationReg_M,
    output reg [63:0] ReadData2_M
);
    wire [3:0] ALUCtrl;
    wire [63:0] SrcA, SrcB, SrcB_tmp;
    wire [63:0] ALUResult, shiftedResult;

    ALUControl aluctrl_inst (
        .ALUOp(ALUOp_E),
        .opcode(opcode_E),
        .ALUCtrl(ALUCtrl)
    );
    
    mux3X1 srca_mux (
        .a(ReadData1_E),
        .b(Result_W),
        .c(ALUResult_M),
        .sel(ForwardA),
        .data_out(SrcA)
    );
    
    mux3X1 srcb_mux (
        .a(ReadData2_E),
        .b(Result_W),
        .c(ALUResult_M),
        .sel(ForwardB),
        .data_out(SrcB_tmp)
    );
    
    mux2X1 #(.DATA_BITS(64)) alu_mux (
        .a(SrcB_tmp),
        .b(signExtendedData_E),
        .sel(ALUSrc_E),
        .data_out(SrcB)
    );
    
    ALU alu_inst (
        .A(SrcA),
        .B(SrcB),
        .ALUCtrl(ALUCtrl),
        .result(ALUResult),
        .Zero(Zero)
    );
    
    PC_Adder branch_adder (
        .a(current_pc_E),
        .b(shiftedResult),
        .result(PCTarget)
    );
    
    ShiftLeft2 sl2_inst (
        .inputData(signExtendedData_E),
        .outputData(shiftedResult)
    );
    
    assign PCSrc = Zero & Branch_E;
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            ALUResult_M <= 64'b0;
            RegWrite_M <= 0;
            MemWrite_M <= 0;
            MemToReg_M <= 0;
            MemRead_M <= 0;
            DestinationReg_M <= 4'b0;
            ReadData2_M <= 64'd0;
        end else begin
            ALUResult_M <= ALUResult;
            RegWrite_M <= RegWrite_E ;
            MemWrite_M <= MemWrite_E ;
            MemToReg_M <= MemToReg_E ;
            MemRead_M  <= MemRead_E;
            DestinationReg_M <= DestinationReg_E;
            ReadData2_M <= SrcB_tmp;
        end
    end

endmodule
