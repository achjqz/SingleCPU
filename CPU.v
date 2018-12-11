module CPU(Clk, Clrn, Inst, Dread, Iaddr, Wmem, Dwirte, Daddr);

	input Clk, Clrn;
	input [31:0] Inst, Dread;
	output [31:0] Iaddr, Daddr, Dwirte;
	output Wmem;

    wire [31:0] p4 , adr , npc , res , ra , alu_mem , alua , alub;
    wire [4:0] reg_dest , wn;
    wire [3:0] aluc;
    wire [1:0] Pcsrc;
    wire zero , wreg,regrt, reg2reg,shift,aluqb,jal,se;
    
	wire [31:0] sa = {27'b0 , Inst[10:6]};  
	wire [31:0] offset = {imm[13:0] , Inst[15:0] , 2'b00}; 
	
	dff32 ip (npc , Clk , Clrn , Iaddr); 
	cla32 pcplus4 ( Iaddr , 32'h4 , 1'b0 , p4);
	cla32 br_adr  ( p4 , offset , 1'b0 ,adr);
	wire [31:0] jpc = {p4[31:28] , Inst[25:0],2'b00}; 
	
	ControlUnit CU ( Inst[31:26] , 	Inst[5:0] , zero,         
					 Wmem,wreg,regrt,reg2reg,aluc,
                          shift,aluqb,Pcsrc,jal,se	);

	 wire e =se & Inst[15];
	 wire [15:0] imm = {16{e}};
	 wire [31:0] immdiate = {imm , Inst[15:0]};  //立即数
		
	RegFile rf (Inst[25:21], Inst[20:16], res, wn,
	                wreg, Clk, Clrn, ra, Daddr );               
			
	MUX2X32 alu_a ( ra , sa , shift , alua);
	MUX2X32 alu_b ( Daddr , immdiate , aluqb , alub);

	ALU alu( alua , alub , aluc , Dwirte , zero);
	
	MUX2X5 reg_wn (Inst[15:11] , Inst[20:16] , regrt , reg_dest);
	
	assign wn = reg_dest | {5{jal}}; 
	
	MUX2X32 res_mem ( Dwirte , Dread , reg2reg , alu_mem);
	MUX2X32 link ( alu_mem , p4 , jal , res);
	MUX4X32 nextpc( p4 , adr , ra , jpc , Pcsrc , npc);		
endmodule
