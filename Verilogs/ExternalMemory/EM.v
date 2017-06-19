module EM(
  clock,
  control,
  IA0, IA1,
  A0, A1, A2, A3,
  DW0, DW1, DW2, DW3,
  DR0, DR1, DR2, DR3,
  PreInstruction,
  led, sseg, sw, reset
  );

  input clock, reset;
  input [2:0] control;
  input [7:0] DW0, DW1, DW2, DW3;
  input [15:0] sw;
  input [31:0] A0, A1, A2, A3, IA0, IA1;
  output [7:0] DR0, DR1, DR2, DR3;
  output [15:0] led, PreInstruction;
  output [31:0] sseg;
  parameter MemSize = 12349;

  reg [7:0] RAM [MemSize - 1:0];

  reg [7:0] preinstr1, preinstr0;
  assign PreInstruction = {preinstr1, preinstr0};

  wire valida0, valida1, valida2, valida3, validia0, validia1;
  assign valida0 = ((~A0[31]) && A0<MemSize);
  assign valida1 = ((~A1[31]) && A1<MemSize);
  assign valida2 = ((~A2[31]) && A2<MemSize);
  assign valida3 = ((~A3[31]) && A3<MemSize);
  assign validia0 = ((~IA0[31]) && IA0<MemSize);
  assign validia1 = ((~IA1[31]) && IA1<MemSize);


  assign led = {RAM[8199],RAM[8200]};
  assign sseg = {RAM[8193],RAM[8194], RAM[8195], RAM[8196]};

  //Write logic
  always @ ( posedge clock or posedge reset) begin
    if (reset==1'b1) begin
      //Paste reset code here
     

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
          if(valida0 && valida1 && valida2 && valida3)begin
            RAM[A0] <= DW0;
            RAM[A1] <= DW1;
            RAM[A2] <= DW2;
            RAM[A3] <= DW3;
          end
        end
        default:begin
          {RAM[8197], RAM[8198]} <= sw;
        end
      endcase
    end
  end//always


  //Read logic

  wire rw, rh;
  assign rw = (control==6);
  assign rh = (control==5);
  assign DR0 = (valida0 && (control==4 || rh || rw)) ? RAM[A0] : 8'h0;
  assign DR1 = (valida1 && (rh || rw)) ? RAM[A1] : 8'h0;
  assign DR2 = (valida2 && rw) ? RAM[A2] : 8'h0;
  assign DR3 = (valida3 && rw) ? RAM[A3] : 8'h0;


  wire ia0a0, ia0a1, ia1a0, ia1a1;
  assign ia0a0 = (IA0 == A0);
  assign ia0a1 = (IA0 == A1);
  assign ia1a0 = (IA1 == A0);
  assign ia1a1 = (IA1 == A1);


  always @ ( * ) begin
    preinstr1 = 8'he8;
    preinstr0 = 8'h0;
    if(validia0 && validia1)begin
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
        default: begin
          preinstr1 = preinstr1;
          preinstr0 = preinstr0;
        end
      endcase
    end
  end



endmodule
