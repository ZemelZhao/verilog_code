module top(
    input clk_p,
    input clk_n,
    input rst_n,

    output fan,

    output e_rstn,
    output e_mdc,
    input e_mdio,

    input e_grxc,
    (*MARK_DEBUG = "true"*)input e_rxdv,
    input e_rxer,
    (*MARK_DEBUG = "true"*)input [7:0] e_rxd,

    output e_gtxc,
    (*MARK_DEBUG = "true"*)output e_txen,
    output e_txer,
    (*MARK_DEBUG = "true"*)output [7:0] e_txd
);

    localparam TLEN = 32'd125_000_000;
    localparam ARP = 16'h0806, IP = 16'h0800;
    localparam ICMP = 8'h01, TCP = 8'h06, UDP = 8'h11;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02;
    localparam FIFO = 8'h10, WORK = 8'h11, REST = 8'h12;

    wire fs_fifo_tx, fd_fifo_tx;
    wire fs_send, fd_send;
    wire fs_recv, fd_recv;
    wire [15:0] tx_dlen, rx_dlen;
    wire fifo_cmd_rxen, fifo_data_rxen;
    wire [7:0] fifo_cmd_rxd, fifo_data_rxd;
    wire fifo_data_txen;
    wire [7:0] fifo_data_txd;
    wire fifo_full;

    wire [15:0] mac_rx_mode, mac_tx_mode;
    wire [7:0] ip_rx_mode, ip_tx_mode;

    wire clk, rst;

    reg [31:0] cnt;

    assign mac_tx_mode = ARP;
    assign ip_tx_mode = IP;

    assign rst = ~rst_n;


    assign fan = 1'b0;
    assign fs_fifo_tx = (state == FIFO);
    assign tx_dlen = 8'h40;
    assign fs_send = (state == WORK);



    IBUFDS #(
        .DIFF_TERM("TRUE"),      // Differential Termination
        .IBUF_LOW_PWR("TRUE"),   // Low power="TRUE", Highest performance="FALSE" 
        .IOSTANDARD("DEFAULT")   // Specify the input I/O standard
    ) u_ibuf_sys_clk (
        .O(clk),             // Buffer output
        .I(clk_p),           // Diff_p buffer input (connect directly to top-level port)
        .IB(clk_n)           // Diff_n buffer input (connect directly to top-level port)
    ); 


    always@(posedge e_grxc or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= FIFO;
            FIFO: begin
                if(fd_fifo_tx) next_state <= WORK;
                else next_state <= FIFO;
            end
            WORK: begin
                if(fd_send) next_state <= REST;
                else next_state <= WORK;
            end
            REST: begin
                if(cnt >= TLEN - 1'b1) next_state <= DONE;
                else next_state <= REST;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge e_grxc or posedge rst) begin
        if(rst) cnt <= 32'h00;
        else if(state == IDLE) cnt <= 32'h00;
        else if(state == UDP) cnt <= 32'h00;
        else if(state == REST) cnt <= cnt + 1'b1;
        else cnt <= 32'h00;
    end



    fifo_tx
    fifo_tx_dut(
        .clk(e_grxc),
        .rst(rst),

        .full(fifo_full),
        .fs(fs_fifo_tx),
        .fd(fd_fifo_tx),

        .dlen(tx_dlen),

        .fifo_txen(fifo_data_txen),
        .fifo_txd(fifo_data_txd)
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


    fifo_eth
    fifo_read_dut(
        .wr_clk(e_grxc),
        .full(fifo_full),
        .din(fifo_data_txd),
        .wr_en(fifo_data_txen),

        .rd_clk(e_gtxc),
        .dout(fifo_data_rxd),
        .rd_en(fifo_data_rxen)
    );





endmodule