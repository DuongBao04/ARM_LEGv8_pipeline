`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 06:53:14 PM
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
    input clk, reset,
    input PCWrite, 
    input [9:0] next_pc,
    output reg [9:0] current_pc
 );
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            current_pc <= 0;
        end else if (PCWrite) begin
            current_pc <= next_pc;
        end
    end
endmodule
