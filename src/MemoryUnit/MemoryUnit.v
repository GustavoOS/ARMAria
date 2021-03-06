module MemoryUnit
#(
	parameter DATA_WIDTH = 32,
	parameter MEMORY_ADDR_WIDTH = 13,
    parameter BIOS_ADDRESS_WIDTH = 8,
    parameter STORAGE_ADDR_WIDTH = 15,
    parameter INSTRUCTION_SIZE = 16
)(
	input allow_write_on_memory, slow_clock, fast_clock,
	input [(DATA_WIDTH -1):0] original_address,
                                original_instruction_address,
                                MemOut,
    input is_bios,
    output [(INSTRUCTION_SIZE -1):0] output_instruction,
	output [(DATA_WIDTH-1):0] data_read_from_memory
);
    wire [(STORAGE_ADDR_WIDTH - 1) : 0] storage_addr;
    wire [(DATA_WIDTH -1): 0] memory_data, storage_data;
    wire is_storage;
    wire [(INSTRUCTION_SIZE -1) : 0] memory_instruction,
                                  bios_instruction;

    MemoryController controller(
        original_address,
        is_storage,
        storage_addr
    );

    Memory main_memory(
        MemOut,
        original_instruction_address[(MEMORY_ADDR_WIDTH - 1) : 0],
        original_address[(MEMORY_ADDR_WIDTH - 1) : 0],
        allow_write_on_memory, fast_clock, slow_clock,
        memory_instruction,
        memory_data
    );

    StorageDrive hd(
        storage_addr,
        MemOut,
        is_storage && allow_write_on_memory , fast_clock, slow_clock,
        storage_data
    );

    MemoryDataHandler poolMux(
        is_storage,
        storage_data, memory_data,
        data_read_from_memory
    );

    BIOS bios(
        fast_clock,
        original_instruction_address[(BIOS_ADDRESS_WIDTH - 1):0],
        bios_instruction
    );

    MemoryDataHandler #(.DATA_WIDTH(INSTRUCTION_SIZE))
        instructionMUX(
            is_bios,
            bios_instruction,
            memory_instruction,
            output_instruction
        );

endmodule