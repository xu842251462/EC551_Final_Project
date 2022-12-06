`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 02:51:10 PM
// Design Name: 
// Module Name: t_FSR
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


module t_FSR(

    );
    
   reg CLK100MHZ;
   reg RST_BTN;
   reg vauxp2;
   reg vauxn2;
   reg vauxp3;
   reg vauxn3;
   reg vauxp10;
   reg vauxn10;
   reg vauxp11;
   reg vauxn11;
   reg vp_in;
   reg vn_in;
   reg [1:0] sw;
   
   wire [15:0] LED;
   wire [7:0] an;
   wire dp;
   wire [6:0] seg;
   wire direction_cs;
   wire [11:0] decimal_reg_in;
   wire left_flag;
   wire right_flag;
   wire neither_flag;
   wire [23:0] count;
   
    FSR_button_controller uut(
  .CLK100MHZ(CLK100MHZ),
  .RST_BTN(RST_BTN),
  .vauxp2(vauxp2),
  .vauxn2(vauxn2),
  .vauxp3(vauxp3),
  .vauxn3(vauxn3),
  .vauxp10(vauxp10),
  .vauxn10(vauxn10),
  .vauxp11(vauxp11),
  .vauxn11(vauxn11),
  .vp_in(vp_in),
  .vn_in(vn_in),
  .sw(sw),
  .LED(LED),
  .an(an),
  .dp(dp),
  .seg(seg),
  .direction_cs(direction_cs),
  .decimal_reg_in(decimal_reg_in),
  .left_flag(left_flag),
  .right_flag(right_flag),
  .neither_flag(neither_flag),
  .count(count)
    );
    
    
    
    
    initial begin
        CLK100MHZ = 0; 
        RST_BTN = 0;
        forever #10 CLK100MHZ = ~CLK100MHZ;
        #100 $finish;
    
    end   
    
    
    
    
endmodule
