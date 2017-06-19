module controlcore(
  ID, take, enable,
  controlALU, controlBS, controlEM, controlRB,
  controlSE1,//down one
  controlSE2,//upper one
  controlMAH, controlMDH, controlMUX, MODE, reset
  );

  input take, MODE, reset;
  input [6:0] ID;
  output reg [2:0] controlEM, controlMDH, controlMAH, controlSE1, controlSE2, controlRB;
  output reg [3:0] controlALU, controlBS;
  output reg enable, controlMUX;





  always @ ( * ) begin

    controlALU = 12;
    controlBS = 0;
    controlRB = 1;
    controlSE1 = 0;
    controlSE2 = 0;
    controlMAH = 0;
    controlMDH = 0;
    controlEM = 0;
    controlMUX = 0;
    enable = 1;
    case (ID)
      1:begin
        controlBS=3;
        controlMUX=1;
      end
      2:begin
        controlBS = 4;
        controlMUX = 1;
      end
      3:begin
        controlBS = 2;
        //controlRB = 1;
        controlMUX = 1;
      end
      4:begin
        controlALU = 2;
        //controlRB = 1;
      end
      5:begin
        controlALU = 5;
      end
      6:begin
        controlALU = 2;
        //controlRB = 1;
        controlMUX = 1;
      end
      7:begin
        controlALU = 5;
        controlMUX = 1;
      end
      8:begin
        controlMUX = 1;
      end
      9:begin
        controlALU = 5;
        //controlRB = 1;
        controlMUX = 1;
      end
      10:begin
        controlALU = 2;
        controlMUX = 1;
      end
      11:begin
        controlALU = 5;
        controlMUX = 1;
      end
      12:begin
        controlALU = 3;
        //controlRB = 1;
      end
      13:begin
        controlALU = 13;
      end
      14:begin
        controlBS = 3;
      end
      15:begin
        controlBS = 4;
      end
      16:begin
        controlBS = 2;
        //controlRB = 1;
      end
      17:begin
        controlALU = 1;
        //controlRB = 1;
      end
      18:begin
        controlALU = 8;
      end
      19:begin
        controlBS = 5;
      end
      20:begin
        controlALU = 14;
      end
      21:begin
        controlALU = 6;
      end
      22:begin
        controlALU = 5;
        //controlRB = 1;
      end
      23:begin
        controlALU = 2;
      end
      24:begin
        controlALU = 7;
      end
      25:begin
        controlALU = 9;
      end
      26:begin
        controlALU = 4;
        //controlRB = 1;
      end
      27:begin
      end
      28:begin
        controlALU = 2;
        //controlRB = 1;
      end
      29:begin
        controlALU = 2;
        //controlRB = 1;
      end
      30:begin
        controlALU = 2;
        //controlRB = 1;
      end
      31:begin
        controlALU = 5;
        //controlRB = 1;
      end
      32:begin
        controlALU = 5;
        //controlRB = 1;
      end
      33:begin
        controlALU = 5;
        //controlRB = 1;
      end
      34:begin
        controlALU = 10;
      end
      35:begin
        //standard
      end
      36:begin
        //standard
      end
      37:begin
        //standard
      end
      38:begin
        controlALU = 0;
        controlMAH = take? 3'h6 : 3'h0;
        controlRB =0;
      end
      39:begin
        controlALU = 2;
        controlBS = 1;
        controlMUX = 1;
        controlRB = 3;
        controlMAH = 5;
        controlMDH = 6;
        controlEM = 6;
      end
      40:begin
        controlALU = 2;
        controlMAH = 5;
        controlMDH = 3;
        controlEM = 3;
        controlRB = 0;
      end
      41:begin
        controlALU = 2;
        controlMAH = 4;
        controlMDH = 2;
        controlEM = 2;
        controlRB = 0;
      end
      42:begin
        controlALU = 2;
        controlMAH = 3;
        controlMDH = 1;
        controlEM = 1;
        controlRB = 0;
      end
      43:begin
        controlALU = 2;
        controlMAH = 3;
        controlEM = 4;
        controlMDH = 4;
        controlSE2 = 2;
        controlRB = 3;
      end
      44:begin
        controlALU = 2;
        controlMAH = 5;
        controlEM = 4;
        controlMDH = 6;
        controlRB = 3;
      end
      45:begin
        controlALU = 2;
        controlMAH = 4;
        controlEM = 5;
        controlMDH = 5;
        controlSE2 = 3;
        controlRB = 3;
      end
      46:begin
        controlALU = 2;
        controlMAH = 3;
        controlMDH = 4;
        controlSE2 = 4;
        controlRB = 3;
      end
      47:begin
        controlALU = 2;
        controlMAH = 4;
        controlMDH = 5;
        controlSE2 = 1;
        controlRB = 3;
      end
      48:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 5;
        controlEM = 3;
        controlMDH =3;
        controlRB = 0;
      end
      49:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 5;
        controlEM = 6;
        controlMDH = 6;
        controlRB = 3;
      end
      50:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 3;
        controlEM = 1;
        controlMDH = 1;
        controlRB  = 0;
      end
      51:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 3;
        controlEM = 4;
        controlMDH = 4;
        controlSE2 = 4;
        controlRB = 3;
      end
      52:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 4;
        controlEM = 2;
        controlMDH = 2;
        controlRB = 0;
      end
      53:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 4;
        controlEM = 5;
        controlMDH = 5;
        controlRB =3;
        controlSE2 = 3;
      end
      54:begin
        controlMUX = 1;
        controlSE1 = 2;
        controlALU = 2;
        controlMAH = 5;
        controlEM = 3;
        controlMDH = 3;
        controlRB = 0;
      end
      55:begin
        controlMUX =1;
        controlSE1 = 2;
        controlALU = 2;
        controlMAH = 5;
        controlEM = 6;
        controlMDH = 6;
        controlRB = 3;
      end
      56:begin
        controlALU = 2;
        controlBS = 1;
        //controlRB = 1;
        controlMUX = 1;
      end
      57:begin
        controlALU = 2;
        controlBS = 1;
        //controlRB = 1;
        controlMUX = 1;
      end
      58:begin
        controlRB = 2;
      end
      59:begin
        controlSE1 = 1;
      end
      60:begin
        controlSE1 = 2;
      end
      61:begin
        controlSE1 = 3;
      end
      62:begin
        controlSE1 = 4;
      end
      63:begin
        controlBS = 6;
      end
      64:begin
        controlBS = 7;
      end
      65:begin
        controlALU = 11;
      end
      66:begin
        controlBS = 8;
      end
      67:begin
        controlMAH = 1;
        controlEM = 3;
        controlMDH = 3;
        controlRB = 0;
      end
      68:begin
        controlMAH = 2;
        controlEM = 6;
        controlMDH = 6;
        controlRB = 3;
      end
      69:begin  //OUTSS
        controlALU = 12;
        controlBS = 0;
        controlRB = 0;
        controlSE1 = 0;
        controlMAH = 5;
        controlMUX = 1;
        controlMDH = 3;
        controlEM = 3;
      end
      70:begin  //OUTLED
        controlALU = 12;
        controlBS = 0;
        controlRB = 0;
        controlSE1 = 0;
        controlMAH = 4;
        controlMUX = 1;
        controlMDH = 2;
        controlEM = 2;
      end
      71:begin  //INSW
        controlALU = 12;
        controlBS = 0;
        controlRB = 3;
        controlSE1 = 0;
        controlSE2 = 3;
        controlMAH = 4;
        controlMUX = 1;
        controlMDH = 5;
        controlEM = 5;
      end
      72:begin
      if (MODE==1'b1) begin
        controlMAH = 6;
        controlRB = 0;
      end else begin
        controlMUX = 1;
        controlMAH = 6;
        controlRB = 4;
      end
      end
      73:begin
        controlMUX = 1;
        controlBS = 1;
        controlSE1 = 2;
        controlALU = 2;
        controlMAH = take? 3'h6:3'h0;
        controlRB = 0;
      end
      74:begin
        controlRB = 0;
      end
      75:begin
        controlRB = 0;
        enable = 0;
      end
      100:begin //RESET
        controlALU = 0;
        controlBS = 0;
        controlRB = 5;
        controlSE1 = 0;//down
        controlSE2 = 0;//up
        controlMAH = 0;
        controlMDH = 0;
        controlEM = 7;
        controlMUX = 0;
        enable = 1;
      end
      default: controlRB = 0;
    endcase


  end

endmodule
