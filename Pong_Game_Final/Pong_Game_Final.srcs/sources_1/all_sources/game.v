
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2020 07:15:08 PM
// Design Name: 
// Module Name: top
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


module game
//   #(
//        MEMFILE = "over.mem",
//        PALETTE = "gameover_palette.mem"
//    )
    (
    input wire mode,
    input wire CLK, // 100 Mhz clock
    input wire [1:0] BTN_LR, // left and right buttons
    input wire [1:0] BTN_UD,
    input wire [3:0] Speed,
    output wire VGA_HS, // horizontal sync
    output wire VGA_VS, // vertical sync
    output reg [3:0] VGA_R, // red channels
    output reg [3:0] VGA_G, // green channels
    output reg [3:0] VGA_B, // blue channels
    output wire endgame, // game end flag
    output wire [8:0] score,
    
    //output position of first ball and paddle
    output wire [11:0] sq_a_x1, 
    output wire [11:0] sq_a_x2,
    output wire [11:0] sq_a_y1, 
    output wire [11:0] sq_a_y2, // positions bits for ball
    output wire [11:0] sq_b_x1, 
    output wire [11:0] sq_b_x2, 
    output wire [11:0] sq_b_y1, 
    output wire [11:0] sq_b_y2, // position bits for paddle
    output wire [11:0] sq_b1_x1, 
    output wire [11:0] sq_b1_x2, 
    output wire [11:0] sq_b1_y1, 
    output wire [11:0] sq_b1_y2 // position bits for b1
    );
    
    localparam PW = 100; // paddle width
    localparam PH = 40; // paddle height
    localparam PY = 480 - PH; // initial paddle y
    localparam PX = 320; // initial paddle x
    localparam PY1 = 240; // initial paddle y
    localparam PX1 = 640 - PH; // initial paddle x
    localparam IX = 320; // intial ball x
    localparam IY = 470 - PH - PH - 30; //initial ball y
    localparam B_SIZE = 20; // ball size
    
    reg [15:0] cnt = 0; // pixel clock counter
    reg pix_stb = 0; // pixel clock
    
    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing
    wire collide; // collision flag
    
    reg sq_a, sq_b, sq_b1, sq_c, sq_d, sq_e, sq_f, sq_g, sq_h; // registers to assign objects
    
    wire [11:0] sq_b1_x1, sq_b1_x2, sq_b1_y1, sq_b1_y2; // positions bits for decoy
    wire [11:0] sq_c_x1, sq_c_x2, sq_c_y1, sq_c_y2; // positions bits for decoy
    wire [11:0] sq_d_x1, sq_d_x2, sq_d_y1, sq_d_y2; // positions bits for decoy
    wire [11:0] sq_e_x1, sq_e_x2, sq_e_y1, sq_e_y2; // positions bits for decoy
    wire [11:0] sq_f_x1, sq_f_x2, sq_f_y1, sq_f_y2; // position bits for decoy
    wire [11:0] sq_g_x1, sq_g_x2, sq_g_y1, sq_g_y2; // positions bits for decoy
    wire [11:0] sq_h_x1, sq_h_x2, sq_h_y1, sq_h_y2; // positions bits for decoy
    wire [11:0] sq_c_x1, sq_c_x2, sq_c_y1, sq_c_y2; // positions bits for decoy
    wire active1;
    wire active; // active flag during game over sequence
    wire [1:0] com; // bits to check paddle direction
    wire [1:0] com1;       
    always @(posedge CLK)
    begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
    end
    
    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(endgame),//in
        .o_hs(VGA_HS), 
        .o_vs(VGA_VS), 
        .o_x(x), 
        .o_y(y),
        .o_animate(animate)
    ); // vga 640x480 driver
    
    
     // VRAM frame buffers (read-write)
    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 480;
    localparam VRAM_DEPTH = SCREEN_WIDTH * SCREEN_HEIGHT; 
    localparam VRAM_A_WIDTH = 18;  // 2^19 > 640 x 480
    localparam VRAM_D_WIDTH = 6;   // colour bits per pixel
    
    reg  [7:0] i_data;
    wire i_write;
    reg  [VRAM_A_WIDTH-1:0] address;
    wire [VRAM_D_WIDTH-1:0] dataout;
    

    
    
    
         
    paddle #(.P_WIDTH(PW), .P_HEIGHT(PH), .IX(PX), .IY(PY)) p1(
        .endgame(endgame|!mode), //in
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .BTN_LR(BTN_LR),
        .Speed(Speed),
        .o_x1(sq_b_x1),
        .o_x2(sq_b_x2),
        .o_y1(sq_b_y1),
        .o_y2(sq_b_y2),
        .active(active1),
        .com(com)
        ); // paddle instance
    
    //extra vertical paddle is added for the game, it works in the game, collision from square works fine
    paddleh #(.P_WIDTH(PW), .P_HEIGHT(PH), .IX(PX1), .IY(PY1)) p2(
        .endgame(endgame|!mode), //in
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .BTN_LR(BTN_UD),
        .o_x1(sq_b1_x1),
        .o_x2(sq_b1_x2),
        .o_y1(sq_b1_y1),
        .o_y2(sq_b1_y2),
        .active(active),
        .com(com1)
        ); // paddle instance
        
            
    square #(.PX(PX1),.PY(PY), .PH(PH), .IX(IX), .IY(IY), .H_SIZE(B_SIZE)) b0 (
        .toggle(1),
        .com(com),
        .com1(com1),
        .mode(mode),
        .start(active | active1),
        .i_y1(sq_b1_x1),
        .i_y2(sq_b1_x2),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .o_x1(sq_a_x1),
        .o_x2(sq_a_x2),
        .o_y1(sq_a_y1),
        .o_y2(sq_a_y2),
        .endgame(endgame), //out
        .score(score)
   
    ); // ball instance
    
    square #(.PY(PY), .PH(PH), .IX(30), .IY(340), .H_SIZE(B_SIZE)) b1 (
        .toggle(0),
        .com(com),
        .mode(mode),
        .start(active),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .o_x1(sq_c_x1),
        .o_x2(sq_c_x2),
        .o_y1(sq_c_y1),
        .o_y2(sq_c_y2)
    ); // ball instance
    
    square #(.PY(PY), .PH(PH), .IX(50), .IY(120), .H_SIZE(B_SIZE)) b2 (
        .toggle(0),
        .com(com),
        .mode(mode),
        .start(active),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .o_x1(sq_d_x1),
        .o_x2(sq_d_x2),
        .o_y1(sq_d_y1),
        .o_y2(sq_d_y2)
    ); // ball instance
    
    square #(.PY(PY), .PH(PH), .IX(30), .IY(140), .H_SIZE(B_SIZE)) b3 (
        .toggle(0),
        .com(com),
        .mode(mode),
        .start(active),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .o_x1(sq_e_x1),
        .o_x2(sq_e_x2),
        .o_y1(sq_e_y1),
        .o_y2(sq_e_y2)
    ); // ball instance
    
    square #(.PY(PY), .PH(PH), .IX(20), .IY(100), .H_SIZE(B_SIZE)) b4 (
        .toggle(0),
        .com(com),
        .mode(mode),
        .start(active),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .o_x1(sq_f_x1),
        .o_x2(sq_f_x2),
        .o_y1(sq_f_y1),
        .o_y2(sq_f_y2)
    ); // ball instance
    
    square #(.PY(PY), .PH(PH), .IX(70), .IY(240), .H_SIZE(B_SIZE)) b5 (
        .toggle(0),
        .com(com),
        .mode(mode),
        .start(active),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .o_x1(sq_g_x1),
        .o_x2(sq_g_x2),
        .o_y1(sq_g_y1),
        .o_y2(sq_g_y2)
    ); // ball instance
    
    square #(.PY(PY), .PH(PH), .IX(370), .IY(150), .H_SIZE(B_SIZE)) b6 (
        .toggle(0),
        .com(com),
        .mode(mode),
        .start(active),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .o_x1(sq_h_x1),
        .o_x2(sq_h_x2),
        .o_y1(sq_h_y1),
        .o_y2(sq_h_y2)
    ); // ball instance
    
    always @ (*)
    begin
            sq_a = ((x > sq_a_x1) & (y > sq_a_y1) & (x < sq_a_x2) & (y < sq_a_y2)) ? 1 : 0; // draw ball edges
            sq_b = ((x > sq_b_x1) & (y > sq_b_y1) & (x < sq_b_x2) & (y < sq_b_y2)) ? 1 : 0; // draw paddle edges
            sq_b1 = ((y > sq_b1_x1) & (x > sq_b1_y1) & (y < sq_b1_x2) & (x < sq_b1_y2)) ? 1 : 0; // draw paddle edges
            sq_c = ((x > sq_c_x1) & (y > sq_c_y1) & (x < sq_c_x2) & (y < sq_c_y2)) ? 1 : 0; // draw ball edges
            sq_d = ((x > sq_d_x1) & (y > sq_d_y1) & (x < sq_d_x2) & (y < sq_d_y2)) ? 1 : 0; // draw ball edges
            sq_e = ((x > sq_e_x1) & (y > sq_e_y1) & (x < sq_e_x2) & (y < sq_e_y2)) ? 1 : 0; // draw ball edges
            sq_f = ((x > sq_f_x1) & (y > sq_f_y1) & (x < sq_f_x2) & (y < sq_f_y2)) ? 1 : 0; // draw ball edges
            sq_g = ((x > sq_g_x1) & (y > sq_g_y1) & (x < sq_g_x2) & (y < sq_g_y2)) ? 1 : 0; // draw ball edges
            sq_h = ((x > sq_h_x1) & (y > sq_h_y1) & (x < sq_h_x2) & (y < sq_h_y2)) ? 1 : 0; // draw ball edges            
    end
    
    
    
    always @(posedge pix_stb)
    begin
        // assign ball(s) and paddle color white
        VGA_R[3] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60); 
        VGA_G[3] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_B[3] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_R[2] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_G[2] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_B[2] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_R[1] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_G[1] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_B[1] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_R[0] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_G[0] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
        VGA_B[0] <= sq_a | sq_b | sq_b1 | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
    end
endmodule

