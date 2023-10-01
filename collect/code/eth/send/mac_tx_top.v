module mac_tx_top(
    input clk,
    input rst,

    input fs,
    output fd,

    input [15:0] mac_mode,
    input [7:0] ip_mode,
    input arp_req,

    input [47:0] src_mac_addr,
    input [47:0] det_mac_addr,
    input [31:0] src_ip_addr,
    input [31:0] det_ip_addr,
    input [15:0] src_ip_port,
    input [15:0] det_ip_port,

    input [15:0] data_len,

    output fifo_rxen,
    input [7:0] fifo_rxd,

    output [7:0] txd,
    output txen
);

    localparam UDP = 8'h11;
    localparam IP = 16'h0800;

    wire [7:0] ip_mode;
    wire [15:0] mac_mode;

    wire fs_udp_tx, fd_udp_tx;
    wire fs_icmp_tx, fd_icmp_tx;
    wire fs_tcp_tx, fd_tcp_tx;
    wire fs_ip_mode, fd_ip_mode;

    wire fs_ip_tx, fd_ip_tx;
    wire fs_arp_tx, fd_arp_tx;
    wire fs_mac_mode, fd_mac_mode;

    wire fs_mac_tx, fd_mac_tx;

    wire [15:0] ip_tx_dlen;

    wire [7:0] icmp_txd;
    wire [7:0] tcp_txd;
    wire [7:0] udp_txd;
    wire [7:0] ip_mode_txd;

    wire [7:0] ip_txd;
    wire [7:0] arp_txd;
    wire [7:0] mac_mode_txd;

    wire [7:0] mac_txd;

    wire crc_en;
    wire [31:0] crc_data;

    assign ip_tx_dlen = data_len + 8'h1C;

    udp_tx
    udp_tx_dut(
        .clk(clk),
        .rst(rst),
        .fs(fs_udp_tx),
        .fd(fd_udp_tx),
        .src_port(src_ip_port),
        .det_port(det_ip_port),
        .data_len(data_len),
        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd),
        .txd(udp_txd)
    );

    tcp_tx
    tcp_tx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_tcp_tx),
        .fd(fd_tcp_tx),

        .txd(tcp_txd)
    );

    icmp_tx
    icmp_tx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_icmp_tx),
        .fd(fd_icmp_tx),

        .txd(icmp_txd)
    );

    ip_tx_mode
    ip_tx_mode_dut(
        .clk(clk),

        .udp_txd(udp_txd),
        .tcp_txd(tcp_txd),
        .icmp_txd(icmp_txd),

        .mode(ip_mode),
        .fs_mode(fs_ip_mode),
        .fd_mode(fd_ip_mode),

        .fs_udp(fs_udp_tx),
        .fd_udp(fd_udp_tx),
        .fs_tcp(fs_tcp_tx),
        .fd_tcp(fd_tcp_tx),
        .fs_icmp(fs_icmp_tx),
        .fd_icmp(fd_icmp_tx),

        .txd(ip_mode_txd)
    );

    ip_tx
    ip_tx_dut(
        .clk(clk),
        .rst(rst),

        .data_len(ip_tx_dlen),
        .src_ip_addr(src_ip_addr),
        .det_ip_addr(det_ip_addr),

        .fs(fs_ip_tx),
        .fd(fd_ip_tx),

        .ip_mode(ip_mode),

        .fs_mode(fs_ip_mode),
        .fd_mode(fd_ip_mode),

        .ip_mode_txd(ip_mode_txd),
        .txd(ip_txd)
    );

    arp_tx
    arp_tx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_arp_tx),
        .fd(fd_arp_tx),
        .btype(arp_req),
        
        .src_mac_addr(src_mac_addr),
        .det_mac_addr(det_mac_addr),
        .src_ip_addr(src_ip_addr),
        .det_ip_addr(det_ip_addr),

        .txd(arp_txd)
    );

    mac_tx_mode
    mac_tx_mode_dut(
        .clk(clk),
        .ip_txd(ip_txd),
        .arp_txd(arp_txd),

        .mode(mac_mode),

        .fs_mode(fs_mac_mode),
        .fd_mode(fd_mac_mode),

        .fs_ip(fs_ip_tx),
        .fd_ip(fd_ip_tx),
        .fs_arp(fs_arp_tx),
        .fd_arp(fd_arp_tx),

        .txd(mac_mode_txd)
    );

    mac_tx
    mac_tx_dut(
        .clk(clk),
        .rst(rst),

        .src_mac_addr(src_mac_addr),
        .det_mac_addr(det_mac_addr),
        
        .fs(fs_mac_tx),
        .fd(fd_mac_tx),

        .mac_mode(mac_mode),
        
        .fs_mode(fs_mac_mode),
        .fd_mode(fd_mac_mode),

        .mac_mode_txd(mac_mode_txd),
        .txd(mac_txd)
    );


    frame_tx
    frame_tx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs),
        .fd(fd),

        .crc_en(crc_en),
        .crc(crc_data),

        .fs_mac(fs_mac_tx),
        .fd_mac(fd_mac_tx),
        
        .mac_txd(mac_txd),
        .txd(txd),

        .txen(txen)
    );

    crc32
    crc32_dut(
        .clk(clk),
        .enable(crc_en),
        .din(mac_txd),
        .dout(crc_data)
    );



endmodule