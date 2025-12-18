`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2025 10:02:40 PM
// Design Name: 
// Module Name: timer
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


module timer(
    input clk_i,
    input frame_i,
    input reset_game_i,
    output qsec_o,
    output hsec_o,
    output T2_o,
    output T6_o
    );

    // Time Counter -------------------------------------------------------
    wire [15:0] frame_count, quarter_seconds;
    wire qsec_edge;

    countUD16L frame_counter (
        .clk_i(clk_i),
        .up_i(frame_i),
        .dw_i(1'b0),
        .ld_i(reset_game_i),
        .Din_i(16'd0),
        .Q_o(frame_count)
    );

    assign qsec_o = frame_count[4]; // High for quarter second, low for quarter second
    assign hsec_o = frame_count[5]; // High for half second, low for half second

    edge_detector quarter_sec_detector (
        .clk_i(clk_i),
        .button_i(frame_count[3]), // Every 1/8 second
        .edge_o(qsec_edge)
    );

    countUD16L quarter_sec_counter (
        .clk_i(clk_i),
        .up_i(qsec_edge),
        .dw_i(1'b0),
        .ld_i(reset_game_i),
        .Din_i(16'd0),
        .Q_o(quarter_seconds)
    ); // Counts quarter seconds

    assign T2_o = (quarter_seconds >= 16'd8); // 2 seconds
    assign T6_o = (quarter_seconds >= 16'd24); // 6 seconds
endmodule
