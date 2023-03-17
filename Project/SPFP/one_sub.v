// This module is one subtractor
module one_sub (
	input s, bi,
	output r, bo
);
	assign r = ~(s ^ bi);
	assign bo = ~s | bi;

endmodule