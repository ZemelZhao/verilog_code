module tb_mac_tx_top(
    input clk,
    input rst
);

    wire [15:0] tx_dlen; 
    wire [7:0] eth_txd;
    wire eth_tx_rdy;

    (*MARK_DEBUG = "true"*)wire [7:0] fifo_txd, fifo_rxd;
    (*MARK_DEBUG = "true"*)wire fifo_txen, fifo_rxen;
    (*MARK_DEBUG = "true"*)wire fifo_full;

    wire fs_fifo_tx, fd_fifo_tx;
    wire fs_eth_tx, fd_eth_rx;

    (*MARK_DEBUG = "true"*)reg [7:0] state; 
    reg [7:0] next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02; 
    localparam FIFO = 8'h13;
    localparam UDP0 = 8'h20, GAP0 = 8'h21, UDP1 = 8'h22, GAP1 = 8'h23;
    localparam UDP2 = 8'h24, GAP2 = 8'h25, UDP3 = 8'h26, GAP3 = 8'h27;

    localparam IP_MODE = 8'h11;
    localparam MAC_MODE = 16'h0800;

    assign fs_fifo_tx = (state == FIFO);
    assign fs_eth_tx = (state == UDP0) || (state == UDP1) || (state == UDP2) || (state == UDP3);


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
                if(fd_eth_tx) next_state <= GAP0;
                else next_state <= UDP0;
            end
            GAP0: next_state <= UDP1;
            UDP1: begin
                if(fd_eth_tx) next_state <= GAP1;
                else next_state <= UDP1;
            end
            GAP1: next_state <= UDP2;
            UDP2: begin
                if(fd_eth_tx) next_state <= GAP2;
                else next_state <= UDP2;
            end
            GAP2: next_state <= UDP3;
            UDP3: begin
                if(fd_eth_tx) next_state <= GAP3;
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

    mac_tx_top
    mac_tx_top_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_eth_tx),
        .fd(fd_eth_tx),

        .src_mac(48'h1A510F000001),
        .det_mac(48'hFFFFFFFFFFFF),
        .src_ip_addr(32'hC0A80002),
        .det_ip_addr(32'hC0A80003),
        .src_ip_port(16'h1F90),
        .det_ip_port(16'h1F90),
        
        .data_len(16'h0A),

        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd),

        .txd(eth_txd),
        .tx_rdy(eth_tx_rdy)
    );

    fifo_eth
    fifo_eth_dut(
        .wr_clk(clk),
        .full(fifo_full),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd),
        .rd_en(fifo_rxen)
    );


endmodule


