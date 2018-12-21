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