`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 06:41:16 PM
// Design Name: 
// Module Name: start_square
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


module start_square
    #(
    H_SIZE=80,      // half square width (for ease of co-ordinate calculations)
    IX=320,         // initial horizontal position of square centre
    IY=240,         // initial vertical position of square centre
    IX_DIR=1,       // initial horizontal direction: 1 is right, 0 is left
    IY_DIR=1,       // initial vertical direction: 1 is down, 0 is up
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
    (
    input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_animate,     // animate when input is high
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,  // square top edge
    output wire [11:0] o_y2   // square bottom edge
    );

    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    reg x_dir = IX_DIR;  // horizontal animation direction
    reg y_dir = IY_DIR;  // vertical animation direction

    assign o_x1 = x - H_SIZE;  // left: centre minus half horizontal size
    assign o_x2 = x + H_SIZE;  // right
    assign o_y1 = y - H_SIZE;  // top
    assign o_y2 = y + H_SIZE;  // bottom

    always @ (posedge i_clk)
    begin
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX; // initial x position
            y <= IY; // initial y position
            x_dir <= IX_DIR; // initial x direction
            y_dir <= IY_DIR; // initial y direction
        end
        if (i_animate && i_ani_stb)
        begin
            x <= (x_dir) ? x + 2 : x - 2;  // move left if positive x_dir
            y <= (y_dir) ? y + 2 : y - 2;  // move down if positive y_dir

            if (x <= H_SIZE + 1)  // edge of square is at left of screen
                x_dir <= 1;  // change direction to right
            if (x >= (D_WIDTH - H_SIZE - 1))  // edge of square at right
                x_dir <= 0;  // change direction to left          
            if (y <= H_SIZE + 1)  // edge of square at top of screen
                y_dir <= 1;  // change direction to down
            if (y >= (D_HEIGHT - H_SIZE - 1))  // edge of square at bottom
                y_dir <= 0;  // change direction to up              
        end
    end
endmodule