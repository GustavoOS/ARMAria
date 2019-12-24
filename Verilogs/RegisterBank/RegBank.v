module RegBank
#(
    parameter DATA_AREA_START = 8192,
    parameter REGISTER_LENGTH = 32,
    parameter MAX_NUMBER = 32'hffffffff,
    parameter ADDR_WIDTH = 32,
    parameter PC_REGISTER = 15,
    parameter SPECREG_LENGTH = 4,
    parameter KERNEL_STACK = 6143,
    parameter USER_STACK = 8191
)(
    input   enable, reset, slow_clock, fast_clock, should_branch,
    input   [2:0]   control, 
    input   [3:0]   register_source_A, register_source_B, register_Dest,
    input   [REGISTER_LENGTH -1:0]  ALU_result, data_from_memory,
    input   [REGISTER_LENGTH -1:0]  new_SP,
    input   [ADDR_WIDTH - 1:0] new_PC,
    output  reg [REGISTER_LENGTH -1:0]  read_data_A, read_data_B,
    output  reg [REGISTER_LENGTH -1:0]  current_PC, current_SP, memory_output,
    input   [(SPECREG_LENGTH - 1) : 0] special_register
);

    reg [REGISTER_LENGTH -1:0] Bank [16:0];

    wire RD_isnt_special;

    assign RD_isnt_special = register_Dest != PC_REGISTER && register_Dest!= 14;

    always @ (posedge fast_clock) begin
        read_data_A <= Bank[register_source_A];
        read_data_B <= Bank[register_source_B];
        current_PC <= Bank[PC_REGISTER];
        current_SP <= Bank[14];
        memory_output <= Bank[register_Dest];
    end


    always @ (posedge slow_clock) begin
        if (reset) begin
            Bank[0] <= DATA_AREA_START;
            Bank[14] <= USER_STACK;
            Bank[PC_REGISTER] <= 1;
            Bank[16] <= KERNEL_STACK;
        end else begin
            if (enable) begin

                Bank[PC_REGISTER] <= should_branch ? ALU_result : new_PC;

                case (control)
                    1:begin //RD=ALU_result
                        if(RD_isnt_special) begin
                            Bank[register_Dest] <= ALU_result;
                        end
                    end
                    3:begin //RD=data_from_memory
                        if(RD_isnt_special)begin
                            Bank[register_Dest] <= data_from_memory;
                        end
                        Bank[14] <= new_SP;
                    end
                    4:begin //Enter privileged mode
                        Bank[5] <= Bank[14];            // Save user SP
                        Bank[13] <= Bank[PC_REGISTER];  //LR = actual next Instruction address
                        Bank[14] <= Bank[16];           //Switch stack
                    end
                    5:begin //Exit privileged mode
                        Bank[16] <= Bank[14];           // Switch stack
                        Bank[14] <= Bank[5];            // Recover user SP
                    end
                    6:begin // CPXR COPY SPECIAL REGISTER
                        Bank[register_Dest] <= special_register;
                    end
                    default:begin
                        Bank[14] <= new_SP;
                    end
                endcase

            end
        end
    end



  endmodule
