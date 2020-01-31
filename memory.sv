module Memory(input MemRead, MemWrite, input [11:0] Address, WriteData,
  output reg [11:0] ReadData);
	   reg [11:0] Memory[0:4095];
	
	   initial begin
	     Memory[1000] <= 1;
	     Memory[1001] <= 2;
	     Memory[1002] <= 3;
	     Memory[1003] <= 4;
	     Memory[1004] <= 5;
	     Memory[1005] <= 6;
	     Memory[1006] <= 7;
	     Memory[1007] <= 8;
	     Memory[1008] <= 9;
	     Memory[1009] <= 10;
	   end
	   
	   initial begin
	     Memory[2000] <= 11;
	     Memory[2001] <= 12;
	     Memory[2002] <= 13;
	     Memory[2003] <= 14;
	     Memory[2004] <= 15;
	     Memory[2005] <= 16;
	     Memory[2006] <= 17;
	     Memory[2007] <= 18;
	     Memory[2008] <= 19;
	     Memory[2009] <= 20;
	   end
	   
	   initial begin
	     Memory[40] <= 12'b1111101000; //X
	     Memory[41] <= 12'b11111010000; //Y
	     Memory[42] <= 12'b101110111000; //Z
	     Memory[43] <= -10; //W
	   end
	   
	   initial begin
	     //Instructions
	     Memory[0] <= {3'b111, 1'b0, 1'b1, 7'b0}; //CLA
	     Memory[1] <= 12'b0; //LOOP
	     Memory[2] <= {3'd1, 1'd1, 1'd0, 7'd40}; //ADD (X) indirect 
	     Memory[3] <= {3'd1, 1'd1, 1'd0, 7'd41}; //ADD (Y) indirect
	     Memory[4] <= {3'd3, 1'd1, 1'd0, 7'd42}; //DCA (Z) indirect
	     Memory[5] <= {3'd2, 1'd0, 1'd0, 7'd40}; //ISZ (X) direct
	     Memory[6] <= {3'd2, 1'd0, 1'd0, 7'd41}; //ISZ (Y) direct
	     Memory[7] <= {3'd2, 1'd0, 1'd0, 7'd42}; //ISZ (Z) direct
	     Memory[8] <= {3'd2, 1'd0, 1'd0, 7'd43}; //ISZ (W) direct
	     Memory[9] <= {3'b100, 1'b0, 1'b0, 7'b1}; //jump LOOP
	     Memory[0] <= 12'b0; //EXIT
	   end
	   
	   always @ (MemWrite) begin
		    if (MemWrite == 1)
			     Memory[Address] <= WriteData;
	   end

	   always @(MemRead) begin
		    if (MemRead == 1)
			     ReadData <= Memory[Address];
	   end
	   
endmodule
