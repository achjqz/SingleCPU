module addsub32(A, B, sub, Result);
	input [31:0] A, B;
	input sub;
	output[31:0] Result;
	cla32 as32(A , B^{32{sub}} , sub , Result); 
endmodule

module cla32(a, b, c, s);
	input [31:0] a, b;
	input c;
	output[31:0] s;
	assign s = a + b + c; 
endmodule
