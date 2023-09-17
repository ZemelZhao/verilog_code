module mac_tx_top(

    input [47:0] src_mac,
    input [47:0] det_mac,
    input [31:0] src_ip,
    input [31:0] det_ip,
    input [15:0] src_port,
    input [15:0] det_port

);

    wire fs_udp_tx, fd_udp_tx;

    wire [7:0] icmp_txd;
    wire [7:0] tcp_txd;
    wire [7:0] udp_txd;

    wire [7:0] ip_mode;

    wire [7:0] ip_mode_txd;


    udp_tx
    udp_tx_dut(
        .clk(udp_txc),
        .rst(rst),

        .fs(fs_udp_tx),
        .fd(fd_udp_tx),

        .src_port(src_port),
        .det_port(det_port),
        .data_len(udp_tx_dlen),

        .fifo_rxen(fifo_eth_rxen),
        .fifo_rxd(fifo_eth_rxd),
        .udp_txd(udp_txd)
    );

    ip_tx_mode
    ip_tx_mode_dut(
        .clk(ip_mode_txc),

        .udp_txd(udp_txd),
        .tcp_txd(tcp_txd),
        .icmp_txd(icmp_txd),

        .tx_mode(ip_mode),

        .txd(ip_mode_txd)
    );



endmodule