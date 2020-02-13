module IOmodule #(
    parameter DISPLAY_SIZE = 32,
    parameter SWITCH_SIZE = 16,
    parameter DATA_SIZE = 32,
    parameter SPECREG_LEN = 5,
    parameter SEGMENT_COUNT = 56,
    parameter INSTRUCTION_ADDR_LEN = 14,
    parameter INSTRUCTION_LEN = 16
)(
    input slow_clock, fast_clock,
    input should_update_display,
    input reset, enable,
    input [(DATA_SIZE - 1) : 0] exported_data,
    output [(DATA_SIZE - 1) : 0] imported_data,
    input [(SWITCH_SIZE - 1) : 0] switches,
    input Neg, Zero, Carry, V, M,
    output [(SWITCH_SIZE - 2) : 0] RedLEDs,
    output [(SPECREG_LEN - 1) : 0] GreenLEDs,
    output [(SEGMENT_COUNT - 1) : 0] SevenSegDisplays,
    input [(INSTRUCTION_ADDR_LEN - 1) : 0] instruction_address
);
  
    reg [31:0] info, q;

    assign RedLEDs = instruction_address;
    assign GreenLEDs[4 : 1] = enable ? {Neg, Zero, Carry, V} : 4'hf;
    assign GreenLEDs[0] = M;
    assign imported_data = {16'h0, switches[15 : 0]};


    initial begin
        info = 0;
    end

    always @ ( posedge slow_clock ) begin
        if (reset) begin
            info <= 0;
        end else begin
            if (should_update_display)
                info <= exported_data;
        end
    end

    always @ (posedge fast_clock ) begin
        q <= info;
    end

    SevenSegDisp ssd(q, SevenSegDisplays);

endmodule
