`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 10:25:45 AM
// Design Name: 
// Module Name: tb_LEGv8_pipeline
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


module tb_LEGv8_pipeline();
    reg clk, reset;
    LEGv8_pipeline uut (
        .clk(clk),
        .reset(reset)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end
    
    
    initial begin
        reset = 1;
        #10;
        reset = 0;

        repeat(8) @(posedge clk);
    end

endmodule
