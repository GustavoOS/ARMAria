module SpecReg(
  clock, reset, ID,
  NEG, ZER, CAR, OVERF, MODE,//Flags
  NALU, ZALU, CALU, VALU,
  NBS, ZBS, CBS
  );
  input [6:0] ID;
  input NALU, ZALU, CALU, VALU, NBS, ZBS, CBS, clock, reset;
  output NEG, ZER, CAR, OVERF, MODE;


  reg [4:0] SPECREG;

  assign {NEG, ZER, CAR, OVERF, MODE} = SPECREG;




  always @ ( posedge clock or posedge reset) begin

    if (reset==1'b1) begin
      SPECREG <= 0;
    end else begin
      case (ID)
        1: begin  //LSL
          SPECREG [4:2] <= {NBS, ZBS, CBS};
        end
        2: begin  //LSR
          SPECREG [4:2] <= {NBS, ZBS, CBS};
        end
        3: begin  //ASR
          SPECREG [4:2] <= {NBS, ZBS, CBS};
        end
        4: begin  //ADD
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        5: begin  //SUB
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        6: begin  //ADD
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end //SUB
        7: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        8: begin  //MOV
          SPECREG[4:3] <= {NALU, ZALU};
        end
        9: begin  //CMP
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        10: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        11: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        12: begin
          SPECREG[4:3] <= {NALU, ZALU};
        end
        13: begin
          SPECREG[4:3] <= {NALU, ZALU};
        end
        14: begin
          SPECREG [4:2] <= {NBS, ZBS, CBS};
        end
        15: begin
          SPECREG [4:2] <= {NBS, ZBS, CBS};
        end
        16: begin
          SPECREG [4:2] <= {NBS, ZBS, CBS};
        end
        17: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        18: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        19: begin
          SPECREG [4:2] <= {NBS, ZBS, CBS};
        end
        20: begin
          SPECREG[4:3] <= {NALU, ZALU};
        end
        21: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        22: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        23: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        24: begin
          SPECREG[4:3] <= {NALU, ZALU};
        end
        25: begin
          SPECREG[4:3] <= {NALU, ZALU};
        end
        26: begin
          SPECREG[4:3] <= {NALU, ZALU};
        end
        27: begin
          SPECREG[4:3] <= {NALU, ZALU};
        end
        31: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        32: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        33: begin
          SPECREG[4:1] <= {NALU, ZALU, CALU, VALU};
        end
        34: begin
          SPECREG[1] <= VALU;
        end
        65: begin
          SPECREG[1] <= VALU;
        end
        72: begin//SWI
          SPECREG[0] <= !SPECREG[0];
        end
        75:begin  //HALT
          SPECREG <= 5'h1f;
        end
        default:begin
          SPECREG <= SPECREG;
        end
      endcase
    end

  end








endmodule
