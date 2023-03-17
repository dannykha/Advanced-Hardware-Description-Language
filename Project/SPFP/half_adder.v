// This module is a half adder
module half_adder (
	input a, b,
	output c_out, s
);

	assign c_out = a & b;
	assign s = a ^ b;

endmodule

