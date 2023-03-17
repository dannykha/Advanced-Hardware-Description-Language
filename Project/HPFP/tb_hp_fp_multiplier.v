`timescale 1ns / 100ps

module tb_hp_fp_multiplier();

	// Inputs
	reg clk,rst;
	reg [15:0] a;
	reg [15:0] b;

	// Outputs
	wire [15:0] fprod;
	
	hp_fp_multiplier test_it_plz(.clk(clk), .rst_n(rst), .op_a(a), .op_b(b), .product(fprod));
	
	initial begin
		clk = 0;
		rst = 0;
		#5 rst = 1;
		#10;
		// 0 * 0 = 0 (0x0000)
		a = 16'h0000; // 0
		b = 16'h0000; // 0
		#5 clk = 1;
		#5 clk = 0;
		// 1 * 0 = 0 (0x0000)
		a = 16'h3C00; // 1
		b = 16'h0000; // 0
		#5 clk = 1;
		#5 clk = 0;
		// 1 * -1 = -1 (0xBC00)
		a = 16'h3C00; // 1
		b = 16'hBC00; // -1
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
		// --0.00006104 * 0.00006104 = -0 (0x8000)
		a = 16'h8400; // -0.00006104
		b = 16'h0400; // 0.00006104
		#5 clk = 1;
		#5 clk = 0;
		// 0.00006104 * 0.00006104 = 0 (0x0000)
		a = 16'h00800000; // 0.00006104
		b = 16'h00800000; // 0.00006104
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
		// -65504 * 65504 = -infinity (0xFC00)
		a = 16'hFBFF; // -65504
		b = 16'h7BFF; // 65504
		#5 clk = 1;
		#5 clk = 0;
		// 65504 * 65504 = infinity (0x7C00)
		a = 16'h7BFF; // 65504
		b = 16'h7BFF; // 65504
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#10;
		#5 rst = 0;
		
		#5 rst = 1;
		// Some random numbers
		// 7 * 2300 = 16100 (0x73DC)
		a = 16'h4700; // 7
		b = 16'h687E; // 2300
		#5 clk = 1;
		#5 clk = 0;
		// 99.82 * 14.61 = 1458 (0x65B2)
		a = 16'h563D; // 99.82
		b = 16'h4B4E; // 14.61
		#5 clk = 1;
		#5 clk = 0;
		// 100.6 * -3.67 = -369 (0xDDC4)
		a = 16'h5649; // 100.6
		b = 16'hC357; // -3.67
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		#5 clk = 1;
		#5 clk = 0;
		
		#5 rst = 0;
		end
endmodule