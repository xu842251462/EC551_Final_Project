`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2022 08:36:27 PM
// Design Name: 
// Module Name: sram_write
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
`default_nettype none

module sram_write
#(parameter ADDR_WIDTH=8, DATA_WIDTH=8, DEPTH=256) (
    input wire i_clk,
    input wire [ADDR_WIDTH-1:0] i_addr, 
    input wire i_write,
    input wire [DATA_WIDTH-1:0] i_data,
    output reg [DATA_WIDTH-1:0] o_data
    
    );

    reg [DATA_WIDTH-1:0] memory_array [0:DEPTH-1];  
    always @ (posedge i_clk)
    begin
        if(i_write) begin
            memory_array[i_addr] <= i_data;           
        end
        else begin
            o_data <= memory_array[i_addr];
        end     
    end
endmodule
