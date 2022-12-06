`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2022 06:34:05 PM
// Design Name: 
// Module Name: clk_divider
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

module clk_divider
    #(
    DIVISOR = 5 // parameter for 1 Hz clock
    )
    (
    input wire clk_in, // input clock
    output reg clk_out // output clock
    );
    
    reg [31:0] ctr; // counter bits
    
    // counter block
    always @(posedge clk_in)
    begin
        if (ctr == DIVISOR-1) 
            ctr <= 0; // reset counter to zero if reach #DIVISOR reached
        else
            ctr <= ctr + 1; // increment to counter to keep track until #DIVISOR reached
    end
    
    // flip flop - comparator block
    always @ (posedge clk_in)
    begin
        if (ctr == DIVISOR-1)
            clk_out <= ~clk_out; // simulate low state
        else
            clk_out <= clk_out; // simulate high state
    end
    
endmodule
