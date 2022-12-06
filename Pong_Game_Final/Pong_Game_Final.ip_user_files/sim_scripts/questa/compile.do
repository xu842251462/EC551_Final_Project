vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"c:/Users/xu842251/Downloads/EC551_FinalProject-ma/EC551_FinalProject-main/Analog_Pong_Game/Single Button Game/2018_ADC_Demo/Nexys-A7-100T-XADC.srcs/xadc_wiz_0/ip/xadc_wiz_0/xadc_wiz_0_sim_netlist.v" \


vlog -work xil_defaultlib \
"glbl.v"

