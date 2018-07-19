module SpecReg(
    input clock, reset, enable,
    input [2:0] update_mode,
    output negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag,
    input alu_negative, alu_zero, alu_carry, alu_overflow,
    input bs_negative, bs_zero, bs_carry
);

    reg [4:0] SPECREG;

    assign {negative_flag, zero_flag, carry_flag, overflow_flag, mode_flag} = enable ? SPECREG : 5'h1f;

    initial begin
        SPECREG <= 0;
    end



    always @ ( negedge clock ) begin
        if (reset) begin
            SPECREG <= 0;
        end else begin
            if(enable)
            begin
                case (update_mode)
                    1: begin
                        SPECREG [4:2] <= {bs_negative, bs_zero, bs_carry};
                    end

                    2: begin  //ADD
                        SPECREG[4:1] <= {alu_negative, alu_zero, alu_carry, alu_overflow};
                    end
                    
                    3: begin  //MOV
                        SPECREG[4:3] <= {alu_negative, alu_zero};
                    end
                    
                    4: begin
                        SPECREG[1] <= alu_overflow;
                    end

                    5: begin//SWI
                        SPECREG[0] <= !SPECREG[0];
                    end
                   
                endcase
            end
        end

    end








endmodule
