`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 07:08:34 PM
// Design Name: 
// Module Name: LEGv8_pipeline
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


module LEGv8_pipeline(
    input clk, reset
);

// =====================
// Program Counter wires
// =====================
wire PCSrc;
wire [9:0] PCTarget;
    
// =====================
// Fetch -> Decode wires
// =====================
wire [31:0] instruction_D;
wire [9:0] current_pc_D;

// =====================
// Decode -> Execute wires
// =====================
wire RegWrite_E, ALUSrc_E, MemWrite_E, MemToReg_E, Branch_E, MemRead_E;
wire [1:0] ALUOp_E;
wire [63:0] ReadData1_E, ReadData2_E, signExtendedData_E;
wire [10:0] opcode_E;
wire [4:0] DestinationReg_E, Rs1_E, Rs2_E;

// =====================
// Execute -> Memory wires
// =====================
wire RegWrite_M, MemWrite_M, MemToReg_M, MemRead_M;
wire [63:0] ALUResult_M;
wire [63:0] ReadData2_M;
wire [4:0] DestinationReg_M;

// =====================
// Memory -> Writeback wires
// =====================
wire [63:0] ReadData;
wire [63:0] ALUResult_W;
wire [4:0] DestinationReg_W;
wire MemToReg_W, RegWrite_W;

wire [63:0] Result_W; // From WriteBack mux output

// =====================
// Forwarding and hazard control wires
// =====================
wire [1:0] ForwardA, ForwardB;
wire [4:0] Rs1_E, Rs2_E;
wire IF_ID_Write, PCWrite, ID_EX_Flush;
    
    // Fetch stage
    IF_ID Fetch (
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .PCSrc(PCSrc),
        .PCTarget(PCTarget),
        
        .instruction_D(instruction_D),
        .current_pc_D(current_pc_D)
    ); 
    
    // Decode Stage 
    ID_EX Decode (
        .clk(clk),
        .reset(reset),
        .ID_EX_Flush(ID_EX_Flush),
        .current_pc_D(current_pc_D),
        .instruction_D(instruction_D),
        .Result_W(Result_W),
        .RegWrite_W(RegWrite_W),
        .DestinationReg_W(DestinationReg_W),
        
        .RegWrite_E(RegWrite_E), 
        .ALUSrc_E(ALUSrc_E), 
        .MemWrite_E(MemWrite_E), 
        .MemToReg_E(MemToReg_E), 
        .Branch_E(Branch_E), 
        .MemRead_E(MemRead_E),
        .ALUOp_E(ALUOp_E),
        .ReadData1_E(ReadData1_E),
        .ReadData2_E(ReadData2_E),
        .signExtendedData_E(signExtendedData_E),
        .opcode_E(opcode_E),
        .DestinationReg_E(DestinationReg_E),
        .current_pc_E(current_pc_E),
        .Rs1_E(Rs1_E),
        .Rs2_E(Rs2_E)
    );
    
    // Execute Stage
    EX_MEM Execute (
        .clk(clk), .reset(reset),
        .RegWrite_E(RegWrite_E), 
        .ALUSrc_E(ALUSrc_E), 
        .MemWrite_E(MemWrite_E), 
        .MemToReg_E(MemToReg_E), 
        .Branch_E(Branch_E), 
        .MemRead_E(MemRead_E),
        .ALUOp_E(ALUOp_E),
        .ReadData1_E(ReadData1_E),
        .ReadData2_E(ReadData2_E),
        .signExtendedData_E(signExtendedData_E),
        .opcode_E(opcode_E),
        .DestinationReg_E(DestinationReg_E),
        .current_pc_E(current_pc_E),
        
        // From Forwarding Unit
        .Result_W(Result_W),
        .ForwardA(ForwardA), .ForwardB(ForwardB),
        
        .PCTarget(PCTarget),
        .PCSrc(PCSrc),
        .RegWrite_M(RegWrite_M), 
        .MemWrite_M(MemWrite_M), 
        .MemToReg_M(MemToReg_M), 
        .MemRead_M(MemRead_M),
        .ALUResult_M(ALUResult_M),
        .DestinationReg_M(DestinationReg_M),
        .ReadData2_M(ReadData2_M)
    );
    
    // Memory Stage
    MEM_WB Memory (
        .clk(clk), .reset(reset),
        .RegWrite_M(RegWrite_M), 
        .MemWrite_M(MemWrite_M), 
        .MemToReg_M(MemToReg_M), 
        .MemRead_M(MemRead_M),
        .ALUResult_M(ALUResult_M),
        .DestinationReg_M(DestinationReg_M),
        .ReadData2_M(ReadData2_M),
        
        .ReadData(ReadData),
        .MemToReg_W(MemToReg_W),
        .RegWrite_W(RegWrite_W),
        .ALUResult_W(ALUResult_W),
        .DestinationReg_W(DestinationReg_W)
    );
    
    // Writeback stage
    mux2X1 #(.DATA_BITS(64)) WriteBack (
        .a(ALUResult_W),
        .b(ReadData),
        .sel(MemToReg_W),
        .data_out(Result_W)
    );
    
    // Forwarding
    ForwardingUnit fd_inst (
        .reset(reset),
        .RegWrite_M(RegWrite_M),
        .RegWrite_W(RegWrite_W),
        .DestinationReg_M(DestinationReg_M),
        .DestinationReg_W(DestinationReg_W),
        .Rs1_E(Rs1_E),
        .Rs2_E(Rs2_E),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    
    // Hazard Control Unit
    HazardControlUnit hu_inst (
        .reset(reset),
        .MemRead_E(MemRead_E),
        .Rd_E(DestinationReg_E),
        .Rs1_D(instruction_D[9:5]),
        .Rs2_D(instruction_D[20:16]),
        .ID_EX_Flush(ID_EX_Flush),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write)
    );

endmodule
