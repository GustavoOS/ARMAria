module Incrementor #(
    parameter PACE = 1,
    parameter DATA_WIDTH = 32,
    parameter MAX_NUMBER = (2**DATA_WIDTH) -1
)(
    input [2:0] control,
    input [31:0] input_address, new_address,
    output reg [31:0]  output_address
);

always @ ( * ) begin
    case (control)
        1:begin
            output_address = input_address + PACE;
        end
        2:begin
            output_address = input_address - PACE;
        end
        3:begin
            output_address = MAX_NUMBER;
        end
        4:begin
            output_address = new_address; 
        end       
        default: begin
            output_address = input_address;
        end
    endcase    
end
    
endmodule