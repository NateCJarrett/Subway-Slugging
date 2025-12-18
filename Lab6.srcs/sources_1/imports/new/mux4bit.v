`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 10:26:52 PM
// Design Name: 
// Module Name: mux8bit
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


module mux4bit(
    input [3:0] i0,
    input [3:0] i1,
    input s,
    output [3:0] y
    );
    
    assign y = (~{4{s}} & i0) | ({4{s}} & i1);
endmodule
