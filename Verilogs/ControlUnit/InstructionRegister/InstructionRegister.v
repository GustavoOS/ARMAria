module InstructionRegister(
  clock, PreInstruction, Instruction, reset, enable
  );

  input clock, reset, enable;
  input [15:0] PreInstruction;
  output reg [15:0] Instruction;


  always @ ( posedge clock or posedge reset ) begin
    if (reset==1'b1) begin
      Instruction<= 16'hffff;
    end else begin
      if (enable==1'b1) begin
        Instruction <= (PreInstruction==16'hffff) ? 16'he000 : PreInstruction;//NOP if all bits are set
      end else begin
        Instruction <= 16'he800; //Maintains at HALT
      end
    end
    // Instruction<= reset? 16'hffff : (enable) ? (PreInstruction==16'hffff) ? 16'he000 : PreInstruction : Instruction;//Reset goes to state 73. If it loads the instruction 16'hffff, the register will understand it as a NOP instruction
  end



endmodule
