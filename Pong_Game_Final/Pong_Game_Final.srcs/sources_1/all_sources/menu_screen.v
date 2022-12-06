`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 01:08:34 PM
// Design Name: 
// Module Name: menu_screen
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


module menu_screen (
    input wire mode, // mode to check if menu screen needs to update
    input wire CLK, // 100 MHz clock
    output wire VGA_HS, // vga horizontal sync
    output wire VGA_VS, // vga vertical sync
    output reg [3:0] VGA_R, // vga red channels
    output reg [3:0] VGA_G, // vga green channels
    output reg [3:0] VGA_B // vga blue channels
    );
 
    localparam IX = 320; // intial ball x
    localparam IY = 440; //initial ball y
    localparam B_SIZE = 20; // ball size
    
    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing
    wire active;   // high during active pixel drawing

    
    reg [15:0] cnt = 0; // clock divider count
    reg pix_stb = 0; // pixel clock   
    reg sq_a; // registers to assign objects

    wire [11:0] sq_a_x1, sq_a_x2, sq_a_y1, sq_a_y2; // positions bits for ball
   
    always @(posedge CLK)
    begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
    end
        
    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(mode),
        .o_hs(VGA_HS), 
        .o_vs(VGA_VS), 
        .o_x(x), 
        .o_y(y),
        .o_animate(animate),
        .o_active(active)
    ); // vga 640x480 driver
    
     start_square #(.IX(IX), .IY(IY), .H_SIZE(B_SIZE)) ball (
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .o_x1(sq_a_x1),
        .o_x2(sq_a_x2),
        .o_y1(sq_a_y1),
        .o_y2(sq_a_y2)
    ); // ball instance
    
localparam SCREEN_WIDTH = 640; // screen width
    localparam SCREEN_HEIGHT = 480; // screen height
    localparam VRAM_DEPTH = SCREEN_WIDTH * SCREEN_HEIGHT; 
    localparam VRAM_A_WIDTH = 18;  // 2^19 > 640 x 480
    localparam VRAM_D_WIDTH = 6;   // colour bits per pixel

    reg [VRAM_A_WIDTH-1:0] address; // bitmap address
    wire [VRAM_D_WIDTH-1:0] dataout; // bitmap to vga

    sram #(
        .ADDR_WIDTH(VRAM_A_WIDTH), 
        .DATA_WIDTH(VRAM_D_WIDTH), 
        .DEPTH(VRAM_DEPTH), 
        .MEMFILE("over.mem"))
        vram (
        .i_addr(address), 
        .i_clk(CLK), 
        .i_write(0),
        .i_data(0), 
        .o_data(dataout)
    ); // memory map reader instance

    reg [11:0] palette [0:63];  // 64 x 12-bit colour palette entries
    reg [11:0] color; // color bits for vga
    
    initial begin
        $display("Loading palette.");
        $readmemh("over_palette.mem", palette);  // bitmap palette to load
    end    
    
    
    always @(*)
    begin 
        sq_a = ((x > sq_a_x1) & (y > sq_a_y1) & (x < sq_a_x2) & (y < sq_a_y2)) ? 1 : 0; // draw ball edges
    end
    

     
    always @(posedge CLK)
    begin
        address <= y * SCREEN_WIDTH + x; // assign address of bitmap

        if (active)
            color <= palette[dataout]; // draw bitmap colors
        else    
            color <= 0; // draw nothing
            
        // assign ball color white and bitmap to corresponding colors
        VGA_R[3] <= color[11] ^ sq_a; 
        VGA_G[3] <= color[7] ^ sq_a; 
        VGA_B[3] <= color[3] ^ sq_a;
        VGA_R[2] <= color[10] ^ sq_a; 
        VGA_G[2] <= color[6] ^ sq_a; 
        VGA_B[2] <= color[2] ^ sq_a;
        VGA_R[1] <= color[9] ^ sq_a; 
        VGA_G[1] <= color[5] ^ sq_a; 
        VGA_B[1] <= color[1] ^ sq_a;
        VGA_R[0] <= color[8] ^ sq_a;
        VGA_G[0] <= color[4] ^ sq_a;
        VGA_B[0] <= color[0] ^ sq_a;

    end
    
    
endmodule
