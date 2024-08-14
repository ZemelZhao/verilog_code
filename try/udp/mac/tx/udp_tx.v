module udp_tx(
    input clk,
    input rst_n,

    input [15:0] src_port,
    input [15:0] det_port,

    input [15:0] data_len,

    input [7:0] ram_rxd,
    output ram_rxen,

    input fs,
    output fd

);


endmodule