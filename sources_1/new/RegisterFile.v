`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 03:11:57 PM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input clk, reset,
    input [4:0] rs1, rs2, WriteReg,
    input RegWrite,
    input [63:0] WriteData,
    
    output [63:0] ReadData1, ReadData2
);
    reg [63:0] registerData[31:0];
    integer k;
    
    assign ReadData1 = (reset) ? 64'h0 : registerData[rs1];
    assign ReadData2 = (reset) ? 64'h0 : registerData[rs2];
    
    always @(*) begin
        if (reset) begin
            for (k = 0; k < 32; k = k + 1) begin
                registerData[k] = 64'b0;
            end 
        end else 
		if (RegWrite == 1 && (WriteReg != 5'h0) ) begin
			registerData[WriteReg] <= WriteData;
		end
	end
    
endmodule
