module RegBank
#(
    parameter DATA_AREA_START = 8192,
    parameter REGISTER_LENGTH = 32,
    parameter MAX_NUMBER = 2**REGISTER_LENGTH - 1
)(
    input   [REGISTER_LENGTH -1:0]  ALU_result, data_from_memory,
    input   [REGISTER_LENGTH -1:0]  new_stack_pointer, new_PC,
    input   [3:0]   register_source_A, register_source_B, register_Dest,
    input   [2:0]   control, 
    input   privileged_mode, enable, reset, clock,
    output [REGISTER_LENGTH -1:0]   read_data_A, read_data_B,
    output [REGISTER_LENGTH -1:0]   current_PC, current_SP, memory_output
);

    reg [REGISTER_LENGTH -1:0] Bank [16:0];

    wire [4:0] SP_index;

    assign SP_index = privileged_mode ? 16 : 14;
    assign current_SP = Bank[SP_index];
    assign read_data_A = (register_source_A==14) ? current_SP : Bank[register_source_A];
    assign read_data_B = (register_source_B==14)? current_SP : Bank[register_source_B];
    assign memory_output = (register_Dest==14)? current_SP : Bank[register_Dest];
    assign current_PC = Bank[15];

    always @ (posedge clock or posedge reset) begin
        if (reset) begin
            Bank[0] <= DATA_AREA_START;
            Bank[14] <= MAX_NUMBER;//User Stack
            Bank[15] <= 0;  //PC
            Bank[16] <= MAX_NUMBER; //Privileged Stack
        end else begin
            if (enable) begin

                Bank[15] <= new_PC;
                Bank[SP_index] <= (control==2)? MAX_NUMBER: new_stack_pointer;

                case (control)
                    1:begin //RD=ALU_result
                        if(register_Dest != 4'hf && register_Dest!=4'he)begin
                            Bank[register_Dest] <= ALU_result;
                        end
                    end
                    2:begin
                        Bank[0] <= DATA_AREA_START;
                    end
                    3:begin //RD=data_from_memory
                        if(register_Dest!=4'hf && register_Dest!=4'he)begin
                            Bank[register_Dest] <= data_from_memory;
                        end
                    end
                    4:begin //Enter privileged mode
                        Bank[13] <= Bank[15];  //LR = actual next Instruction address
                    end
                endcase

            end
        end
    end



  endmodule
