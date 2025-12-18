`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2025 12:33:50 AM
// Design Name: 
// Module Name: lsfr
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


module lsfr(
    input clkin,
    output [7:0] q_o
    );
    
    wire [7:0] rnd;
    
    assign rnd_init = rnd[0] ^ rnd[5] ^ rnd[6] ^ rnd[7];
    
    FDRE #(.INIT(1'b1)) rnd_0 (.C(clkin), .R(1'b0), .CE(1'b1), .D(rnd_init), .Q(rnd[0])); // Bit 0 Flip Flop
    FDRE #(.INIT(1'b0)) rnd_1 (.C(clkin), .R(1'b0), .CE(1'b1), .D(rnd[0]), .Q(rnd[1])); // Bit 0 Flip Flop
    FDRE #(.INIT(1'b0)) rnd_2 (.C(clkin), .R(1'b0), .CE(1'b1), .D(rnd[1]), .Q(rnd[2])); // Bit 0 Flip Flop
    FDRE #(.INIT(1'b0)) rnd_3 (.C(clkin), .R(1'b0), .CE(1'b1), .D(rnd[2]), .Q(rnd[3])); // Bit 0 Flip Flop
    FDRE #(.INIT(1'b0)) rnd_4 (.C(clkin), .R(1'b0), .CE(1'b1), .D(rnd[3]), .Q(rnd[4])); // Bit 0 Flip Flop
    FDRE #(.INIT(1'b0)) rnd_5 (.C(clkin), .R(1'b0), .CE(1'b1), .D(rnd[4]), .Q(rnd[5])); // Bit 0 Flip Flop
    FDRE #(.INIT(1'b0)) rnd_6 (.C(clkin), .R(1'b0), .CE(1'b1), .D(rnd[5]), .Q(rnd[6])); // Bit 0 Flip Flop
    FDRE #(.INIT(1'b0)) rnd_7 (.C(clkin), .R(1'b0), .CE(1'b1), .D(rnd[6]), .Q(rnd[7])); // Bit 0 Flip Flop
    
    assign q_o = rnd;

endmodule
