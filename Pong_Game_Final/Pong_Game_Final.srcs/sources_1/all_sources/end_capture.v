`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2022 04:10:58 PM
// Design Name: 
// Module Name: end_capture
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

//create this module for getting posiiton of paddle and square of last frame of game
module end_capture(
    input  wire CLK, // 100 Mhz clock
    output wire VGA_HS, // horizontal sync
    output wire VGA_VS, // vertical sync
     
    output reg [3:0] VGA_R_C, // red channels
    output reg [3:0] VGA_G_C, // green channels
    output reg [3:0] VGA_B_C, // blue channels
    
    //variable for end game capture
    input  wire [11:0] sq_a_x1, 
    input  wire [11:0] sq_a_x2,
    input  wire [11:0] sq_a_y1, 
    input  wire [11:0] sq_a_y2, // positions bits for ball
    
    input  wire [11:0] sq_b_x1, 
    input  wire [11:0] sq_b_x2, 
    input  wire [11:0] sq_b_y1, 
    input  wire [11:0] sq_b_y2,
    
    input  wire [11:0] sq_b1_x1, 
    input  wire [11:0] sq_b1_x2, 
    input  wire [11:0] sq_b1_y1, 
    input  wire [11:0] sq_b1_y2, 
    
    input  wire endgame,
    input  wire [8:0] score
   // input  wire record //flag for recording*/
    );
    
   wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
   wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
   wire animate;  // high when we're ready to animate at end of drawing
   reg sq_a, sq_b, sq_b1; // registers to assign objects
   reg [15:0] cnt = 0; // pixel clock counter
   reg pix_stb = 0; // pixel clock
   
   
    always @(posedge CLK)
    begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
    end
   
   vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(0),//in
        .o_hs(VGA_HS), 
        .o_vs(VGA_VS), 
        .o_x(x), 
        .o_y(y),
        .o_active(animate)
    ); // vga 640x480 driver
   
   always @ (*)
    begin
            sq_a = ((x > sq_a_x1) & (y > sq_a_y1) & (x < sq_a_x2) & (y < sq_a_y2)) ? 1 : 0; // draw ball edges
            sq_b = ((x > sq_b_x1) & (y > sq_b_y1) & (x < sq_b_x2) & (y < sq_b_y2)) ? 1 : 0; // draw paddle edges
            sq_b1 = ((y > sq_b1_x1) & (x > sq_b1_y1) & (y < sq_b1_x2) & (x < sq_b1_y2)) ? 1 : 0; // draw paddle edges
    end
   
    always @(posedge pix_stb)
    begin
        // assign ball(s) and paddle color white
        VGA_R_C[3] <= sq_a | sq_b | sq_b1; 
        VGA_G_C[3] <= sq_a | sq_b | sq_b1;
        VGA_B_C[3] <= sq_a | sq_b | sq_b1;
        VGA_R_C[2] <= sq_a | sq_b | sq_b1;
        VGA_G_C[2] <= sq_a | sq_b | sq_b1;
        VGA_B_C[2] <= sq_a | sq_b | sq_b1;
        VGA_R_C[1] <= sq_a | sq_b | sq_b1;
        VGA_G_C[1] <= sq_a | sq_b | sq_b1;
        VGA_B_C[1] <= sq_a | sq_b | sq_b1;
        VGA_R_C[0] <= sq_a | sq_b | sq_b1;
        VGA_G_C[0] <= sq_a | sq_b | sq_b1;
        VGA_B_C[0] <= sq_a | sq_b | sq_b1;
    end 
    
endmodule
