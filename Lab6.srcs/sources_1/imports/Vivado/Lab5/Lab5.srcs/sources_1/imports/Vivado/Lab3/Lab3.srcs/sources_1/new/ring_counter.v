`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 02:26:03 PM
// Design Name: 
// Module Name: ring_counter
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


module ring_counter(
    input clk_i,
    input advance_i,
    output [3:0] ring_o
    );
    
    wire ff_0, ff_1, ff_2, ff_3;
    
    FDRE #(.INIT(1'b1)) b0_ff (.C(clk_i), .R(1'b0), .CE(advance_i), .D(ff_3), .Q(ff_0)); // Bit 0 Flip Flop, feeds into bit 1
    FDRE #(.INIT(1'b0)) b1_ff (.C(clk_i), .R(1'b0), .CE(advance_i), .D(ff_0), .Q(ff_1)); // Bit 1 Flip Flop, feeds into bit 2
    FDRE #(.INIT(1'b0)) b2_ff (.C(clk_i), .R(1'b0), .CE(advance_i), .D(ff_1), .Q(ff_2)); // Bit 2 Flip Flop, feeds into bit 3
    FDRE #(.INIT(1'b0)) b3_ff (.C(clk_i), .R(1'b0), .CE(advance_i), .D(ff_2), .Q(ff_3)); // Bit 3 Flip Flop, feeds back to bit 0
    
    assign ring_o[0] = ff_0;
    assign ring_o[1] = ff_1;
    assign ring_o[2] = ff_2;
    assign ring_o[3] = ff_3;

endmodule
