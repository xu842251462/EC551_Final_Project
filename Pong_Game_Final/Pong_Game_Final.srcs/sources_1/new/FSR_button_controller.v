`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 12:19:29 PM
// Design Name: 
// Module Name: FSR_button_controller
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

//we use this module to control the direction of analog signal, it will output the direction_cs to the game
module FSR_button_controller(
   input wire CLK100MHZ,
   input wire RST_BTN,
   output reg direction_cs,
   output reg left_flag,
   output reg right_flag,
   output reg neither_flag,
   output reg [27:0] count
    );
    

   
   always @(posedge CLK100MHZ) begin
    if (~RST_BTN) begin
        direction_cs <= 0;
        count <=0;
    end else begin
        count <=count+1;
        if (count >= 27'h5F5E100 )   //2FAF080,   4C4B40
            begin
            direction_cs <= ~direction_cs;
            if (direction_cs==0) begin
                left_flag <= 1;
                right_flag <= 0;
                neither_flag <=0;
                count <=0;
                end
                else if (direction_cs==1) begin
                left_flag <= 0;
                right_flag <= 1;
                neither_flag <=0;
                count <=0;
                end
                else begin
                left_flag <= 0;
                right_flag <= 0;
                neither_flag <=1;
                count <=0;
                end
            end
        end
    end

    
    
endmodule
