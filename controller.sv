module controller(input clk, rst, input [11:0] instruction, PCout, input zeroACC, minusACC, nonzeroCY, zeroALU, 
  output reg MemRead, MemWrite, IRWrite, IorD,PCWrite, clrACC, clrCY , ACCWrite, CYWrite, SMAWrite, 
  SNCWrite, SZAWrite, ISZWrite, EAWrite, WriteDst, output reg [1:0] ALUsrcA, ALUscrB, PCsrc, EAsrc, 
  output reg [2:0] ALUop);
  
  wire [2:0] opcode = instruction[11:9];
  wire IB_G0 = instruction[8];
  wire PB_G0 = instruction[7];
  
  wire ROT_G1 = instruction[1];
  
  wire [7:0] GROUP12 = {instruction[8:2], instruction[0]};
  
  wire [2:0] GROUP2 = instruction[7:5];
  
  parameter[2:0] ADD_op = 3'd0, AND_op = 3'd1, CMA_op = 3'd2, CMC_op = 3'd3, RAR1_op = 3'd4, 
    RAL1_op = 3'd5, RAR2_op = 3'd6, RAL2_op = 3'd7;
  
  parameter[6:0] SKIP_G2 = 8'b10000000, CLA_G1 = 8'b1000000, CLC_G1 = 8'b100000, CMA_G1 = 8'b10000, 
  CMC_G1 = 8'b1000, RAR_G1 = 8'b100, RAL_G1 = 8'b10, IAC_G1 = 8'b1;
  
  parameter[2:0] SMA_G2 = 3'b100, SZA_G2 = 3'b10, SNC_G2 = 3'b1; 
  
  parameter[2:0] AND_G0 = 3'd0, ADD_G0 = 3'd1, ISZ_G0 = 3'd2 , DCA_G0 = 3'd3, JMP_G0 = 3'd4, JMS_G0 = 3'd5;  
  
  reg[5:0] ns, ps;
  parameter[5:0] IF = 6'd0, ID = 6'd1, DUMMY0 = 6'd2 , CLC = 6'd3, CLA = 6'd4, IAC = 6'd5,  
  IAC1 = 6'd6, CMA = 6'd7, CMA1 = 6'd8, CMC = 6'd9, CMC1 = 6'd10, RAR1 = 6'd11, RAR11 = 6'd12, 
  RAR2 = 6'd13, RAR21 = 6'd14, RAL1 = 6'd15, RAL11 = 6'd16, RAL2 = 6'd17, RAL21 = 6'd18, 
  SKIP = 6'd19, SMA = 6'd20, SZA = 6'd21, SNC = 6'd22, PB1 = 6'd23, PB0 = 6'd24, INDRC = 6'd25, 
  DRC = 6'd26, JMP = 6'd27, ISZ = 6'd28, ISZ1 = 6'd29, ISZ2= 6'd30, ISZ3= 6'd31, ADD = 6'd32, 
  AND = 6'd33,  AND1 = 6'd34, DCA = 6'd35, DCA1 = 6'd36, DUMMY12 = 6'd37, IB1 = 6'd38, 
  IB0 = 6'd39, ADD1 = 6'd40, JMS = 6'd41, JMS1 = 6'd42, JMS2 = 6'd43, IB10 = 6'd44, HALT = 6'd45;
  
  
  always@(ps)begin  
    ns = 6'b0;
    case(ps)   
      IF : ns = (PCout == 4095) ? HALT: ID;
      ID : ns = (opcode == 3'b111) ? DUMMY12 : DUMMY0;
      
      DUMMY12 : case(GROUP12)
                  //SKIP_G2 : ns = SKIP;
                  CLA_G1 : ns = CLA;
                  CLC_G1 : ns = CLC;
                  CMA_G1 : ns = CMA;
                  CMC_G1 : ns = CMC;
                  RAR_G1 : ns = (ROT_G1 == 1) ? RAR2 : RAR1;
                  RAL_G1 : ns = (ROT_G1 == 1) ? RAL2 : RAL1; 
                  IAC_G1 : ns = IAC;
                  default : ns = SKIP;
                  endcase
                  
      IAC : ns = IAC1;
      IAC1 : ns = IF;
      CLA : ns = IF;
      CLC : ns = IF;
      CMA : ns = CMA1;
      CMA1 : ns = IF;
      CMC : ns = CMC1; 
      CMC1 : ns = IF;
      RAR1 : ns = RAR11;
      RAR11 : ns = IF;
      RAR2 : ns = RAR21;
      RAR21 : ns = IF;
      RAL1 : ns = RAL11;
      RAL11 : ns = IF;
      RAL2 : ns = RAL21;
      RAL21 : ns = IF;
      
      SKIP : case(GROUP2)
              SMA_G2 : ns = SMA;
              SZA_G2 : ns = SZA;
              SNC_G2 : ns = SNC;
              endcase
              
      SMA : ns = IF;
      SZA : ns = IF;
      SNC : ns = IF;
        
      DUMMY0 : ns = (PB_G0 == 1) ? PB1 : PB0;  
      PB0 : ns = (IB_G0 == 1) ? IB10 : IB0;
      PB1 : ns = (IB_G0 == 1) ? IB10 : IB0;
      DCA : ns = DCA1;   
      DCA1 : ns = IF;
      AND : ns = AND1;
      AND1 : ns = IF;
      IB10 : ns = IB1;
      IB1 : ns = IB0;
      
      IB0 : case(opcode)
              AND_G0 : ns = AND;
              ADD_G0 : ns = ADD;
              ISZ_G0 : ns = ISZ;
              DCA_G0 : ns = DCA;
              JMP_G0 : ns = JMP;
              JMS_G0 : ns = JMS;
              endcase
            
      JMP : ns = IF;
      JMS : ns = JMS1;
      JMS1 : ns = JMS2;
      JMS2 : ns = IF;
      ISZ : ns = ISZ1;
      ISZ1 : ns = (zeroALU == 1) ? ISZ2 : IF;
      ISZ2 : ns = ISZ3;
      ISZ3 : ns = IF;
      ADD : ns = ADD1;
      ADD1 : ns = IF;
      default : ns = HALT;
      
    endcase
    
  end
  
  always@(ps)begin  
    MemRead = 0; MemWrite = 0; IRWrite = 0; IorD = 0; PCWrite = 0; clrACC = 0; clrCY = 0; 
    ACCWrite = 0; CYWrite = 0; SMAWrite = 0; SNCWrite = 0; SZAWrite = 0; ISZWrite = 0; 
    EAWrite = 0; WriteDst = 0; ALUsrcA = 2'b0; ALUscrB = 2'b0; PCsrc = 2'b0; EAsrc = 2'b0;
    ALUop = 3'b0;
    case(ps)   
      IF :begin IorD = 0; MemRead = 1; IRWrite = 1; ALUop = ADD_op; ALUsrcA = 2; ALUscrB = 0; PCWrite = 1;  PCsrc = 0; end
      ID :begin IorD = 1; end
      IAC : begin ALUsrcA = 0; ALUscrB = 0; ALUop = ADD_op; end
      IAC1 : begin ACCWrite = 1; end
      CLA : begin clrACC = 1; end
      CLC : clrCY = 1;
      CMA : begin ALUsrcA = 0; ALUop = CMA_op; end
      CMA1 : begin ACCWrite = 1; end
      CMC : begin ALUop = CMC_op; end
      CMC1 : begin CYWrite = 1'b1; end
      RAR1 : begin ALUop = RAR1_op; ALUsrcA = 1'b0; end
      RAR11 : begin ACCWrite = 1; CYWrite = 1; end
      RAR2 : begin ALUop = RAR2_op; ALUsrcA = 1'b0; end
      RAR21 : begin ACCWrite = 1; CYWrite = 1; end
      RAL1 : begin ALUop = RAL1_op; ALUsrcA = 2'b0; end
      RAL11 : begin ACCWrite = 1; CYWrite = 1; end
      RAL2 : begin ALUop = RAL2_op; ALUsrcA = 1'b0; end
      RAL21 : begin ACCWrite = 1; CYWrite = 1; end
      
      SKIP : begin ALUsrcA = 2; ALUscrB = 1; ALUop = ADD_op; end
      SMA : begin SMAWrite = 1; PCsrc = 1; end
      SZA : begin SZAWrite = 1; PCsrc = 1; end
      SNC : begin SNCWrite = 1; PCsrc = 1; end
        
      PB0 : begin EAsrc = 1; EAWrite = 1; end
      PB1 : begin EAsrc = 0; EAWrite = 1; end
      DCA : begin WriteDst = 1; MemWrite = 1; IorD = 1;end    
      DCA1 : begin clrACC = 1; end
      AND : begin ALUsrcA = 0; ALUscrB = 2; ALUop = AND_op; end 
      AND1 : begin ACCWrite = 1; end
      IB1 : begin EAsrc = 2; EAWrite = 1; end
      IB0 : begin IorD = 1; MemRead = 1; end
      IB10 : begin IorD = 1; MemRead = 1; end
      JMP : begin PCsrc = 2; PCWrite = 1; end
      JMS : begin ALUsrcA = 2; ALUscrB = 0; ALUop = ADD_op; end
      JMS1 : begin IorD = 1; WriteDst = 0; MemWrite = 1; ALUsrcA = 3; ALUscrB = 0 ; ALUop = ADD_op; end
      JMS2 : begin PCsrc = 1; PCWrite = 1; end
      ISZ : begin ALUsrcA = 1; ALUscrB = 0; ALUop = ADD_op; end 
      ISZ1 : begin WriteDst = 0; MemWrite = 1; IorD = 1; end 
      ISZ2 : begin ALUsrcA = 2; ALUscrB = 1; ALUop = ADD_op; end
      ISZ3 : begin ISZWrite = 1; PCsrc = 1; end
      ADD : begin ALUsrcA = 0; ALUscrB = 2; ALUop = ADD_op; end
      ADD1 : begin ACCWrite = 1; CYWrite = 1; end
      default : begin MemRead = 0; MemWrite = 0; IRWrite = 0; IorD = 0; PCWrite = 0; clrACC = 0; clrCY = 0; 
                      ACCWrite = 0; CYWrite = 0; SMAWrite = 0; SNCWrite = 0; SZAWrite = 0; ISZWrite = 0; 
                      EAWrite = 0; WriteDst = 0; ALUsrcA = 2'b0; ALUscrB = 2'b0; PCsrc = 2'b0; EAsrc = 2'b0;
                      ALUop = 3'b0; end
                      
    endcase
    
  end
  
  always@(posedge clk, posedge rst) begin
    if(rst)
      ps <= 6'b0;
    else if(clk)
      ps <= ns;
  end
   
endmodule 
