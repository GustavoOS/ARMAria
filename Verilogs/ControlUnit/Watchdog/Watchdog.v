module Watchdog
#(
    parameter COUNTER_SIZE = 4
)(
    input clock,
    input is_Bios, is_kernel,
    input enable,
    output interruption
);

    reg [(COUNTER_SIZE - 1) : 0] counter;
    assign interruption = counter[(COUNTER_SIZE - 1)];

    initial begin
        counter = 0;
    end

    always @(posedge clock) begin
        if(enable) begin
            if(is_Bios || is_kernel)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    end

endmodule
