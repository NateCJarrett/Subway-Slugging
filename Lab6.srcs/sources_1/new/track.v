`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 09:04:57 PM
// Design Name: 
// Module Name: track
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


module track(
        input [15:0] trigger_i,
        input [15:0] track_left_i,
        input [15:0] col_i,
        input [15:0] row_i,
        input clk_i,
        input advance_i,
        input frame_i,
        input go_i,
        input reset_game_i,
        input crashed_i,
        output train_1_o,
        output train_2_o,
        output score_inc_o
    );

    wire [15:0] random_delay;
    wire [6:0] rnd;
    wire train_1_trigger, train_2_trigger;

    // Train Delay Calculation ---------------------------------------------------------------
    assign random_delay[15:7] = 9'b0; // Upper bits zeroed
    lsfr delay_randomizer (.clkin(clk_i), .q_o(rnd));
    FDRE #(.INIT(7'b0)) train_delay [6:0] (
        .C(clk_i), 
        .R(1'b0), 
        .CE(frame_i), 
        .D(rnd[6:0]), 
        .Q(random_delay[6:0])
    );

    // Train Instances -----------------------------------------------------------------------
    train train1 (
        .T_i(random_delay), // Input Delay
        .go_i((go_i & ~crashed_i) | train_2_trigger), // Go Signal
        .clk_i(clk_i),
        .advance_i(advance_i),
        .frame_i(frame_i),
        .start_i(go_i),
        .reset_game_i(reset_game_i),
        .trigger_val_i(trigger_i),
        .col_i(col_i),
        .row_i(row_i),
        .track_left_i(track_left_i), 
        .active_train_o(train_1_o),
        .trigger_o(train_1_trigger),
        .score_inc_o(t1_score_inc)
    );

    train train2 (
        .T_i(random_delay), // Input Delay
        .go_i(train_1_trigger), // Go Signal
        .clk_i(clk_i),
        .advance_i(advance_i),
        .frame_i(frame_i),
        .start_i(train_1_trigger & frame_i),
        .reset_game_i(reset_game_i),
        .trigger_val_i(trigger_i),
        .col_i(col_i),
        .row_i(row_i),
        .track_left_i(track_left_i), 
        .active_train_o(train_2_o),
        .trigger_o(train_2_trigger),
        .score_inc_o(t2_score_inc)
    );

    wire t1_score_inc, t2_score_inc;
    assign score_inc_o = t1_score_inc | t2_score_inc;

endmodule
