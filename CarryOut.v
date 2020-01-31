module CarryOut(input clk, rst, input dataIn, output reg CarryOut);
  always@(posedge clk, posedge rst) begin
    if(rst)
      CarryOut <= 1'b0;
    else if(clk)
      CarryOut <= dataIn;
  end
endmodule
