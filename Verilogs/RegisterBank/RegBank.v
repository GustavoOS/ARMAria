module RegBank(
    A, B,//Read
    Result,//From ALU
    PC, PCin, SP, SPin,//Memory Address Handler
    MemOut,//To MDH
    MemIn,//From Memory
    M,//MODE Flag: 0 to user, 1 to privileged
    RegD,RegA, RegB,//Control Unit
    control, clock,
    enable, reset
  );
  //I/O
  input [31:0] Result, PCin, SPin, MemIn;
  input [3:0] RegD, RegA, RegB;
  input M, clock, enable, reset;
  input [2:0] control;
  output [31:0] A,B, PC, SP;
  output [31:0]  MemOut;
  parameter dataStart = 113;

  reg [31:0] Bank [16:0];

  assign SP = (M==1'b1)? Bank[16]: Bank[14];
  assign A = (RegA==14)? SP : Bank[RegA];
  assign B = (RegB==14)? SP : Bank[RegB];
  assign MemOut = (RegD==14)? SP : Bank[RegD];
  assign PC = Bank[15];

  always @ (posedge clock or posedge reset) begin
    if (reset==1'b1) begin
      Bank[0] <= dataStart;
      Bank[14] <= 32'hffffffff;//User Stack
      Bank[15] <= 1;  //PC
      Bank[16] <= 32'hffffffff; //Privileged Stack
    end else begin
      if (enable==1'b1) begin
        Bank[15] <= PCin;
        if (M==1'b0) begin
          Bank[14] <= (control==2)? 32'hffffffff: SPin;
        end else begin
          Bank[16] <= (control==2)? 32'hffffffff: SPin;
        end
        case (control)
          1:begin //RD=Result
            if(RegD != 4'hf && RegD!=4'he)begin
              Bank[RegD] <= Result;
            end
          end
          2:begin
            Bank[0] <= dataStart;
          end
          3:begin //RD=MemIn
            if(RegD!=4'hf && RegD!=4'he)begin
              Bank[RegD] <= MemIn;
            end
          end
          4:begin //Enter privileged mode
            Bank[13] <= Bank[15];  //LR = actual next Instruction address
          end
        endcase

      end
    end
  end



  endmodule
