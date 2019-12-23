module RegBank
#(
    parameter DATA_AREA_START = 8192,
    parameter REGISTER_LENGTH = 32,
    parameter MAX_NUMBER = 32'hffffffff,
    parameter ADDR_WIDTH = 32,
    parameter PC_REGISTER = 15,
    parameter SPECREG_LENGTH = 4
)(
    input   privileged_mode, enable, reset, slow_clock, fast_clock, should_branch,
    input   [2:0]   control, 
    input   [3:0]   register_source_A, register_source_B, register_Dest,
    input   [REGISTER_LENGTH -1:0]  ALU_result, data_from_memory,
    input   [REGISTER_LENGTH -1:0]  new_SP,
    input   [ADDR_WIDTH - 1:0] new_PC,
    output  [REGISTER_LENGTH -1:0]  read_data_A, read_data_B,
    output  [REGISTER_LENGTH -1:0]  current_PC, current_SP, memory_output,
    input   [(SPECREG_LENGTH - 1) : 0] special_register
);

    reg [REGISTER_LENGTH -1:0] Bank [16:0];
    reg [REGISTER_LENGTH - 1:0] infoA, infoB;

    wire [4:0] SP_index;
    wire RD_isnt_special;

    assign SP_index = privileged_mode ? 16 : 14;
    assign current_SP = Bank[SP_index];
    assign read_data_A = (register_source_A==14) ? current_SP : infoA;
    assign read_data_B = (register_source_B==14)? current_SP : infoB;
    assign memory_output = (register_Dest==14)? current_SP : Bank[register_Dest];
    assign current_PC = Bank[PC_REGISTER];
    assign RD_isnt_special = register_Dest != PC_REGISTER && register_Dest!= 14;

    initial begin
        Bank[0] = DATA_AREA_START;
        Bank[14] = MAX_NUMBER;//User Stack
        Bank[PC_REGISTER] = 0;  //PC
        Bank[16] = MAX_NUMBER; //Privileged Stack
    end

    always @ (posedge fast_clock) begin
        infoA = Bank[register_source_A];
        infoB = Bank[register_source_B];
    end


    always @ (posedge slow_clock) begin
        if (reset) begin
            Bank[0] <= DATA_AREA_START;
            Bank[14] <= MAX_NUMBER;//User Stack
            Bank[PC_REGISTER] <= 1;
            Bank[16] <= MAX_NUMBER; //Privileged Stack
        end else begin
            if (enable) begin

                Bank[PC_REGISTER] <= should_branch ? ALU_result : new_PC;
                Bank[SP_index] <= (control==2)? MAX_NUMBER: new_SP;

                case (control)
                    1:begin //RD=ALU_result
                        if(RD_isnt_special) begin
                            Bank[register_Dest] <= ALU_result;
                        end
                    end
                    2:begin // Clear stack instruction
                        Bank[0] <= DATA_AREA_START;
                    end
                    3:begin //RD=data_from_memory
                        if(RD_isnt_special)begin
                            Bank[register_Dest] <= data_from_memory;
                        end
                    end
                    4:begin //Enter privileged mode
                        Bank[13] <= Bank[PC_REGISTER];  //LR = actual next Instruction address
                        Bank[5] <= Bank[14];            // Save user SP
                    end
                    5:begin //Exit privileged mode
                        Bank[14] <= Bank[5];            // Recover user SP
                    end
                    6:begin // CPXR COPY SPECIAL REGISTER
                        Bank[register_Dest] <= special_register;
                    end
                endcase

            end
        end
    end



  endmodule
