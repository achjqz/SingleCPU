module test_main();
    reg Clock;
	reg Reset;
	reg mem_clk;
	wire[31:0] inst;
	wire[31:0] pc;
	wire[31:0] aluout;
	wire[31:0] memout;
    Mainboard main(.Clock(Clock), .Reset(Reset), .mem_clk(mem_clk), .inst(inst), .pc(pc), .aluout(aluout), .memout(memout));
    initial begin
        $dumpfile("test.vcd");  
        $dumpvars(0,test_main);
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		mem_clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		Reset <= 1;
	end
	
	always begin
	   #50;
	   Clock = ~Clock; 
	end
endmodule