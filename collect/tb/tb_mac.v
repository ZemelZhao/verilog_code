module tb_mac(
    input clk,
    input rst
);



    reg [7:0] state; 
    reg [7:0] next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02; 
    localparam FIFO = 8'h13;
    localparam UDP0 = 8'h20, GAP0 = 8'h21, UDP1 = 8'h22, GAP1 = 8'h23;
    localparam UDP2 = 8'h24, GAP2 = 8'h25, UDP3 = 8'h26, GAP3 = 8'h27;

    wire e0_grxc, e1_grxc;
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

    assign e0_grxc = clk;
    assign e1_grxc = clk;

    assign e0_rxdv = e1_txen;
    assign e1_rxdv = e0_txen;

    assign e0_rxd = e1_txd;
    assign e1_rxd = e0_txd;

    assign tx_dlen0 = 16'h20;
    assign tx_dlen1 = 16'h20;

    assign fs_send0 = (state == UDP0) || (state == UDP1) || (state == UDP2) || (state == UDP3);
    assign fs_fifo_tx = (state == FIFO);
    assign fd_recv1 = 1'b1;

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
                if(cnt >= 8'h20) next_state <= UDP1;
                else next_state <= GAP0;
            end
            UDP1: begin
                if(fd_send0) next_state <= GAP1;
                else next_state <= UDP1;
            end
            GAP1: begin
                if(cnt >= 8'h20) next_state <= UDP2;
                else next_state <= GAP1;
            end
            UDP2: begin
                if(fd_send0) next_state <= GAP2;
                else next_state <= UDP2;
            end
            GAP2: begin
                if(cnt >= 8'h20) next_state <= UDP3;
                else next_state <= GAP2;
            end
            UDP3: begin
                if(fd_send0) next_state <= GAP3;
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

        .fifo_txen(fifo_txen),
        .fifo_txd(fifo_txd)
    );




    


    mac  u_mac0 (
        .e_grxc                  ( e0_grxc                ),
        .e_rxdv                  ( e0_rxdv                ),
        .e_rxd                   ( e0_rxd          [7:0]  ),
        .e_rxer                  (                 ),
        .e_mdio                  (                 ),
        .fs_send                 ( fs_send0               ),
        .fd_recv                 ( fd_recv0              ),
        .rst                     ( rst                   ),
        .tx_dlen                 ( tx_dlen0        [15:0] ),
        .fifo_cmd_rxen           ( fifo_cmd_rxen0         ),

        .e_gtxc                  ( e0_gtxc                ),
        .e_txen                  ( e0_txen                ),
        .e_txd                   ( e0_txd          [7:0]  ),
        .e_txer                  (                 ),
        .e_rstn                  ( e0_rstn                ),
        .e_mdc                   (                  ),
        .fd_send                 ( fd_send0               ),
        .fs_recv                 ( fs_recv0               ),
        .rx_dlen                 ( rx_dlen0        [15:0] ),
        .fifo_cmd_rxd            ( fifo_cmd_rxd0   [7:0]  ),

        .fifo_data_rxen(fifo_rxen),
        .fifo_data_rxd(fifo_rxd)
    );


    mac  u_mac1 (
        .e_grxc                  ( e1_grxc                ),
        .e_rxdv                  ( e1_rxdv                ),
        .e_rxd                   ( e1_rxd          [7:0]  ),
        .e_rxer                  (                 ),
        .e_mdio                  ( e1_mdio                ),
        .fs_send                 ( fs_send1               ),
        .fd_recv                 ( fd_recv1               ),
        .rst                     ( rst                   ),
        .tx_dlen                 ( tx_dlen1        [15:0] ),
        .fifo_cmd_rxen           ( fifo_cmd_rxen1         ),

        .e_gtxc                  ( e1_gtxc                ),
        .e_txen                  ( e1_txen                ),
        .e_txd                   ( e1_txd          [7:0]  ),
        .e_txer                  (                 ),
        .e_rstn                  ( e1_rstn                ),
        .e_mdc                   (                  ),
        .fd_send                 ( fd_send1               ),
        .fs_recv                 ( fs_recv1               ),
        .rx_dlen                 ( rx_dlen1        [15:0] ),
        .fifo_cmd_rxd            ( fifo_cmd_rxd1   [7:0]  )
    );





endmodule