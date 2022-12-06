`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2020 09:49:32 PM
// Design Name: 
// Module Name: increment_one
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


module increment_one(
    input wire CLK, // clock
    input wire btn, // button
    output reg duty // output 
    );
     
    reg n_clicks = 0; // number of presses
    
    wire btn0_state, btn0_dn, btn0_up;
    debounce d_btn0 (
        .clk(CLK),
        .i_btn(btn),
        .o_state(btn0_state),
        .o_ondn(btn0_dn),
        .o_onup(btn0_up)
    ); // debounce instance
    
    always @ (posedge CLK) 
    begin
        if (btn0_dn) // check if button pressed
        begin
            n_clicks <= n_clicks + 1;// increment if button down
        end
    end
    
    always @(*)
    begin
        duty = n_clicks; // assign number of presses to output
    end
    
endmodule