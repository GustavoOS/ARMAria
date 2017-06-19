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
  wire [2:0] controlEM, controlMDH, controlMAH, controlSE1, controlSE2, controlRB;
  wire [3:0] RegD, RegA, RegB, controlALU, controlBS;
  wire [6:0] ID;
  wire [7:0] DW3, DW2, DW1, DW0, DR3, DR2, DR1, DR0;
  wire [8:0] OffImmed;
  wire [15:0] PreInstruction, rledsignal;
  wire NALU, ZALU, CALU, VALU, NBS, ZBS, CBS, NEG, ZER, CAR, OVERF, MODE, enable, controlMUX;
  wire [31:0] IA0, IA1, A0, A1, A2, A3, display7, RESULT, PC, SP, PCdown, SPdown;
  wire [31:0] PreMemIn, MemOut, MemIn, Abus, Bbus, PreB, Bse, Bsh;


  control controlunit(PreInstruction, RegD, RegA, RegB, OffImmed,
    controlEM, controlRB, controlMDH, controlMAH, controlMUX, controlSE2, controlSE1,
    controlBS, controlALU, ID, Instruction, NALU, CALU, VALU, ZALU, NBS, ZBS, CBS,
    NEG, ZER, CAR, OVERF, MODE, reset, clock, enable
    );

  EM externalmem(clock,
	  controlEM,
	  IA0, IA1,
	  A0, A1, A2, A3,
	  DW0, DW1, DW2, DW3,
	  DR0, DR1, DR2, DR3, PreInstruction,
	  rledsignal, display7, sw, reset
    );

  IOmodule iomo (
    display7, rledsignal,
    NEG, ZER, CAR, OVERF, MODE,
    rled, gled, sseg
    );

  MemoryAddressHandler mah(
    RESULT, PC, SP, PCdown, SPdown,
    A3, A2, A1, A0, IA1, IA0, MODE, controlMAH
  );

  MemoryDataHandler mdh(
    DR3, DR2, DR1, DR0,
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
