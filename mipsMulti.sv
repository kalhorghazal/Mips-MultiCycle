`timescale 1ns/1ns
module MIPS(input clk, rst);

wire MemRead, MemWrite, IorD, WriteDst, IRWrite, PCWrite, ACCWrite, 
clrACC, clrCY, EAWrite, CYWrite, SMAWrite, SZAWrite, SNCWrite, ISZWrite,
zeroACC, minusACC, nonzeroCY, zeroALU;
wire [1:0] PCsrc, ALUsrcA, ALUscrB, EAsrc;
wire [2:0] ALUop;
wire [11:0] instruction, PCout;

DataPath DP(clk, rst, MemRead, MemWrite, IorD, WriteDst, IRWrite, PCWrite, ACCWrite, 
  clrACC, clrCY, EAWrite, CYWrite, SMAWrite, SZAWrite, SNCWrite, ISZWrite, PCsrc, ALUsrcA, 
  ALUscrB, EAsrc, ALUop, zeroACC, minusACC, nonzeroCY, zeroALU, instruction, PCout);
  
controller CU(clk, rst, instruction, PCout, zeroACC, minusACC, nonzeroCY, zeroALU, 
  MemRead, MemWrite, IRWrite, IorD,PCWrite, clrACC, clrCY , ACCWrite, CYWrite, SMAWrite, 
  SNCWrite, SZAWrite, ISZWrite, EAWrite, WriteDst, ALUsrcA, ALUscrB, PCsrc, EAsrc, ALUop);

endmodule
