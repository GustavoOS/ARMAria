module ALU(
  A,Bs,
  outputALU,
  control,
  CarryIn,
  Negative, Zero, Carry, oVerflow
  );

  input [31:0] A, Bs;
  output [31:0] outputALU;
  input [3:0] control;
  input CarryIn;
  output reg Negative, Zero, Carry, oVerflow;

  reg [30:0] aux;
  reg msb;

  assign outputALU = {msb, aux};

  wire zer, verf;
  assign zer = (outputALU == 0);
  assign verf = msb ^ Carry;

  always @ ( * ) begin
    Negative = 0;
    Zero = 0;
    Carry = 0;
    oVerflow = 0;
    aux = 0;
    msb=0;
    case (control)
      1:begin //Add with CarryIn
        {Carry, msb, aux} =  A + Bs + CarryIn;       //ADC, C flag
        oVerflow = verf;//V flag
        Zero =  zer;                                     //Z flag
        Negative =  msb;
      end
      2:begin //Add
        {Carry, msb, aux} =  A + Bs;                   //ADD, C flag
        oVerflow = verf;//V flag
        Zero =  zer;   //Z flag
        Negative =  msb;   //N flag
      end
      3:begin   //AND
        {msb, aux} = A&Bs;
        Zero =  zer;          //Z flag
        Negative =  msb;    //N flag
      end
      4:begin //BIC
        {msb, aux} = A & (~Bs); //BIC
        Zero =  zer;//Z flag
        Negative =  msb;//N flag
      end
      5:begin //SUB or CMP
        {Carry, msb, aux} =  A - Bs;//C flag, SUB
        oVerflow = verf;//V flag
        Zero =  zer;//Z flag
        Negative =  msb;//N flag
      end
      6:begin //NEG
        {Carry, msb, aux} =  0 - A;//C flag, SUB
        oVerflow = verf;//V flag
        Zero =  zer;//Z flag
        Negative =  msb;//N flag
      end
      7:begin //OR
        {msb, aux} = A|Bs;
        Zero =  zer;          //Z flag
        Negative =  msb;    //N flag
      end
      8:begin //SBC
        {Carry, msb, aux} =  A - Bs - ~CarryIn;    //SBC, C flag
        oVerflow = verf;//V flag
        Zero =  zer;   //Z flag
        Negative =  msb;   //N flag
      end
      9:begin //MULTIPLY
        {msb, aux} = A*Bs;
        Zero =  zer;
        Negative  =  msb;
      end
      10:begin  //DIV
        oVerflow = (Bs==0);
        {msb, aux} = (oVerflow)? 32'h0 : A / Bs;
      end
      11:begin  //MOD
        oVerflow = (Bs==0);
        {msb, aux} = (oVerflow)? 32'h0 : A % Bs;
      end
      12:begin  //BarrelShifter
        {msb, aux} = Bs;
      end
      13:begin //XOR
        {msb, aux} = A^Bs;
        Zero =  zer;          //Z flag
        Negative =  msb;    //N flag
      end
      14:begin// LOGICAL AND
        {msb, aux} = A&&Bs;
        Zero =  zer;          //Z flag
        Negative =  msb;    //N flag
      end
      default:begin //A OUTPUT
        {msb, aux} = A;
        Negative = msb;
        Zero = zer;
      end
    endcase

  end


endmodule
