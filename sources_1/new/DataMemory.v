`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 05:55:07 PM
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input clk, reset,
    input [63:0] addr, WriteData,
    input MemRead, MemWrite,
    
    output [63:0] ReadData
);
    reg [63:0] memoryData [127:0]; // max is 2^64
    integer k;
    
    always@(posedge clk or posedge reset) begin
        if (MemWrite) begin
            memoryData[addr] <=  WriteData;
        end else if (reset) begin
            for (k = 0;k<128;k = k + 1) begin
                memoryData[k] <= 63'd0;
            end
        end
    end
    
    assign ReadData = (MemRead) ? memoryData[addr] : 32'h0000_0000;
endmodule
