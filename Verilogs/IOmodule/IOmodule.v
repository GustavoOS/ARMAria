module IOmodule(
  clock, control, reset,
  MemOut,
  IData,
  switches,
  Neg, Zero, Carry, V, M,        //Flags from Control Unit
  RedLEDs,
  GreenLEDs,//Will show flags
  SevenSegDisplays, clk, botaoc, botaor
  );
  input [1:0] control;
  input [15:0] switches;
  input [31:0] MemOut;
  input Neg, Zero, Carry, V, M, clk, botaoc, botaor;
  output clock, reset;
  output [4:0] GreenLEDs;
  output [15:0] RedLEDs;
  output [31:0] IData;
  output [55:0] SevenSegDisplays;

  reg [15:0] RLED;
  reg [31:0] info;


  assign GreenLEDs = {Neg, Zero, Carry, V, M};
  assign RedLEDs = RLED;
  assign IData = {16'h0, switches};

  always @ ( posedge clock or posedge reset ) begin
    if (reset==1'b1) begin
      info <= 0;
      RLED <=0;
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

  SevenSegDisp ssd(info, SevenSegDisplays);

  debounce botaoclock(clk, botaoc, clock);

  debounce botaoreset(clk, botaor, reset);




endmodule
