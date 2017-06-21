module MemoryAddressHandler(
  ResultAddress,//From ALU
  PC,SP,//From Register Bank
  PCout,SPout,//Back to Register Bank
  Address,//Output
  InstAdd1, InstAdd0,//Instruction Addresses
  M, control//Control Unit
  // ,StackOverflow
  );
  //I/O
  input  M;
  input [2:0] control;
  input [31:0] PC, SP, ResultAddress;
  // output reg StackOverflow;
  // output reg [10:0] Byte3,Byte2,Byte1,Byte0;
  output [39:0] Address;
  output reg [31:0] SPout;
  output wire [31:0] PCout;
  output [9:0] InstAdd1, InstAdd0;

  //PC
  wire [31:0] actualPC;
  assign actualPC = control==6? ResultAddress : PC;
  assign PCout = actualPC+2;
  assign InstAdd0 = actualPC[10:0];
  assign InstAdd1 = InstAdd0-1;

  //old Logic adaptation
  reg [10:0] Byte3, Byte2, Byte1, Byte0;
  assign Address = {Byte3, Byte2, Byte1, Byte0};
  //Logic
  always @ (*) begin
    SPout=SP;
    Byte0 = 0;
    Byte1 = 0;
    Byte2 = 0;
    Byte3 = 0;
    // StackOverflow=1'b0;


    case(control)
      default:begin
        Byte0 = 0;
      end

      1:begin//PUSH

        if(M==1'b0)begin //User Stack
          if(SP==32'hffffffff)begin//Empty
            Byte0=36;
            SPout=36;
          end else begin//Not empty
            if (SP>31 && SP<=36) begin //Not full
              Byte0=SP-1;
              SPout=Byte0;
            end
            //  else begin //FULL
              // StackOverflow=1'b1; //Stack Overflow DO NOTHING
            // end
          end
        end else begin //Privileged Mode
          if(SP==32'hffffffff)begin//Empty
            Byte0=42;
          end else begin//Not empty
            if (SP>37 && SP<=42) begin //Not full
              Byte0=SP-1;
              SPout=SP-1;
            // end else begin //Full
            //   // StackOverflow=1'b1;//Stack Overflow
            end
          end
        end

      end
      2:begin//POP
        if(M==1'b0)begin //User Stack
          if(SP>=31 && SP<36)begin  //More than one item
            Byte0=SP;
            SPout=SP+1;
          end else begin  //Single item
            if(SP==36) begin
              Byte0=36;
              SPout=32'hffffffff;
            end else begin  //empty
              Byte0 = 10'h3ff;
              SPout = 32'hffffffff;
            end
          end
        end else begin //Privileged Mode
          if(SP>=37 && SP<42)begin //More than one item
            Byte0=SP;
            SPout=SP+1;
          end else begin//Single item
            if(SP==42) begin
              Byte0=55;
              SPout=32'hffffffff;
            end else begin
              Byte0 = 11'h3ff;
              Byte1 = 11'h3ff;
              Byte2 = 11'h3ff;
              Byte3 = 11'h3ff;
              SPout = 32'hffffffff;
            end
          end
        end
      end

      3:begin
        Byte0=ResultAddress;
      end
      4:begin
        Byte1=ResultAddress-1;
        Byte0=ResultAddress;
      end
      5:begin
        Byte3=ResultAddress-3;
        Byte2=ResultAddress-2;
        Byte1=ResultAddress-1;
        Byte0=ResultAddress;
      end

    endcase

  end//always



endmodule
