// EE 427
// PA3
// Part 1
// Accumulator

module EE427_PA3_Part1(

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);

wire [7:0] accum_out; // send this to a hex displayer
wire [7:0] hex_out;

accumulate acc(.clock(KEY[0]), .reset(SW[9]), .in(SW[7:0]), .s_reg(accum_out), .led_out(LEDR[7:0]), .c_out(LEDR[8]), .overflow(LEDR[9]), .a_reg(hex_out));
Seg7 seg(.v(accum_out[7:4]), .hex(HEX1[6:0]));
Seg7 seg1(.v(accum_out[3:0]), .hex(HEX0[6:0]));
Seg7 seg2(.v(hex_out[7:4]), .hex(HEX3[6:0]));
Seg7 seg3(.v(hex_out[3:0]), .hex(HEX2[6:0]));

endmodule

module accumulate(
    input clock,
    input reset,
    input [7:0] in,
    output reg [7:0] s_reg,
    output [7:0] led_out,
	 output reg [7:0] a_reg,
    output reg c_out,
    output reg overflow
    );

    wire [7:0] accum_wire;
	 wire [7:0] led_temp;
	 wire c_out_temp;
	 
	assign {c_out_temp, accum_wire} = s_reg + a_reg;
	assign led_out = accum_wire;
	
    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            a_reg <= 8'b0;
            overflow <= 1'b0;
            c_out <= 1'b0;
			s_reg <= 8'b0;
        end else begin
			s_reg <= accum_wire;
            c_out <= c_out_temp;
			a_reg <= in;
			if ((a_reg[7] == 0 && accum_wire[7] == 1 && s_reg[7] == 0) || (a_reg[7] == 1 && accum_wire[7] == 0 && s_reg[7] == 1)) begin
				overflow <= 1'b1;
			end else begin
				overflow <= 1'b0;
			end
        end
    end
endmodule


	






