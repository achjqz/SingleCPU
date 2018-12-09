module Control_Unit(
	input [5:0]  op,
	input [5:0]  func,
	input        z,
	output       wmem,
	output       wreg,
	output       regrt,
	output       m2reg,
	output [3:0] aluc,
	output       shift,
	output       aluimm,
	output [1:0] pcsource,
	output       jal,
	output       sext			
    );
		
// Register addressing
wire i_add = (op == 6'b000000 & func == 6'b100000)?1:0;
wire i_sub = (op == 6'b000000 & func == 6'b100010)?1:0;
wire i_and = (op == 6'b000000 & func == 6'b100100)?1:0;
wire i_or  = (op == 6'b000000 & func == 6'b100101)?1:0;
wire i_xor = (op == 6'b000000 & func == 6'b100110)?1:0;
wire i_sll = (op == 6'b000000 & func == 6'b000000)?1:0;
wire i_srl = (op == 6'b000000 & func == 6'b000010)?1:0;
wire i_sra = (op == 6'b000000 & func == 6'b000011)?1:0;
wire i_jr  = (op == 6'b000000 & func == 6'b001000)?1:0;
		
//immediate addressing
wire i_addi = (op == 6'b001000)?1:0;
wire i_andi = (op == 6'b001100)?1:0; 
wire i_ori  = (op == 6'b001101)?1:0;
wire i_xori = (op == 6'b001110)?1:0;
wire i_lw   = (op == 6'b100011)?1:0;
wire i_sw   = (op == 6'b101011)?1:0;
wire i_beq  = (op == 6'b000100)?1:0;
wire i_bne  = (op == 6'b000101)?1:0;
wire i_lui  = (op == 6'b001111)?1:0;

wire i_j    = (op == 6'b000010)?1:0;  //   j
wire i_jal  = (op == 6'b000011)?1:0;  // jal
  
//Create control signal
assign wreg  = i_add  | i_sub  | i_and | i_or | i_xor  | 
i_sll | i_srl |i_sra |	i_addi | i_andi | 
i_ori | i_or | i_xori | i_lw  | i_lui |i_jal;
assign regrt  = i_addi | i_andi | i_ori | i_xori |i_lw |i_lui;
assign jal    = i_jal;
assign m2reg  = i_lw;
assign shift  = i_sll | i_srl |i_sra;
assign aluimm = i_addi | i_andi | i_ori | i_xori | i_lw |
 i_lui |i_sw;
assign sext   = i_addi | i_lw | i_sw | i_beq | i_bne;

assign aluc[3] = i_sra;
assign aluc[2] = i_sub |i_or | i_srl | i_sra | i_ori |i_lui;
assign aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori |
 i_beq | i_bne | i_lui;
assign aluc[0] = i_and | i_or | i_sll | i_srl |i_sra |
 i_andi  | i_ori;
assign wmem    = i_sw;
assign pcsource[1] = i_jr | i_j | i_jal;
assign pcsource[0] = i_beq & z | i_bne&~z | i_j | i_jal;
endmodule
