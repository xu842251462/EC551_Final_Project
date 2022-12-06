`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2020 09:45:00 PM
// Design Name: 
// Module Name: num_hex
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


module num_hex(
    input wire clk, // input clock
    input wire [3:0] bnum, // input number
    output reg [6:0] hex_seg // output segment
    );
    
    always @(posedge clk) begin
        case (bnum)
            4'b0000 : hex_seg <= ~7'h7E; // 0
            4'b0001 : hex_seg <= ~7'h30; // 1
            4'b0010 : hex_seg <= ~7'h6D; // 2
            4'b0011 : hex_seg <= ~7'h79; // 3
            4'b0100 : hex_seg <= ~7'h33; // 4     
            4'b0101 : hex_seg <= ~7'h5B; // 5
            4'b0110 : hex_seg <= ~7'h5F; // 6
            4'b0111 : hex_seg <= ~7'h70; // 7
            4'b1000 : hex_seg <= ~7'h7F; // 8
            4'b1001 : hex_seg <= ~7'h7B; // 9
            4'b1010 : hex_seg <= ~7'h77; // A
            4'b1011 : hex_seg <= ~7'h1F; // B
            4'b1100 : hex_seg <= ~7'h4E; // C
            4'b1101 : hex_seg <= ~7'h3D; // D
            4'b1110 : hex_seg <= ~7'h4F; // E
            4'b1111 : hex_seg <= ~7'h47; // F
        endcase
     end
endmodule
