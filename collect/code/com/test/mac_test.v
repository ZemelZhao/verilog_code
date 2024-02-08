`timescale  1ns / 1ns

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
    output reg tx_done_o,

    output [15:0] rx_length_o,
    output [7:0] rx_data_o,
    output rx_valid_o
); 

    reg [5:0] state, next_state;
    localparam IDLE = 6'h01, ARP_REQ = 6'h02, ARP_SEND = 6'h04, ARP_WAIT = 6'h08;
    localparam WAIT = 6'h10, CHECK_ARP = 6'h20;

    wire rst;
    wire mac_not_exist;
    wire arp_found;

    reg gmii_rx_dv_d0;
    reg [7:0] gmii_rxd_d0;
    wire gmii_tx_en_a0;
    wire gmii_txd_a0;

    wire udp_ram_data_req;
    wire [7:0] tx_ram_wr_data;
    reg tx_ram_wr_en;
    reg udp_tx_req;
    wire arp_request_req;
    wire mac_send_end;

    wire udp_send_end;
    reg [1:0] udp_send_end_b;
    wire udp_tx_end;
    wire almost_full;

    reg [31:0] wait_cnt;

    reg [4:0] tx_state, next_tx_state;

    assign rst = ~rst_n;
    assign arp_request_req = (state == ARP_REQ);


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

    always@(posedge gmii_rx_clk or posedge rst) begin
        if(rst) gmii_tx_en <= 1'b0;
        else gmii_tx_en <= gmii_tx_en_a0;
    end

    always@(posedge gmii_rx_clk or posedge rst) begin
        if(rst) gmii_txd <= 8'h00;
        else gmii_txd <= gmii_txd_a0;
    end

    always@(posedge gmii_tx_clk or posedge rst) begin
        if(rst) wait_cnt <= 32'h00;
        else if(state == IDLE || state == WAIT || state == ARP_WAIT && state != next_state) wait_cnt <= 32'h00;  
        else if(state == IDLE || state == WAIT || state == ARP_WAIT) wait_cnt <= wait_cnt + 1'b1;
        else wait_cnt <= 32'h00;
    end

    localparam[15:0]                  PKG_LEN   = 'd1400;//默认一包发送的最大长度
    reg[15:0]                         noSend_len = 'd0;//还未发送的数据长度
//    reg[15:0]                         send_len_b  = 'd0;//当前包发送的数据长度
    reg                               last_pkg  = 'd0;//最后一包的标记 
    reg[15:0]                         tx_cnt    = 'd0;//单位   Byte
    reg[2:0]                          tx_sts    = 'd0; 
    reg[2:0]                          tx_send_b = 'd0; 
    reg[31:0]                         tx_wait   = 'd0;  
    assign                             tx_ram_wr_data  =  tx_data_i;  

 always @(posedge gmii_tx_clk ) begin
     tx_send_b                          <= {tx_send_b[1:0],tx_send_i};
     udp_send_end_b                     <= {udp_send_end_b[0:0],udp_send_end};
     
     case(tx_sts)
        'd0:begin
            noSend_len                  <= tx_len_i; 
            last_pkg                    <= 'd0;
            if(tx_send_b[2:1] == 2'b01) begin
                tx_sts          <= 'd1;
                tx_addr_o       <= tx_addr_i;
                tx_done_o       <= 'd0;
            end   
        end
        'd1:begin    
            if(last_pkg) begin
                tx_done_o               <= 'd1;
                tx_sts                  <= 'd0;
            end
            else begin
                if(noSend_len > PKG_LEN) begin
                    send_len            <=  PKG_LEN;     
                    noSend_len          <=  noSend_len - PKG_LEN;   
                end
                else begin
                    send_len            <=  noSend_len;        
                    last_pkg            <= 'd1;
                end
                tx_sts                  <= 'd2; 
                udp_tx_req              <= 'd1;
            end 
        end
        'd2:begin    
            tx_cnt                      <= 'd1;  
            if(udp_ram_data_req) begin
                tx_addr_o               <= tx_addr_o + 'd1; 
                udp_tx_req              <= 'd0;
                tx_sts                  <= 'd3;
            end
        end
        'd3:begin 
            tx_ram_wr_en                <= 'd1;
            tx_cnt                      <= tx_cnt + 'd1;
            if(tx_cnt == send_len)   
                tx_sts                  <= 'd4;
            else
                tx_addr_o               <= tx_addr_o + 'd1; 
        end
        'd4:begin
            tx_wait                     <= 'd0;
            tx_ram_wr_en                <= 'd0;    
            if(udp_send_end_b[1:0] == 2'b10) begin //等待上一次发送完成
                tx_sts                  <= 'd5;
            end
        end
        'd5:begin
            tx_wait                     <= tx_wait + 'd1; 
            if(tx_wait == 'd125) begin //延迟 1us，防止数据太集中而导致丢失 
                tx_sts                  <= 'd1;
            end
        end
    endcase
 end 


    // always@(posedge gmii_tx_clk or posedge rst) begin
    //     if(rst) state <= IDLE;
    //     else state <= next_state;
    // end

    // always@(*) begin
    //     case(tx_state)
    //         IDLE: begin
    //             if(tx_send_b[2:1] == 2'b01) next_tx_state <= TAKE;
    //             else next_tx_state <= IDLE;
    //         end
    //         TAKE: begin
    //             if(last_pkg) next_tx_state <= IDLE;
    //             else next_tx_state <= WAIT;
    //         end
    //         WAIT: begin
    //             if(udp_ram_data_req) next_tx_state <= WORK;
    //             else next_tx_state <= WAIT;
    //         end
    //         WORK: begin
    //             if(udp_send_end_b[1:0] == 2'b10) next_tx_state <= DONE;
    //             else next_tx_state <= WORK;
    //         end

    //     endcase
    // end



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
        .ram_wr_en(rx_ram_wr_en),
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