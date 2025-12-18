`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 02:30:00 PM
// Design Name: 
// Module Name: sync
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


module sync(
    input [15:0] row_i,
    input [15:0] col_i,
    input clk_i,
    output Hsync_o,
    output Vsync_o
    );
    
    FDRE #(.INIT(1'b0)) h_sync (.C(clk_i), .R(1'b0), .CE(1'b1), .D(h_sync_n), .Q(Hsync_o));
    FDRE #(.INIT(1'b0)) v_sync (.C(clk_i), .R(1'b0), .CE(1'b1), .D(v_sync_n), .Q(Vsync_o));
    
    assign h_sync_n = (col_i < 16'd655) | (col_i > 16'd750);
    assign v_sync_n = (row_i < 16'd489) | (row_i > 16'd490);
endmodule
