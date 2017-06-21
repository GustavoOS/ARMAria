module ARMAria(
  clock, reset, sw, rled, gled, sseg,
  //debug io
  Instruction
  );
  input clock, reset;
  input [15:0] sw;
  output [4:0] gled;
  output [15:0] rled;
  output [55:0] sseg;

  //debug outputs, that will become wires
  output [15:0] Instruction;

  // wires
  wire NALU, ZALU, CALU, VALU, NBS, ZBS, CBS, NEG, ZER, CAR, OVERF, MODE, enable, controlMUX;
  wire [2:0] controlMDH, controlMAH, controlSE1, controlSE2, controlRB;
  wire [3:0] RegD, RegA, RegB, controlALU, controlBS;
  wire [6:0] ID;
  wire [7:0] DW3, DW2, DW1, DW0, OffImmed;// DR3, DR2, DR1, DR0;
  wire [15:0] PreInstruction, rledsignal, IData;
  wire [9:0] IA0, IA1;
  wire [39:0] Address;
  wire [31:0] display7, RESULT, PC, SP, PCdown, SPdown, Read;
  wire [31:0] PreMemIn, MemOut, MemIn, Abus, Bbus, PreB, Bse, Bsh, OData;
  wire [1:0] controlIO, controlEM;

  control controlunit(PreInstruction, RegD, RegA, RegB, OffImmed,
    controlEM, controlRB, controlMDH, controlMAH, controlMUX, controlSE2, controlSE1,
    controlBS, controlALU, ID, Instruction, NALU, CALU, VALU, ZALU, NBS, ZBS, CBS,
    NEG, ZER, CAR, OVERF, MODE, reset, clock, enable, controlIO
    );

  EM externalmem(clock,
	  controlEM,
	  IA0, IA1,
	  Address,
	  DW0, DW1, DW2, DW3,
	  Read, PreInstruction,
	  reset
    );

  IOmodule iomo (clock, controlIO, reset,
    OData, IData, sw,
    NEG, ZER, CAR, OVERF, MODE,
    rled, gled, sseg
    );

  MemoryAddressHandler mah(
    RESULT, PC, SP, PCdown, SPdown,
    Address, IA1, IA0, MODE, controlMAH
  );

  MemoryDataHandler mdh(
	 OData, IData,
    Read,
    DW3, DW2, DW1, DW0,
    PreMemIn, MemOut, controlMDH
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
