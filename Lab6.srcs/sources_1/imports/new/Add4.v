`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 10:35:50 PM
// Design Name: 
// Module Name: Add8
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


module Add4(
    input [3:0] A_i,
    input [3:0] B_i,
    output cout_o,
    output ovfl_o,
    output [3:0] S_o
    );
    
    wire c1, c2, c3; // Each "wire" is a physical wire, not just a variable
    
    fa fa_0 (.a_i(A_i[0]), .b_i(B_i[0]), .cin_i(1'b0), .s_o(S_o[0]), .cout_o(c1)); // FA 1
    fa fa_1 (.a_i(A_i[1]), .b_i(B_i[1]), .cin_i(c1), .s_o(S_o[1]), .cout_o(c2)); // FA 2
    fa fa_2 (.a_i(A_i[2]), .b_i(B_i[2]), .cin_i(c2), .s_o(S_o[2]), .cout_o(c3)); // FA 3
    fa fa_3 (.a_i(A_i[3]), .b_i(B_i[3]), .cin_i(c3), .s_o(S_o[3]), .cout_o(cout_o)); // FA 4
    
    assign ovfl_o = cout_o ^ c3;
    
endmodule
