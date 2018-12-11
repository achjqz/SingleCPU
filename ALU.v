module ALU(X, Y, Aluc, R, Z);
	input [31:0] X, Y;
	input [3:0] Aluc;
	output wire [31:0] R;
	output wire Z;

	// always @(*) begin
	//   case(Aluc)
	// 	4'b0000: R = X + Y;
	// 	4'b0100: R = X - Y;
	// 	4'b0001: R = X & Y;
	// 	4'b0101: R = X | Y;
	// 	4'b0010: R = X ^ Y;
	// 	4'b0011: 
	// end
	wire [31:0] d_and = X & Y;
	wire [31:0] d_or  = X | Y;
	wire [31:0] d_xor = X ^ Y;
	wire [31:0] d_lui = {Y[15:0],16'h0};
	wire [31:0] d_and_or = Aluc[2]? d_or:d_and;
	wire [31:0] d_xor_lui = Aluc[2]? d_lui:d_xor;
	wire [31:0] d_as , d_sh;
	
	addsub32 as32 (X , Y , Aluc[2] , d_as);
	Shifter shift_1 ( Y , X[4:0] , Aluc[2] , Aluc[3] , d_sh);
	MUX4X32 sel ( d_as , d_and_or , d_xor_lui , d_sh , Aluc[1:0] , R);
   
	assign Z = ~|R;
endmodule
