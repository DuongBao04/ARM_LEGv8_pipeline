`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 07:10:25 PM
// Design Name: 
// Module Name: InstructionMemory
// Project Name: LEGv8 Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Instruction memory for LEGv8 (1024 bytes)
// 
// Dependencies: None
// 
// Revision:
// Revision 0.02 - Load sample ADDI instructions
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module InstructionMemory(
    input reset,
    input [9:0] current_pc,
    output [31:0] instruction
);
    reg [7:0] InstrMemData [1023:0];
    integer k;

    // Combine 4 bytes into a 32-bit instruction (little-endian)
    assign instruction = (reset) ? 32'h0 : {
        InstrMemData[current_pc + 3],
        InstrMemData[current_pc + 2],
        InstrMemData[current_pc + 1],
        InstrMemData[current_pc + 0]
    };

    always @(posedge reset) begin
        if (reset) begin
            // Initialize memory
            for (k = 0; k < 1024; k = k + 1)
                InstrMemData[k] = 8'b0;

            // =============================
            // For testing only
            // =============================

            // ADDI X1, X0, #5   ? 0x91001401
            InstrMemData[0]  = 8'h01;
            InstrMemData[1]  = 8'h14;
            InstrMemData[2]  = 8'h00;
            InstrMemData[3]  = 8'h91;

            // ADDI X2, X0, #10  ? 0x91002802
            InstrMemData[4]  = 8'h02;
            InstrMemData[5]  = 8'h28;
            InstrMemData[6]  = 8'h00;
            InstrMemData[7]  = 8'h91;
            
            // ADDI X3, X0, #15  ? 0x91003C03
            InstrMemData[8]  = 8'h03;
            InstrMemData[9]  = 8'h3C;
            InstrMemData[10] = 8'h00;
            InstrMemData[11] = 8'h91;
            
            // ADDI X4, X3, #3   ? 0x91000C64
            InstrMemData[12]  = 8'h64;
            InstrMemData[13]  = 8'h0C;
            InstrMemData[14]  = 8'h00;
            InstrMemData[15]  = 8'h91;
            
            // LDUR X5, [X6, #0] ? 0xF8400065
            InstrMemData[16] = 8'h65;
            InstrMemData[17] = 8'h00;
            InstrMemData[18] = 8'h40;
            InstrMemData[19] = 8'hF8;
            
            // ADD X6, X5, X4    ? 0x8B0400A6
            InstrMemData[20] = 8'hA6;
            InstrMemData[21] = 8'h00;
            InstrMemData[22] = 8'h04;
            InstrMemData[23] = 8'h8B;

        end
    end

endmodule
