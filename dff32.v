module dff32(D, Clock, Reset, Q);	 
	input Clock, Reset;
	input [31:0] D;
	output reg [31:0] Q;
	always @(posedge Clock or negedge Reset) begin
		if(Reset == 0) Q <= 0;
		else     Q <= D;
	end
endmodule
