module IR(input clk, rst, input IRWrite, input [11:0] dataIn, output reg [11:0] IRout);
  always@(posedge clk, posedge rst) begin
    if(rst)
      IRout <= 12'b0;
    else
      if(IRWrite)
        IRout <= dataIn;
      else
        IRout <= IRout;
  end
endmodule
