module ALU(input [2:0] AluOp, input [11:0] A, B, input CarryIn, output reg [11:0] AluOut,output reg Zero, Carry);
  
  parameter[2:0] ADD = 3'd0, AND = 3'd1, CMA = 3'd2, CMC = 3'd3, RAR1 = 3'd4, 
    RAL1 = 3'd5, RAR2 = 3'd6, RAL2 = 3'd7; 
  
  always@(A, B, AluOp)
  begin
    Carry = 1'b0;
    case(AluOp)
      ADD : begin {Carry, AluOut} = A + B;
        if(B == 2)
      $display("%d + %d = %d", A, B, AluOut); end  
      AND : begin AluOut = A & B; end 
      CMA : begin AluOut = ~A; end 
      CMC : begin Carry = ~CarryIn; end 
      RAR1 : begin {Carry, AluOut} = {A[0], CarryIn, A[11:1]}; end 
      RAL1 : begin {Carry, AluOut} = {A[11:0], CarryIn}; end 
      RAR2 : begin {Carry, AluOut} = {A[1], CarryIn, A[11:2], A[0]}; end
      RAL2 : begin {Carry, AluOut} = {A[10:0], CarryIn, A[11]}; end 
    endcase
    Zero = (AluOut == 0 );
  end
endmodule 
