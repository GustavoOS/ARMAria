module ARMAria
#(
    parameter ADDR_WIDTH = 32,
    parameter INSTRUCTION_WIDTH = 16,
    parameter FLAG_COUNT = 5,
    parameter IO_WIDTH = 16,
    parameter SEGMENTS_COUNT = 7*8,
    parameter DATA_WIDTH = 32,
    parameter OFFSET_WIDTH = 12
)(
    input fast_clock, confirmation_button, reset_button, continue_button,
    input [IO_WIDTH :0] sw,
    output [IO_WIDTH - 1:0] rled,
    output [FLAG_COUNT - 1:0] gled,
    output [SEGMENTS_COUNT - 1:0] sseg,
    output slow_clock, reset, should_take_branch,
    output is_input, is_output, enable
);

    /* Wire Declaration Section*/

    wire alu_negative, alu_zero, alu_carry, alu_overflow;
    wire bs_negative, bs_zero, bs_carry, confirmation, continue_debounced;
    wire negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag;
    wire allow_write_on_memory, should_fill_channel_b_with_offset;
    wire should_read_from_input_instead_of_memory;
    wire isStorage, is_bios;
    wire [2:0] controlMAH, control_channel_B_sign_extend_unit;
    wire [2:0] control_load_sign_extend_unit, controlRB;
    wire [3:0] RegD, RegA, RegB, controlALU, controlBS;
    wire [6:0] ID;
    wire [(OFFSET_WIDTH - 1):0] OffImmed;
    wire [(IO_WIDTH - 1):0] rledsignal;
    wire [(INSTRUCTION_WIDTH -1) :0] Instruction;
    wire [(ADDR_WIDTH - 1): 0] instruction_address, next_PC, data_address,
                                storage_addres;
    wire [(DATA_WIDTH - 1):0] display7, PC, SP, data_read_from_memory;
    wire [(DATA_WIDTH - 1):0] PreMemIn, MemIn, Bbus, IData, PreB, Bse;
    wire [(DATA_WIDTH - 1): 0] next_SP, RESULT, Abus, MemOut, Bsh;
    wire [(DATA_WIDTH - 1): 0] StoDat, MemDat; //Storage Data, Memory Data

    /* Buttons startup  */

    DeBounce dbc(fast_clock, confirmation_button, confirmation);
    DeBounce dbr(fast_clock, reset_button, reset);
    DeBounce dbco(fast_clock, continue_button, continue_debounced);

    /*Drive slow clock */

    FrequencyDivider fd(fast_clock, slow_clock);

    /* Module interconnection*/

    Control control_unit(
        Instruction,
        alu_negative, alu_carry, alu_overflow, alu_zero, continue_debounced,
        bs_negative, bs_zero, bs_carry, reset, slow_clock, confirmation,
        OffImmed,
        ID, 
        RegD, RegA, RegB,
        controlBS, controlALU, 
        controlRB, controlMAH, 
        control_channel_B_sign_extend_unit, control_load_sign_extend_unit,
        allow_write_on_memory, should_fill_channel_b_with_offset, 
        should_read_from_input_instead_of_memory, 
        negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag, 
        enable, should_take_branch, is_input, is_output, is_bios
    );

    MemoryUnit mu(
        allow_write_on_memory, slow_clock, fast_clock,
        data_address, instruction_address, MemOut,
        is_bios,
        Instruction,
        data_read_from_memory
    );

    IOmodule enterescape(
        slow_clock, fast_clock, 
        is_output & (~is_input),
        reset,
        MemOut, IData, sw,
        negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag,       //Flags from Control Unit
        rled, gled, sseg, instruction_address , Instruction
    );

    MemoryAddressHandler mah(
        RESULT, PC, SP,
        controlMAH,
        reset, mode_flag,
        next_SP,
        data_address,
        instruction_address, next_PC
    );

    MemoryDataHandler mdh(
        should_read_from_input_instead_of_memory,
        IData, data_read_from_memory,
        PreMemIn
    );

    SignExtend load_sign_extend_unit(
        PreMemIn,
        control_load_sign_extend_unit,
        MemIn
    );

    RegBank ARMARIAbank(
        enable, reset, slow_clock, fast_clock, should_take_branch,
        controlRB, 
        RegA, RegB, RegD,
        RESULT, MemIn,
        next_SP, next_PC, 
        Abus, Bbus,
        PC, SP, 
        MemOut,
        {negative_flag, zero_flag, carry_flag, overflow_flag}
    );

    MUXBS muxbusb(
        should_fill_channel_b_with_offset,
        Bbus, OffImmed,
        PreB
    );

    SignExtend channel_B_sign_extend_unit(
        PreB, 
        control_channel_B_sign_extend_unit, 
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
        RESULT,
        controlALU,
        carry_flag,
        alu_negative, alu_zero, alu_carry, alu_overflow
    );

endmodule
