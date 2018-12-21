module MUX4X32(A0 , A1, A2, A3, S, Y);
    input [31:0] A0, A1, A2, A3;
    input [1:0] S;
    output [31:0] Y;
    assign Y = (S == 2'b00)? A0 : (S == 2'b01)? A1 :
	             (S == 2'b10)? A2 : A3; 
endmodule
