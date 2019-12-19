module MemoryController
#(
    parameter INPUT_WIDTH = 32,
	parameter ADDRESS_WIDTH = 14,
    parameter MEMORY_END = 2**ADDRESS_WIDTH - 1
)(
    input [(INPUT_WIDTH -1) : 0] MAH_address, MAH_instruction,
    output is_storage,
    output [(ADDRESS_WIDTH - 1): 0] data_address,
                                    instruction_address
);
    assign is_storage = MAH_address > MEMORY_END;

    assign data_address = MAH_address[(ADDRESS_WIDTH -1) : 0];

    assign instruction_address =
                    MAH_instruction[(ADDRESS_WIDTH -1) : 0];

endmodule