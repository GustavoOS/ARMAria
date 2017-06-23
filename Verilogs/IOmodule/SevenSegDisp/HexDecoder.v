module HexDecoder(
  number,
  display
  );
  input [3:0] number;
  output reg [6:0] display;

  always @ ( * ) begin
    case(number)
      0:begin
        display = 7'h40;
      end
      1:begin
        display = 7'h79;
      end
      2:begin
        display = 7'h24;
      end
      3:begin
        display = 7'h30;
      end
      4: begin
        display = 7'h19;
      end
      5:begin
        display = 7'h11;
      end
      6:begin
        display = 7'h2;
      end
      7:begin
        display = 7'h78;
      end
      8:begin
        display = 7'h0;
      end
      9:begin
        display = 7'h10;
      end
      10:begin
        display = 7'h8;
      end
      11:begin
        display = 7'h3;
      end
      12:begin
        display = 7'h46;
      end
      13:begin
        display = 7'h21;
      end
      14:begin
        display = 7'h6;
      end
      15:begin
        display = 7'he;
      end
      default:begin
        display = 7'h7f;
      end
	 endcase
  end

endmodule
