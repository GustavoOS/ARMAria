module debounce(clk, button, debounced);
  input clk, button;
  output debounced;

  wire ff1, ff2;
  wire exclor, cout;
  dflipflop FF1(clk, button, ff1, 1'b1);
  dflipflop FF2(clk, ff1, ff2, 1'b1);
  assign exclor = ff1 ^ ff2;
  counter contador(exclor, clk, cout, cout);
  dflipflop FF3(clk, ff2, debounced, cout);



endmodule




module dflipflop(tclk, tin, tout, ena);
  input tclk, tin, ena;
  output reg tout;

  always @ (posedge tclk) begin
    tout <= (ena==1'b1)? tin: tout;
  end

endmodule





module counter(sclr, cclk, lena, cout );
  input sclr, cclk, lena;
  output reg cout;



  parameter bitlenght = 19;

  reg [bitlenght-1 : 0] counter;
  wire [bitlenght : 0] aux;
  assign aux = counter + 1;

  always @ (posedge cclk) begin
    {cout, counter} <= (lena==1'b0) ? aux : {cout, counter};
  end


endmodule
