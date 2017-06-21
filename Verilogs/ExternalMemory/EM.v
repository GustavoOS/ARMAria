module EM(
  clock,
  control,
  IA0, IA1,
  Address,
  DW0, DW1, DW2, DW3,
  Read,
  PreInstruction, reset
  );

  input clock, reset;
  input [2:0] control;
  input [7:0] DW0, DW1, DW2, DW3;
  input [9:0]  IA0, IA1;//Lengh matches up to 1023 bytes of Addresses
  input [39:0] Address;
  output [31:0] Read;
  output [15:0] PreInstruction;
  parameter MemSize = 49;

  wire [9:0] A0, A1, A2, A3;
  assign {A3, A2, A1, A0} = Address;

  reg [7:0] RAM [MemSize - 1:0];

  reg [7:0] preinstr1, preinstr0;
  assign PreInstruction = {preinstr1, preinstr0};

  wire valida0, valida1, valida23, validia0, validia1;
  assign valida0 = (A0<MemSize);
  assign valida1 = (A1<MemSize);
  assign valida23 = (A2<MemSize) && (A3<MemSize);
  assign validia = (IA0<MemSize) && (IA1<MemSize);



  //Write logic
  always @ ( posedge clock or posedge reset) begin
    if (reset==1'b1) begin
      //Paste reset code here
      RAM[0] <= 33;
      RAM[1] <= 0;
      RAM[2] <= 92;
      RAM[3] <= 11;
      RAM[4] <= 92;
      RAM[5] <= 12;
      RAM[6] <= 49;
      RAM[7] <= 1;
      RAM[8] <= 92;
      RAM[9] <= 10;
      RAM[10] <= 25;
      RAM[11] <= 20;
      RAM[12] <= 66;
      RAM[13] <= 147;
      RAM[14] <= 211;
      RAM[15] <= 5;
      RAM[16] <= 41;
      RAM[17] <= 5;
      RAM[18] <= 211;
      RAM[19] <= 249;
      RAM[20] <= 190;
      RAM[21] <= 3;
      RAM[22] <= 190;
      RAM[23] <= 68;
      RAM[24] <= 232;
      RAM[25] <= 0;
      RAM[26] <= 28;
      RAM[27] <= 26;
      RAM[28] <= 222;
      RAM[29] <= 249;
      RAM[43] <= 1;
      RAM[44] <= 5;
      RAM[45] <= 8;
      RAM[46] <= 7;
      RAM[47] <= 6;


      //Reset END
    end else begin
      case (control)
        1:begin
          if(valida0)begin
            RAM[A0] <= DW0;
          end
        end
        2:begin
          if(valida0 && valida1)begin
            RAM[A0] <= DW0;
            RAM[A1] <= DW1;
          end
        end
        3:begin
          if(valida0 && valida1 && valida23)begin
            RAM[A0] <= DW0;
            RAM[A1] <= DW1;
            RAM[A2] <= DW2;
            RAM[A3] <= DW3;
          end
        end
      endcase
    end
  end//always


  //Read logic


  assign Read = (valida0 && valida1 && valida23) ? {RAM[A3], RAM[A2], RAM[A1], RAM[A0]} : 0;


  wire ia0a0, ia0a1, ia1a0, ia1a1;
  assign ia0a0 = (IA0 == A0);
  assign ia0a1 = (IA0 == A1);
  assign ia1a0 = (IA1 == A0);
  assign ia1a1 = (IA1 == A1);


  always @ ( * ) begin

    if(validia)begin
      preinstr1 = RAM[IA1];
      preinstr0 = RAM[IA0];
      case (control)
        1:begin
          preinstr0 = (ia0a0) ? DW0 : preinstr0;
          preinstr1 = (ia1a0) ? DW0 : preinstr1;
        end
        2:begin
          preinstr0 = (ia0a0) ? DW0 :
            (ia0a1) ? DW1 :
            preinstr0;
          preinstr1 = (ia1a0) ? DW0 :
            (ia1a1) ? DW1 :
            preinstr1;
        end
        3:begin
        preinstr0 = (ia0a0) ? DW0 :
          (ia0a1) ? DW1 :
          (IA0 == A2)? DW2:
          (IA0 == A3) ? DW3:
          preinstr0;
        preinstr1 = (ia1a0) ? DW0 :
          (ia1a1) ? DW1 :
          (IA1 == A2)? DW2:
          (IA1 == A3) ? DW3:
          preinstr1;
        end
      endcase
    end else begin
      preinstr1 = 8'he8;
      preinstr0 = 8'h0;
    end
  end



endmodule
