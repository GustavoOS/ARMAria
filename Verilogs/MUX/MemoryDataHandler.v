module MemoryDataHandler
#(
    parameter DATA_WIDTH = 32
)(
    input should_read_from_input,
    input  [DATA_WIDTH - 1:0] input_signal, data_read_from_memory,
    output [DATA_WIDTH - 1:0] chosen_data_input
);

    assign chosen_data_input = should_read_from_input ? input_signal : data_read_from_memory;

endmodule
