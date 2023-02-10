//  This  module  is  used  to  lower  the  clock  frequency  (from  50MHz  to  0.25Hz)  or  increase  the  clock 
// period (from 1/(50 x 10^6) seconds to 4 seconds) 
module clock_divider ( 
     input i_clock, 
     input reset_n, 
     output reg o_clock 
); 
 
     reg [27:0] cnt; 
 
     always @(posedge i_clock) begin 
          if (~reset_n) begin 
               cnt <= 0; 
          end else begin 
               if (cnt == 1000000)cnt <= 0; 
               else cnt <= cnt + 1; // the cnt value increases by 1 whenever i_clock changes from 0 to 1 
          end 
     end 
 
     always @(posedge i_clock) begin 
          if (~reset_n) begin 
               o_clock <= 0; 
          end else begin 
               if (cnt == 1000000)begin 
                    o_clock <= ~o_clock; // o_clock is flipped when the cnt value is 100000000 
               end 
          end 
     end 
 
endmodule