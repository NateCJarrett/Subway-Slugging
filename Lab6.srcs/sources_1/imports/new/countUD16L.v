`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 02:20:25 PM
// Design Name: 
// Module Name: countUD16L
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


module countUD16L(
    input clk_i,
    input up_i,
    input dw_i,
    input ld_i,
    input [15:0] Din_i,
    output [15:0] Q_o,
    output utc_o,
    output dtc_o
    );
    
    wire u1, u2, u3, u4, d1, d2, d3, d4;
    wire u1_e, u2_e, u3_e, d1_e, d2_e, d3_e;
    
    assign u1_e = up_i & u1;
    assign u2_e = up_i & u1 & u2;
    assign u3_e = up_i & u1 & u2 & u3;
    assign d1_e = dw_i & d1;
    assign d2_e = dw_i & d1 & d2;
    assign d3_e = dw_i & d1 & d2 & d3;
    assign utc_o = u1 & u2 & u3 & u4;
    assign dtc_o = d1 & d2 & d3 & d4;
    
    countUD4L b4 (.clk_i(clk_i), .up_i(up_i), .dw_i(dw_i), .ld_i(ld_i), .Din_i(Din_i[3:0]), .Q_o(Q_o[3:0]), .utc_o(u1), .dtc_o(d1)); // First 4 bits
    countUD4L b8 (.clk_i(clk_i), .up_i(u1_e), .dw_i(d1_e), .ld_i(ld_i), .Din_i(Din_i[7:4]), .Q_o(Q_o[7:4]), .utc_o(u2), .dtc_o(d2)); // Second 4 bits
    countUD4L b12 (.clk_i(clk_i), .up_i(u2_e), .dw_i(d2_e), .ld_i(ld_i), .Din_i(Din_i[11:8]), .Q_o(Q_o[11:8]), .utc_o(u3), .dtc_o(d3)); // Third 4 bits
    countUD4L b16 (.clk_i(clk_i), .up_i(u3_e), .dw_i(d3_e), .ld_i(ld_i), .Din_i(Din_i[15:12]), .Q_o(Q_o[15:12]), .utc_o(u4), .dtc_o(d4)); // Final 4 bits
endmodule
