module mac(
    input e_grxc,
    input e_rxdv,
    input [7:0] e_rxd,
    input e_rxer,

    output e_gtxc,
    output e_txen,
    output [7:0] e_txd,
    output e_txer,

    output e_rstn,
    output e_mdc,
    input e_mdio,

    input fs_send,
    output fd_send,
    output fs_recv,
    input fd_recv,

    input rst,
    input [15:0] tx_dlen,
    output [15:0] rx_dlen,

    input fifo_cmd_rxen,
    output [7:0] fifo_cmd_rxd,
    output fifo_data_rxen,
    input [7:0] fifo_data_rxd
);

    localparam SRC_MAC_ADDR = 48'h1A510F000001;
    localparam DET_MAC_ADDR = 48'hFFFFFFFFFFFF;
    localparam SRC_IP_ADDR = 32'hC0A80002;
    localparam DET_IP_ADDR = 32'hC0A80003;
    localparam SRC_IP_PORT = 16'h1F90;
    localparam DET_IP_PORT = 16'h1F90;

    wire [47:0] src_mac_addr, tgt_mac_addr;
    wire [31:0] src_ip_addr, tgt_ip_addr;
    wire [15:0] src_ip_port, tgt_ip_port;

    assign e_rstn = 1'b1;
    assign e_mdc = 1'b0;
    assign e_gtxc = e_grxc;


    mac_rx_top
    mac_rx_top_dut(
        .clk(e_grxc),
        .rst(rst),
        .fs(fs_recv),
        .fd(fd_recv),

        .src_mac_addr(tgt_mac_addr),
        .det_mac_addr(src_mac_addr),
        .src_ip_addr(tgt_ip_addr),
        .det_ip_addr(src_ip_addr),
        .src_ip_port(tgt_ip_port),
        .det_ip_port(src_ip_port),

        .data_len(rx_dlen),
        .fifo_rxen(fifo_cmd_rxen),
        .fifo_rxd(fifo_cmd_rxd),

        .rxd(e_rxd),
        .rxdv(e_rxdv)
    );

    mac_tx_top
    mac_tx_top_dut(
        .clk(e_gtxc),
        .rst(rst),
        .fs(fs_send),
        .fd(fd_send),

        .src_mac_addr(SRC_MAC_ADDR),
        .det_mac_addr(DET_MAC_ADDR),
        .src_ip_addr(SRC_IP_ADDR),
        .det_ip_addr(DET_IP_ADDR),
        .src_ip_port(SRC_IP_PORT),
        .det_ip_port(DET_IP_PORT),

        .data_len(tx_dlen),
        .fifo_rxen(fifo_data_rxen),
        .fifo_rxd(fifo_data_rxd),

        .txd(e_txd),
        .txen(e_txen)
    );
    




endmodule