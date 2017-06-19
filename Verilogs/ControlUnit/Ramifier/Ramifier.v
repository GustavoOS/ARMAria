module Ramifier(
  Condition,
  Neg, Zer, Carry, V,
  take
  );
  input [3:0] Condition;
  input Neg, Carry, Zer, V;
  output reg take;

  reg difnv;


  always @ ( * ) begin
    difnv= Neg != V;
    case (Condition)
      0:begin //EQ
        take = Zer;
      end
      1:begin //NE
        take = ~Zer;
      end
      2:begin //CS / HS
        take = Carry;
      end
      3:begin //CC / LO
        take = ~Carry;
      end
      4:begin   //MI
        take = Neg;
      end
      5:begin   //PL
        take = ~Neg;
      end
      6:begin   //VS
        take = V;
      end
      7:begin   //VC
        take = ~V;
      end
      8:begin   //HI
        take = Carry && ~Zer;
      end
      9:begin   //LS
        take = ~Carry || Zer;
      end
      4'ha:begin    //GE
        take = ~difnv;
      end
      4'hb:begin    //LT
        take = difnv;
      end
      4'hc:begin    //GT
        take = ~(Zer || difnv);
      end
      4'hd:begin     //LE
        take = Zer && difnv;
      end
      4'he:begin  //Al
        take = 1'b1;
      end
      default: begin
        take = 1'b0;

      end
    endcase
  end

endmodule
