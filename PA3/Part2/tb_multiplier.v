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
			#10;
			rst = 1;
			for (i = 0; i <= 15; i = i + 1) begin
				a_temp = a_temp + 1'b1;
				b_temp = b_temp + 1'b1;
				#10;
			end
			#50;
			rst = 0;
		end
		always #5 clk = ~clk;

endmodule