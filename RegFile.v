module RegFile(Ra, Rb, D, Wr, We, Clk, Clrn, Qa, Qb);
	input [4:0] Ra, Rb, Wr;
	input [31:0] D;
	input Clk, Clrn, We;

	output [31:0] Qa, Qb;
    reg [31:0] Register[1:31];
	 
	 //Read data
	 assign Qa = (Ra == 0)? 0 : Register[Ra];
	 assign Qb = (Rb == 0)? 0 : Register[Rb];
	 
	 //Write data
	 integer i;
	 always @ (posedge Clk or negedge Clrn) begin
		if (Clrn == 0) begin				
			for (i=1 ; i <=31 ; i = i+1) Register[i] <= 0;
		end else  if (( We ) && ( Wr != 0)) 	
			Register[Wr] <= D;
	end
endmodule
