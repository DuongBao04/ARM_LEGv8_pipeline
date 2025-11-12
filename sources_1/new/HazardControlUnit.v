`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 09:15:40 AM
// Design Name: 
// Module Name: HazardControlUnit
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


module HazardControlUnit(
    input reset, 
    input MemRead_E,               
    input [4:0] Rd_E,              
    input [4:0] Rs1_D, Rs2_D,      
    output reg ID_EX_Flush,        
    output reg PCWrite,            
    output reg IF_ID_Write         
);

always @(*) begin
    if (reset) begin
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        ID_EX_Flush = 1'b0;
    end 
    else if (MemRead_E &&
            ((Rd_E == Rs1_D) || (Rd_E == Rs2_D)) &&
            (Rd_E != 5'd0)) begin 
                PCWrite     = 1'b0;  // gi? PC
                IF_ID_Write = 1'b0;  // gi? IF/ID
                ID_EX_Flush = 1'b1;  // chèn bubble
            end 
    else begin
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        ID_EX_Flush = 1'b0;
    end
end
endmodule
