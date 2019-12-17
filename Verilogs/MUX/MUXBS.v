module MUXBS
#(
    parameter DATA_WIDTH = 32,
    parameter OFFSET_WIDTH = 12
)(
    input should_output_offset,
    input [DATA_WIDTH - 1:0] input_channel_B,
    input [OFFSET_WIDTH - 1:0] Offset,
    output [DATA_WIDTH - 1:0] updated_channel_B
);
    wire [DATA_WIDTH - OFFSET_WIDTH -1:0] zeros;
    assign zeros = 0;

    assign updated_channel_B = (should_output_offset)? {zeros, Offset} : input_channel_B;

endmodule
