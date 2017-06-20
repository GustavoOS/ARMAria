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

  //Memory
  reg [31:0] Bank [15:0];
  reg [31:0] SSP, PSP;//Standard Stack Pointer, Privileged Stack Pointer
  assign SP = (M) ? PSP : SSP;//Exports the right SP depending on M flag


  //Bank Readers
  assign A = (RegA==14)? SP : Bank[RegA];
  assign B = (RegB==14)? SP : Bank[RegB];
  assign PC = Bank[15];
  assign MemOut = (RegD==14)? SP : Bank[RegD];


  //Write into the Register Bank
  always @ ( posedge clock or posedge reset) begin
    if (reset==1'b1) begin//Asynchronous Reset
      // TEST
      Bank[0] <= 32'h8192;//Data start
      Bank[13] <= 32'h0;
      Bank[14] <= 32'h0;

  		//Configs
  		Bank[15] <= 1;
      SSP <= 32'hffffffff;
      PSP <= 32'hffffffff;
    end else begin
      if (enable) begin
        Bank[15] <= PCin;
        if (control==2) begin
          SSP <= (M)? SSP : 32'hffffffff;
          PSP <= (M)? 32'hffffffff: PSP;
        end else begin
          SSP <= (M)?  SSP: SPin;
          PSP <= (M)?  SPin : PSP;
        end
        case (control)
          1:begin //RD=Result
            if(RegD != 4'hf && RegD!=4'he)begin
              Bank[RegD] <= Result;
            end
          end
          2:begin
            Bank[0] <= 32'h8192;//Data start
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
      end else begin
        Bank[15] <= Bank[15]; //PC update
        SSP <= SSP;
        PSP <= PSP;
      end


    end

  end//always

endmodule
