
module Mux2to1( input [11:0] In1 , In2 ,input Sel , output [11:0]Out);
	

	assign Out = (Sel == 1'b0) ? In1 : 
	             (Sel == 1'b1) ? In2 : 12'bx;

endmodule

module Mux3to1( input [11:0] In1 , In2, In3 , input [1:0]Sel , output [11:0]Out);
	

	assign Out = (Sel == 2'b00) ? In1 : 
	             (Sel == 2'b01) ? In2 : 
	             (Sel == 2'b10) ? In3 :12'bx;

endmodule

module Mux4to1( input [11:0] In1 , In2, In3 , In4 , input [1:0]Sel , output [11:0]Out);
	

	assign Out = (Sel == 2'b00) ? In1 : 
	             (Sel == 2'b01) ? In2 : 
	             (Sel == 2'b10) ? In3 : 
	             (Sel == 2'b11) ? In4 : 12'bx;
endmodule
