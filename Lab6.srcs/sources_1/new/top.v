`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 02:02:37 PM
// Design Name: 
// Module Name: top
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


module top(
    input btnD,
    input btnU,
    input btnL, 
    input btnR,
    input btnC,
    input [15:0] sw,
    input clkin,
    input dp,
    output Hsync,
    output Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg
    );
    
    wire [15:0] curr_row, curr_col;
    wire clk, digsel, active_region, frame, arrived;
    
    labVGA_clks not_so_slow(
        .clkin(clkin),
        .greset(btnD),
        .clk(clk),
        .digsel(digsel));
    
    // Frame Counter
    edge_detector frame_detector (.clk_i(clk), .button_i(Vsync), .edge_o(frame));
    
    // VGA Logic
    pixel_address pixels (
        .clk_i(clk), 
        .row_o(curr_row), 
        .col_o(curr_col), 
        .active_region_o(active_region)
    );

    sync syncs (
        .clk_i(clk), 
        .row_i(curr_row), 
        .col_i(curr_col), 
        .Hsync_o(Hsync), 
        .Vsync_o(Vsync)
    );
    
    // RGB Selector Logic --------------------------------------------------------------------
    rgb_selector rgb (
        .clk_i(clk), 
        .frame_i(frame), 
        .btnC(btnC), 
        .btnL(btnL), 
        .btnR(btnR), 
        .btnU(btnU),
        .row_i(curr_row), 
        .col_i(curr_col), 
        .active_region_i(active_region), 
        .red_o(vgaRed), 
        .green_o(vgaGreen), 
        .blue_o(vgaBlue),
        .score_o(display_o[7:0]),
        .lives_o(display_o[15:12])
    );

    // Score Display Logic -------------------------------------------------------------------
    wire [15:0] display_o;
    wire [3:0] ring, sel;

    ring_counter round (.clk_i(clk), .advance_i(digsel), .ring_o(ring)); // Ring Counter, round and round we go, clk = clk, advance = digsel
    selector select (.Sel_i(ring), .N_i(display_o), .H_o(sel)); // Ring Counter -> Selector
    hex7seg segment (.N_i(sel), .Seg_o(seg)); // Selector -> Hex 7 Display

    assign an[3] = 1'b1;
    assign an[2] = 1'b1;
    assign an[1] = ~ring[1];
    assign an[0] = ~ring[0];
    
endmodule
