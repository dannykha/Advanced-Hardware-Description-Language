// EE 427
// PA3 Part 2
// 4-bit unsigned multiplier converted into 4-stage pipleine

module EE427_PA3_Part2(

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

wire [7:0] product; // product of multiplication

pipeline u_pipeline(.clk(KEY[0]), .rst_n(SW[9]), .data_a(SW[7:4]), .data_b(SW[3:0]), .result(LEDR[7:0]));
bin2dec u_inputA(.v(SW[7:4]), .hex0(HEX3[6:0]), .hex1(HEX2[6:0]));
bin2dec u_inputB(.v(SW[3:0]), .hex0(HEX1[6:0]), .hex1(HEX0[6:0]));

endmodule

module pipeline(
	input clk, rst_n,
	input [3:0] data_a, data_b,
	output reg [7:0] result
);

	// output registers
	reg [3:0] reg_and_stg1; // used in stage 1 as register
	reg [3:0] reg_fa_stg2, reg_fa_stg3; // used in stage 2, 3 as register and stage 4 register is result itself
	
	reg [3:0] reg_p0_stg2, reg_p0_stg3; // reg for p0 after the first cycle to keep passing
	
	reg [3:0] reg_p1_stg3; // reg for p1 after the second stage to keep passing
	reg [3:0] reg_cout_stg2, reg_cout_stg3; // reg for cout 
	
	reg [3:0] reg_dataA_stg1, reg_dataB_stg1; // used for stage 1 data passing
	reg [3:0] reg_dataA_stg2, reg_dataB_stg2; // used for stage 2 data passing
	reg [3:0] reg_dataA_stg3, reg_dataB_stg3; // used for stage 3 data passing
	
	// wires
	wire [3:0] and_stg1, and_stg2, and_stg3, and_stg4;
	wire [3:0] cout_stg2, cout_stg3, cout_stg4;
	wire [3:0] fa_stg2, fa_stg3, fa_stg4;
	
	// stage 1
	assign and_stg1 = data_a & {4{data_b[0]}};
	
	// output stage 1
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			reg_and_stg1 <= 0;
		end else begin
			// cycle 1
			reg_and_stg1 <= and_stg1;
		end
	end
	
	// input stage 1
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			reg_dataA_stg1 <= 0;
			reg_dataB_stg1 <= 0;
		end else begin
			reg_dataA_stg1 <= data_a;
			reg_dataB_stg1 <= data_b;
		end
	end
	
	// stage 2
	assign and_stg2 = reg_dataA_stg1 & {4{reg_dataB_stg1[1]}};
	
	fa fa_stage2_0(reg_and_stg1[1], and_stg2[0], 1'b0, cout_stg2[0], fa_stg2[0]); // far right
	fa fa_stage2_1(reg_and_stg1[2], and_stg2[1], cout_stg2[0], cout_stg2[1], fa_stg2[1]);
	fa fa_stage2_2(reg_and_stg1[3], and_stg2[2], cout_stg2[1], cout_stg2[2], fa_stg2[2]);
	fa fa_stage2_3(1'b0, and_stg2[3], cout_stg2[2], cout_stg2[3], fa_stg2[3]); // far left
	
	// output stage 2
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			reg_cout_stg2 <= 0;
			reg_p0_stg2 <= 0;
			reg_fa_stg2 <= 0;
		end else begin
			// cycle 2
			reg_cout_stg2 <= cout_stg2;
			reg_p0_stg2 <= reg_and_stg1;
			reg_fa_stg2 <= fa_stg2;
		end
	end
	
	// input stage 2
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			reg_dataA_stg2 <= 0;
			reg_dataB_stg2 <= 0;
		end else begin
			reg_dataA_stg2 <= reg_dataA_stg1;
			reg_dataB_stg2 <= reg_dataB_stg1;
		end
	end
	
	// stage 3
	assign and_stg3 = reg_dataA_stg2 & {4{reg_dataB_stg2[2]}};
	
	fa fa_stage3_0(and_stg3[0], reg_fa_stg2[1], 1'b0, cout_stg3[0], fa_stg3[0]); // far right
	fa fa_stage3_1(and_stg3[1], reg_fa_stg2[2], cout_stg3[0], cout_stg3[1], fa_stg3[1]);
	fa fa_stage3_2(and_stg3[2], reg_fa_stg2[3], cout_stg3[1], cout_stg3[2], fa_stg3[2]);
	fa fa_stage3_3(and_stg3[3], reg_cout_stg2[3], cout_stg3[2], cout_stg3[3], fa_stg3[3]); // far left
	
	// output stage 3
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			reg_cout_stg3 <= 0;
			reg_p0_stg3 <= 0;
			reg_p1_stg3 <= 0;
			reg_fa_stg3 <= 0;
		end else begin
			// cycle 3
			reg_cout_stg3 <= cout_stg3;
			reg_p0_stg3 <= reg_p0_stg2;
			reg_p1_stg3 <= reg_fa_stg2;
			reg_fa_stg3 <= fa_stg3;
		end
	end
	
	// input stage 3
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			reg_dataA_stg3 <= 0;
			reg_dataB_stg3 <= 0;
		end else begin
			reg_dataA_stg3 <= reg_dataA_stg2;
			reg_dataB_stg3 <= reg_dataB_stg2;
		end
	end
	
	// stage 4
	assign and_stg4 = reg_dataA_stg3 & {4{reg_dataB_stg3[3]}};
	
	fa fa_stage4_0(and_stg4[0], reg_fa_stg3[1], 1'b0, cout_stg4[0], fa_stg4[0]); // far right
	fa fa_stage4_1(and_stg4[1], reg_fa_stg3[2], cout_stg4[0], cout_stg4[1], fa_stg4[1]);
	fa fa_stage4_2(and_stg4[2], reg_fa_stg3[3], cout_stg4[1], cout_stg4[2], fa_stg4[2]);
	fa fa_stage4_3(and_stg4[3], reg_cout_stg3[3], cout_stg4[2], cout_stg4[3], fa_stg4[3]); // far left
	
	// output stage 4
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			result <= 0;
		end else begin
			// cycle 4
			result <= {cout_stg4[3], fa_stg4[3:0], reg_fa_stg3[0], reg_p1_stg3[0], reg_p0_stg3[0]};
		end 
	end
	
endmodule


module fa(
	input a, b, c_in,
	output c_out, s
);

	assign c_out = (a & b) | (b & c_in) | (c_in & a);
	assign s = a ^ b ^ c_in;

endmodule