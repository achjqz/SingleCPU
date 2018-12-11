module Main(Clk, Clrn, inst, pc, aluout, memout);

	input Clk, Clrn;
	output [31:0] inst, pc, aluout, memout;
	wire [31:0] data;
	wire        wmem;	
	CPU cpu (Clk , Clrn , inst , memout , pc , wmem , aluout ,data);
    Inst_mem imem(pc , inst);
	Data_mem dmem(Clk , memout , data , aluout , wmem );
endmodule
