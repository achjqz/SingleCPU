module MUX2X5(A0, A1, S, Y);
	input [4:0] A0;
	input [4:0] A1;
	input S;
	output [4:0] Y;
	assign Y = S? A1 : A0; 
endmodule
