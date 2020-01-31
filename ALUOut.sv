module ALUOut(input clk, rst, input [11:0] dataIn, output reg [11:0] AluOut);
  always@(posedge clk, posedge rst) begin
    if(rst)
      AluOut <= 12'b0;
    else if(clk)
      AluOut <= dataIn;
  end
endmodule
