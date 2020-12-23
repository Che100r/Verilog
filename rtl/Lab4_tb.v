`timescale 1ns / 1ps
module Lab4_tb();

localparam CLK_FREQ_MHZ   = 100;
localparam CLK_SEMIPERIOD = ( 1000 / CLK_FREQ_MHZ ) / 2;

reg clk;
reg reset;
reg button;

Lab4 DUT
(
	.clk (clk),
	.reset (reset),
	.button (button)
);

initial begin
	clk = 1'b1;
	forever begin
		#CLK_SEMIPERIOD clk=~clk;
	end
end

initial begin
	forever begin
		button = 0;
		#( 100 * CLK_SEMIPERIOD );
		button = 1;
		#( 2 * CLK_SEMIPERIOD );
		button = 0;
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
