module tb_ip_rx(
    input clk,
    input rst
);

    wire [15:0] tx_dlen, udp_tx_dlen;

    wire [7:0] udp_txd, tcp_txd, icmp_txd;
    wire [7:0] ip_mode_txd;
    wire [7:0] ip_txd;

    wire [7:0] udp_rxd, tcp_rxd, icmp_rxd;
    wire [7:0] ip_mode_rxd;
    wire [7:0] ip_rxd;

    wire [7:0] ip_rxm;

    (*MARK_DEBUG = "true"*)wire [7:0] fifo_txd, fifo_rxd;
    (*MARK_DEBUG = "true"*)wire fifo_txen, fifo_rxen;
    (*MARK_DEBUG = "true"*)wire fifo_full;

    wire fs_fifo_tx, fd_fifo_tx;
    wire fs_eth_tx, fd_eth_tx;

    wire fs_udp_tx, fd_udp_tx;
    wire fs_tcp_tx, fd_tcp_tx;
    wire fs_icmp_tx, fd_icmp_tx;
    wire fs_ip_tx, fd_ip_tx;
    wire fs_ip_mode_tx, fd_ip_mode_tx;

    wire fs_udp_rx, fd_udp_rx;
    wire fs_tcp_rx, fd_tcp_rx;
    wire fs_icmp_rx, fd_icmp_rx;
    wire fs_ip_rx, fd_ip_rx;
    wire fs_ip_mode_rx, fd_ip_mode_rx;

    wire [15:0] ip_tx_dlen;

    assign udp_tx_dlen = tx_dlen + 8'h8;
    assign tx_dlen = 16'h20;

    assign fs_ip_tx = fs_eth_tx;
    assign fd_eth_tx = fd_ip_tx;

    localparam IP_MODE = 8'h11;

    (*MARK_DEBUG = "true"*)reg [7:0] state; 
    reg [7:0] next_state;

    reg fs_eth_rx;

    wire [15:0] udp_rx_len, udp_rx_sip_port, udp_rx_dip_port;
    wire [31:0] ip_rx_sip_addr, ip_rx_dip_addr;
    wire fifo_read_txen;
    wire [7:0] fifo_read_txd;

    reg [7:0] cnt;

    assign ip_tx_dlen = tx_dlen + 8'h1C;

    assign ip_rxd = ip_txd;
    assign fs_ip_rx = fs_eth_rx;


    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02; 
    localparam FIFO = 8'h13;
    localparam UDP0 = 8'h20, GAP0 = 8'h21, UDP1 = 8'h22, GAP1 = 8'h23;
    localparam UDP2 = 8'h24, GAP2 = 8'h25, UDP3 = 8'h26, GAP3 = 8'h27;

    assign fs_fifo_tx = (state == FIFO);
    assign fs_eth_tx = (state == UDP0) || (state == UDP1) || (state == UDP2) || (state == UDP3);

    always@(posedge clk) begin
        fs_eth_rx <= fs_eth_tx;
    end


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= FIFO;
            FIFO: begin
                if(fd_fifo_tx) next_state <= UDP0;
                else next_state <= FIFO;
            end
            UDP0: begin
                if(fd_udp_tx) next_state <= GAP0;
                else next_state <= UDP0;
            end
            GAP0: begin
                if(cnt >= 8'h20) next_state <= UDP1;
                else next_state <= GAP0;
            end
            UDP1: begin
                if(fd_udp_tx) next_state <= GAP1;
                else next_state <= UDP1;
            end
            GAP1: begin
                if(cnt >= 8'h20) next_state <= UDP2;
                else next_state <= GAP1;
            end
            UDP2: begin
                if(fd_udp_tx) next_state <= GAP2;
                else next_state <= UDP2;
            end
            GAP2: begin
                if(cnt >= 8'h20) next_state <= UDP3;
                else next_state <= GAP2;
            end
            UDP3: begin
                if(fd_udp_tx) next_state <= GAP3;
                else next_state <= UDP3;
            end
            GAP3: begin
                if(cnt >= 8'h20) next_state <= DONE;
                else next_state <= GAP3;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 8'h00;
        else if(state == IDLE) cnt <= 8'h00;
        else if(state == WAIT) cnt <= 8'h00;
        else if(state == GAP0) cnt <= cnt + 1'b1;
        else if(state == GAP1) cnt <= cnt + 1'b1;
        else if(state == GAP2) cnt <= cnt + 1'b1;
        else if(state == GAP3) cnt <= cnt + 1'b1;
        else cnt <= 8'h00;
    end


    fifo_tx
    fifo_tx_dut(
        .clk(clk),
        .rst(rst),
        .full(fifo_full),
        .fs(fs_fifo_tx),
        .fd(fd_fifo_tx),

        .fifo_txen(fifo_txen),
        .fifo_txd(fifo_txd)
    );


    udp_tx
    udp_tx_dut(
        .clk(clk),
        .rst(rst),
        .fs(fs_udp_tx),
        .fd(fd_udp_tx),
        .src_port(16'h1F90),
        .det_port(16'h1F90),
        .data_len(tx_dlen),
        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd),
        .txd(udp_txd)
    );

    ip_tx
    ip_tx_dut(
        .clk(clk),
        .rst(rst),

        .data_len(ip_tx_dlen),
        .src_ip_addr(32'hC0A80002),
        .det_ip_addr(32'hC0A80003),

        .fs(fs_ip_tx),
        .fd(fd_ip_tx),

        .ip_mode(IP_MODE),

        .fs_mode(fs_ip_tx_mode),
        .fd_mode(fd_ip_tx_mode),

        .ip_mode_txd(ip_mode_txd),
        .txd(ip_txd)
    );

    ip_tx_mode
    ip_tx_mode_dut(
        .clk(clk),

        .udp_txd(udp_txd),
        .tcp_txd(tcp_txd),
        .icmp_txd(icmp_txd),

        .mode(IP_MODE),

        .fs_udp(fs_udp_tx),
        .fd_udp(fd_udp_tx),
        .fs_icmp(fs_icmp_tx),
        .fd_icmp(fd_icmp_tx),
        .fs_tcp(fs_tcp_tx),
        .fd_tcp(fd_tcp_tx),

        .fs_mode(fs_ip_tx_mode),
        .fd_mode(fd_ip_tx_mode),

        .txd(ip_mode_txd)
    );

    udp_rx
    udp_rx_dut(
        .clk(clk),
        .rst(rst),
        .rxd(udp_rxd),

        .fs(fs_udp_rx),
        .fd(fd_udp_rx),
        .dlen(udp_rx_len),
        .src_ip_port(udp_rx_sip_port),
        .det_ip_port(udp_rx_dip_port),

        .fifo_txen(fifo_read_txen),
        .fifo_txd(fifo_read_txd)
    );

    ip_rx_mode
    ip_rx_mode_dut(
        .clk(clk),

        .mode(ip_rxm),
        .fs_mode(fs_ip_mode_rx),
        .fd_mode(fd_ip_mode_rx),

        .fs_udp(fs_udp_rx),
        .fs_tcp(fs_tcp_rx),
        .fs_icmp(fs_icmp_rx),

        .fd_udp(fd_udp_rx),
        .fd_tcp(fd_tcp_rx),
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

        .fs_mode(fs_ip_mode_rx),
        .fd_mode(fd_ip_mode_rx),

        .ip_mode(ip_rxm),
        .src_ip_addr(ip_rx_sip_addr),
        .det_ip_addr(ip_rx_dip_addr),
        .mode_rxd(ip_mode_rxd)
    );

    fifo_eth
    fifo_send_dut(
        .wr_clk(clk),
        .full(fifo_full),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd),
        .rd_en(fifo_rxen)
    );

    fifo_eth
    fifo_read_dut(
        .wr_clk(clk),
        .full(fifo_read_full),
        .din(fifo_read_txd),
        .wr_en(fifo_read_txen),

        .rd_clk(clk),
        .dout(fifo_read_rxd),
        .rd_en(fifo_read_rxen)
    );



endmodule


