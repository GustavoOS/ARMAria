module Watchdog
#(
    parameter COUNTER_SIZE = 12
)(
    input slow_clock, fast_clock,
    input user_interruption_button,
    output reg [1 : 0] interruption
);

    reg [(COUNTER_SIZE - 1) : 0] counter;

    always @(posedge slow_clock) begin
        if (counter[(COUNTER_SIZE - 1)]) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    always @(posedge fast_clock ) begin
        interruption[0] <= counter[(COUNTER_SIZE -1)];
        interruption[1] <= user_interruption_button;
    end

endmodule
