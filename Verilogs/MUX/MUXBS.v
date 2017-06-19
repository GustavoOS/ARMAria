module MUXBS(
  MUXSelector,//0 to B, 1 to Offset
  B,
  Offset,
  PreB
  );
  input MUXSelector;
  input [31:0] B;
  input [8:0] Offset;
  output [31:0] PreB;

  assign PreB= (~MUXSelector)? B:
    (Offset[8]==1'b0) ? {23'h0, Offset}:
    (Offset[7:0]==8'h0) ? 32'h2004 :  //Demultiplexed from instructiondecoder
    (Offset[7:0]==8'h1) ? 32'h2008:   //Demultiplexed from instructiondecoder
    32'h2006                          //Demultiplexed from instructiondecoder
  ;

endmodule
