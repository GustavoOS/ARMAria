module Control
#(
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH = 7,
    parameter INSTRUCTION_WIDTH = 16,
    parameter REGISTER_ID = 4,
    parameter OFFSET_WIDTH = 12,
    parameter CONDITION_WIDTH = 4
)(
    input [INSTRUCTION_WIDTH - 1 : 0] Instruction,
    input alu_negative, alu_carry, alu_overflow,
    input alu_zero, continue_button, bs_negative,
    input bs_zero, bs_carry, reset, clock,
    input confirmation, is_user_request,
    output [(OFFSET_WIDTH - 1) : 0] OffImmed,
    output [(REGISTER_ID - 1) : 0] RegD, RegA, RegB,
    output [3 : 0] controlBS, controlALU,
    output [2 : 0] controlRB, controlMAH,
    output [2 : 0] b_sign_extend, load_sign_extend,
    output is_memory_write, shoud_fill_b_offset,
    output n_flag, z_flag, c_flag, v_flag, is_os, enable,
    output should_branch, is_input, is_output, is_bios
);

    wire [(ID_WIDTH - 1) : 0] ID, decoded_id;
    wire [(OFFSET_WIDTH - 1) : 0] decoded_offset;
    wire [(CONDITION_WIDTH -1) : 0] condition_code;
    wire [3 : 0] specreg_update_mode;
    wire interruption;

    InstructionDecoder id(
        Instruction,
        decoded_id,
        RegD, RegA, RegB,
        decoded_offset,
        condition_code
    );

    SpecReg sr(
        clock, reset, enable,
        specreg_update_mode,
        n_flag, z_flag, c_flag, v_flag, is_os,
        alu_negative, alu_zero, alu_carry, alu_overflow,
        bs_negative, bs_zero, bs_carry, is_bios
    );

    Ramifier rm(
        condition_code,
        n_flag,
        z_flag,
        c_flag,
        v_flag,
        should_branch
    );

    ControlCore core(
        confirmation, continue_button, is_os,
        ID,
        enable, is_memory_write, shoud_fill_b_offset,
        is_input, is_output,
        b_sign_extend, load_sign_extend,
        controlRB, controlMAH,
        controlALU, controlBS, specreg_update_mode
    );

    Watchdog pitbull(
        clock,
        (is_bios || is_os || is_input || is_output),
        interruption
    );

    Interruptor proxy(
        decoded_id,
        decoded_offset,
        is_user_request, interruption,
        ID,
        OffImmed
    );

endmodule
