`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 10:33:32 PM
// Design Name: 
// Module Name: fa
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


module fa(
    input a_i,
    input b_i,
    input cin_i,
    output s_o,
    output cout_o
    );
    
    wire c1,c2,s1;
       
    ha ha_1 (.a_i(a_i), .b_i(b_i), .c_o(c1), .s_o(s1)); // Half Adder 1
    ha ha_2 (.a_i(s1), .b_i(cin_i), .c_o(c2), .s_o(s_o)); // Half Adder 2
    
    assign cout_o = c1 | c2; // Output carry
   
endmodule
