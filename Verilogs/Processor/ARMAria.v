module ARMAria
#(
    parameter WORD_SIZE = 32,
    parameter INSTRUCTION_WIDTH = 16,
    parameter FLAG_COUNT = 5,
    parameter IO_WIDTH = 16,
    parameter SEGMENTS_COUNT = 7*8,
    parameter OFFSET_WIDTH = 12
)(
    input fast_clock, confirmation_button, reset_button,
    input continue_button, request_os_button,
    input [IO_WIDTH :0] sw,
    output [(IO_WIDTH - 1) : 0] rled,
    output [(FLAG_COUNT - 1) : 0] gled,
    output [(SEGMENTS_COUNT - 1) : 0] sseg,
    output slow_clock, reset,
    output is_input, is_output, enable
);

    /* Wire Declaration Section*/

    wire alu_negative, alu_zero, alu_carry, alu_overflow;
    wire bs_negative, bs_zero, bs_carry, confirmation;
    wire continue_debounced, n_flag, z_flag, should_branch;
    wire c_flag, v_flag, is_os, is_memory_write;
    wire should_fill_b_offset, is_bios, user_request;
    wire [2 : 0] controlMAH, b_sign_extend;
    wire [2 : 0] load_sign_extend, controlRB;
    wire [3 : 0] RegD, RegA, RegB, controlALU, controlBS;
    wire [(OFFSET_WIDTH - 1) : 0] OffImmed;
    wire [(INSTRUCTION_WIDTH -1) : 0] Instruction;
    wire [(WORD_SIZE - 1) : 0] instruction_address, next_PC;
    wire [(WORD_SIZE - 1) : 0] data_address, ALU_result, final_result;
    wire [(WORD_SIZE - 1) : 0] PC, SP, memory_read_data, Bse;
    wire [(WORD_SIZE - 1) : 0] PreMemIn, MemIn, Bbus, IData, PreB;
    wire [(WORD_SIZE - 1) : 0] next_SP, Abus, MemOut, Bsh;

    /* Buttons startup  */

    DeBounce dbc(fast_clock, confirmation_button, confirmation);
    DeBounce dbr(fast_clock, reset_button, reset);
    DeBounce dbco(fast_clock, continue_button, continue_debounced);
    DeBounce dbur(fast_clock, request_os_button, user_request);

    /*Drive slow clock */

    FrequencyDivider fd(fast_clock, slow_clock);

    /* Module interconnection*/

    Control control_unit(
        Instruction,
        alu_negative, alu_carry, alu_overflow,
        alu_zero, continue_debounced, bs_negative,
        bs_zero, bs_carry, reset, slow_clock,
        confirmation, user_request,
        OffImmed,
        RegD, RegA, RegB,
        controlBS, controlALU, 
        controlRB, controlMAH, 
        b_sign_extend, load_sign_extend,
        is_memory_write, should_fill_b_offset,
        n_flag, z_flag, c_flag, v_flag, is_os, enable,
        should_branch, is_input, is_output, is_bios
    );

    MemoryUnit mu(
        is_memory_write, slow_clock, fast_clock,
        data_address, instruction_address, MemOut,
        is_bios,
        Instruction,
        memory_read_data
    );

    IOmodule enterescape(
        slow_clock, fast_clock, 
        is_output & (~is_input),
        reset, enable,
        MemOut, IData, sw,
        n_flag, z_flag, c_flag, v_flag, is_os,
        rled, gled, sseg, instruction_address , Instruction
    );

    MemoryAddressHandler mah(
        is_os, should_branch, reset,
        controlMAH,
        ALU_result, PC, SP,
        next_SP, data_address,
        final_result, next_PC,
        instruction_address
    );

    MemoryDataHandler mdh(
        (is_input && !is_output),
        IData, memory_read_data,
        PreMemIn
    );

    SignExtend load_sign_extend_unit(
        PreMemIn,
        load_sign_extend,
        MemIn
    );

    RegBank ARMARIAbank(
        enable, reset, slow_clock, fast_clock,
        controlRB, 
        RegA, RegB, RegD,
        final_result, MemIn,
        next_SP, next_PC, 
        Abus, Bbus,
        PC, SP, MemOut,
        {n_flag, z_flag, c_flag, v_flag}
    );

    MUXBS muxbusb(
        should_fill_b_offset,
        Bbus, OffImmed,
        PreB
    );

    SignExtend channel_B_sign_extend_unit(
        PreB, 
        b_sign_extend, 
        Bse
    );

    BarrelShifter NiagaraFalls(
        Abus, Bse, 
        controlBS, 
        Bsh, 
        bs_negative, bs_zero, bs_carry
    );

    ALU arithmeticlogicunit(
        Abus, Bsh,
        ALU_result,
        controlALU,
        c_flag,
        alu_negative, alu_zero, alu_carry, alu_overflow
    );

endmodule
