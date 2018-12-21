module ControlUnit(Op, Func, Z, Wmem, Wreg, Regrt, Reg2reg, Aluc, Shift, Aluqb, Pcsrc, jal, Se);
	
	input [5:0] Op, Func;
	input Z;
	output [3:0] Aluc;
	output [1:0] Pcsrc;
	output Wmem, Wreg, Regrt, Se, Shift, Aluqb, Reg2reg, jal;
		
	// R型指令
	wire i_add = (Op == 6'b000000 & Func == 6'b100000)?1:0;
	wire i_sub = (Op == 6'b000000 & Func == 6'b100010)?1:0;
	wire i_and = (Op == 6'b000000 & Func == 6'b100100)?1:0;
	wire i_or  = (Op == 6'b000000 & Func == 6'b100101)?1:0;
	wire i_xor = (Op == 6'b000000 & Func == 6'b100110)?1:0;
	wire i_sll = (Op == 6'b000000 & Func == 6'b000000)?1:0;
	wire i_srl = (Op == 6'b000000 & Func == 6'b000010)?1:0;
	wire i_sra = (Op == 6'b000000 & Func == 6'b000011)?1:0;
	wire i_jr  = (Op == 6'b000000 & Func == 6'b001000)?1:0;

	// I型指令
	wire i_addi = (Op == 6'b001000)?1:0;
	wire i_andi = (Op == 6'b001100)?1:0; 
	wire i_ori  = (Op == 6'b001101)?1:0;
	wire i_xori = (Op == 6'b001110)?1:0;
	wire i_lw   = (Op == 6'b100011)?1:0;
	wire i_sw   = (Op == 6'b101011)?1:0;
	wire i_beq  = (Op == 6'b000100)?1:0;
	wire i_bne  = (Op == 6'b000101)?1:0;
	wire i_lui  = (Op == 6'b001111)?1:0;

	// J型指令
	wire i_j    = (Op == 6'b000010)?1:0;
	wire i_jal  = (Op == 6'b000011)?1:0; 
	
	assign Wreg  = i_add  | i_sub  | i_and | i_or | i_xor  | 
	i_sll | i_srl |i_sra |	i_addi | i_andi | 
	i_ori | i_or | i_xori | i_lw  | i_lui |i_jal;
	assign Regrt  = i_addi | i_andi | i_ori | i_xori |i_lw |i_lui;
	assign jal = i_jal;
	assign Reg2reg  = i_lw;
	assign Shift  = i_sll | i_srl |i_sra;
	assign Aluqb = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui |i_sw;
	assign Se = i_addi | i_lw | i_sw | i_beq | i_bne;
	assign Aluc[3] = i_sra;
	assign Aluc[2] = i_sub |i_or | i_srl | i_sra | i_ori |i_lui;
	assign Aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori |
	 i_beq | i_bne | i_lui;
	assign Aluc[0] = i_and | i_or | i_sll | i_srl |i_sra |
	 i_andi  | i_ori;
	assign Wmem  = i_sw;
	assign Pcsrc[1] = i_jr | i_j | i_jal;
	assign Pcsrc[0] = i_beq & Z | i_bne&~Z | i_j | i_jal;
endmodule
