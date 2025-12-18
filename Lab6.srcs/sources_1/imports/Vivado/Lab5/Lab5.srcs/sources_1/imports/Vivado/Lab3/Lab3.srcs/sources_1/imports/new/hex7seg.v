`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 11:11:58 PM
// Design Name: 
// Module Name: hex7seg
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


module hex7seg(
    input [3:0] N_i,
    output [6:0] Seg_o
    );
    
    assign n3 = N_i[3];
    assign n2 = N_i[2];
    assign n1 = N_i[1];
    assign n0 = N_i[0];
    
    assign Seg_o[0] = (~n3 & ~n2 & ~n1 & n0) | (~n3 & n2 & ~n1 & ~n0) | (n3 & ~n2 & n1 & n0) | (n3 & n2 & ~n1 & n0); // CA
    assign Seg_o[1] = (~n3 & n2 & ~n1 & n0) | (n2 & n1 & ~n0) | (n3 & n1 & n0) | (n3 & n2 & ~n0); // CB
    assign Seg_o[2] = (~n3 & ~n2 & n1 & ~n0) | (n3 & n2 & ~n0) | (n3 & n2 & n1); // CC
    assign Seg_o[3] = (~n2 & ~n1 & n0) | (~n3 & n2 & ~n1 & ~n0) | (n2 & n1 & n0) | (n3 & ~n2 & n1 & ~n0); // CD
    assign Seg_o[4] = (~n3 & n0) | (~n3 & n2 & ~n1) | (~n2 & ~n1 & n0); // CE
    assign Seg_o[5] = (~n3 & ~n2 & n0) | (~n3 & ~n2 & n1) | (~n3 & n1 & n0) | (n3 & n2 & ~n1 & n0); // CF
    assign Seg_o[6] = (~n3 & ~n2 & ~n1) | (~n3 & n2 & n1 & n0) | (n3 & n2 & ~n1 & ~n0); // CG
  
endmodule
