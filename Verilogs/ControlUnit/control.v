module Control
#(
    parameter DATA_WIDTH = 32,
    parameter ID_WIDTH = 7,
    parameter INSTRUCTION_WIDTH = 16,
    parameter REGISTER_ID = 4,
    parameter OFFSET_WIDTH = 12,
    parameter CONDITION_WIDTH = 5,
    parameter INTERRUPTION_SIZE = 2,
)(
    input [INSTRUCTION_WIDTH - 1:0] Instruction,
    input alu_negative, alu_carry, alu_overflow,
    input alu_zero, continue_button, bs_negative,
    input bs_zero, bs_carry, reset, clock,
    input confirmation, is_user_request
    output [(OFFSET_WIDTH - 1):0] OffImmed,
    output [(ID_WIDTH - 1):0] ID,
    output [(REGISTER_ID - 1):0] RegD, RegA, RegB,
    output [3:0] controlBS, controlALU,
    output [2:0] controlRB, controlMAH,
    output [2:0] b_sign_extend, load_sign_extend,
    output allow_write_on_memory, shoud_fill_b_offset,
    output negative_flag, zero_flag, carry_flag,
    output overflow_flag, mode_flag, enable,
    output should_branch, is_input, is_output, is_bios
);
    
    wire [(CONDITION_WIDTH -1):0] condition_code;
    wire [3:0] specreg_update_mode;
    wire [(INTERRUPTION_SIZE - 1) : 0] interruption;
    
    InstructionDecoder id(
    Instruction,
    is_bios,
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
    bs_negative, bs_zero, bs_carry, is_bios
    );
    
    Ramifier rm(
    condition_code,
    negative_flag,
    zero_flag,
    carry_flag,
    overflow_flag,
    should_branch
    );
    
    ControlCore core(
    confirmation, continue_button, mode_flag,
    ID,
    enable, allow_write_on_memory, shoud_fill_b_offset,
    is_input, is_output,
    b_sign_extend, load_sign_extend,
    controlRB, controlMAH,
    controlALU, controlBS, specreg_update_mode
    );
    
    Watchdog pitbull(
    clock,
    is_bios, mode_flag,
    is_input, is_output,
    is_user_request,
    interruption
    );
    
    
endmodule
