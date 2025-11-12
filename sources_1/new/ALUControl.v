`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 10:07:39 AM
// Design Name: 
// Module Name: ALUControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ALU Control logic for ARMv8-like processor
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.vh"
module ALUControl(
    input  [1:0]  ALUOp,
    input  [10:0] opcode,
    output reg [3:0] ALUCtrl
);
    always @(*) begin
        case (ALUOp)
            2'b00 : ALUCtrl = `ALU_ADD;          // Load / Store
            2'b01 : ALUCtrl = `ALU_PASS_INPUT_B; // Branch compare
            2'b10 : begin
                case (opcode)
                    11'h458: ALUCtrl = `ALU_ADD;          // ADD
                    11'h658: ALUCtrl = `ALU_SUB;          // SUB
                    11'h450: ALUCtrl = `ALU_AND;          // AND
                    11'h550: ALUCtrl = `ALU_OR;           // ORR
                    11'h650: ALUCtrl = `ALU_XOR;          // EOR
                    11'h69B: ALUCtrl = `ALU_LSHIFT_LEFT;  // LSL
                    11'h69A: ALUCtrl = `ALU_LSHIFT_RIGHT; // LSR
                    default: ALUCtrl = `NOP;              // Default NOP
                endcase
            end
            2'b11 : begin
                case (opcode[10:1])
                    10'b1001000100: begin ALUCtrl = `ALU_ADD; end
                    10'b1001001000: begin ALUCtrl = `ALU_AND; end
                    10'b1011001000: begin ALUCtrl = `ALU_OR; end
                    10'b1101000100: begin ALUCtrl = `ALU_SUB; end
                endcase
            end
            default: ALUCtrl = `NOP;
        endcase
    end
endmodule
