module Mainboard(
	input Clock,
	input Reset,
	input mem_clk,
	output[31:0] inst,
	output[31:0] pc,
	output[31:0] aluout,
	output[31:0] memout
    );
	wire [31:0] data;
	wire        wmem;	
	Data_flow CPU (Clock , Reset , inst , memout , pc , wmem , aluout ,data);
    Inst_mem imem(pc , inst);
	Data_mem dmem(Clock , memout , data , aluout , wmem , Clock , Clock);
endmodule
