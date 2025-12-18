`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 12:45:24 AM
// Design Name: 
// Module Name: player
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


module player(
        input clk_i,
        input btnL,
        input btnR,
        input btnU,
        input has_energy_i,
        input frame_i,
        input crashed_i,
        input [15:0] col_i,
        input [15:0] row_i,
        output hovering_o,
        output character_o
    );

    // Initialize starting values --------------------------------------
    wire INITIALIZER;
    FDRE #(.INIT(1'b1)) initializer (
        .C(clk_i), 
        .R(1'b0), 
        .CE(1'b1), 
        .D(1'b0), 
        .Q(INITIALIZER)
    );
   
    wire double_frame, move_left, move_right, arrived;
    wire [15:0] char_left, target_player_left;

    // Character Logic ------------------------------------------------
    assign double_frame = frame_i | ((row_i == 16'd245) & (col_i == 16'd320)); // High twice per frame
    assign move_left = (char_left > target_player_left) & ~crashed_i & double_frame;
    assign move_right = (char_left < target_player_left) & ~crashed_i & double_frame;
    assign arrived = char_left == target_player_left;
    
    wire L_i, R_i;
    edge_detector left (.clk_i(clk_i), .button_i(btnL), .edge_o(L_i));
    edge_detector right (.clk_i(clk_i), .button_i(btnR), .edge_o(R_i));

    // Moving character left and right --------------------------------
    countUD16L character_left (
        .clk_i(clk_i), 
        .up_i(move_right), 
        .dw_i(move_left), 
        .ld_i(INITIALIZER), 
        .Din_i(16'd515), 
        .Q_o(char_left)
    );

    // Player State Machine ----------------------------------------
    player_fsm player (
        .clk_i(clk_i), 
        .left_i(L_i), 
        .right_i(R_i), 
        .up_i(btnU), 
        .arrived_i(arrived), 
        .has_energy_i(has_energy_i),
        .collision_i(crashed_i),
        .player_left_o(target_player_left), 
        .hover_o(hovering_o)
    );

    // Player Display -------------------------------------------------
    wire [15:0] char_top;
    assign char_top = 16'd360;
    assign character_o = ((col_i >= char_left) & (col_i <= char_left + 16'd16)) & // x-axis character bounds
                         ((row_i >= char_top) & (row_i <= char_top + 16'd16)); // y-axis character bounds
     
endmodule
