module tb_bram;

parameter RAM_WIDTH = 32;
parameter RAM_ADDR_BITS = 9;

reg							clk;
reg							ram_enable;
reg							write_enable;
reg 	[RAM_ADDR_BITS-1:0]	address = 0;
reg 	[11:0] 	input_data;
wire	[11:0] 	output_data;

reg [11:0] sq_c_x1; 
    reg [11:0] sq_c_x2;
    reg [11:0] sq_c_y1; 
    reg [11:0] sq_c_y2; // positions bits for ball
    
    reg [11:0] sq_d_x1; 
    reg [11:0] sq_d_x2; 
    reg [11:0] sq_d_y1; 
    reg [11:0] sq_d_y2;
    
    reg [11:0] sq_d1_x1; 
    reg [11:0] sq_d1_x2; 
    reg [11:0] sq_d1_y1; 
    reg [11:0] sq_d1_y2;
integer i;
bram
#(
	.RAM_WIDTH 		(RAM_WIDTH 		),
	.RAM_ADDR_BITS 	(RAM_ADDR_BITS 	),
	.INIT_START_ADDR(0				),
	.INIT_END_ADDR	(10				)
)
bram_inst
(
	.clock			(clk			),
	.ram_enable		(ram_enable		),
	.write_enable	(write_enable	),
	.address		(address		),
	.input_data		(input_data		),
	.output_data    (output_data	)
);
	
initial
begin
	clk = 0;
	forever #5 clk = ~clk;
end



	always @(posedge clk) begin
     write_enable	= 1;
   
	for (i = 0; i < 6; i = i +1)
	begin
        case(i)	
		0:begin 
		input_data <= address;
        address <= address + 1;
		end
        1:begin 
		input_data <= address;
        address <= address + 1;
		end
        2:  begin 
		input_data <= address;
address <= address + 1;
		end
        3:  begin 
		input_data <= address;
address <= address + 1;
		end
        4:  begin 
		input_data <= address;
 address <= address + 1;
		end
        5:  begin 
		input_data <= address;
address <= address + 1;
		end
        6:  begin 
		input_data <= address;
address <= address + 1;
		end
        7:  begin 
		input_data <= address;
address <= address + 1;
		end
		8: begin 
		input_data <= address;
address <= address + 1;
		end
		9:  begin 
		input_data <= address;
address <= address + 1;
		end
		10:  begin 
		input_data <= address;
address <= address + 1;
		end
		11:  begin 
		input_data <= address;
		address <= address + 1; 
		end
		
		endcase
		     
		#10;
	end
	write_enable = 0;
	ram_enable	= 1;
	for (address = 0; address < 12; address = address +1)
	begin
		if (address % 12 == 0) sq_c_x1 <= output_data;
        else if (address % 12 == 1) sq_c_x2 <= output_data;
        else if (address % 12 == 2) sq_c_y1 <= output_data;
        else if (address % 12 == 3) sq_c_y2 <= output_data;
        else if (address % 12 == 4) sq_d_x1 <= output_data;
        else if (address % 12 == 5) sq_d_x2 <= output_data;
        else if (address % 12 == 6) sq_d_y1 <= output_data;
        else if (address % 12 == 7) sq_d_y2 <= output_data;
		else if (address % 12 == 8) sq_d1_x1 <= output_data;
		else if (address % 12 == 9) sq_d1_x2 <= output_data;
		else if (address % 12 == 10) sq_d1_y1 <= output_data;
		else if (address % 12 == 11)  sq_d1_y2 <= output_data;
		 #10;
	end
	ram_enable	= 0;
	
end

endmodule