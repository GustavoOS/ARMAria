module Ramifier
(
  input [5:0] Condition,
  input negative_flag, zero_flag, carry_flag, overflow_flag,
  output reg take
);


    always @ ( * ) begin
        case (Condition)
            0:begin //EQ
                take = zero_flag;
            end
            1:begin //NE
                take = !zero_flag;
            end
            2:begin //CS / HS
                take = carry_flag;
            end
            3:begin //CC / LO
                take = !carry_flag;
            end
            4:begin   //MI
                take = negative_flag;
            end
            5:begin   //PL
                take = !(negative_flag);
            end
            6:begin   //VS
                take = overflow_flag;
            end
            7:begin   //VC
                take = !(overflow_flag);
            end
            8:begin   //HI
                take = (carry_flag) && (!zero_flag);
            end
            9:begin   //LS
                take = (!carry_flag) || (zero_flag);
            end
            10:begin    //GE
                take =  (negative_flag ^~ overflow_flag) ;
            end
            11:begin    //LT
                take = (negative_flag ^ overflow_flag);
            end
            12:begin    //GT
                take = (!zero_flag) && (negative_flag ^~ overflow_flag);
            end
            13:begin     //LE
                take = (zero_flag) || (negative_flag ^ overflow_flag);
            end
            14:begin  //Al
                take = 1;
            end
            15:begin    //ABSOLUTE JUMP ALWAYS AB
                take = 1;
            end
            default: begin
                take = 0; //NEVER
            end
        endcase
    end

endmodule
