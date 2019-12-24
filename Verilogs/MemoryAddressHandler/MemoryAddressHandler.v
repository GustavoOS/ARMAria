module MemoryAddressHandler #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32;
    parameter KERNEL_STACK_TOP = 4096,
    parameter KERNEL_STACK_BOTTOM = 6143,
    parameter USER_STACK_TOP = 6144,
    parameter USER_STACK_BOTTOM = 8191,
    parameter MAX_NUMBER = 32'hffffffff

)(
    input [DATA_WIDTH -1:0]  input_address, current_PC, current_SP,
    input [2:0] control,
    input reset, is_kernel,    
    output reg [DATA_WIDTH -1:0] next_SP,
    output reg [ADDR_WIDTH - 1:0] output_address, 
    output [ADDR_WIDTH - 1:0] instruction_address, next_PC
);

    /* PC behavior */
    assign instruction_address = reset ? 0 : current_PC;
    Incrementor PC_incr(
        1,
        current_PC,
        1,
        next_PC
        );

    //Stack behavior
    wire [DATA_WIDTH - 1: 0] top_stack, bottom_stack;
    assign top_stack = is_kernel ? KERNEL_STACK_TOP : USER_STACK_TOP;
    assign bottom_stack = is_kernel ? KERNEL_STACK_BOTTOM : USER_STACK_BOTTOM;


    always @( * ) begin
        case (control)
            /* PUSH address math: Store in Memory, remove from Register*/
            1:begin
                next_SP = (current_SP > top_stack) ? top_stack : current_SP - 1;
                output_address = next_SP;
            end

            /* POP address math: Load into Register, remove from memory*/
            2:begin
                next_SP = (current_SP < bottom_stack) ? bottom_stack : current_SP + 1;
                output_address = current_SP;
            end
            default: begin
                output_address = input_address[ADDR_WIDTH - 1:0];
                next_SP = (current_SP == 0) ? bottom_stack: current_SP;
            end
        endcase
    end




    
endmodule
