`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2025 02:19:52 PM
// Design Name: 
// Module Name: player_fsm
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


module player_fsm(
    input left_i,
    input right_i,
    input up_i,
    input clk_i,
    input arrived_i,
    input has_energy_i,
    input collision_i,
    output [15:0] player_left_o,
    output hover_o
    );
    
    wire M_ns, L_ns, R_ns, H_ns; // Next state wires
    wire M_s, L_s, R_s, H_s; // Current State wires
    wire [15:0] MIDDLE; // Defines the left bound of the character in the middle track
    wire [15:0] LEFT, RIGHT;
    
    assign MIDDLE = 16'd515;
    assign LEFT = MIDDLE - 16'd70;
    assign RIGHT = MIDDLE + 16'd70;
    
    FDRE #(.INIT(1'b1)) middle_state (.C(clk_i), .R(1'b0), .CE(1'b1), .D(M_ns), .Q(M_s)); // Initial reset state
    FDRE #(.INIT(1'b0)) left_state (.C(clk_i), .R(1'b0), .CE(1'b1), .D(L_ns), .Q(L_s)); // Left Track
    FDRE #(.INIT(1'b0)) right_state (.C(clk_i), .R(1'b0), .CE(1'b1), .D(R_ns), .Q(R_s)); // Right Track
    FDRE #(.INIT(1'b0)) hover_state (.C(clk_i), .R(1'b0), .CE(1'b1), .D(H_ns), .Q(H_s)); // Hover State
    
    assign M_ns = (M_s & ~left_i & ~right_i & ~up_i) | (M_s & ~arrived_i) | (H_s & ~up_i) |
                  (L_s & ~left_i & right_i & arrived_i) | (R_s & left_i & ~right_i & arrived_i);
    assign L_ns = (M_s & left_i & ~right_i & arrived_i) | (L_s & ~left_i & ~right_i) | (L_s & left_i & ~right_i) | (L_s & ~arrived_i);
    assign R_ns = (M_s & ~left_i & right_i & arrived_i) | (R_s & ~left_i & ~right_i) | (R_s & ~left_i & right_i) | (R_s & ~arrived_i);
    assign H_ns = (M_s & up_i & arrived_i & ~collision_i) | (H_s & up_i);
    
    assign player_left_o = (MIDDLE & {16{M_s | H_s}}) | (LEFT & {16{L_s}}) | (RIGHT & {16{R_s}});
    assign hover_o = H_s;

endmodule
