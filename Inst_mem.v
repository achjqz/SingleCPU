module INSTMEM(Addr, Inst); 
	input  [31:0] Addr;
	output [31:0] Inst;
	wire [31:0] Ram [0:31];
	assign Ram[5'h00] = 32'h3c011111; //lui R1 , 0x1111
	assign Ram[5'h01] = 32'h3C021111; //lui R2 , 0x1111
	assign Ram[5'h02] = 32'h00221820; //add R3 , R1 , R2
	assign Ram[5'h03] = 32'h10220001; //beq R2 , R1 , 1
	assign Ram[5'h04] = 32'h00222020;  //add R4 , R1 , R2
	assign Ram[5'h05] = 32'h00222824; // and  R5, R1, R2
	assign Ram[5'h06] = 32'h14610001; // bne R3 , R1 , 1
	assign Ram[5'h07] = 32'h00222020;  //add R4 , R1 , R2
	assign Ram[5'h08] = 32'h00223025;  // or R6 , R1 , R2
	assign Ram[5'h09] = 32'h00222022;  // sub R4 , R1 , R2
	assign Ram[5'h0a] = 32'h00221826; //xor R3 , R1 , R2
	assign Ram[5'h0b] = 32'h00021880; //sll R3 , R2 , 2
	assign Ram[5'h0c] = 32'h00021882; //srl R3 , R2 , 2
	assign Ram[5'h0d] = 32'h00021883; //sra R3 , R2 , 2
	assign Ram[5'h0e] = 32'h20231234; //addi R3 , R1,0x1234
	assign Ram[5'h0f] = 32'h302300EF; //andi R3 , R1,0xef
	assign Ram[5'h10] = 32'h342300EF; //ori   R3 , R1,0xef
	assign Ram[5'h11] = 32'h382300EF; //xori  R3 , R1,0xef
	assign Ram[5'h12] = 32'had420004; //sw R2 , 1(R10)
	assign Ram[5'h13] = 32'h8d420004; //lw R2 , 1(R10)
	assign Ram[5'h14] = 32'h0c000016; //jar 16
	assign Ram[5'h15] = 32'h00223024; //and R6 , R1 , R2
	assign Ram[5'h16] = 32'h00223020; //add R6 , R1 , R2
	assign Ram[5'h17] = 32'h08000019; // j 19
	assign Ram[5'h18] = 32'h00223020; //add R6 , R1 , R2
	assign Ram[5'h19] = 32'h00223024; //and R6 , R1 , R2
	assign Ram[5'h1a] = 32'h00800008; //jr R4

	assign Inst = Ram[Addr[6:2]];
endmodule
