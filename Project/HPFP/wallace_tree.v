// This module is the wallace tree design that utilizes
// carry save adders
module wallace_tree(
	input [10:0] op1, op2, 
	output [21:0] product, 
	output carry
);

	wire [21:0] prod_tmp;
	
	wire [23:0] p [10:0];

	wire [23:0] carry_tmp [9:1];

	wire [23:0] sum_tmp [9:1];
	
	// assigning partial products prior to sending to CSA
	// If bit of op2 is 1 then the corresponding bit is set to op1 with shift, 
	// else bit of op2 is 0 then set it to 0
	assign p[0] = (op2[0] == 1'b1) ? {12'b0, op1} : 24'h0000;

	assign p[1] = (op2[1] == 1'b1) ? {11'b0, op1, 1'b0} : 24'h0000;

	assign p[2] = (op2[2] == 1'b1) ? {10'b0, op1, 2'b0} : 24'h0000;

	assign p[3] = (op2[3] == 1'b1) ? {9'b0, op1, 3'b0} : 24'h0000;

	assign p[4] = (op2[4] == 1'b1) ? {8'b0, op1, 4'b0} : 24'h0000;

	assign p[5] = (op2[5] == 1'b1) ? {7'b0, op1, 5'b0} : 24'h0000;

	assign p[6] = (op2[6] == 1'b1) ? {6'b0, op1, 6'b0} : 24'h0000;

	assign p[7] = (op2[7] == 1'b1) ? {5'b0, op1, 7'b0} : 24'h0000;

	assign p[8] = (op2[8] == 1'b1) ? {4'b0, op1, 8'b0} : 24'h0000;

	assign p[9] = (op2[9] == 1'b1) ? {3'b0, op1, 9'b0} : 24'h0000;

	assign p[10] = (op2[10] == 1'b1) ? {2'b0, op1, 10'b0} : 24'h0000;
	
	// Creating wallace tree with the carry save adders
	// op1, op2, op3, sum, carry
	
	// level 1
	carry_save_adder#(24) c1(p[0], p[1], p[2], sum_tmp[1], carry_tmp[1]);

	carry_save_adder#(24) c2(p[3], p[4], p[5], sum_tmp[2], carry_tmp[2]);

	carry_save_adder#(24) c3(p[6], p[7], p[8], sum_tmp[3], carry_tmp[3]);
	
	// level 2
	carry_save_adder#(24) c4(sum_tmp[1], carry_tmp[1], sum_tmp[2], sum_tmp[4], carry_tmp[4]);

	carry_save_adder#(24) c5(carry_tmp[2], sum_tmp[3], carry_tmp[3], sum_tmp[5], carry_tmp[5]);
	
	// level 3
	carry_save_adder#(24) c6(sum_tmp[4], carry_tmp[4], sum_tmp[5], sum_tmp[6], carry_tmp[6]);

	carry_save_adder#(24) c7(carry_tmp[5], p[9], p[10], sum_tmp[7], carry_tmp[7]);

	// level 4
	carry_save_adder#(24) c8(sum_tmp[6], carry_tmp[6], sum_tmp[7], sum_tmp[8], carry_tmp[8]);

	// level 5
	carry_save_adder#(24) c9(sum_tmp[8], carry_tmp[8], carry_tmp[7], sum_tmp[9], carry_tmp[9]);

	// Final part of wallace tree is to RCA
	rca24bit#(24) add1(sum_tmp[9], carry_tmp[9], 1'b0, prod_tmp, carry);

	assign product = prod_tmp[21:0];

endmodule
