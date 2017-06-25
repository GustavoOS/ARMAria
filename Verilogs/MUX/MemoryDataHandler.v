module MemoryDataHandler(
  IData,
  Read,//Read memory
  PreMemIn,//output
  control//Control Unit
  );

  // input [7:0] DataReadByte3, DataReadByte2, DataReadByte1, DataReadByte0;
  input [31:0] Read;
  input [31:0] IData;
  input control;
  output [31:0] PreMemIn;

  assign PreMemIn = (control==1'b0)? Read : IData;

endmodule
