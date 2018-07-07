module MUXPC
#(
    parameter DATA_WIDTH = 32
)(
    input should_use_alu_as_pc_source,
    input [DATA_WIDTH - 1:0] alu_result, current_PC,
    output [DATA_WIDTH - 1:0] final_PC
);

    assign final_PC = (should_use_alu_as_pc_source) ? alu_result : current_PC;

endmodule
