vlib work
vlib activehdl

vlib activehdl/xil_defaultlib

vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"c:/Users/xu842251/Downloads/EC551_FinalProject-ma/EC551_FinalProject-main/Analog_Pong_Game/Single Button Game/2018_ADC_Demo/Nexys-A7-100T-XADC.srcs/xadc_wiz_0/ip/xadc_wiz_0/xadc_wiz_0_sim_netlist.v" \


vlog -work xil_defaultlib \
"glbl.v"

