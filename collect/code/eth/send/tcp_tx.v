module tcp_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    output [7:0] txd
);

    assign txd = 8'h00;
    assign fd = 1'b0;



endmodule