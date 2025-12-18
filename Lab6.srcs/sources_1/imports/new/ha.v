`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 01:33:48 PM
// Design Name: 
// Module Name: ha
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


module ha(
    input a_i,
    input b_i,
    output c_o,
    output s_o
    );
    
    assign c_o = a_i & b_i; // Carry
    assign s_o = ~(c_o | ~ (a_i | b_i) ); // Sum
endmodule
