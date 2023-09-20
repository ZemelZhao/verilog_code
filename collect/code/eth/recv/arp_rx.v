module arp_rx(
    input clk,
    input rst,

    input fd,
    output fd,

    input [7:0] rxd
);

    assign fd = 1'b0;

endmodule