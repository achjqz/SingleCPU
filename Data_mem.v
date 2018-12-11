module Data_mem(Clk, dataout, datain, addr, we);

	input Clk, we;
	input [31:0] datain, addr;
	output [31:0] dataout;
	reg [31:0] ram [0:31];
	
	assign dataout = ram[addr[6:2]];
	always @ (posedge Clk) begin
			if (we) ram[addr[6:2]] = datain;
	end

	integer i;
	
	initial begin
			for ( i = 0 ; i <= 31 ; i = i + 1) ram [i] = i * i;
	end		
	
endmodule
