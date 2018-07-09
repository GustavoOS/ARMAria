module ALU
#(
    parameter DATA_WIDTH = 32
)(
    input [DATA_WIDTH - 1:0] channel_A, channel_B,
    output [DATA_WIDTH - 1:0] outputALU,
    input [3:0] control,
    input CarryIn,
    output reg Negative, Zero, Carry, oVerflow
);


  reg [DATA_WIDTH - 2:0] aux;
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
    msb = 0;
    case (control)
      1:begin //Add with CarryIn
        {Carry, msb, aux} =  channel_A + channel_B + CarryIn;       //ADC, C flag
        oVerflow = verf;//V flag
        Zero =  zer;                                     //Z flag
        Negative =  msb;
      end
      2:begin //Add
        {Carry, msb, aux} =  channel_A + channel_B;                   //ADD, C flag
        oVerflow = verf;//V flag
        Zero =  zer;   //Z flag
        Negative =  msb;   //N flag
      end
      3:begin   //AND
        {msb, aux} = channel_A&channel_B;
        Zero =  zer;          //Z flag
        Negative =  msb;    //N flag
      end
      4:begin //BIC
        {msb, aux} = channel_A & (~channel_B); //BIC
        Zero =  zer;//Z flag
        Negative =  msb;//N flag
      end
      5:begin //SUB or CMP
        {Carry, msb, aux} =  channel_A - channel_B;//C flag, SUB
        oVerflow = verf;//V flag
        Zero =  zer;//Z flag
        Negative =  msb;//N flag
      end
      6:begin //NEG
        {Carry, msb, aux} =  - channel_A;//C flag, SUB
        oVerflow = verf;//V flag
        Zero =  zer;//Z flag
        Negative =  msb;//N flag
      end
      7:begin //OR
        {msb, aux} = channel_A | channel_B;
        Zero =  zer;          //Z flag
        Negative =  msb;    //N flag
      end
      8:begin //SBC
        {Carry, msb, aux} =  channel_A - channel_B - ~CarryIn;    //SBC, C flag
        oVerflow = verf;//V flag
        Zero =  zer;   //Z flag
        Negative =  msb;   //N flag
      end
      9:begin //MULTIPLY
        {msb, aux} = channel_A * channel_B;
        Zero =  zer;
        Negative  =  msb;
      end
      10:begin  //DIV
        oVerflow = (channel_B==0);
        {msb, aux} = (oVerflow)? 32'h0 : channel_A / channel_B;
      end
      11:begin  //MOD
        oVerflow = (channel_B==0);
        {msb, aux} = (oVerflow)? 32'h0 : channel_A % channel_B;
      end
      12:begin  //BarrelShifter
        {msb, aux} = channel_B;
      end
      13:begin //XOR
        {msb, aux} = channel_A^channel_B;
        Zero =  zer;          //Z flag
        Negative =  msb;    //N flag
      end
      14:begin// LOGICAL AND
        {msb, aux} = channel_A&&channel_B;
        Zero =  zer;          //Z flag
        Negative =  msb;    //N flag
      end
      default:begin //channel_A OUTPUT
        {msb, aux} = channel_A;
        Negative = msb;
        Zero = zer;
      end
    endcase

  end


endmodule
