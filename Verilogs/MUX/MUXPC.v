module MUXPC(
  Result, PC,
  ResultPC, selector, reset
  );
  input selector, reset;
  input [31:0] Result, PC;
  output [31:0] ResultPC;

  assign ResultPC = (reset==1'b1)? 10'h1:
  (selector==1'b1)? Result[9:0] : PC[9:0];

endmodule
