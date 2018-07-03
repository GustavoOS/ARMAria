// Quartus Prime Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// single read/write clock

module Memory
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(4*DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, clk,
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0][3:0];

	always @ (posedge clk)
	begin
		// Write
		if (we)begin
			{ram[write_addr][3], ram[write_addr][2], ram[write_addr][1], ram[write_addr][0]} <= data;
		end
		// Read (if read_addr == write_addr, return OLD data).	To return
		// NEW data, use = (blocking write) rather than <= (non-blocking write)
		// in the write assignment.	 NOTE: NEW data may require extra bypass
		// logic around the RAM.
		q <= ram[read_addr][0];
	end

endmodule
