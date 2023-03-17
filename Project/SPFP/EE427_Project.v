// EE 427
// Project 2
// Danny Kha
// 3 stage pipelined 32-bit single precision floating-point multiplier
// Sign and exponent is calculated and pipelined according to the paper
// Multiplication is calculated using a wallace tree consiting of carry save adders


module EE427_Project(
	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

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

	// Internal signals
	wire rst_n = SW[9];
	 reg [ 4:0] r_addr_a;
	 reg [ 4:0] r_addr_b;
	wire [31:0] w_rdata_a;
	wire [31:0] w_rdata_b;
	wire [31:0] w_output;
	wire [31:0] w_result;

	// Clock divider
	clock_divider u_clock_divider (
		.i_clock (CLOCK_50),
		.reset_n (rst_n),
		.o_clock (clk)
	);

	// Read address for the A port
	always @(posedge clk, negedge rst_n) begin
		if (~rst_n) begin
			r_addr_a <= 0;
			r_addr_b <= 1;
		end else begin
			if (!KEY[0]) begin // Whenever KEY0 is pressed, the read address increases by 1 and the next operand is read
				r_addr_a <= r_addr_a + 1;
				r_addr_b <= r_addr_b + 1;
			end
		end
	end
	
	// On-chip ROM IP that provides test vectors to your design
	rom_2port u_rom(
		.address_a (r_addr_a),
		.address_b (r_addr_b), // TODO
		.clock     (clk),
		.q_a       (w_rdata_a),
		.q_b       (w_rdata_b) // TODO
	);
	
	/*Your design*/
	// Instantiate your FP multiplier design here
	sp_fp_multiplier sp_multiply(clk, rst_n, w_rdata_a, w_rdata_b, w_output);
	assign w_result = w_output; // Replace w_rdata_a with your signal
	
	// Displays
	assign LEDR[8] = w_result[31];
	assign LEDR[7:0] = w_result[30:23];
	
	seg7_driver u_hex5({1'b1, w_result[22:20]}, HEX5);
	seg7_driver u_hex4(w_result[19:16], HEX4);
	seg7_driver u_hex3(w_result[15:12], HEX3);
	seg7_driver u_hex2(w_result[11: 8], HEX2);
	seg7_driver u_hex1(w_result[ 7: 4], HEX1);
	seg7_driver u_hex0(w_result[ 3: 0], HEX0);

endmodule

// This module is the single precision floating point multiplier
module sp_fp_multiplier(
	input clk, rst_n,
	input [31:0] op_a, op_b,
	output [31:0] product
);

	// Setting up A and B parts
	wire sign_a;
	wire sign_b;
	
	wire [7:0] expon_a;
	wire [7:0] expon_b;
	
	wire [23:0] frac_a;
	wire [23:0] frac_b;
	
	assign sign_a = op_a[31];
	assign sign_b = op_b[31];
	
	assign expon_a = op_a[30:23];
	assign expon_b = op_b[30:23];
	
	assign frac_a[22:0] = op_a[22:0];
	assign frac_b[22:0] = op_b[22:0];
	
	assign frac_a[23] = 1;
	assign frac_b[23] = 1;
	
	wire [47:0] prod1;
	wire carry;
	
	// Calcultaing the signficand
	wallace_tree v1 (frac_a, frac_b, prod1, carry);

	// STAGE 1
	
	// Stage 1 registers and wires
	reg sign_stg1; // passing it on 
	reg [8:0] expon_stg1; // just the addition and before bias subtraction
	reg [47:0] frac_stg1; // middle of significand multiplier
	reg res_nan;
	wire sign_temp;
	wire [7:0] expon_temp_stg1;
	wire [7:0] expon_cout_stg1; 
	wire is_nan_a, is_nan_b; // used to check nan
	
	// checking nan 
	assign is_nan_a = &expon_a & (frac_a != 0);
	assign is_nan_b = &expon_b & (frac_b != 0);
	wire is_res_nan;
	assign is_res_nan = is_nan_a | is_nan_b;
	
	// sign 
	assign sign_temp = sign_a ^ sign_b; // XOR the signs
	
	// exponent with ripple carry adder
	// a, b, c_out, s
	// a, b, c_in, c_out, s
	half_adder ha_u1(expon_a[0], expon_b[0], expon_cout_stg1[0], expon_temp_stg1[0]);
	full_adder fa_u2(expon_a[1], expon_b[1], expon_cout_stg1[0], expon_cout_stg1[1], expon_temp_stg1[1]);
	full_adder fa_u3(expon_a[2], expon_b[2], expon_cout_stg1[1], expon_cout_stg1[2], expon_temp_stg1[2]);
	full_adder fa_u4(expon_a[3], expon_b[3], expon_cout_stg1[2], expon_cout_stg1[3], expon_temp_stg1[3]);
	full_adder fa_u5(expon_a[4], expon_b[4], expon_cout_stg1[3], expon_cout_stg1[4], expon_temp_stg1[4]);
	full_adder fa_u6(expon_a[5], expon_b[5], expon_cout_stg1[4], expon_cout_stg1[5], expon_temp_stg1[5]);
	full_adder fa_u7(expon_a[6], expon_b[6], expon_cout_stg1[5], expon_cout_stg1[6], expon_temp_stg1[6]);
	full_adder fa_u8(expon_a[7], expon_b[7], expon_cout_stg1[6], expon_cout_stg1[7], expon_temp_stg1[7]);
	
	// output stage 1
	always@(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			sign_stg1 <= 0;
			expon_stg1 <= 0;
			frac_stg1 <= 0;
			res_nan <= 0;
		end else begin
			sign_stg1 <= sign_temp;
			expon_stg1 <= {expon_cout_stg1[7], expon_temp_stg1[7:0]};
			frac_stg1 <= prod1;
			res_nan <= is_res_nan;
		end
	end
	
	
	// STAGE 2
	
	// stage 2 registers
	reg sign_stg2; // passing it on 
	reg [8:0] expon_stg2; // after the entire exponent adder (addition and subtraction of bias, done)
	reg [47:0] outm;
	reg r_ovf, r_unf;
	wire [8:0] expon_temp_stg2;
	wire [8:0] expon_cout_stg2;
	wire ovf, unf;

	// exponent subtracting the bias
	// s, bi, r, bo
	one_sub os_u1(expon_stg1[0], 1'b0, expon_temp_stg2[0], expon_cout_stg2[0]);
	one_sub os_u2(expon_stg1[1], expon_cout_stg2[0], expon_temp_stg2[1], expon_cout_stg2[1]);
	one_sub os_u3(expon_stg1[2], expon_cout_stg2[1], expon_temp_stg2[2], expon_cout_stg2[2]);
	one_sub os_u4(expon_stg1[3], expon_cout_stg2[2], expon_temp_stg2[3], expon_cout_stg2[3]);
	one_sub os_u5(expon_stg1[4], expon_cout_stg2[3], expon_temp_stg2[4], expon_cout_stg2[4]);
	one_sub os_u6(expon_stg1[5], expon_cout_stg2[4], expon_temp_stg2[5], expon_cout_stg2[5]);
	one_sub os_u7(expon_stg1[6], expon_cout_stg2[5], expon_temp_stg2[6], expon_cout_stg2[6]);
	z_sub zs_u1(expon_stg1[7], expon_cout_stg2[6], expon_temp_stg2[7], expon_cout_stg2[7]);
	z_sub zs_u2(expon_stg1[8], expon_cout_stg2[7], expon_temp_stg2[8], expon_cout_stg2[8]);
		
	// checking overflow and underflow
	assign ovf = expon_temp_stg2[8] | res_nan;
	assign unf = expon_cout_stg2[8];
	
	// input stage 2
	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			sign_stg2 <= 0;
			expon_stg2 <= 0;
			outm <= 0;
			r_ovf <= 0;
			r_unf <= 0;
		end begin
			sign_stg2 <= sign_stg1;
			expon_stg2 <= expon_temp_stg2;
			outm <= frac_stg1;
			r_ovf <= ovf;
			r_unf <= unf;
		end
	end

	
	// STAGE 3
	
	// stage 3 registers
	reg [31:0] fin_out;

	// input stage 3
	always@(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			fin_out <= 0;
		end else begin
			if (r_unf) begin
				fin_out <= {sign_stg2, 31'b00000000_000_0000_0000_0000_0000_0000}; // +/- 0 for underflow
			end else if (r_ovf) begin
				fin_out <= {sign_stg2, 31'b11111111_000_0000_0000_0000_0000_0000}; // +/- infinity for overflow
			end else begin
				fin_out <= (outm[47] == 1'b1) ? ({sign_stg2, expon_stg2[7:0] + 1'b1, outm[46:24]}) : ({sign_stg2, expon_stg2[7:0], outm[45:23]});
			end
		end
	end
	
	// assigning all together
	assign product = fin_out;

endmodule

// This module converts a 4-bit binary number into a hex digit for a 7-segment display
module seg7_driver (
	 input [3:0] hex,
	output [6:0] led
);

	assign led[6] = (~hex[3] & ~hex[2] & ~hex[1]) | (hex[3] & hex[2] & ~hex[1] & ~hex[0]) | (~hex[3] & hex[2] & hex[1] & hex[0]);
	assign led[5] = (~hex[3] & ~hex[2] & hex[0]) | (~hex[3] & ~hex[2] & hex[1]) | (~hex[3] & hex[1] & hex[0]) | (hex[3] & hex[2] & ~hex[1] & hex[0]);
	assign led[4] = (~hex[3] & hex[0]) | (~hex[3] & hex[2] & ~hex[1]) | (~hex[2] & ~hex[1] & hex[0]);
	assign led[3] = (hex[2] & hex[1] & hex[0]) | (~hex[3] & hex[2] & ~hex[1] & ~hex[0]) | (~hex[2] & ~hex[1] & hex[0]) | (hex[3] & ~hex[2] & hex[1] & ~hex[0]);
	assign led[2] = (hex[3] & hex[2] & ~hex[0]) | (hex[3] & hex[2] & hex[1]) | (~hex[3] & ~hex[2] & hex[1] & ~hex[0]);
	assign led[1] = (hex[3] & hex[1] & hex[0]) | (hex[2] & hex[1] & ~hex[0]) | (hex[3] & hex[2] & ~hex[0]) | (~hex[3] & hex[2] & ~hex[1] & hex[0]);
	assign led[0] = (~hex[3] & hex[2] & ~hex[1] & ~hex[0]) | (~hex[3] & ~hex[2] & ~hex[1] & hex[0]) | (hex[3] & hex[2] & ~hex[1] & hex[0]) | (hex[3] & ~hex[2] & hex[1] & hex[0]);

endmodule


// This module is used to lower the clock frequency
module clock_divider (
	input i_clock,
	input reset_n,
	output reg o_clock
);

	reg [31:0] cnt;

	always @(posedge i_clock, negedge reset_n) begin
		if (!reset_n) begin
			cnt <= 0;
		end else begin
			if (cnt == 5000000) begin
				cnt <= 0;
			end else begin
				cnt <= cnt + 1; // the cnt value is incremented by 1 whenever i_clock changes from 0 to 1
			end
		end
	end

	always @(posedge i_clock, negedge reset_n) begin
		if (!reset_n) begin
			o_clock <= 1;
		end else begin
			if (cnt == 5000000) begin
				o_clock <= ~o_clock; // o_clock is flipped when the cnt value is 5000000
			end
		end
	end

endmodule
