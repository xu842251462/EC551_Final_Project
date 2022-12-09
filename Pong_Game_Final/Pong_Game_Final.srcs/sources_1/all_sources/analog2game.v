`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2022 03:04:55 PM
// Design Name: 
// Module Name: analog2game
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

//this module sends the direction and speed signal
module analog2game(
    input wire CLK100MHZ,
    input wire RST_BTN,
    input wire [11:0]analog_in,
    input wire SW_direction,
    output reg [3:0]Speed,
    output reg [1:0]BTN_LR
    );

  reg [1:0] BTN_LR_NEXT;
  reg [23:0] count;


  always@(posedge CLK100MHZ)
     begin
         if(analog_in >= 1000)      // Looks nicer if our max value is 1V instead of .999755
            begin
                case(SW_direction)
                    2'b0: BTN_LR_NEXT <= 2'b01;
                    2'b1: BTN_LR_NEXT <= 2'b10;
                endcase
            end
        else begin
            BTN_LR_NEXT <= 00;
            end
        if(analog_in >= 1000 && analog_in < 1100)
            begin
            Speed = 4'b10;
            end
        else if (analog_in >= 1100 && analog_in < 1200)
            begin
            Speed = 4'b100;
            end
        else if (analog_in >= 1200 && analog_in < 3000)
            begin
            Speed = 4'b1000;
            end
    end
    
    always @(posedge CLK100MHZ)
    begin 
         if (~RST_BTN) begin
            count <=0;
         end else begin
            count <=count+1;
                 if (count >= 26'h10000 ) begin
                    BTN_LR<=BTN_LR_NEXT;
                    count <=0;
                end
        end
    end
     
endmodule
