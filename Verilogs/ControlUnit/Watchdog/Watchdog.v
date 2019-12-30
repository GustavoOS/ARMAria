module Watchdog
#(
    parameter INTERRUPTION_SIZE = 2,
    parameter COUNTER_SIZE = 4
)(
    input clock,
    input is_Bios, is_kernel,
    input is_input, is_output,
    input is_user_request,
    output reg [(INTERRUPTION_SIZE - 1) : 0] interruption
);

    reg [(COUNTER_SIZE - 1) : 0] counter;

    initial begin
        counter = 0;
    end
    always @(clock) begin
        if(is_Bios || is_kernel || is_input || is_output)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    always @(*) begin
        if(is_user_request)
            interruption = 1; // User interruption
        else
            // Automatic interruption
            interruption = counter[(COUNTER_SIZE - 1)] ? 2 : 0;
    end

endmodule
