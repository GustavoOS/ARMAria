module ControlCore(
  ID, enable, controlHI,
  controlALU, controlBS, allow_write_on_memory, controlRB,
  control_channel_B_sign_extend_unit,//down one
  control_load_sign_extend_unit,//upper one
  controlMAH, should_read_from_input_instead_of_memory, controlMUX, MODE,
  specreg_update_mode
  );

  input MODE;
  input [6:0] ID;
  output reg [1:0] controlHI;
  output reg allow_write_on_memory;
  output reg [2:0] controlMAH, control_channel_B_sign_extend_unit, control_load_sign_extend_unit, controlRB;
  output reg [3:0] controlALU, controlBS;
  output reg enable, controlMUX, should_read_from_input_instead_of_memory;
  output reg [2:0] specreg_update_mode;





  always @ ( * ) begin
    controlALU = 12;
    controlBS = 0;
    controlRB = 1;
    control_channel_B_sign_extend_unit = 0;
    control_load_sign_extend_unit = 0;
    controlMAH = 0;
    should_read_from_input_instead_of_memory = 0;
    allow_write_on_memory = 0;
    controlMUX = 0;
    controlHI = 0;
    enable = 1;
    specreg_update_mode = 0;

    case (ID)
      1:begin
        controlBS=3;
        controlMUX=1;
        specreg_update_mode = 1;
      end
      2:begin
        controlBS = 4;
        controlMUX = 1;
        specreg_update_mode = 1;
      end
      3:begin
        controlBS = 2;
        //controlRB = 1;
        controlMUX = 1;
        specreg_update_mode = 1;
      end
      4:begin
        controlALU = 2;
        //controlRB = 1;
        specreg_update_mode = 2;
      end
      5:begin
        controlALU = 5;
        specreg_update_mode = 2;
      end
      6:begin
        controlALU = 2;
        //controlRB = 1;
        controlMUX = 1;
        specreg_update_mode = 2;
      end
      7:begin
        controlALU = 5;
        controlMUX = 1;
        specreg_update_mode = 2;
      end
      8:begin
        controlMUX = 1;
        specreg_update_mode = 3;
      end
      9:begin
        controlALU = 5;
        controlRB = 0;
        controlMUX = 1;
        specreg_update_mode = 2;
      end
      10:begin
        controlALU = 2;
        controlMUX = 1;
        specreg_update_mode = 2;
      end
      11:begin
        controlALU = 5;
        controlMUX = 1;
        specreg_update_mode = 2;
      end
      12:begin
        controlALU = 3;
        //controlRB = 1;
        specreg_update_mode = 3;
      end
      13:begin
        controlALU = 13;
        specreg_update_mode = 3;
      end
      14:begin
        controlBS = 3;
        specreg_update_mode = 1;
      end
      15:begin
        controlBS = 4;
        specreg_update_mode = 1;
      end
      16:begin
        controlBS = 2;
        //controlRB = 1;
        specreg_update_mode = 1;
      end
      17:begin
        controlALU = 1;
        //controlRB = 1;
        specreg_update_mode = 2;
      end
      18:begin
        controlALU = 8;
        specreg_update_mode = 2;
      end
      19:begin
        controlBS = 5;
        specreg_update_mode = 1;
      end
      20:begin
        controlALU = 14;
        specreg_update_mode = 3;
      end
      21:begin
        controlALU = 6;
        specreg_update_mode = 2;
      end
      22:begin
        controlALU = 5;
        controlRB = 0;
        specreg_update_mode = 2;
      end
      23:begin
        controlALU = 2;
        controlRB = 0;
        specreg_update_mode = 2;
      end
      24:begin
        controlALU = 7;
        specreg_update_mode = 3;
      end
      25:begin
        controlALU = 9;
        specreg_update_mode = 3;
      end
      26:begin
        controlALU = 4;
        specreg_update_mode = 3;
        //controlRB = 1;
      end
      27:begin
        specreg_update_mode = 3;
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
        controlRB = 0;
      end
      31:begin
        controlALU = 5;
        //controlRB = 1;
        specreg_update_mode = 2;
      end
      32:begin
        controlALU = 5;
        controlRB = 0;
        specreg_update_mode = 2;
      end
      33:begin
        controlALU = 5;
        controlRB = 0;
        specreg_update_mode = 2;
      end
      34:begin
        controlALU = 10;
        specreg_update_mode = 4;
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
        controlALU = 2;
        controlBS = 1;
        controlRB = 0;
        control_channel_B_sign_extend_unit = 0;
        controlMAH = 0;
        controlMUX = 0;
      end
      39:begin
        controlALU = 2;
        controlBS = 1;
        controlMUX = 1;
        controlRB = 3;
        controlMAH = 5;
      end
      40:begin
        controlALU = 2;
        controlMAH = 5;
        allow_write_on_memory = 1;
        controlRB = 0;
      end
      41:begin
        controlALU = 2;
        controlMAH = 4;
        allow_write_on_memory = 1;
        controlRB = 0;
      end
      42:begin
        controlALU = 2;
        controlMAH = 3;
        allow_write_on_memory = 1;
        controlRB = 0;
      end
      43:begin
        controlALU = 2;
        controlMAH = 3;
        control_load_sign_extend_unit = 2;
        controlRB = 3;
      end
      44:begin
        controlALU = 2;
        controlMAH = 5;
        controlRB = 3;
      end
      45:begin
        controlALU = 2;
        controlMAH = 4;
        control_load_sign_extend_unit = 3;
        controlRB = 3;
      end
      46:begin
        controlALU = 2;
        controlMAH = 3;
        control_load_sign_extend_unit = 4;
        controlRB = 3;
      end
      47:begin
        controlALU = 2;
        controlMAH = 4;
        control_load_sign_extend_unit = 1;
        controlRB = 3;
      end
      48:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 5;
        allow_write_on_memory = 1;
        controlRB = 0;
      end
      49:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 5;
        controlRB = 3;
      end
      50:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 3;
        allow_write_on_memory = 1;
        controlRB  = 0;
      end
      51:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 3;
        control_load_sign_extend_unit = 4;
        controlRB = 3;
      end
      52:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 4;
        allow_write_on_memory = 1;
        controlRB = 0;
      end
      53:begin
        controlMUX = 1;
        controlALU = 2;
        controlMAH = 4;
        controlRB =3;
        control_load_sign_extend_unit = 3;
      end
      54:begin
        controlMUX = 1;
        control_channel_B_sign_extend_unit = 2;
        controlALU = 2;
        controlMAH = 5;
        allow_write_on_memory = 1;
        controlRB = 0;
      end
      55:begin
        controlMUX =1;
        control_channel_B_sign_extend_unit = 2;
        controlALU = 2;
        controlMAH = 5;
        controlRB = 3;
      end
      56:begin
        controlALU = 2;
        // controlBS = 1;
        //controlRB = 1;
        controlMUX = 1;
      end
      57:begin
        controlALU = 2;
        // controlBS = 1;
        //controlRB = 1;
        controlMUX = 1;
      end
      58:begin
        controlRB = 2;
      end
      59:begin
        control_channel_B_sign_extend_unit = 1;
      end
      60:begin
        control_channel_B_sign_extend_unit = 2;
      end
      61:begin
        control_channel_B_sign_extend_unit = 3;
      end
      62:begin
        control_channel_B_sign_extend_unit = 4;
      end
      63:begin
        controlBS = 6;
      end
      64:begin
        controlBS = 7;
      end
      65:begin
        controlALU = 11;
        specreg_update_mode = 4;
      end
      66:begin
        controlBS = 8;
      end
      67:begin  //PUSH
        controlMAH = 1;
        allow_write_on_memory = 1;
        controlRB = 0;
      end
      68:begin  //POP
        controlMAH = 2;
        controlRB = 3;
        control_load_sign_extend_unit = 4;
      end
      69:begin  //OUTSS
        controlALU = 0;
        controlRB = 0;
        allow_write_on_memory = 0;
        controlHI = 2'h2;
      end
      70:begin  //OUTLED
        controlALU = 0;
        controlBS = 0;
        controlRB = 0;
        control_channel_B_sign_extend_unit = 0;
        controlMAH = 0;
        controlMUX = 0;
        allow_write_on_memory = 0;
        controlHI = 2'h1;
      end
      71:begin  //INSW
        controlALU = 0;
        controlBS = 0;
        controlRB = 3;
        control_channel_B_sign_extend_unit = 0;
        control_load_sign_extend_unit = 3;
        controlMAH = 0;
        controlMUX = 0;
        should_read_from_input_instead_of_memory = 1;
        allow_write_on_memory = 0;
      end
      72:begin //SWI
        if (MODE==1'b1) begin
          controlMAH = 0;
          controlRB = 0;
        end else begin
          controlMUX = 1;
          controlMAH = 0;
          controlRB = 4;
        end
      end
      73:begin
        controlMUX = 1;
        controlBS = 1;
        control_channel_B_sign_extend_unit = 2;
        controlALU = 2;
        controlMAH = 0;
        controlRB = 0;
      end
      74:begin
        controlRB = 0;
      end
      75:begin
        controlRB = 0;
        enable = 0;
        specreg_update_mode = 6;
      end
      100:begin //RESET
        controlALU = 0;
        controlBS = 0;
        controlRB = 0;
        control_channel_B_sign_extend_unit = 0;//down
        control_load_sign_extend_unit = 0;//up
        controlMAH = 0;
        should_read_from_input_instead_of_memory = 0;
        allow_write_on_memory = 0;
        controlMUX = 0;
        enable = 1;
      end
      default: controlRB = 0;
    endcase


  end

endmodule
