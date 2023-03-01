`timescale 1 ns / 100 ps

module tb_multiplier();

		reg clk, rst;
		reg [3:0] a_temp;
		reg [3:0] b_temp;
		wire [7:0] result_temp;
		integer i;
		
		pipeline u_test(.data_a(a_temp), .data_b(b_temp), .clk(clk), .rst_n(rst), .result(result_temp));
		
		initial begin
			clk = 0;
			rst = 0;
			a_temp = 4'b0000;
			b_temp = 4'b0000;
			#10 rst = 1;
			a_temp = 4'b0001;
			b_temp = 4'b0001;
			#10
			a_temp = 4'b0010;
			b_temp = 4'b0010;
			#10
			a_temp = 4'b0011;
			b_temp = 4'b0011;
			#10
			a_temp = 4'b0100;
			b_temp = 4'b0100;
			#10
			a_temp = 4'b0101;
			b_temp = 4'b0101;
			#10
			a_temp = 4'b0110;
			b_temp = 4'b0110;
			#10
			a_temp = 4'b0111;
			b_temp = 4'b0111;
			#10
			a_temp = 4'b1000;
			b_temp = 4'b1000;
			#10
			a_temp = 4'b1001;
			b_temp = 4'b1001;
			#50
			rst = 0;
		end
		always #5 clk = ~clk;

endmodule