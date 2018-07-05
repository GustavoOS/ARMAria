module Memory
#(parameter DW=32, parameter ADDR_WIDTH=14, parameter inputFile = "Program.txt")
(
	input [(DW-1):0] input_data,
	input [(ADDR_WIDTH-1):0] instrunction_address, data_address,
	input write_enable, clock,
	output [15:0] instrunction,
	output reg [(DW-1):0] output_data
);
	//Chops the instrunction output
	reg [(DW-1):0] fetched_instrunction;
	assign instrunction = fetched_instrunction[15:0];

	// Storage declaration
	reg [DW-1:0] ram[2**ADDR_WIDTH-1:0];	

	//Initialization: loads input file into memory
	initial begin
		// $readmemb(inputFile, ram);
		ram[0] = 0;
		ram[1] = 1;
		ram[2] = 2;
		ram[3] = 3;
		ram[4] = 4;
		ram[5] = 5;
		ram[6] = 6;
		ram[7] = 7;
		ram[8] = 8;
		ram[9] = 9;
		ram[10] = 10;
		ram[11] = 11;
		ram[12] = 12;
		ram[13] = 13;
		ram[14] = 14;
		ram[15] = 15;
		ram[16] = 16;
		ram[17] = 17;
		ram[18] = 18;
		ram[19] = 19;
		ram[20] = 20;
		ram[21] = 21;
		ram[22] = 22;
		ram[23] = 23;
		ram[24] = 24;
		ram[25] = 25;
		ram[26] = 26;
		ram[27] = 27;
		ram[28] = 28;
		ram[29] = 29;
		ram[30] = 30;
		ram[31] = 31;
		ram[32] = 32;
		ram[33] = 33;
		ram[34] = 34;
		ram[35] = 35;
		ram[36] = 36;
		ram[37] = 37;
		ram[38] = 38;
		ram[39] = 39;
		ram[40] = 40;
		ram[41] = 41;
		ram[42] = 42;
		ram[43] = 43;
		ram[44] = 44;
		ram[45] = 45;
		ram[46] = 46;
		ram[47] = 47;
		ram[48] = 48;
		ram[49] = 49;
		ram[50] = 50;
		ram[51] = 51;
		ram[52] = 52;
		ram[53] = 53;
		ram[54] = 54;
		ram[55] = 55;
		ram[56] = 56;
		ram[57] = 57;
		ram[58] = 58;
		ram[59] = 59;
		ram[60] = 60;
		ram[61] = 61;
		ram[62] = 62;
		ram[63] = 63;
		ram[64] = 64;
		ram[65] = 65;
		ram[66] = 66;
		ram[67] = 67;
		ram[68] = 68;
		ram[69] = 69;
		ram[70] = 70;
		ram[71] = 71;
		ram[72] = 72;
		ram[73] = 73;
		ram[74] = 74;
		ram[75] = 75;
		ram[76] = 76;
		ram[77] = 77;
		ram[78] = 78;
		ram[79] = 79;
		ram[80] = 80;
		ram[81] = 81;
		ram[82] = 82;
		ram[83] = 83;
		ram[84] = 84;
		ram[85] = 85;
		ram[86] = 86;
		ram[87] = 87;
		ram[88] = 88;
		ram[89] = 89;
		ram[90] = 90;
		ram[91] = 91;
		ram[92] = 92;
		ram[93] = 93;
		ram[94] = 94;
		ram[95] = 95;
		ram[96] = 96;
		ram[97] = 97;
		ram[98] = 98;
		ram[99] = 99;
	end

	//Port A
	always @ (posedge clock)
	begin
		fetched_instrunction = ram[instrunction_address];
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
