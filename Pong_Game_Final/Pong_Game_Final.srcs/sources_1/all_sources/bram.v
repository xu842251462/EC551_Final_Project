module bram
	#(
		parameter RAM_WIDTH 		= 32,
		parameter RAM_ADDR_BITS 	= 9,
		parameter INIT_START_ADDR 	= 0,
		parameter INIT_END_ADDR		= 10
	)
	(
	input		wire					clock,
	input		wire					ram_enable,
	input		wire					write_enable,
    input 		wire [RAM_ADDR_BITS-1:0]	address,
    input 		wire       [11:0] 	input_data,
	output reg 	[11:0] 	output_data
	);
	
   
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] ram_name [(2**RAM_ADDR_BITS)-1:0];


   always @(posedge clock)
      if (write_enable) begin
            ram_name[address] <= {20'b0,input_data};
      end else if (ram_enable) begin
            output_data <= ram_name[address][11:0];
      end

endmodule
