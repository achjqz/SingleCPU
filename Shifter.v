module Shifter(
		input [31:0] D,
		input [4:0]  Sa,
		input        Right,
		input        Arith,
		output reg [31:0] O
    );
	always @(*) begin
		if (!Right)      O = D << Sa ;
		else if (!Arith) O = D >> Sa;
		else             O = $signed(D) >>> Sa;
	end	

endmodule
