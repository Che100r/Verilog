module fifo (
    input clk,
    input reset,
    input [7:0] data_in,
    output [7:0] data_out,
    output [6:0] hex_1,
    output [6:0] hex_2
);

reg [7:0] data_o;

assign data_out = data_o;

always@ (posedge clk) begin
    data_o <= data_in;
end

hex hex1(
    .hex_i(data_out[3:0]),
    .hex_o(hex_1)
);

hex hex2(
    .hex_i(data_out[7:4]),
    .hex_o(hex_2)
);

endmodule