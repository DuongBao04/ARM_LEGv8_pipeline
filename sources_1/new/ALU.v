`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 11:25:50 AM
// Design Name: 
// Module Name: ALU
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

`include "defines.vh"
module ALU(
    input [63:0] A, B,
    input [3:0] ALUCtrl,
    output reg [63:0] result,
    output reg Zero
);
    assign {Cout, sub_result} = {1'b0, A} + ~{1'b0, B} + 1'b1; //2's Complement
    always@(*) begin
        case(ALUCtrl) 
            `ALU_AND: result <= A & B;
            `ALU_OR : result <= A | B;
            `ALU_ADD: result <= A + B;
            `ALU_XOR: result <= A ^ B;
            `ALU_LSHIFT_LEFT: result <= A << B;
            `ALU_LSHIFT_RIGHT: result <= A >> B;
            `ALU_SUB: result <= sub_result;
        endcase
        
        Zero <= (sub_result == 0) ? 1'b1 : 1'b0;
    end
endmodule
