module ALU
#(
    parameter DATA_WIDTH = 32
)(
    input [DATA_WIDTH - 1:0] channel_A, channel_B,
    output reg [DATA_WIDTH - 1:0] operation_result,
    input [3:0] control,
    input previous_specreg_carry,
    output reg Negative_ALU_flag,
    output Zero_ALU_flag, 
    output reg Carry_ALU_flag, oVerflow_ALU_flag
);
    // Declaration section
    wire [DATA_WIDTH - 1:0] channel_B_negative;
    wire most_significant_bit, local_overflow, channel_A_msb, channel_B_msb;
    reg use_negative_B;

    // Z Flag
    assign Zero_ALU_flag = (operation_result == 0);

    
    // OVERFLOW Flag calculation    
    assign most_significant_bit = operation_result[DATA_WIDTH - 1];
    assign channel_A_msb = channel_A[DATA_WIDTH -1];
    assign channel_B_negative = - channel_B;
    assign channel_B_msb = use_negative_B ? channel_B_negative[DATA_WIDTH - 1] :
                                            channel_B[DATA_WIDTH -1];
    assign local_overflow =   most_significant_bit ?    !(channel_A_msb || channel_B_msb) :
                                                        channel_A_msb && channel_B_msb;

    // ALU Implementation
    always @ ( * ) begin

        // Default values that might be overriden
        Negative_ALU_flag = 0;
        Carry_ALU_flag = 0;
        oVerflow_ALU_flag = 0;

        use_negative_B = 0;
        operation_result = 0;

        // Controlled operations
        case (control)
            1:  // ADD + previous_specreg_carry
            begin 
                {Carry_ALU_flag, operation_result} =  channel_A + channel_B + previous_specreg_carry;
                oVerflow_ALU_flag = local_overflow;
                Negative_ALU_flag =  most_significant_bit;
            end

            2:  // ADD
            begin 
                {Carry_ALU_flag, operation_result} =  channel_A + channel_B;
                oVerflow_ALU_flag = local_overflow;
                Negative_ALU_flag =  most_significant_bit;
            end

            3:  // AND
            begin 
                operation_result = channel_A & channel_B;
                Negative_ALU_flag =  most_significant_bit;
            end

            4:  // BIC
            begin 
                operation_result = channel_A & (~channel_B);
                Negative_ALU_flag =  most_significant_bit;
            end

            5:  // SUB or CMP
            begin 
                use_negative_B = 1;
                {Carry_ALU_flag, operation_result} =  channel_A + channel_B_negative;
                oVerflow_ALU_flag = local_overflow;
                Negative_ALU_flag =  most_significant_bit;
            end

            6:  // NEG
            begin
                {Carry_ALU_flag, operation_result} =  - channel_A;
                oVerflow_ALU_flag = local_overflow;
                Negative_ALU_flag =  most_significant_bit;
            end

            7:  // OR
            begin
                operation_result = channel_A | channel_B;
                Negative_ALU_flag =  most_significant_bit;
            end

            8:  // SBC
            begin
                {Carry_ALU_flag, operation_result} =  channel_A - channel_B - ~previous_specreg_carry;
                oVerflow_ALU_flag = local_overflow;
                Negative_ALU_flag =  most_significant_bit;
            end

            9:  // MULTIPLY
            begin
                operation_result = channel_A * channel_B;
                Negative_ALU_flag  =  most_significant_bit;
            end

            10: // DIV
            begin 
                oVerflow_ALU_flag = (channel_B == 0);
                operation_result = (oVerflow_ALU_flag) ? 0 : channel_A / channel_B;
            end

            11: // MOD
            begin
                oVerflow_ALU_flag  = (channel_B == 0);
                operation_result = (oVerflow_ALU_flag) ? 0 : channel_A % channel_B;
            end

            12: // BarrelShifter
            begin
                operation_result = channel_B;
            end
            13: // XOR
            begin
                operation_result = channel_A ^ channel_B;
                Negative_ALU_flag =  most_significant_bit;
            end
            14: // LOGICAL AND
            begin
                operation_result = channel_A && channel_B;
                Negative_ALU_flag =  most_significant_bit;
            end

            default:    // channel_A is OUTPUT
            begin 
                operation_result = channel_A;
                Negative_ALU_flag = most_significant_bit;
            end
        endcase
    end

endmodule
