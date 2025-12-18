`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2025 01:19:00 AM
// Design Name: 
// Module Name: energy_bar
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


module energy_bar(
        input clk_i,
        input hover_i,
        input frame_i,
        input [15:0] col_i,
        input [15:0] row_i,
        output energy_bar_o,
        output has_energy_o
    );

    // Initializer
    wire INITIALIZER;
    FDRE #(.INIT(1'b1)) initializer (.C(clk_i), .R(1'b0), .CE(1'b1), .D(1'b0), .Q(INITIALIZER)); // Initial reset state

    // Energy Position -------------------------------------------------------------------------
    wire [15:0] energy_bar_left, energy_bar_bottom;
    assign energy_bar_left = 16'd10; // Test Location
    assign energy_bar_bottom = 16'd202 & {16{has_energy_o}}; // Test location

    // Energy Level ----------------------------------------------------------------------------
    wire [15:0] energy_capacity, curr_energy;
    wire energy_up, energy_dw;
    countUD16L energy_bar_counter (
        .clk_i(clk_i), 
        .up_i(energy_up & frame_i), 
        .dw_i(energy_dw & frame_i), 
        .ld_i(INITIALIZER), 
        .Din_i(16'd192), // Energy Starts Full
        .Q_o(curr_energy)
    );

    assign energy_up = ~hover_i & (curr_energy < 16'd192);
    assign energy_dw = hover_i & (curr_energy > 16'd0);
    assign has_energy_o = (curr_energy > 16'd0) & (curr_energy <= 16'd192);
    assign energy_capacity = curr_energy & {16{has_energy_o}};

    // Energy Display -------------------------------------------------------------------------
    assign energy_bar_o = ((col_i >= energy_bar_left) & (col_i <= energy_bar_left + 16'd20)) & // x-axis energy bounds
                          ((row_i <= energy_bar_bottom) & (row_i >= energy_bar_bottom - energy_capacity)); // Energy level
    
endmodule
