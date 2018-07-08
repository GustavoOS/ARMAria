module Memory
#(
	parameter DW=32,
	parameter ADDR_WIDTH=14, 
	parameter inputFile = "Programa.txt")
(
	input [(DW-1):0] input_data,
	input [(ADDR_WIDTH-1):0] instruction_address, data_address,
	input write_enable, clock,
	output [15:0] instruction,
	output reg [(DW-1):0] output_data
);
	//Chops the instruction output
	reg [(DW-1):0] fetched_instruction;
	assign instruction = fetched_instruction[15:0];

	// Storage declaration
	reg [DW-1:0] ram[2**ADDR_WIDTH-1:0];	

	//Initialization: loads input file into memory
	initial begin
		$readmemb(inputFile, ram);
	end

	//Port A
	always @ (posedge clock)
	begin
		fetched_instruction = ram[instruction_address];
	end

	//Port B
	always @ (negedge clock)	
	begin
		if (write_enable) 
		begin
			ram[data_address] <= input_data;
		end		
		output_data = ram[data_address];				
	end

endmodule
