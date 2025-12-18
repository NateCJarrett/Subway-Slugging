`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 11:06:14 PM
// Design Name: 
// Module Name: AddSub8
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


module AddSub4(
    input [3:0] A_i,
    input [3:0] B_i,
    input sub_i,
    output [3:0] S_o,
    output ovfl_o
    );
    
    // Imported adder files from Lab 2, changed from a 8 bit adder to a 4 bit adder
    
    wire [3:0] sum_o;
    wire [3:0] diff_o;
    wire [3:0] B_flipped;
    wire [3:0] B_inv = ~B_i;
    wire add_ovfl_o, sub_ovfl_o, flip_ovfl_o, diff_ovfl_o;
    
    Add4 flip (.A_i(4'd1), .B_i(B_inv), .ovfl_o(flip_ovfl_o), .S_o(B_flipped));
    
    Add4 sum (.A_i(A_i), .B_i(B_i), .ovfl_o(add_ovfl_o), .S_o(sum_o)); // Add the numbers
    Add4 diff (.A_i(A_i), .B_i(B_flipped), .ovfl_o(diff_ovfl_o), .S_o(diff_o)); // Subtract the number
    
    mux4bit op (.i0(sum_o), .i1(diff_o), .s(sub_i), .y(S_o)); // Pick the operation
    
    assign sub_ovfl_o = flip_ovfl_o | diff_ovfl_o ;
    assign ovfl_o = (~sub_i & ~add_ovfl_o) | (sub_i & sub_ovfl_o); // Select the overflow
endmodule
