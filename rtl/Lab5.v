module Lab5 (
    input clk,
    input reset,
    input button
);

reg [2:0] button_syncroniser;
reg [7:0] counter;

always @(posedge clk)
begin
	button_syncroniser[0] <= button;
	button_syncroniser[1] <= button_syncroniser[0];
	button_syncroniser[2] <= button_syncroniser[1];
end

assign button_pressed = ~button_syncroniser[2] & button_syncroniser[1];

always@ (posedge clk) begin
    if (reset) begin
        counter <= 0;
    end else if (button_pressed) begin
        counter <= counter + 1;
    end
end

fifo fifo_input_buffer(
    .clk(clk),
    .reset(reset),
    .data_in(counter)
);

endmodule
