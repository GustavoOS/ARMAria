module ARMAria
#(
    parameter ADDR_WIDTH = 14,
    parameter INSTRUCTION_WIDTH = 16,
    parameter FLAG_COUNT = 5,
    parameter IO_WIDTH = 16,
    parameter SEGMENTS_COUNT = 7*8,
    parameter DATA_WIDTH = 32,
    parameter OFFSET_WIDTH = 8
)(
    input clock_50mhz, confirmation_button, reset_button,
    input [IO_WIDTH :0] sw,
    output [IO_WIDTH - 1:0] rled,
    output [FLAG_COUNT - 1:0] gled,
    output [SEGMENTS_COUNT - 1:0] sseg,
    output clock, reset, should_take_branch,
    output is_input, is_output, confirmation
);

    /* Wire Declaration Section*/

    wire alu_negative, alu_zero, alu_carry, alu_overflow;
    wire bs_negative, bs_zero, bs_carry, enable;
    wire negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag;
    wire allow_write_on_memory, should_fill_channel_b_with_offset;
    wire should_read_from_input_instead_of_memory;
    wire [1:0] control_Human_Interface;
    wire [2:0] controlMAH, control_channel_B_sign_extend_unit;
    wire [2:0] control_load_sign_extend_unit, controlRB;
    wire [3:0] RegD, RegA, RegB, controlALU, controlBS;
    wire [6:0] ID;
    wire [OFFSET_WIDTH - 1:0] OffImmed;
    wire [IO_WIDTH - 1:0] rledsignal;
    wire [INSTRUCTION_WIDTH -1 :0] Instruction;
    wire [ADDR_WIDTH - 1: 0] instruction_address, next_PC, data_address;
    wire [DATA_WIDTH - 1:0] display7, PC, SP, data_read_from_memory;
    wire [DATA_WIDTH - 1:0] PreMemIn, MemIn, Bbus, IData, PreB, Bse;
    wire [DATA_WIDTH - 1: 0] next_SP, RESULT, Abus, MemOut, Bsh;

    /* Buttons startup  */

    DeBounce dbc(clock_50mhz, confirmation_button, confirmation);
    DeBounce dbr(clock_50mhz, reset_button, reset);

    /*Clock startup */

    FrequencyDivider fd(clock_50mhz, clock);

    /* Module interconnection*/

    Control control_unit(
        Instruction,
        alu_negative, alu_carry, alu_overflow, alu_zero, 
        bs_negative, bs_zero, bs_carry, reset, clock, confirmation,
        OffImmed,
        ID, 
        RegD, RegA, RegB, 
        controlBS, controlALU, control_Human_Interface, 
        controlRB, controlMAH, 
        control_channel_B_sign_extend_unit, control_load_sign_extend_unit,
        allow_write_on_memory, should_fill_channel_b_with_offset, 
        should_read_from_input_instead_of_memory, 
        negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag, 
        enable, should_take_branch, is_input, is_output
    );

    Memory externalmem(
        MemOut,
        instruction_address, data_address,
        allow_write_on_memory, clock,
        Instruction,
        data_read_from_memory
    );

    IOmodule enterescape(
        clock, control_Human_Interface, reset,
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
        mode_flag, enable, reset, clock, should_take_branch,
        controlRB, 
        RegA, RegB, RegD, 
        RESULT, MemIn,
        next_SP, next_PC, 
        Abus, Bbus,
        PC, SP, 
        MemOut
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
