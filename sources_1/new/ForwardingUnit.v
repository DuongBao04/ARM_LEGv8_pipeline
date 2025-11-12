`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 11:32:53 PM
// Design Name: 
// Module Name: ForwardingUnit
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

module ForwardingUnit(
    input reset, RegWrite_M, RegWrite_W,
    input [4:0] DestinationReg_M, DestinationReg_W, Rs1_E, Rs2_E,
    output [1:0] ForwardA, ForwardB
);
    
    assign ForwardA = (reset) ? 2'b00 : 
                    ((RegWrite_W) & (DestinationReg_W != 0) &(DestinationReg_W == Rs1_E)) ? 2'b01 :
                    ((RegWrite_M) & (DestinationReg_M != 0) &(DestinationReg_M == Rs1_E)) ? 2'b10 : 2'b00;
   
    assign ForwardB = (reset) ? 2'b00 : 
                    ((RegWrite_W) & (DestinationReg_W != 0) &(DestinationReg_W == Rs2_E)) ? 2'b01 :
                    ((RegWrite_M) & (DestinationReg_M != 0) &(DestinationReg_M == Rs2_E)) ? 2'b10 : 2'b00;
endmodule