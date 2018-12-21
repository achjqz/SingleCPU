module DATAMEM(Clk, dataout, datain, addr, we);
	input Clk, we;
	input [31:0] datain, addr;
	output [31:0] dataout;
	reg [31:0] Ram [0:31];
	
	assign dataout = Ram[addr[6:2]];
	always @ (posedge Clk) begin
		if (we) Ram[addr[6:2]] = datain;
	end

	integer i;
	initial begin
		for (i = 0 ; i <= 31 ; i = i + 1) Ram [i] = 0;
	end		
	
endmodule
