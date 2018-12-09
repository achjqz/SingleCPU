module ALU(
    input [31:0] A, 
	input [31:0] B,
	input [3:0] ALU_Operation,
	output [31:0] Result,
	output     Zero
	);

	wire [31:0] d_and = A & B;
	wire [31:0] d_or  = A | B;
	wire [31:0] d_xor = A ^ B;
	wire [31:0] d_lui = {B[15:0],16'h0};
	wire [31:0] d_and_or = ALU_Operation[2]? d_or:d_and;
	wire [31:0] d_xor_lui = ALU_Operation[2]? d_lui:d_xor;
	wire [31:0] d_as , d_sh;
	
	addsub32 as32 (A , B , ALU_Operation[2] , d_as);
	Shifter shift_1 ( B , A[4:0] , ALU_Operation[2] , 
ALU_Operation[3] , d_sh);
	MUX32_4_1 sel ( d_as , d_and_or , d_xor_lui , d_sh , 
ALU_Operation[1:0] , Result);
   
	assign Zero = ~|Result;
endmodule
