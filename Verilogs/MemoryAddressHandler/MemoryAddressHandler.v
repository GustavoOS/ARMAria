module MemoryAddressHandler #(
    parameter ADDR_WIDTH = 14,
    parameter DATA_WIDTH = 32;
    parameter CODE_AREA_SIZE = 4096,
    parameter PRIVILEGED_STACK_SIZE = 2048,
    parameter PRIVILEGED_STACK_TOP = CODE_AREA_SIZE,
    parameter PRIVILEGED_STACK_BOTTOM = USER_STACK_TOP - 1,
    parameter USER_STACK_SIZE = 2048,
    parameter USER_STACK_TOP = CODE_AREA_SIZE + PRIVILEGED_STACK_SIZE,
    parameter USER_STACK_BOTTOM = DATA_AREA_SIZE - 1,
    parameter DATA_AREA_SIZE = 8192,
    parameter MAX_NUMBER = (2**DATA_WIDTH) -1

)(
    input [DATA_WIDTH -1:0]  input_address, current_PC, current_SP,
    input [2:0] control,
    input reset, privilege_mode_flag,    
    output [DATA_WIDTH -1:0] next_SP,
    output reg [ADDR_WIDTH - 1:0] output_address, 
    output [ADDR_WIDTH - 1:0] instruction_address, next_PC
);

    /* PC behavior */
    assign instruction_address = reset ? 0 : current_PC;
    Incrementor PC_incr(
        reset ? 4 : 1,
        current_PC,
        1,
        next_PC
        );


    //Stack behavior
    reg [2:0] SP_incr_control;
    wire [DATA_WIDTH - 1: 0] min_stack, max_stack;
    assign min_stack = privilege_mode_flag ? PRIVILEGED_STACK_TOP : USER_STACK_TOP;
    assign max_stack = privilege_mode_flag ? PRIVILEGED_STACK_BOTTOM : USER_STACK_BOTTOM;
    Incrementor SP_incr(
        SP_incr_control,
        current_SP,
        max_stack,
        next_SP
    );


    always @( * ) begin
        case (control)
            /* PUSH address math */
            1:begin
                
                if (current_SP == MAX_NUMBER) begin // is the stack empty?
                    SP_incr_control = 4; //SP = first SP
                end
                else begin
                    if (current_SP > min_stack) // has multiple items?
                    begin
                        SP_incr_control = 2; //SP--
                    end
                    else begin // is the stack full?
                        SP_incr_control = 3; //SP = 32'hffffffff
                    end
                end
                output_address = next_SP[ADDR_WIDTH - 1:0];
            end

            /* POP address math */
            2:begin                
                if (current_SP < max_stack // has multiple items?
                ) begin
                    SP_incr_control = 1; //SP ++
                end
                else begin // has 1 or less items
                    SP_incr_control = 3; //SP = 32'hffffffff
                end
                output_address = current_SP[ADDR_WIDTH - 1:0];
            end
            default: begin
                output_address = input_address[ADDR_WIDTH - 1:0];
                SP_incr_control = 0; //SP = SP
            end
        endcase
    end




    
endmodule