`timescale 1 ns / 100 ps

module tb_counter();

	parameter n =5;
	parameter k = 20;

	reg Clock, Reset_n;
	integer i;
	
	counter #(.n(5), .k(20)) u_test(.Clock(Clock), .Reset_n(Reset_n), .Q(), .rollover());
	
	initial begin
		Clock = 0;
		Reset_n = 1;
		for (i = 0; i <= 100; i = i + 1) begin
			#5 Clock = 1;
			#5 Clock = 0;
		end
		#5 Reset_n = 0;
		#5 Reset_n = 1;
	end
endmodule