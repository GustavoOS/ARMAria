module MemoryUnit
#(
	parameter DATA_WIDTH=32,
	parameter ADDR_WIDTH=14,
   parameter INSTRUCTION_SIZE = 32
)(
	input allow_write_on_memory, slow_clock, fast_clock,
	input [(DATA_WIDTH -1):0] original_address,
                                original_instruction_address,
                                MemOut,
    output [(INSTRUCTION_SIZE -1):0] output_instruction,
	output [(DATA_WIDTH-1):0] data_read_from_memory
);

    wire [(ADDR_WIDTH -1): 0] memory_address, storage_address,
                                instruction_address;
    wire [(DATA_WIDTH -1): 0] memory_data, storage_data;
    wire is_storage;

    MemoryController controller(
        original_address, original_instruction_address,
        is_storage,
        memory_address, storage_address, instruction_address
    );

    Memory main_memory(
        MemOut,
        instruction_address, memory_address,
        allow_write_on_memory, fast_clock, slow_clock,
        output_instruction,
        memory_data
    );

    StorageDrive hd(
        storage_address,
        MemOut,
        is_storage && allow_write_on_memory , fast_clock, slow_clock,
        storage_data
    );

    MemoryDataHandler poolMux(
        is_storage,
        storage_data, memory_data,
        data_read_from_memory
    );

endmodule