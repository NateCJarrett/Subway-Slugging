`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2025 12:44:44 PM
// Design Name: 
// Module Name: rgb_selector
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


module rgb_selector(
    input [15:0] row_i,
    input [15:0] col_i,
    input btnL,
    input btnR,
    input btnU,
    input btnC,
    input active_region_i,
    input clk_i,
    input frame_i,
    input [15:0] sw,
    output [3:0] red_o,
    output [3:0] green_o,
    output [3:0] blue_o,
    output [15:0] score_o,
    output [3:0] lives_o
    );
    
    wire border, character, energy_bar, hover_i, has_energy_o;
    
    wire [15:0] char_top;
    wire [11:0] white, red, green, blue;
    
    assign white = 12'b111111111111;
    assign red = 12'b111100000000;
    assign green = 12'b000011110000;
    assign blue = 12'b000000001111;

    // Character Logic ------------------------------------------------------
    player player_character (
        .clk_i(clk_i),
        .btnL(btnL),
        .btnR(btnR),
        .btnU(btnU),
        .has_energy_i(has_energy_o),
        .frame_i(frame_i),
        .crashed_i(crashed),
        .col_i(col_i),
        .row_i(row_i),
        .hovering_o(hover_i),
        .character_o(character)
    );
        
    // Energy Bar Logic ----------------------------------------------------
    energy_bar energy (
        .clk_i(clk_i),
        .hover_i(hover_i),
        .frame_i(frame_i),
        .col_i(col_i),
        .row_i(row_i),
        .energy_bar_o(energy_bar),
        .has_energy_o(has_energy_o)
    );

    // Game Controller -----------------------------------------------------
    wire [15:0] lives;
    wire dec_lives, track_1_unlock, track_2_unlock, track_3_unlock;
    wire reset_game, loss;

    game_fsm game_controller (
        .clk_i(clk_i),
        .go_i(btnC),
        .frame_i(frame_i),
        .crashed_i(crashed),
        .loss_i(1'b0),
        .dec_lives_o(dec_lives),
        .track_1_unlock_o(track_1_unlock),
        .track_2_unlock_o(track_2_unlock),
        .track_3_unlock_o(track_3_unlock),
        .reset_game_o(reset_game)
    );

    /*
    wire [15:0] initial_lives;
    assign initial_lives = (sw[15:0] == 16'd0) ? 16'd3 : sw[15:0]; // Default to 3 lives if switch is 0

    countUD16L lives_counter (
        .clk_i(clk_i),
        .up_i(1'b0),
        .dw_i(dec_lives),
        .ld_i(btnL | btnC), // Disable loading after game start
        .Din_i(initial_lives),
        .Q_o(lives)
    );

    assign loss = (lives == 16'd0);
    assign lives_o = lives[3:0];
    */
    
    // Train Track Logic ---------------------------------------------------
    wire [15:0] track_1_left, track_2_left, track_3_left, track_1_trigger, track_2_trigger, track_3_trigger;
    wire collision, advance;

    wire t1_train_1, t1_train_2; // Track 1 trains
    wire t2_train_1, t2_train_2; // Track 2 trains
    wire t3_train_1, t3_train_2; // Track 3 trains
    wire t1_score_inc, t2_score_inc, t3_score_inc;

    assign track_1_left = track_2_left - 16'd70;
    assign track_2_left = 16'd493;
    assign track_3_left = track_2_left + 16'd70;
    assign track_1_trigger = 16'd400;
    assign track_2_trigger = 16'd440;
    assign track_3_trigger = 16'd401;

    track track1 (
        .trigger_i(track_1_trigger),
        .track_left_i(track_1_left),
        .col_i(col_i),
        .row_i(row_i),
        .clk_i(clk_i),
        .advance_i(advance),
        .frame_i(frame_i),
        .go_i(track_1_unlock),
        .reset_game_i(reset_game),
        .crashed_i(crashed),
        .train_1_o(t1_train_1),
        .train_2_o(t1_train_2),
        .score_inc_o(t1_score_inc)
    );

    track track2 (
        .trigger_i(track_2_trigger),
        .track_left_i(track_2_left),
        .col_i(col_i),
        .row_i(row_i),
        .clk_i(clk_i),
        .advance_i(advance),
        .frame_i(frame_i),
        .go_i(track_2_unlock),
        .reset_game_i(reset_game),
        .crashed_i(crashed),
        .train_1_o(t2_train_1),
        .train_2_o(t2_train_2),
        .score_inc_o(t2_score_inc)
    );

    track track3 (
        .trigger_i(track_3_trigger),
        .track_left_i(track_3_left),
        .col_i(col_i),
        .row_i(row_i),
        .clk_i(clk_i),
        .advance_i(advance),
        .frame_i(frame_i),
        .go_i(track_3_unlock),
        .reset_game_i(reset_game),
        .crashed_i(crashed),
        .train_1_o(t3_train_1),
        .train_2_o(t3_train_2),
        .score_inc_o(t3_score_inc)
    );

    // Time Counter -------------------------------------------------------
    wire qsec, hsec;
    timer game_timer (
        .clk_i(clk_i),
        .frame_i(frame_i),
        .reset_game_i(1'b0),
        .qsec_o(qsec),
        .hsec_o(hsec)
    );

    // Collision Logic --------------------------------------------------------
    assign collision = ((character & (t1_train_1 | t1_train_2 | t2_train_1 | t2_train_2 | t3_train_1 | t3_train_2))) & (~hover_i | ~has_energy_o) & ~sw[3];
    assign advance_val = reset_game ? 1'b1 : 1'b0;
    FDRE #(.INIT(1'b1)) crash_detector (.C(clk_i), .R(1'b0), .CE(collision), .D(advance_val), .Q(advance));

    assign crashed = ~advance;

    // Score Logic ------------------------------------------------------------
    wire score_inc;
    wire [15:0] score;
    assign score_inc = t1_score_inc | t2_score_inc | t3_score_inc;
    countUD16L score_counter (
        .clk_i(clk_i),
        .up_i(score_inc),
        .dw_i(1'b0),
        .ld_i(1'b0),
        .Din_i(16'd0),
        .Q_o(score_o)
    );

    // Sectional Logic ----------------------------------------------------------
    assign border = ((col_i >= 16'd0) & (col_i <= 16'd7)) | // Left Border
                    ((col_i >= 16'd632) & (col_i <= 16'd639)) | // Right Border
                    ((row_i >= 16'd0) & (row_i <= 16'd7)) | // Top Border
                    ((row_i >= 16'd472) & (row_i <= 16'd479)); // Bottom Border

    // Track Display --------------------------------------------------------
    wire track_1, track_2, track_3, train;
    assign track_1 = ((col_i >= track_1_left) & (col_i <= track_1_left + 16'd4)) |
                     (col_i >= (track_1_left + 16'd56)) & (col_i <= (track_1_left + 16'd60));
    assign track_2 = ((col_i >= track_2_left) & (col_i <= track_2_left + 16'd4)) |
                     (col_i >= (track_2_left + 16'd56)) & (col_i <= (track_2_left + 16'd60));
    assign track_3 = ((col_i >= track_3_left) & (col_i <= track_3_left + 16'd4)) |
                     (col_i >= (track_3_left + 16'd56)) & (col_i <= (track_3_left + 16'd60));
    assign train = t1_train_1 | t1_train_2 | t2_train_1 | t2_train_2 | t3_train_1 | t3_train_2;
                  
    // Color Logic --------------------------------------------------------------
    assign red_o = {4{active_region_i}} & (({4{border}} & white[3:0]) | // White for border
                   ({4{character}} & red[11:8] & {4{~hover_i | (hover_i & ~has_energy_o)}}) | // Red for character
                   ({4{character}} & red[11:8] & {4{hover_i}} & {4{has_energy_o}} & {4{hsec}} & {4{~crashed}}) |
                   ({4{track_1 | track_2 | track_3}} & white[11:8] & {4{~train}} & {4{~border}} & {4{~character}})) | // Yellow for hover
                   ({4{~active_region_i}} & 4'b0); // All 0's
    assign green_o = {4{active_region_i}} & (({4{border}} & white[7:4]) | // White for border
                     ({4{energy_bar}} & green[7:4]) | // Green for bar
                     ({4{character}} & green[7:4] & {4{~border}} & {4{hover_i}} & {4{has_energy_o}}) |
                     ({4{track_1 | track_2 | track_3}} & white[11:8] & {4{~train}} & {4{~border}} & {4{~character}})) | // Green for hover
                     ({4{~active_region_i}} & 4'b0); // All 0's
    assign blue_o = {4{active_region_i}} & (({4{border}} & white[11:8]) | // White for border
                    ({4{t1_train_1 | t1_train_2}} & blue[3:0] & {4{~border}} & {4{~character}}) | // Blue for Train
                    ({4{t2_train_1 | t2_train_2}} & blue[3:0] & {4{~border}} & {4{~character}}) | // Blue for Train
                    ({4{t3_train_1 | t3_train_2}} & blue[3:0] & {4{~border}} & {4{~character}}) | // Blue for Train
                    ({4{character}} & blue[3:0] & {4{crashed}} & {4{qsec}}) |
                    ({4{track_1 | track_2 | track_3}} & white[11:8] & {4{~train}} & {4{~border}} & {4{~character}})) | // Purple for crashed
                    ({4{~active_region_i}} & 4'b0); // All 0's

endmodule
