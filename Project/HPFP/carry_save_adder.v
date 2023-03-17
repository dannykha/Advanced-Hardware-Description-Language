// This module is for the carry save adders in the wallace tree


module carry_save_adder#(parameter width = 50)(
	input [width - 1:0] op1, op2, op3,
	output[width - 1:0] sum,
	output[width:0] carry
);

	assign carry[0]=1'b0;
	
	//	input a, b, c_in,
	// output c_out, s

	genvar i;
	generate
		for(i= 0; i <= width - 1; i = i + 1) begin : stageCSA
			full_adder f1(op1[i], op2[i], op3[i], carry[i+1], sum[i]);
		end
	endgenerate
endmodule
