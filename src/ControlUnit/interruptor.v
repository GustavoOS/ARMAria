module Interruptor #(
    parameter ID_WIDTH = 7,
    parameter OFFSET_WIDTH = 12
)(
    input [(ID_WIDTH - 1) : 0] decoded_id,
    input [(OFFSET_WIDTH - 1) : 0] decoded_offset,
    input [1 : 0] interruption, // [1] user [0] watchdog
    input is_special,
    output [(ID_WIDTH - 1) : 0] actual_id,
    output [(OFFSET_WIDTH - 1) : 0] actual_offset
);
    wire [(ID_WIDTH - 1) : 0] id;
    wire [(OFFSET_WIDTH - 1) : 0] offset;
    assign id = (interruption[1] || interruption[0]) ? 7'd72 : decoded_id;
    assign offset = interruption[1] ? 12'd3 : 
        (interruption[0] ? 12'd0 : decoded_offset);

    assign actual_id = is_special ? decoded_id : id;
    assign actual_offset = is_special ? decoded_offset : offset;

endmodule
