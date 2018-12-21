module Main(Clk, Clrn, inst, addr, aluout, memout);
	input Clk, Clrn;
	output [31:0] inst, addr, aluout, memout;
	wire [31:0] data;
	wire        wmem;	
	INSTMEM imem(addr, inst);
	CPU cpu (Clk, Clrn, inst, memout, addr, wmem, aluout, data);
	DATAMEM dmem(Clk, memout, data, aluout, wmem);
endmodule
