`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 02:11:56 PM
// Design Name: 
// Module Name: pixel_address
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


module pixel_address(
    input clk_i,
    output [15:0] row_o,
    output [15:0] col_o,
    output Hsync_o,
    output Vsync_o,
    output active_region_o
    );
    
    wire ovfl_col, ovfl_row;
    
    assign ovfl_col = col_o > 16'd799;
    assign ovfl_row = row_o > 16'd529;
    
    countUD16L columns (.clk_i(clk_i), .up_i(1'b1), .dw_i(1'b0), .ld_i(ovfl_col), .Din_i(16'b0), .Q_o(col_o));
    countUD16L rows (.clk_i(clk_i), .up_i(ovfl_col), .dw_i(1'b0), .ld_i(ovfl_row), .Din_i(16'b0), .Q_o(row_o));
    
    assign active_region_o = ((row_o >= 16'd0) & (row_o <= 16'd479)) & ((col_o >= 16'd0) & (col_o <= 16'd639));
endmodule
