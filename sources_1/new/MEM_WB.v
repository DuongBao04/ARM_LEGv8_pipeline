`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 06:00:41 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input clk, reset,
    input RegWrite_M, MemWrite_M, MemToReg_M, MemRead_M,
    input [63:0] ALUResult_M,
    input [63:0] ReadData2_M,
    input [4:0] DestinationReg_M,
    
    output reg [63:0] ReadData,
    output reg [63:0] ALUResult_W,
    output reg MemToReg_W, RegWrite_W,
    output reg [4:0] DestinationReg_W
 );
    wire [63:0] ReadData_wire;
    DataMemory dataMem (
        .clk(clk),
        .reset(reset),
        .MemRead(MemRead_M),
        .MemWrite(MemWrite_M),
        .addr(ALUResult_M),
        .WriteData(ReadData2_M),
        .ReadData(ReadData_wire)
    );
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            ReadData <= 64'd0;
            MemToReg_W <= 1'b0;
            RegWrite_W <= 1'b0;
            ALUResult_W <= 64'd0;
            DestinationReg_W <= 4'd0;
        end else begin
            ReadData <= ReadData_wire;
            MemToReg_W <= MemToReg_M;
            RegWrite_W <= RegWrite_M;
            ALUResult_W <= ALUResult_M;
            DestinationReg_W <= DestinationReg_M;
        end
    end



endmodule
