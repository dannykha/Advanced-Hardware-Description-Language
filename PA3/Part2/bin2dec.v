module bin2dec(input [3:0]  v,
				output reg[6:0] hex0, hex1);
		
	// hex0 is left digit and hex1 is right digit
	always @(*) begin
		
		case(v)
			4'b0000: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b1000000; // 0
			end
			4'b0001: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b1111001; // 1
			end
			4'b0010: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b0100100; // 2
			end
			4'b0011: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b0110000; // 3
			end
			4'b0100: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b0011001; // 4
			end
			4'b0101: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b0010010; // 5
			end
			4'b0110: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b0000010; // 6
			end
			4'b0111: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b1111000; // 7
			end
			4'b1000: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b0000000; // 8
			end
			4'b1001: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b0011000; // 9
			end
			4'b1010: begin
				hex0 = 7'b1111001; // 1
				hex1 = 7'b1000000; // 0
			end
			4'b1011: begin
				hex0 = 7'b1111001; // 1
				hex1 = 7'b1111001; // 1
			end
			4'b1100: begin
				hex0 = 7'b1111001; // 1
				hex1 = 7'b0100100; // 2
			end
			4'b1101: begin
				hex0 = 7'b1111001; // 1
				hex1 = 7'b0110000; // 3
			end
			4'b1110: begin
				hex0 = 7'b1111001; // 1
				hex1 = 7'b0011001; // 4
			end
			4'b1111: begin
				hex0 = 7'b1111001; // 1
				hex1 = 7'b0010010; // 5
			end
			default: begin
				hex0 = 7'b1000000; // 0
				hex1 = 7'b1000000; // 0
			end
		endcase
	end
	
endmodule