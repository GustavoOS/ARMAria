module Watchdog
#(
    parameter COUNTER_SIZE = 5
)(
    input clock,
    input is_special_mode,
    input is_io,
    output reg interruption
);

    reg [(COUNTER_SIZE - 1) : 0] counter;
    wire reset;
    assign reset = !(is_special_mode || is_io);

    initial begin
        counter = 0;
    end

    always @(posedge clock) begin
        if(reset) begin
            if(counter[(COUNTER_SIZE - 1)])begin
                interruption = 1'b1;
                counter <= 0;
            end else
                counter <= counter + 1;
                interruption = 1'b0;
        end else begin
            counter <= 0;
            interruption = 1'b0;
        end
    end

endmodule
