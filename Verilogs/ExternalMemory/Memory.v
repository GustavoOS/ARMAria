module Memory
#(parameter DW=32, parameter ADDR_WIDTH=10)
(
	input [(DW-1):0] input_data,
	input [(ADDR_WIDTH-1):0] instrunction_address, data_address,
	input we_a, clk_a,
	output reg [(DW-1):0] instrunction,
	output reg [(DW-1):0] output_data
);
	// reg [DW-1:0] fetched_instrunction;
	// Declare the RAM variable
	reg [DW-1:0] ram[2**ADDR_WIDTH-1:0];

	

	initial begin
		$readmemb("Program.txt", ram); //File that fills memory
	end

	always @ (posedge clk_a)
	begin
		instrunction = ram[instrunction_address];
	end

	always @ (negedge clk_a)

	
	begin
		if (we_a) 
		begin
			ram[data_address] <= input_data;
		end		
		output_data = ram[data_address];
				
		
	end

endmodule
