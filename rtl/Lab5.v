module Lab5 (
    input clk,
    input reset,
    input buttonWrite,
    input buttonRead
);

reg [2:0] button_syncroniser_write;
reg [2:0] button_syncroniser_read;
reg [15:0] counter;
reg write;
reg read;
wire empty;
wire full;

always @(posedge clk)
begin
	button_syncroniser_write[0] <= buttonWrite;
	button_syncroniser_write[1] <= button_syncroniser_write[0];
	button_syncroniser_write[2] <= button_syncroniser_write[1];
end

always @(posedge clk)
begin
	button_syncroniser_read[0] <= buttonRead;
	button_syncroniser_read[1] <= button_syncroniser_read[0];
	button_syncroniser_read[2] <= button_syncroniser_read[1];
end

assign button_pressed_write = ~button_syncroniser_write[2] & button_syncroniser_write[1];
assign button_pressed_read = ~button_syncroniser_read[2] & button_syncroniser_read[1];

always@ (posedge clk) begin
    if (reset) begin
        counter <= 0;
        write <= 1;
    end else if (button_pressed_write & empty) begin
        counter <= counter + 1;
        write <= 1;
        read <= 0;
    end else if (button_pressed_read) begin
        write <= 0;
        read <= 1;
    end else if (full) begin
        counter <= 0;
    end
end

fifo fifo_input_buffer(
    .clock(clk),
    .data(counter),
    .rdreq(read),
    .wrreq(write),
    .empty(empty),
    .full(full)
);

endmodule
