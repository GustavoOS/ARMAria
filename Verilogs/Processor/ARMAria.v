module ARMAria(
  clock, reset, sw, rled, gled, sseg,
  //debug io
  Instruction, IA1, IA0, PCdown, SPdown, take, ResultPC, RESULT, Abus, MemOut,Bsh, controlHI

  );
  input clock, reset;
  input [15:0] sw;
  output [4:0] gled;
  output [15:0] rled;
  output [55:0] sseg;
  output take;


  //debug outputs, that will become wires
  output [15:0] Instruction;
  output [9:0] IA0, IA1, ResultPC;
  output [31:0] PCdown, SPdown, Abus, RESULT, Bsh, MemOut;
  output [1:0] controlHI;

  // wires
  wire NALU, ZALU, CALU, VALU, NBS, ZBS, CBS, NEG, ZER, CAR, OVERF, MODE, enable, controlMUX, controlMDH;
  wire [2:0] controlMAH, controlSE1, controlSE2, controlRB;
  wire [3:0] RegD, RegA, RegB, controlALU, controlBS;
  wire [6:0] ID;
  wire [7:0] DW3, DW2, DW1, DW0, OffImmed;
  wire [15:0] PreInstruction, rledsignal;
  wire [39:0] Address;
  wire [31:0] display7, PC, SP, Read, PreB, Bse;
  wire [31:0] PreMemIn, MemIn, Bbus, IData; //Abus, Bse, PreB;
  wire [1:0] controlEM;

  control controlunit(PreInstruction, RegD, RegA, RegB, OffImmed,
    controlEM, controlRB, controlMDH, controlMAH, controlMUX, controlSE1, controlSE2,
    controlBS, controlALU, controlHI, ID, Instruction, NALU, CALU, VALU, ZALU, NBS, ZBS, CBS,
    NEG, ZER, CAR, OVERF, MODE, reset, clock, enable, take
    );

  EM externalmem(clock,
	  controlEM,
	  IA0, IA1,
	  Address,
	  MemOut,
	  Read,
    PreInstruction, reset
    );


  IOmodule enterescape(
    clock, controlHI, reset,
    MemOut, IData, sw,
    NEG, ZER, CAR, OVERF, MODE,       //Flags from Control Unit
    rled, gled, sseg
    );

  MemoryAddressHandler mah(
    RESULT, ResultPC, SP, PCdown, SPdown,
    Address, IA1, IA0, MODE, controlMAH
  );

  MUXPC mpc(
    RESULT, PC,
    ResultPC, take, reset
    );

  MemoryDataHandler mdh(
    IData,
    Read,//Read memory
    PreMemIn,//output
    controlMDH//Control Unit
  );

  SignExtend upperOne(
    PreMemIn, controlSE2, MemIn
  );

  RegBank ARMARIAbank(
    Abus, Bbus, RESULT, PC, PCdown, SP, SPdown,
    MemOut, MemIn,
    MODE,
    RegD, RegA, RegB,
    controlRB, clock,
    enable, reset
    );

  MUXBS muxbusb(
    controlMUX,
    Bbus, OffImmed,
    PreB
  );

  SignExtend downOne(PreB, controlSE1, Bse);

  BarrelShifter NiagaraFalls(
    Abus, Bse, controlBS, Bsh, NBS, ZBS, CBS
  );

  ALU arithmeticlogicunit(
    Abus, Bsh, RESULT,
    controlALU, CAR,
    NALU, ZALU, CALU, VALU
  );





endmodule
