module FrequencyDivider
#(
    parameter COUNTER_WIDTH = 23,
    parameter MAX_COUNTER_VALUE = 2**COUNTER_WIDTH - 1
)(
    input clock_50mhz,   
    output reg divided_clock
);
    reg [COUNTER_WIDTH-1:0] counter;

    always @ (posedge clock_50mhz) begin
        counter <= counter + 1;
        if (counter == MAX_COUNTER_VALUE) begin
            counter <= 0;
            divided_clock <=  !divided_clock;
        end
    end

endmodule