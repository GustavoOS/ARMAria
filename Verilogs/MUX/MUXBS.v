module MUXBS(
  MUXSelector,//0 to B, 1 to Offset
  B,
  Offset,
  PreB
  );
  input MUXSelector;
  input [31:0] B;
  input [7:0] Offset;
  output [31:0] PreB;

  assign PreB= (~MUXSelector)? B:{23'h0, Offset};

endmodule
