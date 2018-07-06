module SignExtend
#(
	parameter DATA_WIDTH = 32
)(
	input [31:0] Input,
	input [2:0] control,
	output reg [31:0] outputSE
);

	wire signed [7:0] byte1, byte0;
	assign {byte1,byte0} = Input[15:0];

	always @ ( * ) begin
		case (control)
			1:begin //Sign extends halfword to word
				outputSE = ({byte1, byte0}<0)? {16'hffff, byte1, byte0} : {16'h0, byte1, byte0};
			end
			2:begin //Sign extends byte to word
				outputSE = (byte0<0)? {16'hffff, 8'hff, byte0} : {16'h0, 8'h0, byte0};
			end
			3:begin//Zero extends halfword
				outputSE = {16'h0, byte1, byte0};
			end
			4:begin///Zero extends byte
				outputSE = {16'h0, 8'h0, byte0};
			end
			default:begin
				outputSE = Input;
			end
		endcase
	end

endmodule
