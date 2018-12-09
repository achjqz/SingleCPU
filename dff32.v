module dff32(
		input [31:0] D,
		input        Clock,
		input        Reset,
		output reg [31:0] Q    
    );	 
	always @(posedge Clock or negedge Reset) begin
		if(Reset == 0) Q <= 0;
		else             Q <= D;
	end
endmodule
