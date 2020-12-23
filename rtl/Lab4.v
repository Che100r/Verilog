module Lab4 (
	input clk,
	input reset,
	input button
);

localparam yellow = 3'b000;
localparam yellow_blinking = 3'b001;
localparam green = 3'b010;
localparam green_blinking = 3'b011;
localparam red = 3'b100;
localparam red_and_yellow = 3'b101;
localparam crosswalk = 3'b110;

reg [2:0] state;
reg [2:0] next_state;
reg work;

always @(posedge clk) begin
	if (reset) begin
		state <= yellow_blinking;
		work <= 0;
	end
	else begin
		state = next_state;
		work <= 1;
	end
end

reg [2:0] button_syncroniser;

always @(posedge clk)
begin
	button_syncroniser[0] <= !button;
	button_syncroniser[1] <= button_syncroniser[0];
	button_syncroniser[2] <= button_syncroniser[1];
end

assign button_pressed = ~button_syncroniser[2] & button_syncroniser[1];
reg [3:0] counter;
reg crosswalk_button;

always @(*) begin
	if (reset)
		crosswalk_button = 0;
	else if (button_pressed)
		crosswalk_button = 1;
	else if (state == crosswalk)
		crosswalk_button = 0;
end

always @(posedge clk) begin
	if (work == 0) begin
		next_state <= yellow_blinking;
		counter = 4'd0;
	end else begin
	case (state)
		yellow_blinking: if (work)
			next_state <= green;

		green: if (counter == 4'd15) begin
			next_state <= green_blinking;
			counter = 0;
		end else begin
			counter = counter + 1;
			next_state <= green;
		end

		green_blinking: if (counter == 4'd5) begin
			next_state <= yellow;
			counter = 0;
		end else begin
			counter = counter + 1;
			next_state <= green_blinking;
		end

		yellow: if (counter == 4'd3) begin
			next_state <= red;
			counter = 0;
		end else begin
			counter = counter + 1;
			next_state <= yellow;
		end

		red: if (crosswalk_button)
			next_state <= crosswalk;
		else if (counter == 4'd10) begin
			next_state <= red_and_yellow;
			counter = 0;
		end else begin
			counter = counter + 1;
			next_state <= red;
		end

		red_and_yellow: if (counter == 4'd5) begin
			next_state <= green;
			counter = 0;
		end else begin
			counter = counter + 1;
			next_state <= red_and_yellow;
		end

		crosswalk: if (counter == 4'd10) begin
			next_state <= red_and_yellow;
			counter = 0;
		end else begin
			counter = counter + 1;
			next_state <= crosswalk;
		end
	endcase
	end
end
endmodule
