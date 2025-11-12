`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 08:40:45 PM
// Design Name: 
// Module Name: mux2X1
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


module mux2X1 #(
    parameter DATA_BITS = 32
)(
    input [DATA_BITS - 1:0] a, b,
    input sel,
    
    output [DATA_BITS -1:0] data_out    
);
assign data_out = (sel == 0) ? a : b;
endmodule