module CY(input clk, rst, clr, input CYWrite, input dataIn, output reg CYout);
  always@(posedge clk, posedge rst) begin
    if(rst)
      CYout <= 1'b0;
    else
      if(CYWrite)
        CYout <= dataIn;
      else if(clr)
        CYout <= 1'b0;
      else
        CYout <= CYout;
  end
endmodule
