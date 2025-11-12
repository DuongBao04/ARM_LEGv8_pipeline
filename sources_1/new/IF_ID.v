`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 07:37:24 PM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clk, reset,
    input PCWrite, IF_ID_Write,
    input PCSrc,
    input [9:0] PCTarget,
    
    output reg [31:0] instruction_D,
    output reg [9:0] current_pc_D    
);
    wire [9:0] next_pc, pc_plus4;
    wire [31:0] instruction;
    wire [9:0] current_pc;

    mux2X1 #(.DATA_BITS(10)) PCMux (
        .a(pc_plus4),
        .b(PCTarget),
        .sel(PCSrc),
        .data_out(next_pc)
    );
    
    ProgramCounter Pc_inst (
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );
   
    PC_Adder PC_add_inst (
        .a(current_pc),
        .b(10'd4),
        .result(pc_plus4)
    );
   
    InstructionMemory Imem_inst (
        .reset(reset),
        .current_pc(current_pc),
        .instruction(instruction)
    );
   
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_D   <= 32'b0;
            current_pc_D    <= 10'b0;
        end else if (IF_ID_Write) begin
            instruction_D   <= instruction;
            current_pc_D    <= current_pc;
        end     
    end
    
    
    
    
endmodule
