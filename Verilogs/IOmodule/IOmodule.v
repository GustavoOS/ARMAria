module IOmodule(
  slow_clock, fast_clock,
  control,
  reset,
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
  input Neg, Zero, Carry, V, M, slow_clock, fast_clock, reset;
  output [4:0] GreenLEDs;
  output [55:0] SevenSegDisplays;
  output [15:0] RedLEDs;
  input [31:0] MemOut;
  input control;
  output [31:0] IData;
  input [13:0] instruction_address;
  input [15:0] Instruction;
  
  reg [31:0] info, q;

  assign RedLEDs = switches[16] ? Instruction : instruction_address;
  assign GreenLEDs = {Neg, Zero, Carry, V, M};
  assign IData = {16'h0, switches[15:0]};


  initial begin
    info = 0;
  end

  always @ ( posedge slow_clock ) begin
    if (reset) begin
      info <= 0;
    end else begin
      if (control) //Records on Seven Segment Displays       
          info <= MemOut;
    end
  end

  always @ (posedge fast_clock ) begin
    q <= info;
  end

  SevenSegDisp ssd(
    q, SevenSegDisplays
    );




endmodule