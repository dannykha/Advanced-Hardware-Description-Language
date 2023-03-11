//module testing_stuff#(parameter width = 23)(
////	input clk, rst_n,
//	input [width - 1:0] op1, op2,
//	output [(2 * width) - 1:0] product
//);
//	
//	// ha = a, b, c_out, s
//	// fa = a, b, c_in, c_out, s
//	
//	wire and_tmp;
//	
//	assign and_tmp = op1[0] & op2[0];
//	
//	wire [width - 1:0] cout_tmp [width - 1:0];
//	wire [width - 1:0] s_tmp [width - 1:0];
//	
//	// this is working
//	genvar h;
//	generate
//		for (h = 1; h < width; h = h + 1) begin : ha_block
//			half_adder ha_u1(.a(op1[h - 1] & op2[1]), .b(op1[h] & op2[0]), .c_out(cout_tmp[0][h - 1]), .s(s_tmp[0][h - 1]));
//		end
//	endgenerate
//	
//	// ha = a, b, c_out, s
//	// fa = a, b, c_in, c_out, s
//	
//	genvar k, m;
//	generate
//		for (k = 1; k < width - 1; k = k + 1) begin : fa_middle1
//			for (m = 0; m < width; m = m + 1) begin : fa_middle2
//				full_adder fa_u1(
//				// Ground A if we're at the last adder in chain
//				.a((m == width - 1) ? (op1[22] & op2[k]) : (s_tmp[k - 1][m + 1])),
//				.b(op1[m] & op2[k + 1]),
//				.c_in(cout_tmp[k - 1][m]),
//				.c_out(cout_tmp[k][m]),
//				.s(s_tmp[k][m])
//			 );
//		  end
//		end
//	endgenerate
//
//
//	genvar n;
//	
//	// manually doing first half adder
//	half_adder ha_u2(.a(cout_tmp[21][0]), .b(s_tmp[21][1]), .c_out(cout_tmp[22][0]), .s(s_tmp[22][0]));
//	
//	generate
//		for (n = 1; n < width; n = n + 1) begin : fa_last
//			full_adder fa_u2(
//				.a((n == width - 1) ? (op1[22] & op2[22]) : (s_tmp[21][n + 1])),
//				.b(cout_tmp[21][n]),
//				.c_in(cout_tmp[22][n - 1]),
//				.c_out(cout_tmp[22][n]),
//				.s(s_tmp[22][n])
//			);
//		end
//	endgenerate
//	
//	reg [(2 * width) - 1:0] res;
//	
//	always@(*) begin
//		res = {cout_tmp[22][22], s_tmp[22][22:0], s_tmp[21][0], s_tmp[20][0], s_tmp[19][0], s_tmp[18][0],
//		s_tmp[17][0], s_tmp[16][0], s_tmp[15][0], s_tmp[14][0], s_tmp[13][0], s_tmp[12][0], s_tmp[11][0], s_tmp[10][0], s_tmp[9][0],
//		s_tmp[8][0], s_tmp[7][0], s_tmp[6][0], s_tmp[5][0], s_tmp[4][0], s_tmp[3][0], s_tmp[2][0], s_tmp[1][0], s_tmp[0][0], and_tmp};
//	end
//	
//	assign product = res;
//	
//endmodule

//module fp_multiplier(
//	input clk, rst_n,
//	input [31:0] op_a, op_b,
//	output [31:0] product
//);
//
//	// Setting up A and B parts
//	wire sign_a;
//	wire sign_b;
//	
//	wire [7:0] expon_a;
//	wire [7:0] expon_b;
//	
//	wire [23:0] frac_a;
//	wire [23:0] frac_b;
//	
//	assign sign_a = op_a[31];
//	assign sign_b = op_b[31];
//	
//	assign expon_a = op_a[30:23];
//	assign expon_b = op_b[30:23];
//	
//	assign frac_a = op_a[22:0];
//	assign frac_b = op_b[22:0];
//	
//	assign frac_a[23] = 1;
//	assign frac_b[23] = 1;
//		
//	// STAGE 1
//	// Stage 1 registers and wires
//	reg sign_stg1; // passing it on 
//	reg [8:0] expon_stg1; // just the addition and before bias subtraction
//	reg [45:0] frac_stg1; // middle of significand multiplier
//	wire sign_temp;
//	wire [8:0] expon_temp_stg1;
//	wire [7:0] expon_cout_stg1;
//	wire [47:0] prod1;
//	wire carry;
//	
//	// sign 
//	assign sign_temp = sign_a ^ sign_b; // XOR the signs
//	
//	// exponent with ripple carry adder
//	// a, b, c_out, s
//	// a, b, c_in, c_out, s
//	half_adder ha_u1(expon_a[0], expon_b[0], expon_cout_stg1[0], expon_temp_stg1[0]);
//	full_adder fa_u2(expon_a[1], expon_b[1], expon_cout_stg1[0], expon_cout_stg1[1], expon_temp_stg1[1]);
//	full_adder fa_u3(expon_a[2], expon_b[2], expon_cout_stg1[1], expon_cout_stg1[2], expon_temp_stg1[2]);
//	full_adder fa_u4(expon_a[3], expon_b[3], expon_cout_stg1[2], expon_cout_stg1[3], expon_temp_stg1[3]);
//	full_adder fa_u5(expon_a[4], expon_b[4], expon_cout_stg1[3], expon_cout_stg1[4], expon_temp_stg1[4]);
//	full_adder fa_u6(expon_a[5], expon_b[5], expon_cout_stg1[4], expon_cout_stg1[5], expon_temp_stg1[5]);
//	full_adder fa_u7(expon_a[6], expon_b[6], expon_cout_stg1[5], expon_cout_stg1[6], expon_temp_stg1[6]);
//	full_adder fa_u8(expon_a[7], expon_b[7], expon_cout_stg1[6], expon_temp_stg1[8], expon_temp_stg1[7]);
//	
//	// significand
//	wallace_tree v1 (frac_a, frac_b, prod1, carry);
//	
//	// output stage 1
//	always@(posedge clk, negedge rst_n) begin
//		if (!rst_n) begin
//			sign_stg1 <= 0;
//			expon_stg1 <= 0;
//			frac_stg1 <= 0;
//		end else begin
//			sign_stg1 <= sign_temp;
//			expon_stg1 <= expon_temp_stg1;
//		end
//	end
//	
//	
//	// STAGE 2
//	// stage 2 registers
//	reg sign_stg2; // passing it on 
//	reg [8:0] expon_stg2; // after the entire exponent adder (addition and subtraction of bias, done)
//	reg [45:0] frac_stg2; // after the entire significand multiplier
//	wire [8:0] expon_temp_stg2;
//	wire [8:0] expon_cout_stg2;
//
//	// exponent subtracting the bias
//	// s, bi, r, bo
//	one_sub os_u1(expon_stg1[0], 1'b0, expon_temp_stg2[0], expon_cout_stg2[0]);
//	one_sub os_u2(expon_stg1[1], expon_cout_stg2[0], expon_temp_stg2[1], expon_cout_stg2[1]);
//	one_sub os_u3(expon_stg1[2], expon_cout_stg2[1], expon_temp_stg2[2], expon_cout_stg2[2]);
//	one_sub os_u4(expon_stg1[3], expon_cout_stg2[2], expon_temp_stg2[3], expon_cout_stg2[3]);
//	one_sub os_u5(expon_stg1[4], expon_cout_stg2[3], expon_temp_stg2[4], expon_cout_stg2[4]);
//	one_sub os_u6(expon_stg1[5], expon_cout_stg2[4], expon_temp_stg2[5], expon_cout_stg2[5]);
//	one_sub os_u7(expon_stg1[6], expon_cout_stg2[5], expon_temp_stg2[6], expon_cout_stg2[6]);
//	z_sub zs_u1(expon_stg1[7], expon_cout_stg2[6], expon_temp_stg2[7], expon_cout_stg2[7]);
//	z_sub zs_u2(expon_stg1[8], expon_cout_stg2[7], expon_temp_stg2[8], expon_cout_stg2[8]);
//	
//	// sigifnicand
//	
//	// input stage 2
//	always@(posedge clk, negedge rst_n) begin
//		if(!rst_n) begin
//			sign_stg2 <= 0;
//			expon_stg2 <= 0;
//		end else begin
//			sign_stg2 <= sign_stg1;
//			expon_stg2 <= expon_temp_stg2;
//		end
//	end
//	
//	
//	
//	
//	
//	// STAGE 3
//	
//	// stage 3 registers
//	reg sign_stg3; // passing it on
//	reg [8:0] expon_stg3; // using for normalization
//	reg [45:0] frac_stg3; // using for normalization
//	
//	// input stage 3
//	always@(posedge clk, negedge rst_n) begin
//		if(!rst_n) begin
//			sign_stg3 <= 0;
//		end else begin
//			sign_stg3 <= sign_stg2;
//		end
//	end
//	
//	round rr (clk,reset,outm,routm);
//
//	
//endmodule

// NOTES
// SO FAR IT IS 2 PIPELINE STAGEs
// the multiplier works fine with the CSA, FA, and RCA so wallace tree is good
// now need to do the exponents and sign

module testing_stuff(clk,reset,a,b,fprod);
parameter w=32;
input [w-1:0] a,b;
input clk,reset;

output  [w-1:0] fprod;

wire [w-1:0]s1,s2;
wire [w-1-8:0] m1,m2;
wire [w-1-6:0] routm;
wire [w-1-24:0] e1,e2,oe;
wire signa,signb,carry;

wire [47:0] prod1;
reg [7:0] oute;
reg signout;
reg [47:0] prod;
 reg [w-1-6:0]outm;

  assign s1=a;
  assign s2=b;
  assign e1=s1[30:23];
  assign e2=s2[30:23];
  assign m1[23]=1;
  assign m1[22:0]=s1[22:0];
  assign m2[23]=1;
  assign m2[22:0]=s2[22:0];
  assign signa=s1[31];
  assign signb=s2[31];

smallalu ee(0,clk,reset,e1,e2,oe);
//assign oute=oe+7'b01111111;
//assign signout=(signa^signb);

wallace_tree v1 (m1, m2, prod1, carry);

//wallacemultiplier(carryf,product1,inp1,inp2);

always @ (posedge clk)
begin
if (reset)
begin
outm=26'b0;
oute=8'b0;
signout=1'b0;
prod=48'b0;
end
else if (prod1[47])
begin
prod=prod1>>1;
outm=prod[46:20];
oute=oe+8'b01111111+8'b00000001;
signout=(signa^signb);

end
else
begin
outm=prod1[47:21];
oute=oe+8'b01111111+8'b00000010;
signout=(signa^signb);

end



end//always

round rr (clk,reset,outm,routm);

assign fprod[31]=signout;
assign fprod[30:23]=oute;
assign fprod[22:0]=routm[24:2];

endmodule

module round(clk,reset,a,out);
parameter width=26;

input clk,reset;
input [width-1:0] a;
output reg [width-1:0] out;

reg [width-1:0] temp;




always @ (posedge clk)
begin
if (reset)
out=26'b0;
else
begin
  case (a[2:0])
      3'b000  : begin
					out=a; //round to zero
					end
		3'b001	: begin
					 out=a; //round to zero
					end
		3'b010   : begin
					out=a; //round to zero
					end
										
      3'b011  : begin
                  out={a[25:3] ,3'b100};
					end
      3'b100  : begin
                  out={a[25:3] ,3'b100};
               end
      3'b101 : begin
                out={a[25:3] ,3'b100};
               end
		3'b110 :begin
					temp={a[25:3] ,3'b100};
					out[25:2]=temp[25:2]+1;
					out[1:0]=2'b0;
					 end
		3'b111:begin
					temp={a[25:3] ,3'b100};
					out[25:2]=temp[25:2]+1;
					out[1:0]=2'b0; 
					 end
					
      default: begin
                 out=a; 
               end
   endcase
end
end

endmodule

module smallalu(sel,clk,reset,a,b,out );

parameter width=8;
  input        [1:0] sel ;
  input         reset,     clk;
  input        [width-1:0] a;
  input        [width-1:0] b;
  output reg   [width-1:0] out;

wire [7:0] MUX [0:3];

assign MUX[0] = a+b;
assign MUX[1] = a-b;
assign MUX[2] = a^b;
assign MUX[3] = a&b;

always@(posedge clk)
begin
if (reset)
  out<=7'b0;
  else
  out <= MUX[sel];
end
 endmodule 

module wallace_tree(
	input [23:0] op1, op2, 
	output [47:0] product, 
	output carry
);

	wire [47:0] prod_tmp;
	
	wire [49:0] p [23:0];

	wire [49:0] carry_tmp [22:1];

	wire [49:0] sum_tmp [22:1];
	
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
	
	carry_save_adder c1(p[0], p[1], p[2], sum_tmp[1], carry_tmp[1]);

	carry_save_adder c2(p[3], p[4], p[5], sum_tmp[2], carry_tmp[2]);

	carry_save_adder c3(p[6], p[7], p[8], sum_tmp[3], carry_tmp[3]);

	carry_save_adder c4(p[9], p[10], p[11], sum_tmp[4], carry_tmp[4]);

	carry_save_adder c5(p[12], p[13], p[14], sum_tmp[5], carry_tmp[5]);

	carry_save_adder c6(p[15], p[16], p[17], sum_tmp[6], carry_tmp[6]);

	carry_save_adder c7(p[18], p[19], p[20], sum_tmp[7], carry_tmp[7]);

	carry_save_adder c8(p[21], p[22], p[23], sum_tmp[8], carry_tmp[8]);
	
	carry_save_adder c9(sum_tmp[1], carry_tmp[1], sum_tmp[2], sum_tmp[9], carry_tmp[9]);

	carry_save_adder c10(carry_tmp[2], sum_tmp[3], carry_tmp[3], sum_tmp[10], carry_tmp[10]);

	carry_save_adder c11(sum_tmp[4], carry_tmp[4], sum_tmp[5], sum_tmp[11], carry_tmp[11]);

	carry_save_adder c12(carry_tmp[5], sum_tmp[6], carry_tmp[6], sum_tmp[12], carry_tmp[12]);

	carry_save_adder c13(sum_tmp[7], carry_tmp[7], sum_tmp[8], sum_tmp[13], carry_tmp[13]);

	carry_save_adder c14(sum_tmp[9], carry_tmp[9], sum_tmp[10], sum_tmp[14], carry_tmp[14]);

	carry_save_adder c15(carry_tmp[10], sum_tmp[11], carry_tmp[11], sum_tmp[15], carry_tmp[15]);

	carry_save_adder c16(sum_tmp[12], carry_tmp[12], sum_tmp[13], sum_tmp[16], carry_tmp[16]);

	carry_save_adder c17(sum_tmp[14], carry_tmp[14], sum_tmp[15], sum_tmp[17], carry_tmp[17]);

	carry_save_adder c18(carry_tmp[15], sum_tmp[16], carry_tmp[16], sum_tmp[18], carry_tmp[18]);

	carry_save_adder c19(sum_tmp[17], carry_tmp[17], sum_tmp[18], sum_tmp[19], carry_tmp[19]);

	carry_save_adder c20(carry_tmp[18], carry_tmp[13], carry_tmp[8], sum_tmp[20], carry_tmp[20]);

	carry_save_adder c21(sum_tmp[19], carry_tmp[19], sum_tmp[20], sum_tmp[21], carry_tmp[21]);

	carry_save_adder c22(sum_tmp[21], carry_tmp[21], carry_tmp[20], sum_tmp[22], carry_tmp[22]);
	
	rca24bit add1(sum_tmp[22], carry_tmp[22], 1'b0, prod_tmp, carry);

	assign product = prod_tmp[47:0];

endmodule

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
			full_adder f1(op1[i], op2[i], op3[i], sum[i], carry[i + 1]);
		end
	endgenerate
endmodule


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
			full_adder f1(op1[i], op2[i], c_tmp[i], sum[i], c_tmp[i+1]);
		end
	endgenerate
endmodule



//module full_adder(a,b,cin,sout,cout);
//input a,b,cin;
//output sout,cout;
//assign sout=a^b^cin;
//assign cout=(a&b)|(b&cin)|(cin&a);
//
//endmodule

// This module is a full adder
module full_adder (
	input a, b, c_in,
	output s, c_out
);

	assign c_out = (a & b) | (b & c_in) | (c_in & a);
	assign s = a ^ b ^ c_in;
	
endmodule

// This module is a half adder
module half_adder (
	input a, b,
	output c_out, s
);

	assign c_out = a & b;
	assign s = a ^ b;

endmodule
