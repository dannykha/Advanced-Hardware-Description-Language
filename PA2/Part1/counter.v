module counter(Clock, Reset_n, Q, rollover);
	parameter n = 4; // default value is 4
	parameter k = 10; // default value is 10
	
	input Clock, Reset_n;
	output reg [n-1:0] Q;
	output reg rollover;
	
	initial begin
		Q = 0;
		rollover = 0;
	end

	always @(posedge Clock or negedge Reset_n)
	begin
		
		if(!Reset_n) begin
			Q <= 1'd0;
			rollover <= 0;
		end else if(Q == k - 1) begin
			Q <= 0;
			rollover <= 0;
		else if(Q == k - 2) begin
			Q <= Q + 1'b1;
			rollover <= 1'b1;
		end
		else
			Q <= Q + 1'b1;
	end
endmodule