module StorageDrive
#(
	parameter DW=32,
	parameter ADDR_WIDTH=14, 
	parameter inputFile = "Programa.txt")
(
	input [(DW-1):0] input_data,
	input [(ADDR_WIDTH-1):0] data_address,
	input write_enable, read_clock, write_clock
);

	// Storage declaration
	reg [DW-1:0] hd[2**ADDR_WIDTH-1:0];

	//Initialization: loads input file into memory
	initial begin
		$readmemb(inputFile, hd);
	end

	// Read port	
	always @ (posedge read_clock)
	begin	
		output_data <= hd[data_address];
	end

	// Write port
	always @ (posedge write_clock)
	begin
		if (write_enable)
			hd[data_address] <= input_data;
	end

endmodule
