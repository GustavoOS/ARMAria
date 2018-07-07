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

    /* Clock statup  */
    wire clktemp, resetemp;
    DeBounce dbc(clk_fpga, clock_fpga_button, clktemp);
    DeBounce dbr(clk_fpga, reset_fpga, resetemp);

    assign clock = ~clktemp;
    assign reset = ~resetemp;
    /*Clock startup end */

    /* Wire Declaration Section*/
    wire alu_negative, alu_zero, alu_carry, alu_overflow;
    wire bs_negative, bs_zero, bs_carry;
    wire negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag, enable;
    wire should_fill_channel_b_with_offset;
    wire should_read_from_input_instead_of_memory;
    wire [2:0] controlMAH, control_channel_B_sign_extend_unit;
    wire [2:0] control_load_sign_extend_unit, controlRB;
    wire [3:0] RegD, RegA, RegB, controlALU, controlBS;
    wire [6:0] ID;
    wire [7:0] OffImmed;
    wire [15:0] rledsignal;
    wire [ADDR_WIDTH - 1: 0] data_address;
    wire [31:0] display7, PC, SP, Read, PreB, Bse;
    wire [31:0] PreMemIn, MemIn, Bbus, IData; //Abus, Bse, PreB;
    wire allow_write_on_memory;

    /* Module interconnection*/

    Control control_unit(
        Instruction,
        alu_negative, alu_carry, alu_overflow, alu_zero, 
        bs_negative, bs_zero, bs_carry,
        OffImmed,
        ID, 
        RegD, RegA, RegB, 
        controlBS, controlALU, control_Human_Interface, 
        controlRB, controlMAH, 
        control_channel_B_sign_extend_unit, control_load_sign_extend_unit,
        allow_write_on_memory, should_fill_channel_b_with_offset, 
        should_read_from_input_instead_of_memory, 
        negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag, 
        reset, clock, enable, should_take_branch
    );

    Memory externalmem(
        MemOut,
        instruction_address, data_address,
        allow_write_on_memory, clock,
        Instruction,
        Read
    );


    IOmodule enterescape(
        clock, control_Human_Interface, reset,
        MemOut, IData, sw,
        negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag,       //Flags from Control Unit
        rled, gled, sseg
    );

    MemoryAddressHandler mah(
    RESULT, next_instruction_address, SP, next_PC, next_SP,
    data_address, IA1, IA0, mode_flag, controlMAH
    );

    MUXPC mpc(
    RESULT, PC,
    next_instruction_address, should_take_branch, reset
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
    Abus, Bbus, RESULT, PC, next_PC, SP, next_SP,
    MemOut, MemIn,
    mode_flag,
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
    Abus, Bse, controlBS, Bsh, bs_negative, bs_zero, bs_carry
    );

    ALU arithmeticlogicunit(
    Abus, Bsh, RESULT,
    controlALU, carry_flag,
    alu_negative, alu_zero, alu_carry, alu_overflow
    );





endmodule
