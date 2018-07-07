module Control
#(
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH = 7,
    parameter INSTRUCTION_WIDTH = 16,
    parameter REGISTER_NUMBER_WIDTH = 4,
    parameter OFFSET_WIDTH = 8
)(
    input [INSTRUCTION_WIDTH - 1:0] Instruction,
    input alu_negative, alu_carry, alu_overflow, alu_zero, bs_negative, bs_zero, bs_carry,
    output [OFFSET_WIDTH - 1:0] OffImmed,
    output [ID_WIDTH - 1:0] ID,
    output [REGISTER_NUMBER_WIDTH - 1:0] RegD, RegA, RegB,
    output [3:0] controlBS, controlALU, control_Human_Interface,
    output [2:0] controlRB, controlMAH, control_channel_B_sign_extend_unit, control_load_sign_extend_unit,
    output allow_write_on_memory, should_fill_channel_b_with_offset, should_read_from_input_instead_of_memory,
    output negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag,
    output reset, clock, enable, should_take_branch
);
  
    wire [3:0] condition_code;

    InstructionDecoder id(
        Instruction,
        ID, 
        RegD, 
        RegA, 
        RegB, 
        OffImmed, 
        condition_code
    );

    SpecReg sr(
        clock, 
        reset, 
        ID, 
        negative_flag,
        zero_flag, 
        carry_flag, 
        overflow_flag, 
        mode_flag, 
        alu_negative, 
        alu_zero, 
        alu_carry, 
        alu_overflow, 
        bs_negative, 
        bs_zero, 
        bs_carry
    );

    Ramifier rm(
        condition_code, 
        negative_flag, 
        zero_flag, 
        carry_flag, 
        overflow_flag, 
        should_take_branch
    );

    ControlCore core(
        ID, 
        should_take_branch, 
        enable, 
        control_Human_Interface,
        controlALU, 
        controlBS, 
        allow_write_on_memory, 
        controlRB,
        control_channel_B_sign_extend_unit,
        control_load_sign_extend_unit,
        controlMAH, 
        should_read_from_input_instead_of_memory, 
        should_fill_channel_b_with_offset, 
        mode_flag
    );




endmodule
