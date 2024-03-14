`timescale 1 ns/1 ns
module mac_test(
    input rst_n,
    input [31:0] pack_total_len,
    input gmii_tx_clk,
    input gmii_rx_clk,
    input gmii_rx_dv,
    input [7:0] gmii_rxd,
    output reg gmii_tx_en,
    output reg [7:0] gmii_txd,

    input tx_send_i,
    input [15:0] tx_len_i,
    input [15:0] tx_addr_i,
    output reg [15:0] tx_addr_o,
    input [7:0] tx_data_i,
    output tx_done_o,

    output [15:0] rx_length_o,
    output [7:0] rx_data_o,
    output rx_valid_o
); 

    reg gmii_rx_dv_d0;
    reg [7:0] gmii_rxd_d0;
    wire gmii_tx_en_a0;
    wire [7:0] gmii_txd_a0;

    wire udp_ram_data_req;
    wire [7:0] tx_ram_wr_data;
    reg tx_ram_wr_en;
    wire udp_tx_req;
    wire arp_request_req;
    wire mac_send_end;

    wire udp_send_end;
    wire udp_tx_end;
    wire almost_full;

    reg [31:0] wait_cnt;
    reg [15:0] send_len, nosend_len;

    wire rst;
    wire mac_not_exist;
    wire arp_found;
    reg last_pkg;
    reg [15:0] tx_cnt;
    reg [1:0] udp_send_end_b;

    reg [5:0] state, next_state;
    reg [7:0] tx_state; 
    reg [7:0] next_tx_state;
    localparam IDLE = 6'h01, ARP_REQ = 6'h02, ARP_SEND = 6'h04, ARP_WAIT = 6'h08;
    localparam WAIT = 6'h10, CHECK_ARP = 6'h20;
    localparam TX_IDLE = 8'h01, TX_WAIT = 8'h02, TX_DOOR = 8'h04, TX_MAKE = 8'h08;
    localparam TX_TAKE = 8'h10, TX_WORK = 8'h20, TX_REST = 8'h40, TX_DONE = 8'h80;

    localparam PKG_LEN = 15'd1_400;
    localparam RAM_SEND_LATENCY = 8'h02;
    localparam RAM_SEND_RXA_INIT = 8'h00;


    assign rst = ~rst_n;
    assign arp_request_req = (state == ARP_REQ);
    assign tx_ram_wr_data = tx_data_i;
    assign udp_tx_req = (tx_state == TX_TAKE);
    assign tx_done_o = (tx_state == TX_DONE);


    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: begin
                if(wait_cnt == pack_total_len) next_state <= ARP_REQ;
                else next_state <= IDLE;
            end
            ARP_REQ: next_state <= ARP_SEND;
            ARP_SEND: begin
                if(mac_send_end) next_state <= ARP_WAIT;
                else next_state <= ARP_SEND;
            end
            ARP_WAIT: begin
                if(arp_found) next_state <= WAIT;
                else if(wait_cnt == pack_total_len) next_state <= ARP_REQ;
                else next_state <= ARP_WAIT;
            end
            WAIT: begin
                if(wait_cnt == pack_total_len) next_state <= CHECK_ARP;
                else next_state <= WAIT;
            end
            CHECK_ARP: begin
                if(mac_not_exist) next_state <= ARP_REQ;
                else next_state <= CHECK_ARP;
            end
            default: next_state <= IDLE;
        endcase
    end
   
    always@(posedge gmii_rx_clk or posedge rst) begin
        if(rst) gmii_rx_dv_d0 <= 1'b0;
        else gmii_rx_dv_d0 <= gmii_rx_dv;
    end

    always@(posedge gmii_rx_clk or posedge rst) begin
        if(rst) gmii_rxd_d0 <= 8'h00;
        else gmii_rxd_d0 <= gmii_rxd;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) gmii_tx_en <= 1'b0;
        else gmii_tx_en <= gmii_tx_en_a0;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) gmii_txd <= 8'h00;
        else gmii_txd <= gmii_txd_a0;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) wait_cnt <= 32'h00;
        else if(state != next_state) wait_cnt <= 32'h00;  
        else if(state == IDLE) wait_cnt <= wait_cnt + 1'b1;
        else if(state == WAIT) wait_cnt <= wait_cnt + 1'b1;
        else if(state == ARP_WAIT) wait_cnt <= wait_cnt + 1'b1;
        else wait_cnt <= 32'h00;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) tx_state <= TX_IDLE;
        else tx_state <= next_tx_state;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) udp_send_end_b <= 2'h0; 
        else udp_send_end_b = {udp_send_end_b[0], udp_send_end};
    end

    always@(*) begin
        case(tx_state)
            TX_IDLE: next_tx_state <= TX_WAIT;
            TX_WAIT: begin
                if(tx_send_i) next_tx_state <= TX_DOOR;
                else next_tx_state <= TX_WAIT;
            end
            TX_DOOR: begin
                if(last_pkg) next_tx_state <= TX_DONE;
                else next_tx_state <= TX_MAKE;
            end
            TX_MAKE: next_tx_state <= TX_TAKE;
            TX_TAKE: begin
                if(udp_ram_data_req) next_tx_state <= TX_WORK;
                else next_tx_state <= TX_TAKE;
            end
            TX_WORK: begin
                if(tx_cnt >= send_len - 1'b1) next_tx_state <= TX_REST;
                else next_tx_state <= TX_WORK;
            end
            TX_REST: begin
                if(udp_send_end_b == 2'b10) next_tx_state <= TX_DOOR;
                else next_tx_state <= TX_REST;
            end
            TX_DONE: begin
                if(~tx_send_i) next_tx_state <= TX_IDLE;
                else next_tx_state <= TX_DONE;
            end
            default: next_tx_state <= TX_IDLE;
        endcase
    end

    always@(posedge gmii_tx_clk or posedge rst) begin // send_len
        if(rst) send_len <= 16'h0000;
        else if(tx_state == TX_IDLE) send_len <= 16'h0000;
        else if(tx_state == TX_MAKE && last_pkg) send_len <= nosend_len;
        else if(tx_state == TX_MAKE) send_len <= PKG_LEN;
        else send_len <= send_len;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin // nosend_len
        if(rst) nosend_len <= 16'h0000;
        else if(tx_state == TX_IDLE) nosend_len <= 16'h0000;
        else if(tx_state == TX_WAIT) nosend_len <= tx_len_i;
        else if(tx_state == TX_MAKE && nosend_len > PKG_LEN) nosend_len <= nosend_len - PKG_LEN; 
        else if(tx_state == TX_DONE) nosend_len <= 16'h0000;
        else nosend_len <= nosend_len; 
    end

    always@(posedge gmii_tx_clk or posedge rst) begin // last_pkg
        if(rst) last_pkg <= 1'b0;
        else if(tx_state == TX_IDLE) last_pkg <= 1'b0;
        else if(tx_state == TX_DOOR && nosend_len <= PKG_LEN) last_pkg <= 1'b1;
        else last_pkg <= last_pkg;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) tx_addr_o <= RAM_SEND_RXA_INIT;
        else if(tx_state == TX_IDLE) tx_addr_o <= RAM_SEND_RXA_INIT;
        else if(tx_state == TX_WAIT) tx_addr_o <= tx_addr_i;
        else if(tx_state == TX_TAKE && (udp_ram_data_req)) tx_addr_o <= tx_addr_o + 1'b1;
        else if(tx_state == TX_WORK && next_tx_state == TX_WORK) tx_addr_o <= tx_addr_o + 1'b1;
        else tx_addr_o <= tx_addr_o;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin // tx_ram_wr_en
        if(rst) tx_ram_wr_en <= 1'b0;
        else if(tx_state == TX_IDLE) tx_ram_wr_en <= 1'b0;
        else if(tx_state == TX_WAIT) tx_ram_wr_en <= 1'b0;
        else if(tx_state == TX_WORK) tx_ram_wr_en <= 1'b1;
        else tx_ram_wr_en <= 1'b0;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) tx_cnt <= 16'h00;
        else if(tx_state == TX_IDLE) tx_cnt <= 16'h00;
        else if(tx_state == TX_TAKE) tx_cnt <= 16'h0000;
        else if(tx_state == TX_WORK) tx_cnt <= tx_cnt + 1'b1;
        else tx_cnt <= 16'h00;
    end

    mac_top
    mac_top_dut(
        .gmii_tx_clk(gmii_tx_clk),
        .gmii_rx_clk(gmii_rx_clk),
        .rst_n(rst_n),

        .source_mac_addr(48'h00_0A_35_01_FE_C0),
        .TTL(8'h80),
        .source_ip_addr(32'hC0_A8_16_C8),
        .destination_ip_addr(32'hC0_A8_16_64),
        .udp_send_source_port(16'h1F90),
        .udp_send_destination_port(16'h1F90),

        .ram_wr_data(tx_ram_wr_data),
        .ram_wr_en(tx_ram_wr_en),
        .udp_ram_data_req(udp_ram_data_req),
        .udp_send_data_length(send_len),
        .udp_tx_end(udp_tx_end),
        .udp_send_end(udp_send_end),
        .almost_full(almost_full),

        .udp_tx_req(udp_tx_req),
        .arp_request_req(arp_request_req),

        .mac_send_end(mac_send_end),
        .mac_data_valid(gmii_tx_en_a0),
        .mac_tx_data(gmii_txd_a0),
        .rx_dv(gmii_rx_dv_d0),
        .mac_rx_datain(gmii_rxd_d0),

        .udp_rec_ram_rdata(rx_data_o),
        .udp_rec_ram_read_addr(1'b0),
        .udp_rec_data_length(rx_length_o),

        .udp_rec_data_valid(rx_valid_o),
        .arp_found(arp_found),
        .mac_not_exist(mac_not_exist)
    );
    
 
  
endmodule