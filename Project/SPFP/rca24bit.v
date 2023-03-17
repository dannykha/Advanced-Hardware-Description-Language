// This module is the ripple carry adder for the last part of the wallace tree

module rca24bit#(parameter width = 50)(
	input [width - 1:0] op1, op2,
	input cin,
	output [width - 1:0] sum,
	output c_out
);

	wire [width:0] c_tmp;

	assign c_tmp[0] = cin;

	assign c_out = c_tmp[width];
	genvar i;
	generate
		for(i = 0; i <= width - 1; i = i + 1) begin : stageRCA
			full_adder f1(op1[i], op2[i], c_tmp[i], c_tmp[i+1], sum[i]);
		end
	endgenerate
endmodule