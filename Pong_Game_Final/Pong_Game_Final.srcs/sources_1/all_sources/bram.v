module bram
	#(
		parameter RAM_WIDTH 		= 144,
		parameter RAM_ADDR_BITS 	= 9,
		parameter INIT_START_ADDR 	= 0,
		parameter INIT_END_ADDR		= 10
	)
	(
	input		wire					clock,
	input		wire					ram_enable,
	input		wire					write_enable,
    input 		wire [RAM_ADDR_BITS-1:0]	address,
    input 		wire       [11:0] input_data,
    input 		wire       [11:0] input_data1,
	 input 		wire       [11:0] input_data2,		
	 input 		wire       [11:0]input_data3,		
	 input 		wire       [11:0]input_data4,		
	 input 		wire       [11:0]input_data5,		
	 input 		wire       [11:0]input_data6,		
	 input 		wire       [11:0]input_data7,		
	 input 		wire       [11:0]input_data8,		
	 input 		wire       [11:0]input_data9,		
	 input 		wire       [11:0]input_data10,		
	 input 		wire       [11:0]input_data11,		
     output reg [11:0] output_data,   
	output reg [11:0]output_data1,    
	output reg [11:0]output_data2,    
	output reg [11:0]output_data3,    
	output reg [11:0]output_data4,    
	output reg [11:0] output_data5,    
	output reg [11:0]output_data6,   
	output reg [11:0]output_data7,  
	output reg [11:0]output_data8,  
	output reg [11:0]output_data9,   
	output reg [11:0]output_data10,   
	output reg [11:0]output_data11
	);
	
   
   (* RAM_STYLE="BLOCK" *)
   reg [RAM_WIDTH-1:0] ram_name [(2**RAM_ADDR_BITS)-1:0];


   always @(posedge clock)
      if (write_enable) begin
            ram_name[address] <= {input_data,input_data1,input_data2,input_data3,input_data4,input_data5,input_data6,input_data7,input_data8,input_data9,input_data10,input_data11};
      end else if (ram_enable) begin
            {output_data,output_data1,output_data2,output_data3,output_data4,output_data5,output_data6,output_data7,output_data8,output_data9,output_data10,output_data11} <= ram_name[address];
      end

endmodule
