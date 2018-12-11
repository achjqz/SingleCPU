module test_main();
    reg Clock;
	reg Reset;
	wire[31:0] inst;
	wire[31:0] pc;
	wire[31:0] aluout;
	wire[31:0] memout;
    Main main(.Clk(Clock), .Clrn(Reset), .inst(inst), .pc(pc), .aluout(aluout), .memout(memout));
    initial begin
        $dumpfile("test.vcd");  
        $dumpvars(0,test_main);
		// Initialize Inputs
		Clock = 0;
		Reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		Reset <= 1;

		#2000 $finish();
	end
	
	always begin
	   #50;
	   Clock = ~Clock; 
	end
endmodule