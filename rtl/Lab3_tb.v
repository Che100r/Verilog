`timescale 1ns / 1ps
module Lab3_tb();

localparam CLK_FREQ_MHZ   = 100;
localparam CLK_SEMIPERIOD = ( 1000 / CLK_FREQ_MHZ ) / 2;

reg clk;
reg reset;
reg start_stop;

Lab3 DUT
(
	.clk (clk),
	.reset (reset),
	.start_stop (start_stop)
);

initial begin
	clk = 1'b1;
	forever begin
		#CLK_SEMIPERIOD clk=~clk;
	end
end

initial begin
	forever begin
		start_stop = 1;
		#( 20 * CLK_SEMIPERIOD );
		start_stop = 0;
		#( 2 * CLK_SEMIPERIOD );
		start_stop = 1;
	end
end

initial begin
	reset = 1'b0;
	#( 2 * CLK_SEMIPERIOD );
	reset = 1'b1;
	#( 4 * CLK_SEMIPERIOD );
	reset = 1'b0;
end

endmodule
