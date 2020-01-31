module EA(input clk, rst, input EAWrite, input [11:0] dataIn, output reg [11:0] EAout);
  always@(posedge clk, posedge rst) begin
    if(rst)
      EAout <= 12'b0;
    else
      if(EAWrite)
        begin
        EAout <= dataIn;
        $display("%d", dataIn);
      end
      else
        EAout <= EAout;
  end
endmodule
