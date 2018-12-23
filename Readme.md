# 单周期处理器的设计和实现
[TOC]

## 一、实验要求
1. 至少支持add、sub、and、or、addi、andi、ori、lw、sw、beq、bne和j十二条指令。
2. 完成R型, I型, J型数据通路

## 二、主要实验过程

### 总体设计
1. 总体电路图
  ![](https://i.imgur.com/C3w5cSB.png)


2. 主要模块 
    * 指令存储器: 可储存32条指令, 根据指令地址提供所对应指令
    * 控制部件: 对输入的指令进行解析,判断是哪种操作, 提供使能端
    * 寄存器堆: 根据寄存器地址找到对应寄存器的值, 也有将值写入寄存器的功能
    * ALU: 对输入进来的值进行运算
    * 数据存储器: 只与lw,sw 存数取数命令有关
    * 2个5位2选1选择器: 其中一个区别R型指令和I型指令的目的寄存器, 另一个实现jal的功能
    * 3个32位2选1选择器: 作用分别为:  支持移位操作, 支持立即数运算, 取数指令的实现
    * 1个32位4选1选择器,实现PC指令跳转功能

### 各个模块实现

#### 指令存储器
1. 参数
- 输入 
    - Addr: 指令的地址(32 位, 取第6位到第2位5位,最多32个)
- 输出 
    - Inst: 地址所对应的指令
2. 指令编写
  ![](https://i.imgur.com/dBtrYBo.jpg)
- R型指令, func(最后五位不同)
- I型, J型 op不同

#### 控制部件
1. 参数
- 输入:
    -  Op, Func, Z(beq, bne时有效)
- 输出: 
    - Regrt: 选择rt作为写入寄存器还是rd, R型指令除了jr都是0 
    - Se: 1是符号扩展(addi, lw, sw, beq, bne), 0是零扩展
    - Wreg: 寄存器堆写使能端, sw, beq, bne, j,jr, jal 为0
    - Aluqb: 选择寄存器Qb作为ALU Y的输入还是扩展后的立即数
    - Aluc: 4位 运算指令
    - Wmem: 数据储存器写使能端, 只有sw需要为1
    - Pcsrc: 2位 0 下一条指令, 1 条件分支跳转(beq, bne)2 寄存器跳转(jr) 3 跳转指令跳转(j,jal)
    - Reg2reg: 选择Alu的R输出还是数据储存器的Dout端口(仅lw为1)
    - Shift: 选择根据sa移位运算还是寄存器堆输出
    - Jal: 是否为jal指令
2. 解析过程
- 根据op func 确定指令
- 根据指令生成控制信号

#### 寄存器堆
1. 参数
- 输入: 
    - Ra, Rb, Wr: 三个寄存器的地址
    - D: 要写入Wr寄存器的数据
    - We: 寄存器堆写使能端, sw, beq, bne, j,jr, jal不能写入
      Clk, Clrn: 时钟和清零信号
- 输出: 
    - Qa, Qb:寄存器Ra, Rb对应的值
2. 功能
- 读数据, 直接读取reg数组里的值
- 写数据/ 清零 

#### ALU
1. 参数
- 输入: 
    - X, Y: 需进行运算的两个数 
    - Aluc: 进行的运算类型
- 输出:
    - R, Z: 运算结果,Z用于beq, bne判断输入
2. 计算过程
- 首先进行各种运算
- 再通过选择器选择哪种作为结果

#### 数据存储器
1. 参数
- 输入:
    - We: 写使能端 只有sw为1
    - addr: 由Alu计算出的 数据存储器地址
    - datain: Qb的输出, 作为sw的数据, rt寄存器
    - Clk: 时钟信号
- 输出:
    - dataout: addr取第6位到第2位5位 对应存储器的值

### 整合实现

#### CPU封装
1. 封装示意图
  ![](https://i.imgur.com/ZlQLPSk.png)
2. 参数
- 输入: 
    - Clk, Clrn 时钟和清零信号
    - Inst: CPU要执行的指令编码
    - Dread: 从存储器读取的数据(lw需要)
- 输出:
    - Iaddr: 下一条CPU要执行的指令
    - Daddr: 想要访问数据存储器中的地址(lw, sw)
    - Dwite: 想要写入数据存储器的数据(sw)
    - Wmem: 数据存储器写使能端
3. 主要步骤
- 调用各个模块, 提供参数
- 写选择器

#### 主函数运行
1. 参数
- 输入: 
    - Clk, Clrn 时钟和清零信号
- 输出: 
    - inst: 当前运行的指令
    - addr: 指令的地址
    - aluout: ALU计算的结果
    - memout: 数据存储器输出的结果
2. 主要步骤
- 调用CPU, InstMem, DataMem

## 三、主要实现代码

### 5位2选1选择器
```verilog
module MUX2X5(A0, A1, S, Y);
	input [4:0] A0;
	input [4:0] A1;
	input S;
	output [4:0] Y;
	assign Y = S? A1 : A0; 
endmodule
```
### 32位2选1选择器
```verilog
module MUX2X32(A0, A1, S, Y);
	input [31:0] A0;
	input [31:0] A1;
	input S;
	output [31:0] Y;
	assign Y = S? A1 : A0; 
endmodule
```
### 32位4选1选择器
```verilog
module MUX4X32(A0 , A1, A2, A3, S, Y);
    input [31:0] A0, A1, A2, A3;
    input [1:0] S;
    output [31:0] Y;
    assign Y = (S == 2'b00)? A0 : (S == 2'b01)? A1 : (S == 2'b10)? A2 : A3; 
endmodule
```

### 32位移位器
```verilog
module SHIFTER_32(X,Sa,Arith,Right,Sh);
    input [31:0]X;
    input [4:0]Sa;
    input Arith,Right;
    output [31:0] Sh;
    wire [31:0] T4,S4,T3,S3,T2,S2,T1,S1,T0;
    wire a = X[31] & Arith;
    wire [15:0] e = {16{a}};
    parameter z = 16'b0;
    wire [31:0]L1u,L1d,L2u,L2d,L3u,L3d,L4u,L4d,L5u,L5d;
    //第一级
    assign L1u = {X[15:0],z};
    assign L1d = {e,X[31:16]};
    MUX2X32 M1l(L1u,L1d,Right,T4);
    MUX2X32 M1r(X,T4,Sa[4],S4);
    // 第二级
    assign L2u={S4[23:0],z[7:0]};
    assign L2d={e[7:0],S4[31:8]};
    MUX2X32 M2l(L2u,L2d,Right,T3);
    MUX2X32 M2r(S4,T3,Sa[3],S3);
    // 第三级
    assign L3u={S3[27:0],z[3:0]};
    assign L3d={e[3:0],S3[31:4]};
    MUX2X32 M3l(L3u,L3d,Right,T2);
    MUX2X32 M3r(S3,T2,Sa[2],S2);
    // 第四级
    assign L4u={S2[29:0],z[1:0]};
    assign L4d={e[1:0],S2[31:2]};
    MUX2X32 M4l(L4u,L4d,Right,T1);
    MUX2X32 M4r(S2,T1,Sa[1],S1);
    //第五级
    assign L5u={S1[30:0],z[0]};
    assign L5d={e[0],S1[31:1]};
    MUX2X32 M5l(L5u,L5d,Right,T0);
    MUX2X32 M5r(S1,T0,Sa[0],Sh);
endmodule
```

### 锁存器
```verilog
module dff32(D, Clock, Reset, Q);	 
	input Clock, Reset;
	input [31:0] D;
	output reg [31:0] Q;
	always @(posedge Clock or negedge Reset) begin
		if(Reset == 0) Q <= 0;
		else     Q <= D;
	end
endmodule
```

### 32位加法器
```verilog
module addsub32(A, B, sub, Result);
	input [31:0] A, B;
	input sub;
	output[31:0] Result;
	cla32 as32(A , B^{32{sub}} , sub , Result); 
endmodule

module cla32(a, b, c, s);
	input [31:0] a, b;
	input c;
	output[31:0] s;
	assign s = a + b + c; 
endmodule
```

### 寄存器堆
```verilog
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
		if (Clrn == 0) 
               begin				
		   for (i=1 ; i <=31 ; i = i+1) Register[i] <= 0;
		end 
                else  if (( We ) && ( Wr != 0)) 	
			Register[Wr] <= D;
	end
endmodule
```
### ALU
```verilog
module ALU(X, Y, Aluc, R, Z);
	input [31:0] X, Y;
	input [3:0] Aluc;
	output wire [31:0] R;
	output wire Z;

	wire [31:0] d_and = X & Y;
	wire [31:0] d_or  = X | Y;
	wire [31:0] d_xor = X ^ Y;
	wire [31:0] d_lui = {Y[15:0],16'h0};
	wire [31:0] d_and_or = Aluc[2]? d_or:d_and;
	wire [31:0] d_xor_lui = Aluc[2]? d_lui:d_xor;
	wire [31:0] d_as, d_sh;
	
	addsub32 as32 (X, Y, Aluc[2], d_as);
	SHIFTER_32 shift_1 (Y, X[4:0], Aluc[2], Aluc[3], d_sh);
	MUX4X32 sel(d_as, d_and_or, d_xor_lui, d_sh, Aluc[1:0], R);
   
	assign Z = ~|R;
endmodule
```

### 控制部件
```verilog
module ControlUnit(Op, Func, Z, Wmem, Wreg, Regrt, Reg2reg, Aluc, Shift, Aluqb, Pcsrc, jal, Se);	
	input [5:0] Op, Func;
	input Z;
	output [3:0] Aluc;
	output [1:0] Pcsrc;
	output Wmem, Wreg, Regrt, Se, Shift, Aluqb, Reg2reg, jal;
		
	// R型指令
	wire i_add = (Op == 6'b000000 & Func == 6'b100000)?1:0;
	wire i_sub = (Op == 6'b000000 & Func == 6'b100010)?1:0;
	wire i_and = (Op == 6'b000000 & Func == 6'b100100)?1:0;
	wire i_or  = (Op == 6'b000000 & Func == 6'b100101)?1:0;
	wire i_xor = (Op == 6'b000000 & Func == 6'b100110)?1:0;
	wire i_sll = (Op == 6'b000000 & Func == 6'b000000)?1:0;
	wire i_srl = (Op == 6'b000000 & Func == 6'b000010)?1:0;
	wire i_sra = (Op == 6'b000000 & Func == 6'b000011)?1:0;
	wire i_jr  = (Op == 6'b000000 & Func == 6'b001000)?1:0;

	// I型指令
	wire i_addi = (Op == 6'b001000)?1:0;
	wire i_andi = (Op == 6'b001100)?1:0; 
	wire i_ori  = (Op == 6'b001101)?1:0;
	wire i_xori = (Op == 6'b001110)?1:0;
	wire i_lw   = (Op == 6'b100011)?1:0;
	wire i_sw   = (Op == 6'b101011)?1:0;
	wire i_beq  = (Op == 6'b000100)?1:0;
	wire i_bne  = (Op == 6'b000101)?1:0;
	wire i_lui  = (Op == 6'b001111)?1:0;

	// J型指令
	wire i_j    = (Op == 6'b000010)?1:0;
	wire i_jal  = (Op == 6'b000011)?1:0; 
	
	assign Wreg  = i_add  | i_sub  | i_and | i_or | i_xor  | 
	i_sll | i_srl |i_sra |	i_addi | i_andi | 
	i_ori | i_or | i_xori | i_lw  | i_lui |i_jal;
	assign Regrt  = i_addi | i_andi | i_ori | i_xori |i_lw |i_lui;
	assign jal = i_jal;
	assign Reg2reg  = i_lw;
	assign Shift  = i_sll | i_srl |i_sra;
	assign Aluqb = i_addi | i_andi | i_ori | i_xori | i_lw |
	 i_lui |i_sw;
	assign Se = i_addi | i_lw | i_sw | i_beq | i_bne;
	assign Aluc[3] = i_sra;
	assign Aluc[2] = i_sub |i_or | i_srl | i_sra | i_ori |i_lui;
	assign Aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori |
	 i_beq | i_bne | i_lui;
	assign Aluc[0] = i_and | i_or | i_sll | i_srl |i_sra |
	 i_andi  | i_ori;
	assign Wmem  = i_sw;
	assign Pcsrc[1] = i_jr | i_j | i_jal;
	assign Pcsrc[0] = i_beq & Z | i_bne&~Z | i_j | i_jal;
endmodule
```

### CPU封装
```verilog
module CPU(Clk, Clrn, Inst, Dread, Iaddr, Wmem, Dwirte, Daddr);
	input Clk, Clrn;
	input [31:0] Inst, Dread;
	output [31:0] Iaddr, Daddr, Dwirte;
	output Wmem;

    wire [31:0] p4, adr, npc, res, ra, alu_mem, alua, alub;
    wire [4:0] reg_dest, wn;
    wire [3:0] aluc;
    wire [1:0] Pcsrc;
    wire zero, wreg, regrt, reg2reg, shift, aluqb, jal, se;
    
	ControlUnit CU (Inst[31:26], Inst[5:0], zero,         
					Wmem, wreg, regrt, reg2reg, aluc,
                    shift, aluqb, Pcsrc, jal, se);

	wire [31:0] sa = {27'b0 , Inst[10:6]};  

	wire e = se & Inst[15];

	//符号拓展的符号位
	wire [15:0] sign = {16{e}};

	wire [31:0] offset = {sign[13:0], Inst[15:0], 2'b00}; 
		 
    wire [31:0] immdiate = {sign , Inst[15:0]}; 

	//按照时钟上升沿执行命令
	dff32 ip (npc , Clk , Clrn , Iaddr); 

	cla32 pcplus4(Iaddr , 32'h4 , 1'b0 , p4);

	// 条件分支指令跳转地址
	cla32 br_adr(p4, offset, 1'b0, adr);

	// j 或者 jal
	wire [31:0] jpc = {p4[31:28] , Inst[25:0],2'b00}; 

	// 写使能端
	assign wn = reg_dest | {5{jal}}; 
	RegFile rf (Inst[25:21], Inst[20:16], res, wn,
	                wreg, Clk, Clrn, ra, Daddr );               
			
    // jr的跳转地址
	MUX2X32 alu_a (ra , sa , shift , alua);
	MUX2X32 alu_b (Daddr, immdiate, aluqb, alub);

	ALU alu(alua, alub, aluc, Dwirte, zero);
	
	MUX2X5 reg_wn (Inst[15:11], Inst[20:16], regrt, reg_dest);

	MUX2X32 res_mem(Dwirte, Dread, reg2reg , alu_mem);

	//jal 调用
	MUX2X32 link(alu_mem,  p4 , jal , res);
	MUX4X32 nextpc( p4 , adr , ra , jpc , Pcsrc , npc);		
endmodule
```

### 数据存储器
```verilog
module DATAMEM(Clk, dataout, datain, addr, we);
	input Clk, we;
	input [31:0] datain, addr;
	output [31:0] dataout;
	reg [31:0] Ram [0:31];
	
	assign dataout = Ram[addr[6:2]];
	always @ (posedge Clk) begin
		if (we) Ram[addr[6:2]] = datain;
	end

	integer i;
	initial begin
		for (i = 0 ; i <= 31 ; i = i + 1) Ram [i] = 0;
	end		
	
endmodule
```

### 指令存储器
```verilog
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
	assign Ram[5'h12] = 32'had420001; //sw R2 , 1(R10)
	assign Ram[5'h13] = 32'h91420001; //lw R2 , 1(R10)
	assign Ram[5'h14] = 32'h0c000016; //jar 16
	assign Ram[5'h15] = 32'h00223024; //and R6 , R1 , R2
	assign Ram[5'h16] = 32'h00223020; //add R6 , R1 , R2
	assign Ram[5'h17] = 32'h08000019; // j 19
	assign Ram[5'h18] = 32'h00223020; //add R6 , R1 , R2
	assign Ram[5'h19] = 32'h00223024; //and R6 , R1 , R2
	assign Ram[5'h1a] = 32'h00800008; //jr R4

	assign Inst = Ram[Addr[6:2]];
endmodule
```

### 主函数
```verilog
module Main(Clk, Clrn, inst, addr, aluout, memout);
	input Clk, Clrn;
	output [31:0] inst, addr, aluout, memout;
	wire [31:0] data;
	wire        wmem;	
	INSTMEM imem(addr, inst);
	CPU cpu (Clk, Clrn, inst, memout, addr, wmem, aluout, data);
	DATAMEM dmem(Clk, memout, data, aluout, wmem);
endmodule
```

### 测试代码
```verilog
module test_main();
    reg Clock;
	reg Reset;
	wire[31:0] inst;
	wire[31:0] addr;
	wire[31:0] aluout;
	wire[31:0] memout;
    Main main(.Clk(Clock), .Clrn(Reset), .inst(inst), .addr(addr), .aluout(aluout), .memout(memout));
    initial begin
        $dumpfile("test.vcd");  
        $dumpvars(0,test_main);
		Clock = 0;
		Reset = 0;
		#100;
		
		Reset <= 1;

		#3000 $finish();
	end
	
	always begin
	   #50;
	   Clock = ~Clock; 
	end
endmodule
```
## 四、仿真结果
![](https://i.imgur.com/2ahKvXE.png)
![](https://i.imgur.com/Gu0NlNC.png)

可以看出仿真结果完全正确

## 五、实验结论与体会
结论: 实验非常成功, 设计出的单周期CPU完美支持了20条指令
体会: 经过这次试验收获很多, 学会了各种指令的通路设计, 学会了各个模块的代码实现, 学会了各条指令的编写, 总之是很有意义的一次实验