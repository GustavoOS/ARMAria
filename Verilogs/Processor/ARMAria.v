module ARMAria(
  clk_fpga, clock_fpga, clock, reset, reset_fpga, sw, rled, gled, sseg,
  //debug io
  Instruction, IA1, IA0, PCdown, SPdown, take, ResultPC, RESULT, Abus, MemOut,Bsh, controlHI

  );
  input clk_fpga, clock_fpga, reset_fpga;
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

  output clock, reset;
  wire clktemp, resetemp;
  DeBounce dbc(clk_fpga, clock_fpga, clktemp);
  DeBounce dbr(clk_fpga, reset_fpga, resetemp);

  assign clock = ~clktemp;
  assign reset = ~resetemp;

  // wires
  wire NALU, ZALU, CALU, VALU, NBS, ZBS, CBS, NEG, ZER, CAR, OVERF, MODE, enable, should_fill_channel_b_with_offset, should_read_from_input_instead_of_memory;
  wire [2:0] controlMAH, control_channel_B_sign_extend_unit, control_load_sign_extend_unit, controlRB;
  wire [3:0] RegD, RegA, RegB, controlALU, controlBS;
  wire [6:0] ID;
  wire [7:0] DW3, DW2, DW1, DW0, OffImmed;
  wire [15:0] PreInstruction, rledsignal;
  wire [127:0] Address;
  wire [31:0] display7, PC, SP, Read, PreB, Bse;
  wire [31:0] PreMemIn, MemIn, Bbus, IData; //Abus, Bse, PreB;
  wire [1:0] controlEM;

  Control control_unit(PreInstruction, RegD, RegA, RegB, OffImmed,
    controlEM, controlRB, should_read_from_input_instead_of_memory, controlMAH, should_fill_channel_b_with_offset, control_channel_B_sign_extend_unit, control_load_sign_extend_unit,
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
    should_read_from_input_instead_of_memory//Control Unit
  );

  SignExtend load_sign_extend_unit(
    PreMemIn, control_load_sign_extend_unit, MemIn
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
    should_fill_channel_b_with_offset,
    Bbus, OffImmed,
    PreB
  );

  SignExtend channel_B_sign_extend_unit(PreB, control_channel_B_sign_extend_unit, Bse);

  BarrelShifter NiagaraFalls(
    Abus, Bse, controlBS, Bsh, NBS, ZBS, CBS
  );

  ALU arithmeticlogicunit(
    Abus, Bsh, RESULT,
    controlALU, CAR,
    NALU, ZALU, CALU, VALU
  );





endmodule
