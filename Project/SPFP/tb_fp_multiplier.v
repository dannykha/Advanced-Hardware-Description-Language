`timescale 1ns / 100ps

module tb_fp_multiplier();

	// Inputs
	reg clk,rst;
	reg [31:0] a;
	reg [31:0] b;

	// Outputs
	wire [31:0] fprod;
	
	sp_fp_multiplier test_it(.clk(clk), .rst_n(rst), .op_a(a), .op_b(b), .product(fprod));
	
	initial begin
		clk = 0;
		rst = 0;
		#5 rst = 1;
		#10;
		// 0 * 0 = 0 (0x00000000)
		a = 32'h00000000; // 0
		b = 32'h00000000; // 0
		#5 clk = 1;
		#5 clk = 0;
		// 1 * 0 = 0 (0x00000000)
		a = 32'h3f800000; // 1
		b = 32'h00000000; // 0
		#5 clk = 1;
		#5 clk = 0;
		// 1 * -1 = -1 (0xbf800000)
		a = 32'h3f800000; // 1
		b = 32'hbf800000; // -1
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#10;
		#5 rst = 0;
		
		#5 rst = 1;
		// REALLY SMALL NUMBER TEST FOR UNDERFLOW
		// -1.17549435082e-38 * 1.17549435082e-38 = -0 (0x80000000)
		a = 32'h80800000; // -1.17549435082e-38
		b = 32'h00800000; // 1.17549435082e-38
		#5 clk = 1;
		#5 clk = 0;
		// 1.17549435082e-38 * 1.17549435082e-38 = 0 (0x00000000)
		a = 32'h00800000; // 1.17549435082e-38
		b = 32'h00800000; // 1.17549435082e-38
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#10;
		#5 rst = 0;
		
		#5 rst = 1;
		// REALLY BIG NUMBER TEST FOR OVERFLOW
		// -3.40282346639e+38 * 3.40282346639e+38 = -infinity (0xff800000)
		a = 32'hff7fffff; // -3.40282346639e+38
		b = 32'h7F7FFFFF; // 3.40282346639e+38
		#5 clk = 1;
		#5 clk = 0;
		// 3.40282346639e+38 * 3.40282346639e+38 = infinity (0x7f800000)
		a = 32'h7F7FFFFF; // 3.40282346639e+38
		b = 32'h7F7FFFFF; // 3.40282346639e+38
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#10;
		#5 rst = 0;
		
		#5 rst = 1;
		// Numbers from ROM 
		// - NaN * 1.57347180274e-39 = - NaN (ff800000)
		a = 32'hFFFFFFFF; 
		b = 32'h00112233; 
		#5 clk = 1; 
		#5 clk = 0;
		// 1.57347180274e-39 * 853.601013184 = 1.3431171E-36 (0x04f1f717)
		a = 32'h00112233; 
		b = 32'h44556677; 
       #5 clk = 1;
		#5 clk = 0;   
		// 853.601013184 * -9.24849108691e-34 = -7.8945214e-31 (0x8d80188f)
		a = 32'h44556677; 
		b = 32'h8899AABB; 
		#5 clk = 1;
		#5 clk = 0;
		// -9.24849108691e-34 * -116357112.0 = 1.0761277E-25 (0x160537d9)
		a = 32'h8899AABB; 
		b = 32'hCCDDEEFF; 
		#5 clk = 1;
		#5 clk = 0;										
		// -116357112.0 * 1.57347180274e-39 = -1.8308463E-31 (0x8d7ba408)
		a = 32'hCCDDEEFF; 
		b = 32'h00112233; 
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		
		#5 rst = 0;
	end
endmodule