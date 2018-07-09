module RegBank
#(
    parameter DATA_AREA_START = 8192,
    parameter REGISTER_LENGTH = 32,
    parameter MAX_NUMBER = 32'hffffffff,
    parameter ADDR_WIDTH = 14
)(
    input   privileged_mode, enable, reset, clock,
    input   [2:0]   control, 
    input   [3:0]   register_source_A, register_source_B, register_Dest,
    input   [REGISTER_LENGTH -1:0]  ALU_result, data_from_memory,
    input   [REGISTER_LENGTH -1:0]  new_SP,
    input   [ADDR_WIDTH - 1:0] new_PC,
    output  [REGISTER_LENGTH -1:0]  read_data_A, read_data_B,
    output  [REGISTER_LENGTH -1:0]  current_PC, current_SP, memory_output
);

    reg [REGISTER_LENGTH -1:0] Bank [16:0];
    reg [REGISTER_LENGTH - 1:0] Buffer;
    reg [3:0] stored_register;
    reg past_by_load;

    wire [REGISTER_LENGTH - ADDR_WIDTH - 1:0] zeros;
    assign zeros = 0;

    wire [4:0] SP_index;
    wire RD_isnt_special;

    assign SP_index = privileged_mode ? 16 : 14;
    assign current_SP = Bank[SP_index];
    assign read_data_A = (register_source_A==14) ? current_SP : Bank[register_source_A];
    assign read_data_B = (register_source_B==14)? current_SP : Bank[register_source_B];
    assign memory_output = (register_Dest==14)? current_SP : Bank[register_Dest];
    assign current_PC = Bank[15];
    assign RD_isnt_special = register_Dest != 15 && register_Dest!= 14;

    initial begin
        Bank[0] = DATA_AREA_START;
        Bank[14] = MAX_NUMBER;//User Stack
        Bank[15] = 1;  //PC
        Bank[16] = MAX_NUMBER; //Privileged Stack
        past_by_load = 0;
        stored_register = 0;
    end

    always @ (posedge clock) begin
        Buffer <= data_from_memory;
        
    end


    always @ (negedge clock) begin
        if (reset) begin
            Bank[0] <= DATA_AREA_START;
            Bank[14] <= MAX_NUMBER;//User Stack
            Bank[15] <= {zeros, new_PC};  //PC = 1 due to Memory Address Handler
            Bank[16] <= MAX_NUMBER; //Privileged Stack
            past_by_load = 0;
            stored_register = 0;
        end else begin
            if (enable) begin

                Bank[15] <= {zeros, new_PC};
                Bank[SP_index] <= (control==2)? MAX_NUMBER: new_SP;

                case (control)
                    1:begin //RD=ALU_result
                        if(RD_isnt_special) begin
                            Bank[register_Dest] <= ALU_result;
                        end
                    end
                    2:begin
                        Bank[0] <= DATA_AREA_START;
                    end
                    3:begin //RD=data_from_memory
                        if(RD_isnt_special)begin
                            // Bank[register_Dest] <= data_from_memory;
                            stored_register <= register_Dest;
                            past_by_load <= 1;
                        end
                    end
                    4:begin //Enter privileged mode
                        Bank[13] <= Bank[15];  //LR = actual next Instruction address
                    end
                    5:begin
                      if(past_by_load) begin
                        Bank[stored_register] <= Buffer;
                        past_by_load <= 0;
                      end
                    end
                    6:begin
                        if(RD_isnt_special)begin
                            Bank[register_Dest] <= data_from_memory;
                        end
                    end
                endcase

            end
        end
    end



  endmodule
