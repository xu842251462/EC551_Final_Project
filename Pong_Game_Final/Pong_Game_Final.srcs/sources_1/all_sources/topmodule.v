`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 09:03:24 PM
// Design Name: 
// Module Name: topmodule
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

//This is the top module of game, we need to change add new module to process the end game capture, pass speed and analog signal to the different module in the game
module top_pong(
    input wire CLK, // 100 Mhz clock
    input wire RST_BTN, // reset button
    input wire [1:0] BTN_LR, // left and right buttons
    input wire [1:0] BTN_UD,
    input wire BTNC, // mode change button
    input wire reply,
    input wire [3:0] Speed,
    output reg VGA_HS, // horizontal sync
    output reg VGA_VS, // vertical sync
    output reg [3:0] VGA_R, // red channels
    output reg [3:0] VGA_G, // green channels
    output reg [3:0] VGA_B, // blue channels
    output reg [6:0] seg, // 7-segment segments 
    output reg [7:0] AN // 7-segment anodes
    );
    
    wire [3:0] vga_r, vga_g, vga_b; // pong game vga
    wire [3:0] vga_r_end, vga_g_end, vga_b_end; // game over menu vga
    wire [3:0] vga_r_start, vga_g_start, vga_b_start; // start menu vga 

    wire vga_hs, vga_vs; // pong game horizontal and vertical sync
    wire vga_h_start, vga_v_start; // start menu horizontal and vertical sync
    wire vga_h_end, vga_v_end; // game over menu horizontal and vertical sync

    
    wire [6:0] c_seg, h_seg; // current score segments
    wire [7:0] c_anode, h_anode; // high score segments
    
    wire [8:0] curr_score, highest_score; // current score bits
    wire slow_clk; // 7-segment clock 
    
    wire endgame; // game over flag
    wire mode; // mode 0 - start menu, 1 - pong game
    wire [7:0]o_data;
        
    clock_divider #(.DIVISOR(500000)) clk600Hz(.clk_in(CLK), .clk_out(slow_clk));  // create 200 Hz clock for seven segment display
    
    
    wire [11:0] sq_a_x1; 
    wire [11:0] sq_a_x2;
    wire [11:0] sq_a_y1; 
    wire [11:0] sq_a_y2; // positions bits for ball
    
    wire [11:0] sq_b_x1; 
    wire [11:0] sq_b_x2; 
    wire [11:0] sq_b_y1; 
    wire [11:0] sq_b_y2;
    
    wire [11:0] sq_b1_x1; 
    wire [11:0] sq_b1_x2; 
    wire [11:0] sq_b1_y1; 
    wire [11:0] sq_b1_y2;
    
    reg [11:0] sq_c_x1; 
    reg [11:0] sq_c_x2;
    reg [11:0] sq_c_y1; 
    reg [11:0] sq_c_y2; // positions bits for ball
    
    reg [11:0] sq_d_x1; 
    reg [11:0] sq_d_x2; 
    reg [11:0] sq_d_y1; 
    reg [11:0] sq_d_y2;
    
    reg [11:0] sq_d1_x1; 
    reg [11:0] sq_d1_x2; 
    reg [11:0] sq_d1_y1; 
    reg [11:0] sq_d1_y2;
    
	
	//we need to pass the positions of square and paddle to our end_capture module, every square and paddle have 4 points.
    game pong(.mode(mode), .CLK(CLK), .BTN_LR(BTN_LR), .VGA_HS(vga_hs), .VGA_VS(vga_vs), 
    .VGA_R(vga_r), .VGA_G(vga_g), .VGA_B(vga_b), .endgame(endgame), .score(curr_score),
    .BTN_UD(BTN_UD),
    .sq_a_x1(sq_a_x1),
    .sq_a_x2(sq_a_x2),
    .sq_a_y1(sq_a_y1),
    .sq_a_y2(sq_a_y2),
    .sq_b_x1(sq_b_x1),
    .sq_b_x2(sq_b_x2),
    .sq_b_y1(sq_b_y1),
    .sq_b_y2(sq_b_y2),
    .sq_b1_x1(sq_b1_x1),
    .sq_b1_x2(sq_b1_x2),
    .sq_b1_y1(sq_b1_y1),
    .sq_b1_y2(sq_b1_y2),
    .Speed(Speed)   
    ); // initialize pong game
    
    
    
    menu_screen(.mode(mode), .CLK(CLK), .VGA_HS(vga_h_start), .VGA_VS(vga_v_start), 
    .VGA_R(vga_r_start), .VGA_G(vga_g_start), .VGA_B(vga_b_start)); // start menu driver
    
    
    
    bg_gen #(.MEMFILE("gameover.mem"), .PALETTE("gameover_palette.mem")) end_screen
    (
    .CLK(CLK), .RST_BTN(RST_BTN), .VGA_HS(vga_h_end), 
    .VGA_VS(vga_v_end), .VGA_R(vga_r_end), .VGA_G(vga_g_end), .VGA_B(vga_b_end)); // game over menu driver
            
            
            
    score_to_7seg current(.clk(slow_clk), .currscore(curr_score), .anode(c_anode), .segment(c_seg)); // current score to 7-segment display
    score_to_7seg highest(.clk(slow_clk), .currscore(highest_score), .anode(h_anode), .segment(h_seg)); // high score to 7-segment display
    
    increment_one change_mode(.CLK(CLK), .btn(BTNC), .duty(mode)); // change mode
    
	
	//this module get signal from the game module, it will pass out the VGA signal to the monitor. 
    wire [3:0] VGA_R_C; // red channels
    wire [3:0] VGA_G_C; // green channels
    wire [3:0] VGA_B_C; // blue channels
    wire VGA_HS_C; // horizontal sync
    wire VGA_VS_C; // vertical sync
    wire record; //flag for recording
    end_capture ec(
        .sq_a_x1(sq_c_x1),
        .sq_a_x2(sq_c_x2),
        .sq_a_y1(sq_c_y1),
        .sq_a_y2(sq_c_y2),
        .sq_b_x1(sq_d_x1),
        .sq_b_x2(sq_d_x2),
        .sq_b_y1(sq_d_y1),
        .sq_b_y2(sq_d_y2), 
        .sq_b1_x1(sq_d1_x1),
        .sq_b1_x2(sq_d1_x2),
        .sq_b1_y1(sq_d1_y1),
        .sq_b1_y2(sq_d1_y2), 
        
        .CLK(CLK), // 100 Mhz clock
        .VGA_HS(VGA_HS_C), // horizontal sync
        .VGA_VS(VGA_VS_C), // vertical sync    
        .VGA_R_C(VGA_R_C), // red channels
        .VGA_G_C(VGA_G_C), // green channels
        .VGA_B_C(VGA_B_C), // blue channels  
        .endgame(endgame),
        .score(curr_score)
       // .record(record)
    );
	
	//add the ram to save the bunch of data from the pong game, we plan to replay the video, there is still some issue for using this block of code
    parameter RAM_WIDTH = 32;
parameter RAM_ADDR_BITS = 9;

reg							ram_enable;
reg							write_enable;
reg 	[RAM_ADDR_BITS-1:0]	address;
reg 	[11:0] 	input_data;
wire	[11:0] 	output_data;
reg     [8:0] i;
reg     [8:0] 	addressb;
bram
#(
	.RAM_WIDTH 		(RAM_WIDTH 		),
	.RAM_ADDR_BITS 	(RAM_ADDR_BITS 	),
	.INIT_START_ADDR(0				),
	.INIT_END_ADDR	(10				)
)
bram_inst
(
	.clock			(CLK			),
	.ram_enable		(ram_enable		),
	.write_enable	(write_enable	),
	.address		(address		),
	.input_data		(input_data		),
	.output_data    (output_data	)
);
	
    always @(*)
    begin
        case(mode)
            0: begin
                {seg, AN, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B} = {h_seg, h_anode, vga_h_start, vga_v_start, vga_r_start, vga_g_start, vga_b_start}; // start menu
            end
            1:begin 
                if (!endgame) begin // if game over flag not triggered
                    {seg, AN, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS} = {c_seg, c_anode, vga_r, vga_g, vga_b, vga_hs, vga_vs}; // pong game
                  
                end else 
			
	        // we need another state for getting the VGA data, it will be triggered by the replay switch and endgame signal
                if(reply & endgame) 
                begin // if game over flag triggered
                   
                     {AN, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS} = {8'b11111111 ,VGA_R_C, VGA_G_C, VGA_B_C, VGA_HS_C, VGA_VS_C}; // game over screen
                end else 
                if(endgame) 
                begin // if game over flag triggered
                     //addressb <= address;
                     {AN, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS} = {8'b11111111 ,vga_r_end, vga_g_end, vga_b_end, vga_h_end, vga_v_end}; // game over screen
                end      
              end        
        endcase
    end
    
   

endmodule
