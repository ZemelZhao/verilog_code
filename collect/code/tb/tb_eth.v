`timescale 1ns / 1ps 

module tb_eth(
    input                               clk_in_p            ,
    input                               clk_in_n            ,
    
    output                              fan_n               ,
    output[7:0]                              led_n               ,
    /******************* 网口 接口 ***********/
    
    output                              e_mdc               ,
    inout                               e_mdio              ,
    output                              e_rstn              ,
    output                              e_gtxc              ,
    input                               e_grxc              ,
    input[7:0]	                        e_rxd               , 
    input                               e_rxdv              ,
    input                               e_rxer              ,
    output 	                            e_txen              ,
    output[7:0]                         e_txd               ,                              
    output 		                        e_txer           
); 
    wire                                clk_norm             ; 
    wire                                locked              ;    
    wire rst;
    assign                              fan_n   = 'd0       ;
    assign led_n = 8'h55;

    wire e_grxc_g;
    wire gmii_txc, gmii_rxc;

    assign e_gtxc = ~e_grxc_g;
    assign gmii_txc = e_grxc_g;
    assign gmii_rxc = e_grxc_g;
    assign rst = ~locked;
 
    clk_wiz clk_wiz_dut  (
        .clk_norm       (   clk_norm     ),   
        .locked         (   locked      ),    
        .clk_in1_p      (   clk_in_p    ),   
        .clk_in1_n      (   clk_in_n    )
    );     


    (* MARK_DEBUG="true" *)reg               fs_eth_send  = 'd0     ;//发�?�使能，上升沿有�?
    reg[15:0]         ram_data_dlen  = 'd0            ;//发�?�长度，单位Byte
    (* MARK_DEBUG="true" *)wire[15:0]         ram_data_rxa           ;//读取发�?�数据的地址
    (* MARK_DEBUG="true" *)reg[15:0]          ram_data_rxa_init = 'd0     ;//送开始地�?，单位Byte
    (* MARK_DEBUG="true" *)wire[7:0]          ram_data_rxd           ;//发�?�的数据
    (* MARK_DEBUG="true" *)wire               fd_eth_send           ;//接收时钟
    
    (* MARK_DEBUG="true" *)wire[7:0]          ram_cmd_txd           ;//接收数据
    (* MARK_DEBUG="true" *)reg[15:0]          ram_cmd_rxa_init = 'd10    ;//接收数据的地�?
    (* MARK_DEBUG="true" *)wire[15:0]         ram_cmd_txa           ;//接收数据的地�?
    (* MARK_DEBUG="true" *)wire[15:0]         ram_cmd_dlen            ;//接收数据的地�?
    (* MARK_DEBUG="true" *)reg                fd_eth_read  = 'd0     ;
    (* MARK_DEBUG="true" *)wire               ram_cmd_txen          ;//接收的有效数�?
    (* MARK_DEBUG="true" *)wire               fs_eth_read           ;//接收的有效数�?

/*
    1、mac_test.v source_ip_addr              修改 FPGA IP地址
    2、mac_test.v udp_send_source_port       修改 FPGA IP 端口
    3、mac_test.v destination_ip_addr        修改 PC  IP地址
    4、mac_test.v udp_send_destination_port  修改 PC  端口
*/

    eth 
    eth_dut(
        .sys_clk(clk_norm), 
        .rst(rst),

        .e_mdc(e_mdc),
        .e_mdio(e_mdio),
        .e_reset(e_rstn),

        .gmii_txc(gmii_txc),
        .gmii_rxc(gmii_rxc),
        .gmii_rxd(e_rxd),
        .gmii_rx_dv(e_rxdv),
        .gmii_rx_er(e_rxer),
        .gmii_tx_en(e_txen),
        .gmii_txd(e_txd),
        .gmii_tx_er(e_txer),
        
        .tx_send_i(fs_eth_send),
        .tx_len_i(ram_data_dlen),
        .tx_addr_i(ram_data_rxa_init),
        .tx_addr_o(ram_data_rxa),
        .tx_data_i(ram_data_rxd),
        .tx_done_o(fd_eth_send),

        .rx_addr_i(ram_cmd_rxa_init),
        .rx_ready(fd_eth_read),
        .rx_done_o(fs_eth_read),
        .rx_addr_o(ram_cmd_txa),
        .rx_data_o(ram_cmd_txd),
        .rx_len_o(ram_cmd_dlen),
        .rx_valid_o(ram_cmd_txen)
    ); 

    
    // 写�?�增数据�?1�?始）到ram
    reg                 tx_wea = 'd0;
    reg[15:0]           tx_addr = 'd0;
    reg[7:0]            tx_data = 'd1; 
    reg                 flag    = 'd1;//只写�?�?

    always @(posedge clk_norm) begin//
        if(tx_wea)begin
             tx_data     <= tx_data + 'd1;
             tx_addr     <= tx_addr + 'd1; 
        end
        if(locked) begin
            if(tx_addr != 'hFFFF) begin
                tx_wea      <= flag;
            end
            else begin
                tx_wea      <= 'd0;
                flag        <= 'd0;
            end
        end 
        else begin
            flag            <= 'd1;
            tx_wea          <= 'd0;
            tx_addr         <= 'd0;
        end
    end  
    // 8KHz发�?�数�?
    reg[1:0]            sts_tx = 'd0;
    reg[31:0]           cnt_time = 'd0; 
    wire        tx_en;
    vio_0 u_vio_0 (
      .clk          (clk_norm),                // input wire clk
      .probe_out0   (tx_en  ) 
    );
    always @(posedge clk_norm) begin 
        ram_data_dlen                <= 'd20;
        if(tx_en) begin
            if(cnt_time  < ('d3125-'d1))//125us = 8KHz
//            if(cnt_time  < ('d312500-'d1))//12.500ms 
                cnt_time        <= cnt_time + 'd1;
            else begin
                fs_eth_send       <= ~fs_eth_send;
                if(fs_eth_send)
                    ram_data_rxa_init   <= ram_data_rxa_init + 'd1;
                cnt_time        <= 'd0;
            end
        end
        else begin
            fs_eth_send           <= 'd0;
            ram_data_rxa_init           <= 'd0;
            cnt_time            <= 'd0;
        end 
    end

    ram_cmd 
    ram_cmd_dut (
        .clka   (   clk_norm        ),    // input wire clka
        .wea    (   tx_wea          ),      // input wire [0 : 0] wea
        .addra  (   tx_addr         ),  // input wire [15 : 0] addra 
        .dina   (   tx_data         ),    // input wire [7 : 0] dina
        .clkb   (   gmii_txc        ),    // input wire clkb
        .addrb  (   ram_data_rxa       ),  // input wire [15 : 0] addrb
        .doutb  (   ram_data_rxd       )  // output wire [5 : 0] doutb
    );
    
    // 接收数据
    (* MARK_DEBUG="true" *)reg[7:0]           cnt_ready = 'd0;
    (* MARK_DEBUG="true" *)reg[1:0]           sts_rx    = 'd0;
    always @(posedge clk_norm) begin
        case(sts_rx)
            'd0:begin
                cnt_ready       <= 'd0;
                if(fs_eth_read) begin
                    sts_rx      <= 'd1;
                end
            end 
            'd1:begin
                cnt_ready       <= cnt_ready + 'd1;
                if(cnt_ready[7]) begin
                    sts_rx      <= 'd2;
                    fd_eth_read    <= 'd1;
                end
            end 
            'd2:begin 
                sts_rx          <= 'd3;        
            end
            'd3:begin
                if(!fs_eth_read) begin
                    fd_eth_read    <= 'd0;
                    sts_rx      <= 'd0;
                end        
            end
        endcase 
    end


    BUFG
    bufg_dut(
        .I(e_grxc),
        .O(e_grxc_g)
    );



endmodule