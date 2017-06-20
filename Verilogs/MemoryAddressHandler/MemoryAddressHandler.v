module MemoryAddressHandler(
  ResultAddress,//From ALU
  PC,SP,//From Register Bank
  PCout,SPout,//Back to Register Bank
  Byte3, Byte2, Byte1, Byte0,//Output
  InstAdd1, InstAdd0,//Instruction Addresses
  M, control//Control Unit
  // ,StackOverflow
  );
  //I/O
  input  M;
  input [2:0] control;
  input [31:0] PC, SP, ResultAddress;
  // output reg StackOverflow;
  output reg [31:0] Byte3,Byte2,Byte1,Byte0, SPout;
  output wire [31:0] PCout, InstAdd1, InstAdd0;

  //PC
  wire [31:0] actualPC;
  assign actualPC = control==6? ResultAddress : PC;
  assign PCout = actualPC+2;
  assign InstAdd1 = actualPC-1;
  assign InstAdd0 = actualPC;

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

        if(!M)begin //User Stack
          if(SP==32'hffffffff)begin//Empty
            Byte0=6143;
            Byte1=6142;
            Byte2=6141;
            Byte3=6140;
            SPout=6143;
          end else begin//Not empty
            if (SP>32'h1003 && SP<=32'h17ff) begin //Not full
              Byte3=SP-7;
              Byte2=SP-6;
              Byte1=SP-5;
              Byte0=SP-4;
              SPout=SP-4;
            end else begin //FULL
              // StackOverflow=1'b1; //Stack Overflow
            end
          end
        end else begin //Privileged Mode
          if(SP==32'hffffffff)begin//Empty
            Byte0=8192;
            Byte1=8191;
            Byte2=8190;
            Byte3=8189;
            SPout=8192;
          end else begin//Not empty
            if (SP>32'h1803 && SP<=32'h1fff) begin //Not full
              Byte3=SP-7;
              Byte2=SP-6;
              Byte1=SP-5;
              Byte0=SP-4;
              SPout=SP-4;
            end else begin //Full
              // StackOverflow=1'b1;//Stack Overflow
            end
          end
        end

      end
      2:begin//POP
        if(M==0)begin //User Stack
          if(SP>=32'h1003 && SP<32'h17fc)begin  //More than one item
            Byte3=SP-3;
            Byte2=SP-2;
            Byte1=SP-1;
            Byte0=SP;
            SPout=SP+4;
          end else begin  //Single item
            if(SP==32'h17ff) begin
              Byte0=6143;
              Byte1=6142;
              Byte2=6141;
              Byte3=6140;
              SPout=32'hffffffff;
            end else begin  //empty
              Byte0 = 32'hffffffff;
              Byte1 = 32'hffffffff;
              Byte2 = 32'hffffffff;
              Byte3 = 32'hffffffff;
              SPout = 32'hffffffff;
            end
          end
        end else begin //Privileged Mode
          if(SP>=32'h1803 && SP<32'h1ffc)begin //More than one item
            Byte3=SP-3;
            Byte2=SP-2;
            Byte1=SP-1;
            Byte0=SP;
            SPout=SP+4;
          end else begin//Single item
            if(SP==32'h2000) begin
              Byte0=8191;
              Byte1=8190;
              Byte2=8189;
              Byte3=8188;
              SPout=32'hffffffff;
            end else begin
              Byte0 = 32'hffffffff;
              Byte1 = 32'hffffffff;
              Byte2 = 32'hffffffff;
              Byte3 = 32'hffffffff;
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
