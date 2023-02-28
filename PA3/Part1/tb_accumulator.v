`timescale 1 ns / 100 ps

module tb_accumulator();

	reg clk, rst;
	reg [7:0] in_temp;
	wire [7:0] accum_temp;
	wire [7:0] led_temp;
	wire [7:0] hex_temp;
	wire cout_temp;
	wire ovf_temp;
	integer i;
	
	accumulate accum(.clock(clk), .reset(rst), .in(in_temp), .out(accum_temp), .led_out(led_temp), .c_out(cout_temp), .overflow(ovf_temp), .HEX_out(hex_temp));
	
	initial begin
    // test set 1 adding in 00001111 (15) for 10 times
    rst = 1;
    in_temp = 8'b00001111;
    repeat(10) begin
        #5 clk = 1;
        #5 clk = 0;
    end
    #5 rst = 0;
    #5 rst = 1;

    // test set 2: this triggers carry out and overflow
    in_temp = 8'b01111111;
    repeat(2) begin
        #5 clk = 1;
        #5 clk = 0;
    end
    // LEDR should be 1111 1110
    in_temp = 8'b00000000;
    #5 clk = 1;
    #5 clk = 0;
    // LEDR9 (overflow) turns on
    in_temp = 8'b00000001;
    #5 clk = 1;
    #5 clk = 0;
    // LEDR9 (overflow) turns off
    repeat(4) begin
        #5 clk = 1;
        #5 clk = 0;
    end
    // LEDR8 (carry out) turns on
    #5 clk = 1;
    #5 clk = 0;
    // LEDR 8 (carry out) turns off

    #5 rst = 0;
    #5 rst = 1;

    // test set 3: This test is a negative + negative = positive
    // this triggers carry out and overflow at same time
    in_temp = 8'b10000000; // -128
    #5 clk = 1;
    #5 clk = 0;
    in_temp = 8'b11111111; // -1
    #5 clk = 1;
    #5 clk = 0;
    // LEDR8 (carry out) and LEDR9 (overflow) both turn on
    // output is c_out = 1 and 0111 1111 (127)
    #5 clk = 1;
    #5 clk = 0;

    #5 rst = 0;
    #5 rst = 1;
    // test set 4: This test is a positive + positive = negative
    // this triggers overflow
    in_temp = 8'b01111111; // 127
    #5 clk = 1;
    #5 clk = 0;
    in_temp = 8'b00000001; // 1
    #5 clk = 1;
    #5 clk = 0;
    // LEDR9 (overflow) turns on 
    // output is c_out = 0 and 1000 0000 (-128)
    #5 clk = 1;
    #5 clk = 0;

    #5 rst = 0;
end
	
	
	
	
endmodule


