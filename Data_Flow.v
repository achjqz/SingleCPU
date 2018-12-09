module Data_flow(
		input        Clock,   
		input        Reset,   
		input [31:0] inst,    
		input [31:0] mem,     
		output[31:0] pc,      
		output       wmem,    
		output[31:0] Result,  
		output[31:0] Data     
    );
	 
	 wire [31:0] p4 , adr , npc , res , ra , alu_mem , alua , alub;
	 wire [4:0] reg_dest , wn;
	 wire [3:0] aluc;
	 wire [1:0] pcsource;
	 wire zero , wreg,regrt, m2reg,shift,aluimm,jal,sext;
    
	 wire [31:0] sa = {27'b0 , inst[10:6]};  
	 wire [31:0] offset = {imm[13:0] , inst[15:0] , 2'b00}; 
	
	dff32 ip (npc , Clock , Reset , pc); 
	cla32 pcplus4 ( pc , 32'h4 , 1'b0 , p4);
	cla32 br_adr  ( p4 , offset , 1'b0 ,adr);
	wire [31:0] jpc = {p4[31:28] , inst[25:0],2'b00}; 
	
	Control_Unit CU ( inst[31:26] , 	inst[5:0] , zero,         
					 wmem,wreg,regrt,m2reg,aluc,
                          shift,aluimm,pcsource,jal,sext	);

	 wire e =sext & inst[15];
	 wire [15:0] imm = {16{e}};
	 wire [31:0] immdiate = {imm , inst[15:0]};  //立即数
		

	RegFile rf ( Clock, Reset, inst[25:21], inst[20:16],
	                wn, res, wreg, ra, Data );          
			
	MUX32_2_1 alu_a ( ra , sa , shift , alua);
	MUX32_2_1 alu_b ( Data , immdiate , aluimm , alub);

	ALU alu( alua , alub , aluc , Result , zero);
	
	MUX5_2_1 reg_wn ( inst[15:11] , inst[20:16] , regrt , 
reg_dest);
	
assign wn = reg_dest | {5{jal}}; 
	
	MUX32_2_1 res_mem ( Result , mem , m2reg , alu_mem);
	MUX32_2_1 link ( alu_mem , p4 , jal , res);
	MUX32_4_1 nextpc( p4 , adr , ra , jpc , pcsource , npc);		
endmodule
