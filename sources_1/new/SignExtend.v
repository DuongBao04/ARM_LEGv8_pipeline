`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 11:25:34 AM
// Design Name: 
// Module Name: SignExtend
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


module SignExtend(
    input  [31:0] instruction,
    output reg [63:0] signExtendedData
);
    always @(*) begin
        if (instruction[31:26] == 6'b000101) begin
            // B-type: offset = instruction[25:0]
            signExtendedData[25:0]  = instruction[25:0];
            signExtendedData[63:26] = {38{instruction[25]}};

        end else if (instruction[31:24] == 8'b10110100) begin
            // CBZ-type: offset = instruction[23:5]
            signExtendedData[18:0]  = instruction[23:5];
            signExtendedData[63:19] = {45{instruction[23]}};
    
        end else if (instruction[31:22] == 10'b1001000100 ||
                     instruction[31:22] == 10'b1001001000 ||
                     instruction[31:22] == 10'b1011001000 ||
                     instruction[31:22] == 10'b1101000100) begin
            // I-type
            signExtendedData[11:0]  = instruction[21:10];
            signExtendedData[63:12] = {52{instruction[21]}};

        end else begin
            // D-type: offset = instruction[20:12]
            signExtendedData[8:0]   = instruction[20:12];
            signExtendedData[63:9]  = {55{instruction[20]}};
        end
    end
endmodule

