module SignExtend
#(
	parameter DATA_WIDTH = 32
)(
	input [DATA_WIDTH -1:0] Input,
	input [2:0] control,
	output reg [DATA_WIDTH -1:0] outputSE
);


	always @ ( * ) begin
		case (control)
			1:begin //Sign extends halfword to word
				outputSE = (Input[15])? {16'hffff,Input[15:0]} : {16'h0, Input[15:0]};
			end
			2:begin //Sign extends byte to word
				outputSE = (Input[7])? {24'hffffff, Input[7:0]} : {24'h0, Input[7:0]};
			end
			3:begin//Zero extends halfword
				outputSE = {16'h0, Input[15:0]};
			end
			4:begin///Zero extends byte
				outputSE = {24'h0, Input[7:0]};
			end
			default:begin
				outputSE = Input;
			end
		endcase
	end

endmodule
