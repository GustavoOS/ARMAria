module Control
#(
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH = 7,
    parameter INSTRUCTION_WIDTH = 16,
    parameter REGISTER_NUMBER_WIDTH = 4,
    parameter OFFSET_WIDTH = 8
)(
    input [INSTRUCTION_WIDTH - 1:0] Instruction,
    input alu_negative, alu_carry, alu_overflow, alu_zero, continue_button,
    input bs_negative, bs_zero, bs_carry, reset, clock, confirmation,
    output [OFFSET_WIDTH - 1:0] OffImmed,
    output [ID_WIDTH - 1:0] ID,
    output [REGISTER_NUMBER_WIDTH - 1:0] RegD, RegA, RegB,
    output [3:0] controlBS, controlALU,
    output [2:0] controlRB, controlMAH,
    output [2:0] control_channel_B_sign_extend, control_load_sign_extend,
    output allow_write_on_memory, should_fill_channel_b_with_offset,
    output should_read_from_input_instead_of_memory,
    output negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag,
    output enable, should_take_branch, is_input, is_output
);
    
    wire [3:0] condition_code;
    wire [2:0] specreg_update_mode;

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
        clock, reset, enable,
        specreg_update_mode, 
        negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag, 
        alu_negative, alu_zero, alu_carry, alu_overflow,
        bs_negative, bs_zero, bs_carry
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
        confirmation, continue_button, mode_flag,
        ID, 
        enable, allow_write_on_memory, should_fill_channel_b_with_offset, 
        should_read_from_input_instead_of_memory, is_input, is_output,
        control_channel_B_sign_extend, control_load_sign_extend,
        specreg_update_mode, controlRB, controlMAH, 
        controlALU, controlBS
    );




endmodule
