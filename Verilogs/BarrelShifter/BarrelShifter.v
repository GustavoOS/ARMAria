module BarrelShifter(
  inputA, Bse,
  control,
  outputBS,
  N, Zero, C//Flags
  );

  input [31:0] inputA, Bse;
  input [3:0] control;
  output reg N, Zero, C;
  output reg [31:0] outputBS;

  reg [31:0] aux1, aux3;
  reg aux2;

  wire zer;
  assign zer = (outputBS == 0);

  always @ ( * ) begin
    N=0; Zero=0; C=0; //Flag cleaning
    outputBS=0; //Output cleaning
    aux1=0; aux2=0; aux3=0; //Auxiliar cleaning

    case (control)
      1:begin //Saída=A<<2
        {aux2,outputBS}=inputA<<1;
        C=aux2;
        Zero=zer;
        N=outputBS[31];
      end
      2:begin //ASR
        aux2=inputA[31];
        if (Bse<31) begin
          aux3=inputA>>Bse;
          aux1 = (aux2)? 32'hffffffff : 32'h0;
          aux1=aux1<<32-Bse;
          outputBS= aux3|aux1;
          // aux1=inputA<<32-Bse;
          C=|inputA;
          Zero=zer;
          N=aux2;
        end else begin
          C=|inputA;
          outputBS = (aux2) ? 32'hffffffff : 32'h0;
          Zero=!aux2;
          N=aux2;
        end
      end
      3:begin //LSL
        if (Bse<32) begin
          // {aux1,outputBS}=inputA<<Bse;
          outputBS=inputA<<Bse;
          aux1=inputA>>32-Bse;
          C=|aux1;
          Zero=zer;
          N=outputBS[31];
        end else begin
          C=|inputA;
          outputBS=0;
          Zero=1;
          N=0;
        end
      end
      4:begin //LSR
        if (Bse<32) begin
          outputBS=inputA>>Bse;
          aux1=inputA<<32-Bse;
          C=|aux1;
          Zero=zer;
          N=outputBS[31];
        end else begin
          C=|inputA;
          outputBS=0;
          Zero=1;
          N=0;
        end
      end
      5:begin //ROR
        outputBS=inputA>>Bse%32;
        aux1=inputA<<32-(Bse % 32);
        outputBS=outputBS | aux1;
        C=aux1[31];
        Zero=zer;
        N=outputBS[31];
      end
      6:begin //REV
        outputBS[31:24]=inputA[7:0];
        outputBS[23:16]=inputA[15:8];
        outputBS[15:8]=inputA[23:16];
        outputBS[7:0]=inputA[31:24];
      end
      7:begin //REV16
        outputBS[31:24]=inputA[23:16];
        outputBS[23:16]=inputA[31:24];
        outputBS[15:8]=inputA[7:0];
        outputBS[7:0]=inputA[15:8];
      end
      8:begin //REVSH
        outputBS[31:16]=(inputA[7]) ? 16'hFFFF :16'h0;
        outputBS[15:8]=inputA[7:0];
        outputBS[7:0]=inputA[15:8];
      end
      default:begin
        outputBS=Bse;
      end
    endcase

  end

endmodule
