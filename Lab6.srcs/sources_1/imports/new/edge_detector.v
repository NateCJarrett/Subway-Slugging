`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 02:24:52 PM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input clk_i,
    input button_i,
    output edge_o
    );
    
    wire prev, curr;
    
    FDRE #(.INIT(1'b0)) curr_ff (.C(clk_i), .R(1'b0), .CE(1'b1), .D(button_i), .Q(curr)); // Bit 0 Flip Flop, feeds into bit 1
    FDRE #(.INIT(1'b0)) prev_ff (.C(clk_i), .R(1'b0), .CE(1'b1), .D(curr), .Q(prev)); // Bit 0 Flip Flop, feeds into bit 1
    
    assign edge_o = ~prev & curr;
    
endmodule
