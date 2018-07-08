module ARMAria
#(
    parameter ADDR_WIDTH = 14,
    parameter INSTRUCTION_WIDTH = 16,
    parameter FLAG_COUNT = 5,
    parameter IO_WIDTH = 16,
    parameter SEGMENTS_COUNT = 56,
    parameter DATA_WIDTH = 32
)(
    input clk_fpga, clock_fpga_button, reset_fpga,
    input [IO_WIDTH - 1:0] sw,
    output [IO_WIDTH - 1:0] rled,
    output [FLAG_COUNT - 1:0] gled,
    output [SEGMENTS_COUNT - 1:0] sseg,

    //Debug signals
    output clock, reset, should_take_branch,
    output [1:0] control_Human_Interface,
    output [ADDR_WIDTH - 1: 0] instruction_address, next_instruction_address,
    output [INSTRUCTION_WIDTH -1 :0] Instruction,
    output [DATA_WIDTH - 1: 0] next_PC, next_SP, RESULT, Abus, MemOut, Bsh 
);
    wire [1:0] always_zero;
    assign always_zero = 0;
    /* Clock statup  */
    wire clktemp, resetemp;
    DeBounce dbc(clk_fpga, clock_fpga_button, clktemp);
    DeBounce dbr(clk_fpga, reset_fpga, resetemp);

    assign clock = ~clktemp;
    assign reset = ~resetemp;
    /*Clock startup end */

    /* Wire Declaration Section*/
    wire alu_negative, alu_zero, alu_carry, alu_overflow;
    wire bs_negative, bs_zero, bs_carry, enable;
    wire negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag;
    wire should_fill_channel_b_with_offset;
    wire should_read_from_input_instead_of_memory;
    wire [2:0] controlMAH, control_channel_B_sign_extend_unit;
    wire [2:0] control_load_sign_extend_unit, controlRB;
    wire [3:0] RegD, RegA, RegB, controlALU, controlBS;
    wire [6:0] ID;
    wire [7:0] OffImmed;
    wire [IO_WIDTH - 1:0] rledsignal;
    wire [ADDR_WIDTH - 1: 0] data_address;
    wire [DATA_WIDTH - 1:0] display7, PC, SP, data_read_from_memory;
    wire [DATA_WIDTH - 1:0] PreMemIn, MemIn, Bbus, IData, PreB, Bse;
    wire allow_write_on_memory;

    /* Module interconnection*/

    Control control_unit(
        Instruction,
        alu_negative, alu_carry, alu_overflow, alu_zero, 
        bs_negative, bs_zero, bs_carry, reset, clock,
        OffImmed,
        ID, 
        RegD, RegA, RegB, 
        controlBS, controlALU, control_Human_Interface, 
        controlRB, controlMAH, 
        control_channel_B_sign_extend_unit, control_load_sign_extend_unit,
        allow_write_on_memory, should_fill_channel_b_with_offset, 
        should_read_from_input_instead_of_memory, 
        negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag, 
        enable, should_take_branch
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
        rled, gled, sseg, Instruction
    );

    MemoryAddressHandler mah(
        RESULT, next_instruction_address, SP,
        controlMAH,
        reset, mode_flag,
        next_PC, next_SP,
        data_address,
        instruction_address
    );

    MUXPC mpc(
        should_take_branch,
        RESULT, PC,
        next_instruction_address
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
        mode_flag, enable, reset, clock,
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
