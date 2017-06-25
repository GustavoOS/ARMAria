module control(
  PreInstruction,
  RegD, RegA, RegB,
  OffImmed,
  controlEM, controlRB, controlMDH, controlMAH, controlMUX, controlSE1, controlSE2,
  controlBS, controlALU, controlHI,
  ID, Instruction,
  NALU, CALU, VALU, ZALU, NBS, ZBS, CBS,
  NEG, ZER, CAR, OVERF, MODE,
  reset, clock, enable, take
  );

  input NALU, ZALU, CALU, VALU, NBS, ZBS, CBS, clock, reset;
  input [15:0] PreInstruction;

  output NEG, ZER, CAR, OVERF, MODE, enable, controlMUX, controlMDH;
  output [1:0] controlHI, controlEM;
  output [2:0] controlMAH, controlSE1, controlSE2, controlRB;
  output [3:0] controlALU, controlBS;
  output [3:0] RegD, RegA, RegB;
  output [6:0] ID;
  output [7:0] OffImmed;
  output [15:0] Instruction;
  wire [3:0] cond;
  output take;
  // wire [6:0] IDrt;


  InstructionRegister ir(clock, PreInstruction, Instruction, reset, enable);
  instructiondecoder id(Instruction, ID, RegD, RegA, RegB, OffImmed, cond);
  SpecReg sr(clock, reset, ID, NEG, ZER, CAR, OVERF, MODE, NALU, ZALU, CALU, VALU, NBS, ZBS, CBS);
  Ramifier rm(cond, NEG, ZER, CAR, OVERF, take);
  controlcore contcore(ID, take, enable, controlHI,
  controlALU, controlBS, controlEM, controlRB,
  controlSE1,//down one
  controlSE2,//upper one
  controlMAH, controlMDH, controlMUX, MODE);




endmodule
