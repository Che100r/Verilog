module Lab3 (
	input start_stop,
	input reset,
	input clk
);

localparam PULS_MAX = 14'd9999;
localparam CLOCK_PULSES = 1;
localparam NUMBER_00_01_MAX = 4'd9;
localparam NUMBER_00_10_MAX = 4'd9;
localparam NUMBER_01_00_MAX = 4'd9;
localparam NUMBER_10_00_MAX = 4'd9;

reg [2:0]  start_stop_syncroniser;
reg [13:0] pulse_counter;
reg device_stopped;

always @(posedge clk)
begin
	start_stop_syncroniser[0] <= start_stop;
	start_stop_syncroniser[1] <= start_stop_syncroniser[0];
	start_stop_syncroniser[2] <= start_stop_syncroniser[1];
end

assign start_stop_pressed = ~start_stop_syncroniser[2] & start_stop_syncroniser[1];

wire pulse_counter_passed = (pulse_counter == PULS_MAX);

always @( posedge clk or posedge reset )
begin
	if(reset)
		device_stopped = 1;
	else if (start_stop_pressed)
		device_stopped = ~device_stopped;
end

always @(posedge clk or posedge reset)
begin
	if (reset)
		pulse_counter <= 0;
	else if (device_stopped == 0 | pulse_counter_passed)
		if (pulse_counter_passed)
			pulse_counter <= 0;
		else pulse_counter <= pulse_counter + CLOCK_PULSES;
end

reg [3:0] number_00_01 = 4'd0; 
wire      number_00_01_passed = ( ( number_00_01 == NUMBER_00_01_MAX ) & pulse_counter_passed );

always @( posedge clk or posedge reset )
  begin
	if (reset) 
	  number_00_01 <= 0;
	else if (pulse_counter_passed)
	  if (number_00_01_passed)
		number_00_01 <= 0;
	  else number_00_01 <= number_00_01 + 1;
  end
  
reg [3:0] number_00_10 = 4'd0; 
wire      number_00_10_passed = ( ( number_00_10 == NUMBER_00_10_MAX ) & number_00_01_passed );

always @( posedge clk or posedge reset )
  begin
	if (reset) 
	  number_00_10 <= 0;
	else if (number_00_01_passed)
	  if (number_00_10_passed)
		number_00_10 <= 0;
	  else number_00_10 <= number_00_10 + 1;
  end
  
reg [3:0] number_01_00 = 4'd0; 
wire      number_01_00_passed = ( ( number_01_00 == NUMBER_01_00_MAX ) & number_00_10_passed );

always @( posedge clk or posedge reset )
  begin
	if (reset) 
	  number_01_00 <= 0;
	else if ( number_00_10_passed )
	  if ( number_01_00_passed )
		number_01_00 <= 0;
	  else number_01_00 <= number_01_00 + 1;
  end
  
reg [3:0] number_10_00 = 4'd0; 

always @( posedge clk or posedge reset )
begin
	if (reset) 
	  	number_10_00 <= 0;
	else if ( number_01_00_passed )
		if ( number_10_00 == NUMBER_10_00_MAX )
			number_10_00 <= 0;
		else number_10_00 <= number_10_00 + 1;
end

endmodule
