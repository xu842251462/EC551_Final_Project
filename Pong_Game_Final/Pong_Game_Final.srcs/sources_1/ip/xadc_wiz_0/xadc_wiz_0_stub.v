// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Mon Dec  5 17:04:14 2022
// Host        : ECE-PHO115-14 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top xadc_wiz_0 -prefix
//               xadc_wiz_0_ xadc_wiz_0_stub.v
// Design      : xadc_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module xadc_wiz_0(daddr_in, dclk_in, den_in, di_in, dwe_in, reset_in, 
  vauxp2, vauxn2, vauxp3, vauxn3, vauxp10, vauxn10, vauxp11, vauxn11, busy_out, channel_out, do_out, 
  drdy_out, eoc_out, eos_out, alarm_out, vp_in, vn_in)
/* synthesis syn_black_box black_box_pad_pin="daddr_in[6:0],dclk_in,den_in,di_in[15:0],dwe_in,reset_in,vauxp2,vauxn2,vauxp3,vauxn3,vauxp10,vauxn10,vauxp11,vauxn11,busy_out,channel_out[4:0],do_out[15:0],drdy_out,eoc_out,eos_out,alarm_out,vp_in,vn_in" */;
  input [6:0]daddr_in;
  input dclk_in;
  input den_in;
  input [15:0]di_in;
  input dwe_in;
  input reset_in;
  input vauxp2;
  input vauxn2;
  input vauxp3;
  input vauxn3;
  input vauxp10;
  input vauxn10;
  input vauxp11;
  input vauxn11;
  output busy_out;
  output [4:0]channel_out;
  output [15:0]do_out;
  output drdy_out;
  output eoc_out;
  output eos_out;
  output alarm_out;
  input vp_in;
  input vn_in;
endmodule
