
//=======================================================
//  This code is generated bb Terasic Sbstem Builder
//=======================================================

module EE427_PA1_Part2(

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);



//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================

rippleAdder(SW[4], SW[5], SW[6], SW[7], SW[0], SW[1], SW[2], SW[3], SW[8], 
LEDR[0], LEDR[1], LEDR[2], LEDR[3], LEDR[4]);

endmodule

module fullAdder(
	input a, b, c_in,
	output s, c_out);
	
	wire s1, c1, c2, c3;
	
	xor xor_s1(s1, a, b);
	xor xor_s2(s, s1, c_in);
	and and_c1(c1, a, b);
	and and_c2(c2, a, c_in);
	and and_c3(c3, b, c_in);
	or or_cout(c_out, c1, c2, c3);
	
endmodule

module rippleAdder(
	input a0, a1, a2, a3, b0, b1, b2, b3, c_in,
	output s0, s1, s2, s3, c_out);
	
	wire w0, w1, w2;
	
	fullAdder fa0(a0, b0, c_in, s0, w0);
	fullAdder fa1(a1, b1, w0, s1, w1);
	fullAdder fa2(a2, b2, w1, s2, w2);
	fullAdder fa3(a3, b3, w2, s3, c_out);
	
endmodule