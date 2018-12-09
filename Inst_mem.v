module Inst_mem(
		input  [31:0] address,
		output [31:0] inst
); 
	wire [31:0] ram [0:31];
	assign ram[5'h00] = 32'h3c011234; //lui R1 , 0x1234
	assign ram[5'h01] = 32'h34215678; //ori R1 , R1 ,0x5678
	assign ram[5'h02] = 32'h3C02AAAA; //lui R2 , 0xaaaa
	assign ram[5'h03] = 32'h3442BBBB; //ori R2 , R2 ,0xbbbb
	assign ram[5'h04] = 32'h00221820; //add R3 , R1 , R2
	assign ram[5'h05] = 32'h00221822; //sub R3 , R1 , R2
	assign ram[5'h06] = 32'h00221824; //and R3 , R1 , R2
	assign ram[5'h07] = 32'h00221825; //or  R3 , R1 , R2
	assign ram[5'h08] = 32'h00221826; //xor R3 , R1 , R2
	assign ram[5'h09] = 32'h00021900; //sll R3 , R2 , 4
	assign ram[5'h0a] = 32'h00021902; //srl R3 , R2 , 4
	assign ram[5'h0b] = 32'h00021903; //srl R3 , R2 , 4
	assign ram[5'h0c] = 32'h20231234; //addi R3 , R1,0x1234
	assign ram[5'h0d] = 32'h302300EF; //andi R3 , R1,0xef
	assign ram[5'h0e] = 32'h342300EF; //ori   R3 , R1,0xef
	assign ram[5'h0f] = 32'h382300EF; //xori  R3 , R1,0xef
	assign ram[5'h10] = 32'h00631826; //xor   R3 , R3 , R3
	assign ram[5'h11] = 32'hAC610001; //sw R1 , 1(R3)
	assign ram[5'h12] = 32'h90650001; //lw R5 , 1(R3)
	 assign inst = ram[address[6:2]];

endmodule
