`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Martine
// 
// Create Date: 10/2/2023 07:29:02 PM
// Design Name: 
// Module Name: test_signchanger
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


module test_counter( ); // no inputs/outputs, this is a wrapper


// registers to hold values for the inputs to your top level
    reg btnR, btnL, clkin;
// wires to see the values of the outputs of your top level
    wire [6:0] seg;
    wire [3:0] an;
    wire dp;
    wire [15:0] led;

    
// create one instance of your top level
// and attach it to the registers and wires created above

pixel_address UUT (
    .clk_i(clkin)
);
    
    
// create an oscillating signal to impersonate the clock provided on the BASYS 3 board
    parameter PERIOD = 50;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        #OFFSET
		clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
    end
	
// here is where the values for the registers are provided
// time must be advanced so that the change will have an effect
   initial
   begin
     // Turkey 1
     btnL = 1'b0;
     btnR = 1'b0;
     
     #1000 // Left
     btnL = 1'b1;
     
   end

endmodule
