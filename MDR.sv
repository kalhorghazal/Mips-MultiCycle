module MDR(input clk, rst, input [11:0] dataIn, output reg [11:0] MDRout);
  always@(posedge clk, posedge rst) begin
    if(rst)
      MDRout <= 12'b0;
    else if(clk)
      MDRout <= dataIn;
  end
endmodule
