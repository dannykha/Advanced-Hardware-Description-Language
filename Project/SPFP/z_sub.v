// This module is 2 zero subtractor
module z_sub (
	input s, bi,
		output r, bo
);
	assign r = s ^ bi;
	assign bo = ~s & bi;

endmodule