module SevenSegDisp(
  Display7, SevenSegDisplays
  );
  input [31:0] Display7;
  output [55:0] SevenSegDisplays;

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
