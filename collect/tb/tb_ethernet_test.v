module tb_ethernet_test(
    input clk,
    input rst
);

    reg state, next_state;

    wire [7:0] mac_txd, mac_rxd;
    wire [7:0] eth_txd, eth_rxd;
    wire mac_txen, mac_rxdv;
    wire eth_txen, mac_rxdv;

    wire [15:0] mac_tx_dlen, mac_rx_dlen;
    wire fs_send, fd_send;
    wire fs_recv, fd_recv;
    wire fifo_cmd_rxen, fifo_data_rxen;
    wire [7:0] fifo_cmd_rxd, fifo_data_rxd;

    assign mac_rxd = eth_txd;
    assign eth_rxd = mac_txd;
    assign mac_rxdv = eth_txen;
    assign eth_rxdv = mac_txen;

    mac
    mac_dut(
        .e_grxc(clk),
        .e_rxdv(mac_rxdv),
        .e_rxd(mac_rxd),
        .e_rxer(),

        .e_gtxc(),
        .e_txen(mac_txen),
        .e_txd(mac_txd),
        .e_txer(),

        .e_rstn(),
        .e_mdc(),
        .e_mdio(),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fs_recv(fs_recv),
        .fd_recv(fd_recv),

        .rst(rst),
        .tx_dlen(mac_tx_dlen),
        .rx_dlen(mac_rx_dlen),

        .fifo_cmd_rxen(fifo_cmd_rxen),
        .fifo_cmd_rxd(fifo_cmd_rxd),
        .fifo_data_rxen(fifo_data_rxen),
        .fifo_data_rxd(fifo_data_rxd)
    );

    ethernet_test
    eth_dut(
        .reset_n(~rst),

        .e_reset(),
        .e_mdc(),
        .e_mdio(),

        .e_rxc(clk),
        .e_rxdv(eth_rxdv),
        .e_rxer(),
        .e_rxd(eth_rxd),

        .e_gtxc(),
        .e_txen(eth_txen),
        .e_txer(),
        .e_txd(eth_txd)
    );






endmodule