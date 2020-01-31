module TB();
 reg clk = 0;
 reg rst = 0;
 
 MIPS mips(clk,rst);
 
 initial begin
        forever #10 clk = ~clk;
    end
 
 initial begin
  #15 rst = 1;
  #17 rst = 0;
 end
 
endmodule
