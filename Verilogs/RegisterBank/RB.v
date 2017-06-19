module RB(
  clock, enable, control, M,
  RegD, RegA, RegB,
  busA, busB,
  Result,
  MemOut, MemIn,
  PC, SP,
  PCd, SPd
  );

  input clock, enable, M;
  input [2:0] control;
  input [3:0] RegD, RegA, RegB;
  input [31:0] Result, MemIn, PCd, SPd;
  output [31:0] busA, busB, MemOut, PC, SP;

  reg [7:0] Bank [15:0];
  reg [31:0] SSP,PSP;//Standard Stack Pointer, Privileged Stack Pointer

  //Readers
  assign busA = Bank [RegA];
  assign busB = Bank [RegB];
  assign MemOut = Bank [RegD];
  assign SP = M? PSP:SSP;//Exports the right SP depending on M flag
  assign PC = Bank[15];

  always @ ( posedge clock ) begin

    case (control)
      1:begin
        Bank [RegD] <= Result;
      end
      3:begin
        Bank [RegD] <= MemIn;
      end
      5:begin
        PSP <= 32'hffffffff;
        SSP <= 32'hffffffff;
      end
      default: ;
    endcase
  end


endmodule
