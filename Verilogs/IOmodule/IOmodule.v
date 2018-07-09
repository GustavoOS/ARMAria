module IOmodule(
  clock, control, reset,
  MemOut,
  IData,
  switches,
  Neg, Zero, Carry, V, M,        //Flags from Control Unit
  RedLEDs,
  GreenLEDs,//Will show flags
  SevenSegDisplays,
  instruction_address,
  Instruction
  );
  input [16:0] switches;
  input Neg, Zero, Carry, V, M, clock, reset;
  output [4:0] GreenLEDs;
  output [55:0] SevenSegDisplays;
  output [15:0] RedLEDs;
  input [31:0] MemOut;
  input [1:0] control;
  output [31:0] IData;
  input [13:0] instruction_address;
  input [15:0] Instruction;
  
  reg [15:0] RLED;
  reg [31:0] info;

  assign RedLEDs = switches[16] ? Instruction : instruction_address;
  assign GreenLEDs = {Neg, Zero, Carry, V, M};
  // assign RedLEDs = RLED;
  assign IData = {16'h0, switches[15:0]};

  initial begin
    info = 0;
    RLED = 0;
  end

  always @ ( negedge clock ) begin
    if (reset) begin
      info <= 0;
      RLED <= 0;
    end else begin
      case (control)
        1:begin //Records on LED
          RLED <= MemOut[15:0];
        end
        2:begin  //Records on Seven Segment Displays
          info <= MemOut;
        end
      endcase
    end

  end

  SevenSegDisp ssd(
    info, SevenSegDisplays
    );




endmodule
