module tb_udp_rx(
    input clk,
    input rst
);

    wire [15:0] tx_dlen, udp_tx_dlen;

    wire [7:0] udp_txd;
    (*MARK_DEBUG = "true"*)wire [7:0] fifo_txd, fifo_rxd;
    (*MARK_DEBUG = "true"*)wire fifo_txen, fifo_rxen;
    (*MARK_DEBUG = "true"*)wire fifo_full;

    wire fs_fifo_tx, fd_fifo_tx;

    wire fs_eth_tx, fd_eth_rx;
    wire fs_udp_tx, fd_udp_tx;

    assign udp_tx_dlen = tx_dlen + 8'h8;
    assign tx_dlen = 16'h20;

    assign fs_udp_tx = fs_eth_tx;
    assign fd_eth_tx = fd_udp_tx;

    (*MARK_DEBUG = "true"*)reg [7:0] state; 
    reg [7:0] next_state;

    reg fs_rx;

    wire [15:0] udp_rx_len, udp_rx_sip_port, udp_rx_dip_port;
    wire fifo_read_txen;
    wire [7:0] fifo_read_txd;



    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02; 
    localparam FIFO = 8'h13;
    localparam UDP0 = 8'h20, GAP0 = 8'h21, UDP1 = 8'h22, GAP1 = 8'h23;
    localparam UDP2 = 8'h24, GAP2 = 8'h25, UDP3 = 8'h26, GAP3 = 8'h27;

    assign fs_fifo_tx = (state == FIFO);
    assign fs_eth_tx = (state == UDP0) || (state == UDP1) || (state == UDP2) || (state == UDP3);

    always@(posedge clk) begin
        fs_rx <= fs_udp_tx;
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
            GAP0: next_state <= UDP1;
            UDP1: begin
                if(fd_udp_tx) next_state <= GAP1;
                else next_state <= UDP1;
            end
            GAP1: next_state <= UDP2;
            UDP2: begin
                if(fd_udp_tx) next_state <= GAP2;
                else next_state <= UDP2;
            end
            GAP2: next_state <= UDP3;
            UDP3: begin
                if(fd_udp_tx) next_state <= GAP3;
                else next_state <= UDP3;
            end
            GAP3: next_state <= DONE;
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
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

    udp_rx
    udp_rx_dut(
        .clk(clk),
        .rst(rst),
        .rxd(udp_txd),

        .fs(fs_rx),
        .fd(fd_rx),
        .dlen(udp_rx_len),
        .src_ip_port(udp_rx_sip_port),
        .det_ip_port(udp_rx_dip_port),

        .fifo_txen(fifo_read_txen),
        .fifo_txd(fifo_read_txd)
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


