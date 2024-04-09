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


mac_top mac_top0
(
 .gmii_tx_clk                 (gmii_tx_clk)                  ,
 .gmii_rx_clk                 (gmii_rx_clk)                  ,
 .rst_n                       (rst_n)  ,
 
 .source_mac_addr             (48'h00_0a_35_01_fe_c0)   ,       //source mac address  
 .TTL                         (8'h80),
 .source_ip_addr              (32'hc0a816C8),//192.168.22.200 
 .destination_ip_addr         (32'hc0a81664),//192.168.22.100  
 .udp_send_source_port        (16'h1f90),
 .udp_send_destination_port   (16'h1f90),//0x1f90 = 8080
 
 .ram_wr_data                 (tx_ram_wr_data) ,
 .ram_wr_en                   (tx_ram_wr_en),
 .udp_ram_data_req            (udp_ram_data_req),
 .udp_send_data_length        (send_len             ),
 .udp_tx_end                  (udp_tx_end           ),
 .udp_send_end                (udp_send_end         ),
 .almost_full                 (almost_full          ), 
 
 .udp_tx_req                  (udp_tx_req),
 .arp_request_req             (arp_request_req ),
 
 .mac_send_end                (mac_send_end),
 .mac_data_valid              (gmii_tx_en_tmp),
 .mac_tx_data                 (gmii_txd_tmp),
 .rx_dv                       (gmii_rx_dv_d0   ),
 .mac_rx_datain               (gmii_rxd_d0 ),
 
 .udp_rec_ram_rdata           (rx_data_o),
 .udp_rec_ram_read_addr       ('d0),
 .udp_rec_data_length         (rx_length_o ),
 
 .udp_rec_data_valid          (rx_valid_o),
 .arp_found                   (arp_found ),
 .mac_not_exist               (mac_not_exist )
) ;