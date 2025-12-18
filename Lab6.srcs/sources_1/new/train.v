`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2025 03:10:01 PM
// Design Name: 
// Module Name: train
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


module train(
        input go_i, // Go Signal
        input clk_i,
        input advance_i,
        input frame_i,
        input start_i,
        input reset_game_i,
        input [15:0] T_i, // Train Delay
        input [15:0] trigger_val_i,
        input [15:0] col_i,
        input [15:0] row_i,
        input [15:0] track_left_i, 
        output active_train_o,
        output trigger_o,
        output score_inc_o
    );
    
    wire [7:0] rnd;
    wire [15:0] track_right_i, train_top_o, train_bottom_o, train_length_o, random_length;

    // Started Latch ----------------------------------------------------------------------------
    wire started;
    FDRE #(.INIT(1'b0)) begun (.C(clk_i), .R(reset_game_i), .CE(start_i), .D(1'b1), .Q(started));

    // Train Length Calculation ---------------------------------------------------------------
    assign random_length[15:6] = 10'b0; // Upper bits zeroed
    lsfr length_randomizer (.clkin(clk_i), .q_o(rnd));
    FDRE #(.INIT(6'b0)) train_length [5:0] (
        .C(clk_i), 
        .R(1'b0), 
        .CE(go_i), 
        .D(rnd[5:0]), 
        .Q(random_length[5:0])
    );
    
    assign train_length_o = 16'd60 + random_length; // Train length between 60 and 123 pixels

    // Train Delay Calculation ---------------------------------------------------------------
    wire [15:0] curr_delay, delay_target;
    countUD16L delay_counter (
        .clk_i(clk_i), 
        .up_i(frame_i), 
        .dw_i(1'b0), 
        .ld_i(go_i & frame_i), 
        .Din_i(16'd0), 
        .Q_o(curr_delay)
    );

    wire delay_go;
    assign delay_reached = (delay_target[6:0] <= curr_delay[6:0]);
    FDRE #(.INIT(1'b0)) delay_latch (.C(clk_i), .R(go_i), .CE(delay_reached), .D(1'b1), .Q(delay_go));

    FDRE #(.INIT(7'b0)) delay_target_latch [6:0] (
        .C(clk_i), 
        .R(1'b0), 
        .CE(go_i), 
        .D(T_i[6:0]), 
        .Q(delay_target[6:0])
    );
    
    // Train Movement -------------------------------------------------------------------------
    countUD16L train_bottom (
        .clk_i(clk_i), 
        .up_i(advance_i & frame_i & started & delay_go),
        .dw_i(1'b0), 
        .ld_i(go_i), 
        .Din_i(16'd7), 
        .Q_o(train_bottom_o)
    );

    // Train Display --------------------------------------------------------------------------
    wire negative;
    assign negative = (train_bottom_o < train_length_o);
    
    assign track_right_i = track_left_i + 16'd60;
    assign train_top_o = ((train_bottom_o - train_length_o) & {16{~negative}}) | 
                         (16'd0 & {16{negative}}); // Prevent underflow

    assign active_train_o = started & ((col_i >= track_left_i) & (col_i <= track_right_i)) &
                                      ((row_i <= train_bottom_o) & (row_i >= train_top_o)); // Removed started condition to always show train when in bounds

    assign trigger_o = (train_bottom_o == trigger_val_i) & frame_i;

    assign score_inc_o = (train_top_o == 16'd360) & frame_i;
endmodule
