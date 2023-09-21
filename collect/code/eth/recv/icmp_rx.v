module icmp_rx(
    input clk,
    input rst,

    input fs,
    output fd,

    input [7:0] rxd
);

    assign fd = 1'b0;

endmodule