module MemoryController
#(
    parameter INPUT_WIDTH = 32,
	parameter ADDRESS_WIDTH = 14,
    parameter STORAGE_INITIAL = 2**ADDRESS_WIDTH
)(
    input [(INPUT_WIDTH -1) : 0] original_address, original_instruction,
    output is_storage,
    output [(ADDRESS_WIDTH - 1): 0] memory_address, storage_address,
                                    instruction_address
);
    assign is_storage = original_address >= STORAGE_INITIAL;

    assign storage_address = original_address - STORAGE_INITIAL;

    assign memory_address = original_address[(ADDRESS_WIDTH -1) :0];

    assign instruction_address =
                    original_instruction[(ADDRESS_WIDTH -1): 0];

endmodule