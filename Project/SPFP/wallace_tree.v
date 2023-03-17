// This module is the wallace tree design that utilizes
// carry save adders
module wallace_tree(
	input [23:0] op1, op2, 
	output [47:0] product, 
	output carry
);

	wire [47:0] prod_tmp;
	
	wire [49:0] p [23:0];

	wire [49:0] carry_tmp [22:1];

	wire [49:0] sum_tmp [22:1];
	
	// assigning partial products prior to sending to CSA
	// If bit of op2 is 1 then the corresponding bit is set to op1 with shift, 
	// else bit of op2 is 0 then set it to 0
	assign p[0] = (op2[0] == 1'b1) ? {25'b0, op1} : 50'h00000000;

	assign p[1] = (op2[1] == 1'b1) ? {24'b0, op1, 1'b0} : 50'h00000000;

	assign p[2] = (op2[2] == 1'b1) ? {23'b0, op1, 2'b0} : 50'h00000000;

	assign p[3] = (op2[3] == 1'b1) ? {22'b0, op1, 3'b0} : 50'h00000000;

	assign p[4] = (op2[4] == 1'b1) ? {21'b0, op1, 4'b0} : 50'h00000000;

	assign p[5] = (op2[5] == 1'b1) ? {20'b0, op1, 5'b0} : 50'h00000000;

	assign p[6] = (op2[6] == 1'b1) ? {19'b0, op1, 6'b0} : 50'h00000000;

	assign p[7] = (op2[7] == 1'b1) ? {18'b0, op1, 7'b0} : 50'h00000000;

	assign p[8] = (op2[8] == 1'b1) ? {17'b0, op1, 8'b0} : 50'h00000000;

	assign p[9] = (op2[9] == 1'b1) ? {16'b0, op1, 9'b0} : 50'h00000000;

	assign p[10] = (op2[10] == 1'b1) ? {15'b0, op1, 10'b0} : 50'h00000000;

	assign p[11] = (op2[11] == 1'b1) ? {14'b0, op1, 11'b0} : 50'h00000000;
	 
	assign p[12] = (op2[12] == 1'b1) ? {13'b0, op1, 12'b0} : 50'h00000000;

	assign p[13] = (op2[13] == 1'b1) ? {12'b0, op1, 13'b0} : 50'h00000000;

	assign p[14] = (op2[14] == 1'b1) ? {11'b0, op1, 14'b0} : 50'h00000000;

	assign p[15] = (op2[15] == 1'b1) ? {10'b0, op1, 15'b0} : 50'h00000000;

	assign p[16] = (op2[16] == 1'b1) ? {9'b0, op1, 16'b0} : 50'h00000000;

	assign p[17] = (op2[17] == 1'b1) ? {8'b0, op1, 17'b0} : 50'h00000000;

	assign p[18] = (op2[18] == 1'b1) ? {7'b0, op1, 18'b0} : 50'h00000000;

	assign p[19] = (op2[19] == 1'b1) ? {6'b0, op1, 19'b0} : 50'h00000000;

	assign p[20] = (op2[20] == 1'b1) ? {5'b0, op1, 20'b0} : 50'h00000000;

	assign p[21] = (op2[21] == 1'b1) ? {4'b0, op1, 21'b0} : 50'h00000000;

	assign p[22] = (op2[22] == 1'b1) ? {3'b0, op1, 22'b0} : 50'h00000000;

	assign p[23] = (op2[23] == 1'b1) ? {2'b0, op1, 23'b0} : 50'h00000000;
	
	// Creating wallace tree with the carry save adders
	// op1, op2, op3, sum, carry
	
	// level 1
	carry_save_adder c1(p[0], p[1], p[2], sum_tmp[1], carry_tmp[1]);

	carry_save_adder c2(p[3], p[4], p[5], sum_tmp[2], carry_tmp[2]);

	carry_save_adder c3(p[6], p[7], p[8], sum_tmp[3], carry_tmp[3]);

	carry_save_adder c4(p[9], p[10], p[11], sum_tmp[4], carry_tmp[4]);

	carry_save_adder c5(p[12], p[13], p[14], sum_tmp[5], carry_tmp[5]);

	carry_save_adder c6(p[15], p[16], p[17], sum_tmp[6], carry_tmp[6]);

	carry_save_adder c7(p[18], p[19], p[20], sum_tmp[7], carry_tmp[7]);

	carry_save_adder c8(p[21], p[22], p[23], sum_tmp[8], carry_tmp[8]);
	
	// level 2
	carry_save_adder c9(sum_tmp[1], carry_tmp[1], sum_tmp[2], sum_tmp[9], carry_tmp[9]);

	carry_save_adder c10(carry_tmp[2], sum_tmp[3], carry_tmp[3], sum_tmp[10], carry_tmp[10]);

	carry_save_adder c11(sum_tmp[4], carry_tmp[4], sum_tmp[5], sum_tmp[11], carry_tmp[11]);

	carry_save_adder c12(carry_tmp[5], sum_tmp[6], carry_tmp[6], sum_tmp[12], carry_tmp[12]);

	carry_save_adder c13(sum_tmp[7], carry_tmp[7], sum_tmp[8], sum_tmp[13], carry_tmp[13]);
	
	// level 3
	carry_save_adder c14(sum_tmp[9], carry_tmp[9], sum_tmp[10], sum_tmp[14], carry_tmp[14]);

	carry_save_adder c15(carry_tmp[10], sum_tmp[11], carry_tmp[11], sum_tmp[15], carry_tmp[15]);

	carry_save_adder c16(sum_tmp[12], carry_tmp[12], sum_tmp[13], sum_tmp[16], carry_tmp[16]);

	// level 4
	carry_save_adder c17(sum_tmp[14], carry_tmp[14], sum_tmp[15], sum_tmp[17], carry_tmp[17]);

	carry_save_adder c18(carry_tmp[15], sum_tmp[16], carry_tmp[16], sum_tmp[18], carry_tmp[18]);

	// level 5
	carry_save_adder c19(sum_tmp[17], carry_tmp[17], sum_tmp[18], sum_tmp[19], carry_tmp[19]);

	carry_save_adder c20(carry_tmp[18], carry_tmp[13], carry_tmp[8], sum_tmp[20], carry_tmp[20]);

	// level 6
	carry_save_adder c21(sum_tmp[19], carry_tmp[19], sum_tmp[20], sum_tmp[21], carry_tmp[21]);

	// level 7
	carry_save_adder c22(sum_tmp[21], carry_tmp[21], carry_tmp[20], sum_tmp[22], carry_tmp[22]);
	
	// Final part of wallace tree is to RCA
	rca24bit add1(sum_tmp[22], carry_tmp[22], 1'b0, prod_tmp, carry);

	assign product = prod_tmp[47:0];

endmodule
