module MemoryController
#(
    parameter INPUT_WIDTH = 32,
	parameter MEMORY_ADDRESS_WIDTH = 13,
    parameter STORAGE_ADDRESS_WIDTH = 15,
    parameter STORAGE_START = 2**MEMORY_ADDRESS_WIDTH,
    parameter MEMORY_END = STORAGE_START - 1
)(
    input [(INPUT_WIDTH -1) : 0] original_address,
    output is_storage,
    output [(STORAGE_ADDRESS_WIDTH -1) : 0] storage_address
);
    assign is_storage = original_address > MEMORY_END;
    assign storage_address = original_address - STORAGE_START;

endmodule