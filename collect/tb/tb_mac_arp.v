module tb_mac_arp(
    input clk,
    input rst
);


    localparam GLEN = 8'h40;
    localparam ARP = 16'h0806, IP = 16'h0800;
    localparam ICMP = 8'h01, TCP = 8'h06, UDP = 8'h11;

    reg [7:0] state; 
    reg [7:0] next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02; 
    localparam FIFO = 8'h13;
    localparam UDP0 = 8'h20, GAP0 = 8'h21, UDP1 = 8'h22, GAP1 = 8'h23;
    localparam UDP2 = 8'h24, GAP2 = 8'h25, UDP3 = 8'h26, GAP3 = 8'h27;

    wire e_grxc;
    wire e0_gtxc, e1_gtxc;
    wire e0_txen, e1_txen;
    wire e0_rxdv, e1_rxdv;
    wire [7:0] e0_rxd, e0_txd;
    wire [7:0] e1_rxd, e1_txd;
    wire e0_rstn, e1_rstn;
    wire fs_send0, fd_send0, fs_recv0, fd_recv0;
    wire fs_send1, fd_send1, fs_recv1, fd_recv1;
    wire [15:0] tx_dlen0, rx_dlen0;
    wire [15:0] tx_dlen1, rx_dlen1;
    wire fifo_cmd_rxen0, fifo_cmd_rxen1;
    wire [7:0] fifo_cmd_rxd0, fifo_cmd_rxd1;

    wire fs_fifo_tx, fd_fifo_tx;
    wire fifo_txen, fifo_rxen;
    wire fifo_full;
    wire [7:0] fifo_txd, fifo_rxd;

    wire [15:0] mac_rx_mode, mac_tx_mode;
    wire [7:0] ip_rx_mode, ip_tx_mode;


    assign tx_dlen0 = 16'h0A;
    assign tx_dlen1 = 16'h20;

    assign fs_send = (state == UDP0) || (state == UDP1) || (state == UDP2) || (state == UDP3);
    assign fs_fifo_tx = (state == FIFO);
    assign fd_recv1 = 1'b1;

    assign mac_tx_mode = ARP;
    assign ip_tx_mode = IP;

    assign e_grxc = clk;

    reg [7:0] cnt;

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
                if(fd_send0) next_state <= GAP0;
                else next_state <= UDP0;
            end
            GAP0: begin
                if(cnt >= GLEN) next_state <= UDP1;
                else next_state <= GAP0;
            end
            UDP1: begin
                if(fd_send0) next_state <= GAP1;
                else next_state <= UDP1;
            end
            GAP1: begin
                if(cnt >= GLEN) next_state <= UDP2;
                else next_state <= GAP1;
            end
            UDP2: begin
                if(fd_send0) next_state <= GAP2;
                else next_state <= UDP2;
            end
            GAP2: begin
                if(cnt >= GLEN) next_state <= UDP3;
                else next_state <= GAP2;
            end
            UDP3: begin
                if(fd_send0) next_state <= GAP3;
                else next_state <= UDP3;
            end
            GAP3: begin
                if(cnt >= GLEN) next_state <= DONE;
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

    fifo_eth
    fifo_read_dut(
        .wr_clk(clk),
        .full(fifo_full),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd),
        .rd_en(fifo_rxen)
    );

    fifo_tx
    fifo_tx_dut(
        .clk(clk),
        .rst(rst),

        .full(fifo_full),
        .fs(fs_fifo_tx),
        .fd(fd_fifo_tx),

        .dlen({tx_dlen0, 2'b11}),

        .fifo_txen(fifo_txen),
        .fifo_txd(fifo_txd)
    );




    


    mac
    mac_dut(
        .e_grxc(e_grxc),
        .e_rxdv(e_rxdv),
        .e_rxd(e_rxd),
        .e_rxer(e_rxer),

        .e_gtxc(e_gtxc),
        .e_txen(e_txen),
        .e_txd(e_txd),
        .e_txer(e_txer),

        .e_rstn(e_rstn),
        .e_mdc(e_mdc),
        .e_mdio(e_mdio),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fs_recv(fs_recv),
        .fd_recv(fd_recv),

        .mac_tx_mode(mac_tx_mode),
        .ip_tx_mode(ip_tx_mode),
        .arp_tx_req(1'b1),
        .mac_rx_mode(mac_rx_mode),
        .ip_rx_mode(ip_rx_mode),

        .rst(rst),
        .tx_dlen(tx_dlen),
        .rx_dlen(rx_dlen),

        .fifo_cmd_rxen(fifo_cmd_rxen),
        .fifo_cmd_rxd(fifo_cmd_rxd),
        .fifo_data_rxen(fifo_data_rxen),
        .fifo_data_rxd(fifo_data_rxd)
    );




endmodule