module PC(input clk, rst, input PCWrite, input  [11:0] PCin, output reg [11:0]PCout);
	always @(posedge clk, posedge rst) begin
		if (rst == 1)
			PCout <= 12'b0;
		else
		  if(PCWrite)
			  PCout <= PCin ;
			else
			  PCout <= PCout ;
	end
endmodule
