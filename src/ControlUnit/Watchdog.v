module Watchdog
#(
    parameter COUNTER_SIZE = 5
)(
    input clock,
    input reset,
    output wire interruption
);

    reg [(COUNTER_SIZE - 1) : 0] counter;

    initial begin
        counter = 0;
    end

    assign interruption = counter[(COUNTER_SIZE - 1)];

    always @(posedge clock) begin
        if (reset) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
