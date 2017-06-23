module Ramifier(
  Condition,
  Neg, Zer, Carry, V,
  take
  );
  input [3:0] Condition;
  input Neg, Carry, Zer, V;
  output reg take;



  always @ ( * ) begin
    case (Condition)
      0:begin //EQ
        take = (Zer==1'b1);
      end
      1:begin //NE
        take = (Zer==1'b0);
      end
      2:begin //CS / HS
        take = (Carry==1'b1);
      end
      3:begin //CC / LO
        take =(Carry==1'b0);
      end
      4:begin   //MI
        take = (Neg==1'b1);
      end
      5:begin   //PL
        take = (Neg==1'b0);
      end
      6:begin   //VS
        take = (V==1'b1);
      end
      7:begin   //VC
        take = (V==1'b0);
      end
      8:begin   //HI
        take = (Carry==1'b1) && (Zer==1'b0);
      end
      9:begin   //LS
        take = (Carry==1'b0) || (Zer==1'b1);
      end
      4'ha:begin    //GE
        take = (Neg==V);
      end
      4'hb:begin    //LT
        take = (Neg!=V);
      end
      4'hc:begin    //GT
        take = (Zer==1'b0) && (Neg==V);
      end
      4'hd:begin     //LE
        take = (Zer==1'b1) && (Neg!=V);
      end
      4'he:begin  //Al
        take = 1'b1;
      end
      default: begin
        take = 1'b0; //NEVER
      end
    endcase
  end

endmodule
