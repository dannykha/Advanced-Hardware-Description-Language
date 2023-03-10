// Danny Kha
// PA4
// Due 3/12/23
// Floating point adder

module EE427_PA4(

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);

	reg [31:0] Op1;
	reg [31:0] Op2;
	
	
	always@(*) begin
		if (SW[8] == 0) begin
			if (KEY[3] == 0) Op1[31:24] = SW[7:0];
			if (KEY[2] == 0) Op1[23:16] = SW[7:0];
			if (KEY[1] == 0) Op1[15:8] = SW[7:0];
			if (KEY[0] == 0) Op1[7:0] = SW[7:0];
		end else begin
			if (KEY[3] == 0) Op2[31:24] = SW[7:0];
			if (KEY[2] == 0) Op2[23:16] = SW[7:0];
			if (KEY[1] == 0) Op2[15:8] = SW[7:0];
			if (KEY[0] == 0) Op2[7:0] = SW[7:0];
		end
	end

	wire [31:0] result;
	
	floatingPointAdd u1_add(.op_a(Op1), .op_b(Op2), .result(result));
	assign LEDR[8] = result[31];
	assign LEDR[7:0] = result[30:23];
	Seg7 u1_hex5(.v({1'b1, result[22:20]}), .hex(HEX5));
	Seg7 u2_hex4(.v(result[19:16]), .hex(HEX4));
	Seg7 u3_hex3(.v(result[15:12]), .hex(HEX3));
	Seg7 u4_hex2(.v(result[11:8]), .hex(HEX2));
	Seg7 u5_hex1(.v(result[7:4]), .hex(HEX1));
	Seg7 u6_hex0(.v(result[3:0]), .hex(HEX0));


endmodule

module floatingPointAdd(
	input [31:0] op_a, op_b, 
	output [31:0] result
);

	// creating the sign, exponent, and mantissa
	wire sign_1;
	wire [7:0] exp_1;
	wire [23:0] f1;
	
	wire sign_2;
	wire [7:0] exp_2;
	wire [23:0] f2;
	
	// spliting the inputs into sign, exponent, and mantissa
	assign sign_1 = op_a[31];
	assign sign_2 = op_b[31];
	
	assign exp_1 = op_a[30:23];
	assign exp_2 = op_b[30:23];
	
	assign f1 = {(|(op_a[31:23])), op_a[22:0]};
	assign f2 = {(|(op_b[31:23])), op_b[22:0]};
	
	
	// exponent subtraction and mux
	wire expon_sign;
	wire [7:0] magn;
	
	exponCalc expon(.e1(exp_1), .e2(exp_2), .sign(expon_sign), .magn(magn));
	
	
	// swap section
	wire [23:0] large_f, small_f;
	
	fracSwap frac(.f1(f1), .f2(f2), .sign(expon_sign), .large_f(large_f), .small_f(small_f));
	
	
	// right shift section
	wire [23:0] shifted_f;
	
	rightShifting shiftIt(.shifting(small_f), .shiftAmt(magn), .shifted_f(shifted_f));
	
	
	// mux section
	wire [7:0] expon_res;
	
	exponMux exponChoosing(.e1(exp_1), .e2(exp_2), .sign(expon_sign), .expon_res(expon_res));
	
	
	// sign computation
	wire sR;
	
	signComp signing(.real_sign(sign_1), .sR(sR));
	
	
	// addition computation
	wire [24:0] sum;
	
	fracAddition addItUp(.f1(shifted_f), .f2(large_f), .sum(sum));
	
	
	// normalization and rounding
	wire [22:0] fR;
	wire [7:0] eR;
	
	normRound normalize(.summed(sum), .expon(expon_res), .fR(fR), .eR(eR));
	
	
	// packing!!
	assign result = {sR, eR, fR};
	
   
endmodule

// exponent calculation
module exponCalc(
	input [7:0] e1, e2,
	output sign,
	output [7:0] magn
);
	assign sign = (e1 < e2); // 1 if exponent 1 is less then and 0 if e2 is less than
	// sign = 1
	
	assign magn = (sign) ? (e2 - e1) : (e1 - e2); // finding magnitude by large - small exponents
	
endmodule


// fracton swapping
module fracSwap(
	input [23:0] f1, f2,
	input sign,
	output [23:0] large_f, small_f
);
	// sign = 1
	assign large_f = (sign) ? (f2) : (f1); // larger fraction
	assign small_f = (sign) ? (f1) : (f2); // smaller fraction

endmodule


// right shifting 
module rightShifting(
	input [23:0] shifting,
	input [7:0] shiftAmt,
	output [23:0] shifted_f
);
	assign shifted_f = shifting >> shiftAmt;

endmodule


// mux exponent
module exponMux(
	input [7:0] e1, e2,
	input sign,
	output [7:0] expon_res
);
	assign expon_res = (sign) ? e2 : e1;

endmodule


// sign creator
module signComp(
	input real_sign,
	output sR
);

	assign sR = real_sign;
	
endmodule


// fraction addition
module fracAddition(
	input [23:0] f1, f2,
	output [24:0] sum
);
	assign sum = f1 + f2;

endmodule


// normalization + rounding
module normRound(
	input [24:0] summed,
	input [7:0] expon,
	output [22:0] fR,
	output [7:0] eR
);
	assign fR = (summed[24]) ? (summed[23:1]) : (summed[22:0]);
	
	assign eR = (summed[24]) ? (expon + 1) : (expon);

endmodule