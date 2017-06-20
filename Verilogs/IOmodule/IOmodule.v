module IOmodule(
  clock, control, reset,
  OData,
  IData,
  switches,
  Neg, Zero, Carry, V, M,        //Flags from Control Unit
  RedLEDs,
  GreenLEDs,//Will show flags
  SevenSegDisplays
  );
  input [15:0] switches;
  input Neg, Zero, Carry, V, M, clock;
  output [4:0] GreenLEDs;
  output [55:0] SevenSegDisplays;
  output [15:0] RedLEDs, IData;
  input [31:0] OData;

  reg [15:0] RLED;
  reg [31:0] info;
  wire [31:0] Display7;

  assign Display7 = info;

  assign GreenLEDs = {Neg, Zero, Carry, V, M};
  assign RedLEDs = RLED;
  assign IData = switches

  always @ ( posedge clock or posedge reset ) begin
    if (reset==1'b1) begin
      info <= 0;
      RLED <=0;
    end else begin
      case (control)
        case 1:begin //Records on LED
          RLED <= OData[15:0];
        end
        case 2:begin  //Records on Seven Segment Displays
          info <= OData;
        end
        default: ;
      endcase
    end

  end

  HexDecoder dsp0 (
    Display7[3:0],//Input
    SevenSegDisplays[6:0]
  );
  HexDecoder dsp1 (
    Display7[7:4],//Input
    SevenSegDisplays[13:7]
  );
  HexDecoder dsp2 (
    Display7[11:8], //Input
    SevenSegDisplays[20:14]
  );
  HexDecoder dsp3 (
    Display7[15:12], //Input
    SevenSegDisplays[27:21]
  );
  HexDecoder dsp4 (
    Display7[19:16], //Input
    SevenSegDisplays[34:28]
  );
  HexDecoder dsp5 (
    Display7[23:20], //Input
    SevenSegDisplays[41:35]
  );
  HexDecoder dsp6 (
    Display7[27:24], //Input
    SevenSegDisplays[48:42]
  );
  HexDecoder dsp7 (
    Display7[31:28], //Input
    SevenSegDisplays[55:49]
  );




endmodule
