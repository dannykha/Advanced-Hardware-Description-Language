// This module is a full adder
module full_adder (
	input a, b, c_in,
	output c_out, s
);

	assign c_out = (a & b) | (b & c_in) | (c_in & a);
	assign s = a ^ b ^ c_in;
	
endmodule