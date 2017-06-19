module SignExtend(inputA, control, outputSE);
input [31:0] inputA;
input [2:0] control;
output reg [31:0] outputSE;


always @ (*)
	begin

	  case(control)
		  1://Sign extends halfword to word
		  begin
			 outputSE[15:0]=inputA[15:0];
			 outputSE[31:16]=inputA[15]? 16'hFFFF : 16'h0;
		  end
		  2://Sign extends byte to word
		  begin
			 outputSE[7:0]=inputA[7:0];
			 outputSE[31:8]=inputA[7]? 24'hFFFFFF : 24'h0;
		  end
		  3://Zero extends halfword
		  begin
			 outputSE[15:0]=inputA[15:0];
			 outputSE[31:16]=0;
		  end
		  4://Zero extends byte
		  begin
			 outputSE[7:0]=inputA[7:0];
			 outputSE[31:8]=0;
		  end
			
		  default:
		  begin
			 outputSE=inputA;
		  end
		endcase
	end

endmodule
