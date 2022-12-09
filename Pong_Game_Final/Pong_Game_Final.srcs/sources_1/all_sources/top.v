`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2015 03:26:51 PM
// Design Name: 
// Module Name: // Project Name: 
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
 
// top module for ADC, we adjust the addressin in below code
module top_XADC(
   input wire CLK100MHZ,
   input wire vauxp2,
   input wire vauxn2,
   input wire vauxp3,
   input wire vauxn3,
   input wire vauxp10,
   input wire vauxn10,
   input wire vauxp11,
   input wire vauxn11,
   input wire vp_in,
   input wire vn_in,
   input wire direction_cs,
   output reg [15:0] LED,
   output wire [7:0] an,
   output wire dp,
   output wire [6:0] seg,
   output reg [11:0] decimal_reg_in
 );
   
   wire enable;  
   wire ready;
   wire [15:0] data;   
   reg [6:0] Address_in;     
   reg [32:0] decimal;   
   reg [3:0] dig0;
   reg [3:0] dig1;
   reg [3:0] dig2;
   reg [3:0] dig3;
   reg [3:0] dig4;
   reg [3:0] dig5;
   reg [3:0] dig6;

  
  
   
   //xadc instantiation connect the eoc_out .den_in to get continuous conversion
   xadc_wiz_0  XLXI_7 (.daddr_in(Address_in), //addresses can be found in the artix 7 XADC user guide DRP register space
                     .dclk_in(CLK100MHZ), 
                     .den_in(enable), 
                     .di_in(0), 
                     .dwe_in(0), 
                     .busy_out(),                    
                     .vauxp2(vauxp2),
                     .vauxn2(vauxn2),
                     .vauxp3(vauxp3),
                     .vauxn3(vauxn3),
                     .vauxp10(vauxp10),
                     .vauxn10(vauxn10),
                     .vauxp11(vauxp11),
                     .vauxn11(vauxn11),
                     .vn_in(vn_in), 
                     .vp_in(vp_in), 
                     .alarm_out(), 
                     .do_out(data), 
                     .reset_in(0),
                     .eoc_out(enable),
                     .channel_out(),
                     .drdy_out(ready));
                     
         
    
      //led visual dmm              
      always @( posedge(CLK100MHZ))
      begin            
        if(ready == 1'b1)
        begin
          case (data[15:12])
            1:  LED <= 16'b11;
            2:  LED <= 16'b111;
            3:  LED <= 16'b1111;
            4:  LED <= 16'b11111;
            5:  LED <= 16'b111111;
            6:  LED <= 16'b1111111; 
            7:  LED <= 16'b11111111;
            8:  LED <= 16'b111111111;
            9:  LED <= 16'b1111111111;
            10: LED <= 16'b11111111111;
            11: LED <= 16'b111111111111;
            12: LED <= 16'b1111111111111;
            13: LED <= 16'b11111111111111;
            14: LED <= 16'b111111111111111;
            15: LED <= 16'b1111111111111111;                        
           default: LED <= 16'b1; 
           endcase
        end 

          
      end
      
     reg [32:0] count; 
     //binary to decimal conversion
      always @ (posedge(CLK100MHZ))
      begin
      
        if(count == 10000000)begin
        
        decimal_reg_in = data >> 4;
        //looks nicer if our max value is 1V instead of .999755
        if(decimal_reg_in >= 4093)
        begin
            dig0 = 0;
            dig1 = 0;
            dig2 = 0;
            dig3 = 0;
            dig4 = 0;
            dig5 = 0;
            dig6 = 1;
            count = 0;
        end
        else 
        begin
            decimal = decimal_reg_in * 250000;
            decimal = decimal >> 10;
            
            
            dig0 = decimal % 10;
            decimal = decimal / 10;
            
            dig1 = decimal % 10;
            decimal = decimal / 10;
                   
            dig2 = decimal % 10;
            decimal = decimal / 10;
            
            dig3 = decimal % 10;
            decimal = decimal / 10;
            
            dig4 = decimal % 10;
            decimal = decimal / 10;
                   
            dig5 = decimal % 10;
            decimal = decimal / 10; 
            
            dig6 = decimal % 10;
            decimal = decimal / 10; 
            
            count = 0;
        end
       end
       
      count = count + 1;
               
      end
      
 //we need to change this block of code to make sure analog signal connect to the right channel, it will pass the right value to the FPGA
      always @(posedge(CLK100MHZ))
      begin
        case(direction_cs)
        0: Address_in <= 7'h12;
        1: Address_in <= 7'h1a;
        2: Address_in <= 7'h13;
        3: Address_in <= 7'h1b;
        endcase
      
      
      end
      
      DigitToSeg segment1(.in1(dig0),
                         .in2(dig1),
                         .in3(dig2),
                         .in4(dig3),
                         .in5(dig4),
                         .in6(dig5),
                         .in7(dig6),
                         .in8(),
                         .mclk(CLK100MHZ),
                         .an(an),
                         .dp(dp),
                         .seg(seg));  
endmodule
