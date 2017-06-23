module MemoryAddressHandler(
  ResultAddress,//From ALU
  ResultPC,SP,//From Register Bank
  PCout,SPout,//Back to Register Bank
  Address,//Output
  InstAdd1, InstAdd0,//Instruction Addresses
  M, control,//Control Unit
  reset
  );
  //I/O
  input  M, reset;
  input [2:0] control;
  input [31:0] SP, ResultAddress;
  input [31:0] ResultPC;
  // output reg StackOverflow;
  // output reg [10:0] Byte3,Byte2,Byte1,Byte0;
  output [39:0] Address;
  output reg [31:0] SPout;
  output [31:0] PCout;
  output [9:0] InstAdd1, InstAdd0;

  parameter UserStackStart = 31;
  parameter UserStackEnd = 36;
  parameter PrivilegedStackStart = UserStackEnd +1;
  parameter PrivilegedStackEnd = 42;

  //PC
  assign PCout = (reset==1'b1) ? ResultPC :  ResultPC+2;
  assign InstAdd1 = (ResultPC[9:0]>0) ? ResultPC[9:0]-1 : 10'h0;
  assign InstAdd0 = (ResultPC!=10'h0) ? ResultPC[9:0]  : 10'h1;

  //old Logic adaptation
  reg [9:0] Byte3, Byte2, Byte1, Byte0;
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
            Byte0=UserStackEnd;
            SPout=UserStackEnd;
          end else begin//Not empty
            if (SP>UserStackStart && SP<=UserStackEnd) begin //Not full
              Byte0=SP-1;
              SPout=Byte0;
            end
            //  else begin //FULL
              // StackOverflow=1'b1; //Stack Overflow DO NOTHING
            // end
          end
        end else begin //Privileged Mode
          if(SP==32'hffffffff)begin//Empty
            Byte0=PrivilegedStackEnd;
          end else begin//Not empty
            if (SP>PrivilegedStackStart && SP<=PrivilegedStackEnd) begin //Not full
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
          if(SP>=UserStackStart && SP<UserStackEnd)begin  //More than one item
            Byte0=SP;
            SPout=SP+1;
          end else begin  //Single item
            if(SP==UserStackEnd) begin
              Byte0=UserStackEnd;
              SPout=32'hffffffff;
            end else begin  //empty
              Byte0 = 10'h3ff;
              SPout = 32'hffffffff;
            end
          end
        end else begin //Privileged Mode
          if(SP>=PrivilegedStackStart && SP<PrivilegedStackEnd)begin //More than one item
            Byte0=SP;
            SPout=SP+1;
          end else begin//Single item
            if(SP==PrivilegedStackEnd) begin
              Byte0 = PrivilegedStackEnd;
              SPout = 32'hffffffff;
            end else begin
              Byte0 = 10'h3ff;
              Byte1 = 10'h3ff;
              Byte2 = 10'h3ff;
              Byte3 = 10'h3ff;
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
