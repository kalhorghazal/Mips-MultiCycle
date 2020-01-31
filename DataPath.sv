module DataPath(input clk, rst, input MemRead, MemWrite, IorD, WriteDst, IRWrite, PCWrite, ACCWrite, 
  clrACC, clrCY, EAWrite, CYWrite, SMAWrite, SZAWrite, SNCWrite, ISZWrite, input [1:0] PCsrc, ALUsrcA, 
  ALUsrcB, EAsrc, input [2:0] ALUop, output zeroACC, minusACC, nonzeroCY, zeroALU, 
  output [11:0] instruction, PCOut);

  wire [11:0] Address, EAout, WriteData, ALUout, ACCout, ReadData, IRout, MDRout, PCin, EAin, PCout, zeroPage, curPage, A, B, ALUresult;
  wire CYin, CYout, PCWriteFinal, CarryOut;
  assign zeroPage = {5'b0, IRout[6:0]};
  assign curPage = {PCout[11:7], IRout[6:0]};
  assign zeroACC = {ACCout == 12'b0};
  assign minusACC = {ACCout[11] == 1'b1};
  assign nonzeroCY = {CYout == 1'b1};
  assign PCWriteFinal = (PCWrite | (minusACC & SMAWrite) | (SNCWrite & nonzeroCY) | (SZAWrite & zeroACC) | (ISZWrite & zeroALU));
  assign instruction = IRout;
  assign PCOut = PCout;
  Memory my_memory(MemRead, MemWrite, Address, WriteData, ReadData);
  Mux2to1 my_mux1(PCout, EAout, IorD , Address);
  Mux2to1 my_mux2(ALUout, ACCout, WriteDst, WriteData);
  IR my_IR(clk, rst, IRWrite, ReadData, IRout);
  MDR my_MDR(clk, rst, ReadData, MDRout);
  PC my_PC(clk, rst, PCWriteFinal, PCin, PCout);
  Mux3to1 my_mux3(ALUresult, ALUout, EAout, PCsrc, PCin);
  EA my_EA(clk, rst, EAWrite, EAin, EAout);
  Mux3to1 my_mux4(curPage, zeroPage, MDRout, EAsrc, EAin);
  Mux4to1 my_mux5(ACCout, MDRout, PCout, EAout, ALUsrcA, A);
  Mux3to1 my_mux6(12'b1, 12'b10, MDRout, ALUsrcB, B);
  ALU my_ALU(ALUop, A, B, CYout, ALUresult, zeroALU, CYin);
  CY my_CY(clk, rst, clrCY, CYWrite, CarryOut, CYout);
  ACC my_ACC(clk, rst, clrACC, ACCWrite, ALUout, ACCout);
  ALUOut my_ALUOut(clk, rst, ALUresult, ALUout);
  CarryOut my_CarryOut(clk, rst, CYin, CarryOut);
endmodule
