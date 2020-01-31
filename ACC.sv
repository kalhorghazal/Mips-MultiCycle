module ACC(input clk, rst, clr, input ACCWrite, input [11:0] dataIn, output reg [11:0] ACCout);
  always@(posedge clk, posedge rst) begin
    if(rst)
      ACCout <= 12'b0;
    else
      if(ACCWrite)
        ACCout <= dataIn;
      else if(clr)
        ACCout <= 12'b0;
      else
        ACCout <= ACCout;
  end
endmodule
