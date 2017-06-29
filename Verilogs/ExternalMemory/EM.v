module EM(
  clock,
  control,
  IA0, IA1,
  Address,
  Write,
  Read,
  PreInstruction, reset
  );

  input clock, reset;
  input [1:0] control;
  input [31:0] Write;
  input [9:0]  IA0, IA1;//Lengh matches up to 1023 bytes of Addresses
  input [39:0] Address;
  output [31:0] Read;
  output [15:0] PreInstruction;
  parameter MemSize = 125;

  wire [9:0] A0, A1, A2, A3;
  assign {A3, A2, A1, A0} = Address;

  reg [7:0] RAM [MemSize - 1:0];

  reg [7:0] preinstr1, preinstr0;
  assign PreInstruction = {preinstr1, preinstr0};

  wire valida0, valida1, valida23, validia;
  assign valida0 = (A0<MemSize);
  assign valida1 = (A1<MemSize);
  assign valida23 = (A2<MemSize) && (A3<MemSize);
  assign validia = (IA0<MemSize) && (IA1<MemSize);



  //Write logic
  wire [7:0] DW0, DW1, DW2, DW3;
  assign {DW3, DW2, DW1, DW0} = Write;

  always @ ( posedge clock or posedge reset) begin
    if (reset==1'b1) begin
      //Paste reset code here

      //e.g. RAM[0] <= 0;
      

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
