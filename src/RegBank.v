module RegBank
#(
    parameter WORD_SIZE = 32,
    parameter MAX_NUMBER = 32'hffffffff,
    parameter PC_REGISTER = 15,
    parameter SP_REGISTER = 14,
    parameter SPECREG_LENGTH = 4,
    parameter KERNEL_STACK = 6143,
    parameter USER_STACK = 8191,
    parameter OS_START = 2048,

    parameter SP_KEEPER_REGISTER = 6,
    parameter SYSTEM_CALL_REGISTER = 7,
    parameter PC_KEEPER_REGISTER = 13
)(
    input   enable, reset, slow_clock, fast_clock,
    input   [2:0]   control, 
    input   [3:0]   register_source_A, register_source_B, register_Dest,
    input   [(WORD_SIZE - 1) : 0]  ALU_result, data_from_memory,
    input   [(WORD_SIZE - 1) : 0]  new_SP, new_PC,
    output  reg [(WORD_SIZE - 1) : 0]  read_data_A, read_data_B,
    output  reg [(WORD_SIZE - 1) : 0]  current_PC, current_SP, memory_output,
    input   [(SPECREG_LENGTH - 1) : 0] special_register
);

    reg [(WORD_SIZE - 1) : 0] Bank [15:0];

    wire RD_isnt_special;

    assign RD_isnt_special = register_Dest != PC_REGISTER && register_Dest!= 14;

    always @ (posedge fast_clock) begin
        read_data_A <= Bank[register_source_A];
        read_data_B <= Bank[register_source_B];
        current_PC <= Bank[PC_REGISTER];
        current_SP <= Bank[SP_REGISTER];
        memory_output <= Bank[register_Dest];
    end


    always @ (posedge slow_clock) begin
        if (reset) begin
            Bank[SP_REGISTER] <= USER_STACK;
            Bank[PC_REGISTER] <= 0;
        end else begin
            if (enable) begin
                case (control)
                    1:begin //RD=ALU_result
                        if(RD_isnt_special) begin
                            Bank[register_Dest] <= ALU_result;
                        end
                        Bank[PC_REGISTER] <= new_PC;
                        Bank[SP_REGISTER] <= new_SP;
                    end
                    2:begin //RD=data_from_memory
                        if(RD_isnt_special)begin
                            Bank[register_Dest] <= data_from_memory;
                        end
                        Bank[SP_REGISTER] <= new_SP;
                        Bank[PC_REGISTER] <= new_PC;
                    end
                    3:begin //Enter privileged mode
                        Bank[SP_KEEPER_REGISTER] <= Bank[SP_REGISTER]; // Save user SP
                        Bank[PC_KEEPER_REGISTER] <= Bank[PC_REGISTER];  // LR = actual next Instruction address
                        Bank[PC_REGISTER] <= OS_START;  // Jump to OS
                        Bank[SP_REGISTER] <= KERNEL_STACK;
                        Bank[SYSTEM_CALL_REGISTER] <= ALU_result;          // Set System Call Register
                    end
                    4:begin //Exit privileged mode
                        Bank[SP_REGISTER] <= Bank[SP_KEEPER_REGISTER];            // Recover user SP
                        Bank[PC_REGISTER] <= Bank[PC_KEEPER_REGISTER];  // Return to the same point
                    end
                    5:begin // CPXR COPY SPECIAL REGISTER
                        if(RD_isnt_special)
                            Bank[register_Dest] <= special_register;
                        Bank[PC_REGISTER] <= new_PC;
                        Bank[SP_REGISTER] <= new_SP;
                    end
                    default:begin
                        Bank[SP_REGISTER] <= new_SP;
                        Bank[PC_REGISTER] <= new_PC;
                    end
                endcase

            end
        end
    end



  endmodule
