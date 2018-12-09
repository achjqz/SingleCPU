module addsub32(
		input [31:0] A,
		input [31:0] B,
		input        sub,
		output[31:0] Result
    );
	
	cla32 as32(A , B^{32{sub}} , sub , Result); 

endmodule

module cla32(
		input [31:0] a,
		input [31:0] b,
		input        c,
		output[31:0] s
    );
	 assign s = a + b + c; 
endmodule
