module Data_mem(
		input        Clock,
		output[31:0] dataout,
		input [31:0] datain,
		input [31:0] addr,
		input        we,
		input        inclk,
		input        outclk 
    );

	reg [31:0] ram [0:31];
	
	assign dataout = ram[addr[6:2]];
	
	always @ (posedge Clock) begin
			if (we) ram[addr[6:2]] = datain;
	end

	integer i;
	
	initial begin
			for ( i = 0 ; i <= 31 ; i = i + 1) ram [i] = i * i;
	end		
	
endmodule
