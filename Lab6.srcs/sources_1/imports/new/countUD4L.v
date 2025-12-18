`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 02:13:57 PM
// Design Name: 
// Module Name: countUD4L
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


module countUD4L(
    input clk_i,
    input up_i,
    input dw_i,
    input ld_i,
    input [3:0] Din_i,
    output [3:0] Q_o,
    output utc_o,
    output dtc_o
    );
    
    wire sign_i, enabled_i;
    wire [3:0] A_o, D_i, S_o;
    
    assign enabled_i = (up_i ^ dw_i) | ld_i; // Disabled if neither or both are true, on no matter what if ld_i is true
    assign sign_i = ~up_i & dw_i; // 0 if up_i is on, 1 if dw_i is on, dont care otherwise
    
    mux4bit D (.i0(S_o), .i1(Din_i), .y(D_i), .s(ld_i)); // Selecting between data in and last increment
    // So long as ld_i is true, the FF will keep loading Din_i and not care what the adder does
        
    FDRE #(.INIT(1'b0)) b0_ff (.C(clk_i), .R(1'b0), .CE(enabled_i), .D(D_i[0]), .Q(A_o[0])); // Bit 0 Flip Flop
    FDRE #(.INIT(1'b0)) b1_ff (.C(clk_i), .R(1'b0), .CE(enabled_i), .D(D_i[1]), .Q(A_o[1])); // Bit 1 Flip Flop
    FDRE #(.INIT(1'b0)) b2_ff (.C(clk_i), .R(1'b0), .CE(enabled_i), .D(D_i[2]), .Q(A_o[2])); // Bit 2 Flip Flop
    FDRE #(.INIT(1'b0)) b3_ff (.C(clk_i), .R(1'b0), .CE(enabled_i), .D(D_i[3]), .Q(A_o[3])); // Bit 3 Flip Flop
        
    AddSub4 crement (.A_i(A_o), .B_i(4'b0001), .sub_i(sign_i), .S_o(S_o));
    
    assign utc_o = A_o[0] & A_o[1] & A_o[2] & A_o[3];
    assign dtc_o = ~A_o[0] & ~A_o[1] & ~A_o[2] & ~A_o[3];
    
    assign Q_o = A_o;
endmodule
