`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2025 07:02:21 PM
// Design Name: 
// Module Name: game_fsm
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


module game_fsm(
    input clk_i,
    input go_i,
    input crashed_i,
    input loss_i,
    input frame_i,
    output dec_lives_o,
    output track_1_unlock_o,
    output track_2_unlock_o,
    output track_3_unlock_o,
    output reset_game_o
    );

    wire GO_s, ONE_s, TWO_s, THREE_s; // Current State wires
    wire GO_ns, ONE_ns, TWO_ns, THREE_ns; // Next state wires

    FDRE #(.INIT(1'b1)) go_state (.C(clk_i), .R(1'b0), .CE(1'b1), .D(GO_ns), .Q(GO_s)); // Initial reset state
    FDRE #(.INIT(1'b0)) one_track (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ONE_ns), .Q(ONE_s)); // Left Track
    FDRE #(.INIT(1'b0)) two_tracks (.C(clk_i), .R(1'b0), .CE(1'b1), .D(TWO_ns), .Q(TWO_s)); // Right Track
    FDRE #(.INIT(1'b0)) three_tracks (.C(clk_i), .R(1'b0), .CE(1'b1), .D(THREE_ns), .Q(THREE_s)); // Hover State

    assign GO_ns = (GO_s & ~go_i) | (GO_s & loss_i) | (ONE_s & crashed_i) | (TWO_s & crashed_i) | (THREE_s & crashed_i);
    assign ONE_ns = (GO_s & go_i & ~loss_i) | (ONE_s & ~T2_i & ~crashed_i);
    assign TWO_ns = (ONE_s & T2_i & ~crashed_i) | (TWO_s & ~T6_i & ~crashed_i);
    assign THREE_ns = (TWO_s & T6_i & ~crashed_i) | (THREE_s & ~crashed_i);

    assign dec_lives_o = (ONE_s & crashed_i) | (TWO_s & crashed_i) | (THREE_s & crashed_i);
    //assign reset_game_o = (GO_s & ~go_i & ~loss_i);
    assign reset_game_o = 1'b0;

    assign track_1_unlock_o = GO_s & go_i & ~loss_i;
    assign track_2_unlock_o = TWO_s & T6_i;
    assign track_3_unlock_o = ONE_s & T2_i; 

    timer game_timer (
        .clk_i(clk_i),
        .frame_i(frame_i),
        .reset_game_i(go_i),
        .T2_o(T2_i),
        .T6_o(T6_i)
    );
    
endmodule
