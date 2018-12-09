module RegFile(
             input         Clock,
			 input         Reset,
			 input [4:0]  A_addr,
			 input [4:0]  B_addr,
			 input [4:0]  W_addr,
			 input [31:0]  Data,
			 input         Write,
			 output [31:0] A_data,
			 output [31:0] B_data
    );

    reg [31:0] Register[1:31];
	 
	 //Read data
	 assign A_data = (A_addr == 0)? 0 : Register[A_addr];
	 assign B_data = (B_addr == 0)? 0 : Register[B_addr];
	 
	 //Write data
	 integer i;
	 always @ ( posedge Clock or negedge Reset) begin
		if (Reset == 0) begin				
			for (i=1 ; i <=31 ; i = i+1) Register[i] <= 0;
		end else  if (( Write ) && ( W_addr != 0)) 	
			Register[W_addr] <= Data;
	end
endmodule
