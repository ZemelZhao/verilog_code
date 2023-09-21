module mac_rx_top(
    input clk,
    input rst,

    output fs,
    input fd,

    output [47:0] src_mac_addr,
    output [47:0] det_mac_addr,
    output [31:0] src_ip_addr,
    output [31:0] det_ip_addr,
    output [15:0] src_ip_port,
    output [15:0] det_ip_port,

    output [15:0] data_len,

    input fifo_rxen,
    output [7:0] fifo_rxd,

    input [7:0] rxd,
    input rxdv
);

    wire [7:0] ip_mode;
    wire [15:0] mac_mode;

    wire [15:0] udp_rx_dlen, ip_rx_dlen, mac_rx_dlen, frame_rx_dlen;

    wire fs_udp_rx, fd_udp_rx;
    wire fs_tcp_rx, fd_tcp_rx;
    wire fs_icmp_rx, fd_icmp_rx;
    wire fs_ip_mode, fd_ip_mode;

    wire fs_ip_rx, fd_ip_rx;
    wire fs_arp_rx, fd_arp_rx;
    wire fs_mac_mode, fd_mac_mode;

    wire fs_mac_rx, fd_mac_rx;

    wire fs_fifo_rx, fd_fifo_rx;

    wire [7:0] icmp_rxd, tcp_rxd, udp_rxd;
    wire [7:0] ip_rxd, arp_rxd;
    wire [7:0] ip_mode_rxd, mac_mode_rxd;
    wire [7:0] mac_rxd;

    wire fifo_txen, fifo_full;
    wire [7:0] fifo_txd;
    wire fifo_rxen_in;

    wire crc_en;
    wire [31:0] crc_data; 

    assign data_len = udp_rx_dlen;
    assign mac_rx_dlen = ip_rx_dlen + 8'h0E;
    assign frame_rx_dlen = mac_rx_dlen + 8'h04;

    udp_rx
    udp_rx_dut(
        .clk(clk),
        .rst(rst),

        .rxd(udp_rxd),

        .fs(fs_udp_rx),
        .fd(fd_udp_rx),

        .dlen(udp_rx_dlen),

        .src_ip_port(src_ip_port),
        .det_ip_port(det_ip_port),

        .fifo_full(fifo_full),
        .fifo_txen(fifo_txen),
        .fifo_txd(fifo_txd)
    );

    tcp_rx
    tcp_rx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_tcp_rx),
        .fd(fd_tcp_rx),
        .rxd(tcp_rxd)
    );

    icmp_rx
    icmp_rx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_icmp_rx),
        .fd(fd_icmp_rx),
        .rxd(icmp_rxd)
    );

    ip_rx_mode
    ip_rx_mode_dut(
        .clk(clk),

        .mode(ip_mode),
        
        .fs_mode(fs_ip_mode),
        .fd_mode(fd_ip_mode),

        .fs_udp(fs_udp_rx),
        .fd_udp(fd_udp_rx),
        .fs_tcp(fs_tcp_rx),
        .fd_tcp(fd_tcp_rx),
        .fs_icmp(fs_icmp_rx),
        .fd_icmp(fd_icmp_rx),

        .rxd(ip_mode_rxd),
        .udp_rxd(udp_rxd),
        .tcp_rxd(tcp_rxd),
        .icmp_rxd(icmp_rxd)
    );

    ip_rx
    ip_rx_dut(
        .clk(clk),
        .rst(rst),

        .rxd(ip_rxd),

        .fs(fs_ip_rx),
        .fd(fd_ip_rx),

        .fs_mode(fs_ip_mode),
        .fd_mode(fd_ip_mode),

        .data_len(ip_rx_dlen),
        
        .ip_mode(ip_mode),
        .src_ip_addr(src_ip_addr),
        .det_ip_addr(det_ip_addr),
        .mode_rxd(ip_mode_rxd)
    );

    arp_rx
    arp_rx_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_arp_rx),
        .fd(fd_arp_rx),
        .rxd(arp_rxd)
    );    

    mac_rx_mode
    mac_rx_mode_dut(
        .clk(clk),

        .mode(mac_mode),

        .fs_mode(fs_mac_mode),
        .fd_mode(fd_mac_mode),

        .fs_ip(fs_ip_rx),
        .fd_ip(fd_ip_rx),
        .fs_arp(fs_arp_rx),
        .fd_arp(fd_arp_rx),

        .rxd(mac_mode_rxd),

        .ip_rxd(ip_rxd),
        .arp_rxd(arp_rxd)
    );

    mac_rx
    mac_rx_dut(
        .clk(clk),
        .rst(rst),

        .rxd(mac_rxd),

        .fs(fs_mac_rx),
        .fd(fd_mac_rx),

        .fs_mode(fs_mac_mode),
        .fd_mode(fd_mac_mode),

        .data_len(mac_rx_dlen),

        .mac_mode(mac_mode),
        .src_mac_addr(src_mac_addr),
        .det_mac_addr(det_mac_addr),

        .mode_rxd(mac_mode_rxd)
    );

    frame_rx
    frame_rx_dut(
        .clk(clk),
        .rst(rst),

        .rxdv(rxdv),
        .rxd(rxd),

        .fs_mac(fs_mac_rx),
        .fd_mac(fd_mac_rx),

        .fs_read(fs),
        .fd_read(fd),

        .fs_fifo(fs_fifo_rx),
        .fd_fifo(fd_fifo_rx),

        .crc(crc_data),
        .crc_en(crc_en),

        .data_len(frame_rx_dlen),

        .mac_rxd(mac_rxd)
    );

    crc32
    crc32_dut(
        .clk(clk),
        .enable(crc_en),
        .din(rxd),
        .dout(crc_data)
    );

    fifo_rx
    fifo_rx_dut(
        .clk(clk),

        .fs(fs_fifo),
        .fd(fd_fifo),

        .data_len(udp_rx_dlen),

        .fifo_rxen(fifo_rxen_in),
        .fifo_rxd(fifo_rxd)
    );

    fifo_cache
    fifo_cache_dut(
        .wr_clk(clk),
        .full(fifo_full),
        .wr_en(fifo_txen),
        .din(fifo_txd),

        .rd_clk(clk),
        .rd_en(fifo_rxen || fifo_rxen_in),
        .dout(fifo_rxd)
    );




    




endmodule