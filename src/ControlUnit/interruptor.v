module Interruptor #(
    parameter ID_WIDTH = 7,
    parameter OFFSET_WIDTH = 12
)(
    input [(ID_WIDTH - 1) : 0] decoded_id,
    input [(OFFSET_WIDTH - 1) : 0] decoded_offset,
    input user_interruption, watchdog_interruption,
    output [(ID_WIDTH - 1) : 0] actual_id,
    output [(OFFSET_WIDTH - 1) : 0] actual_offset
);
    assign actual_id = (user_interruption || watchdog_interruption) ? 7'd72 : decoded_id;
    assign actual_offset = user_interruption ? 12'd3 : (watchdog_interruption ? 12'd0 : decoded_offset);

endmodule
