`timescale 1ns / 1ps   

module eth
(
    input               sys_clk,   
    input               rst, 
     
    
    output              e_mdc,
    inout               e_mdio,
    output reg          e_reset = 'd0,
 
    input               gmii_tx_clk         ,
    input               gmii_rx_clk         ,
    input[7:0]	        gmii_rxd            , 
    input               gmii_rx_dv          ,
    input               gmii_rx_er          ,
    output 	            gmii_tx_en          ,
    output[7:0]         gmii_txd            ,                              
    output 		        gmii_tx_er          ,
    
    input               tx_send_i           ,//发送使能，上升沿有效
    input[15:0]         tx_len_i            ,//发送长度， 单位Byte
    input[15:0]         tx_addr_i           ,//发送开始地址，单位Byte
    output[15:0]        tx_addr_o           ,//读取发送数据的地址 ---net to ram 
    input[7:0]          tx_data_i           ,//发送的数据        --- ram to net
    output              tx_done_o           ,//发送完拉高，发送使能变低，有点延迟无所谓，1us都可以
    
    input[15:0]         rx_addr_i           ,//接收地址， 
    output reg[7:0]     rx_data_o       = 'd0   ,//接收数据
    output reg[15:0]    rx_addr_o       = 'd0   ,//接收数据的地址，每次都从rx_addr_i开始递增
    output reg          rx_valid_o      = 'd0   ,//接收的有效数据-- 可以直接 ram wr
    input               rx_ready                ,//默认是低，为高的时候，拉低rx_done_o，等待rx_ready拉低
    output reg[7:0]    rx_len_o        = 'd0   ,//接收长度， 单位Byte
    output reg          rx_done_o       = 'd0   //接收完一包数据，拉高
    //rx_done_o &  rx_ready都低时，打开接收
    
);

    wire[15:0]      rx_length         ;//接收数据长度
    wire[7:0]       rx_data           ;//接收数据
    wire            rx_valid          ;//接收的有效数据

    reg             rst_n       = 'd0;
    reg[19:0]       rst_cnt     = 'd0; 
    
    wire  [31:0]    pack_total_len ; 
     
    assign gmii_tx_er   = 1'b0; 

    wire [1:0]      speed      ;
    wire            link       ;
    wire            e_rx_dv    ;
    wire [7:0]      e_rxd      ;
    wire            e_tx_en    ;
    wire [7:0]      e_txd      ;
    wire            e_rst_n    ;
    always @(posedge sys_clk) begin
        if(rst) begin
            e_reset     <= 'd0;    
            rst_n       <= 'd0;    
            rst_cnt     <= 'd0;    
        end
        else begin
            rst_cnt     <= rst_cnt + 'd1;
            if(rst_cnt[18])
                e_reset <= 'd1;
            if(rst_cnt[19])
                rst_n   <= 'd1;
        end
    end

    gmii_arbi arbi_inst(
     .clk                (gmii_tx_clk      ),
     .rst_n              (rst_n            ),
     .speed              (speed            ),  
     .link               (link             ), 
     .pack_total_len     (pack_total_len   ), 
     .e_rst_n            (e_rst_n          ),
     .gmii_rx_dv_r       (gmii_rx_dv       ),
     .gmii_rxd_r         (gmii_rxd         ),
     .gmii_tx_en         (e_tx_en          ),
     .gmii_txd           (e_txd            ), 
     .e_rx_dv            (e_rx_dv          ),
     .e_rxd              (e_rxd            ),
     .e_tx_en_r          (gmii_tx_en       ),
     .e_txd_r            (gmii_txd         )  
    );
 
    
    smi_config  smi_config_inst       (
        .clk         (sys_clk  ),
        .rst_n       (rst_n    ),		 
        .mdc         (e_mdc    ),
        .mdio        (e_mdio   ),
        .speed       (speed    ),
        .link        (link     ) 
       );
	 
    
    mac_test mac_test0(
     .tx_len_i               (tx_len_i        ),
     .tx_send_i              (tx_send_i       ),
     .tx_addr_i              (tx_addr_i       ),
     .tx_addr_o              (tx_addr_o       ),
     .tx_data_i              (tx_data_i       ), 
     .tx_done_o              (tx_done_o       ), 
     .rx_data_o              (rx_data         ),
     .rx_valid_o             (rx_valid        ),
     .rx_length_o            (rx_length       ),
     .gmii_tx_clk            (gmii_tx_clk     ),
     .gmii_rx_clk            (gmii_rx_clk     ),
     .rst_n                  (e_rst_n         ),
    
     .pack_total_len         (pack_total_len  ),
     .gmii_rx_dv             (e_rx_dv      ),
     .gmii_rxd               (e_rxd        ),
     .gmii_tx_en             (e_tx_en      ),
     .gmii_txd               (e_txd        )
     
    );  
    reg                     sts_rx  = 'd0;
    reg[1:0]                bytes   = 'd0;
    reg                     hasdata = 'd0;
    always @(posedge gmii_rx_clk) begin
        case(sts_rx)
            'd0:begin
                hasdata             <= 'd0;
                if(rx_ready) begin//高时拉低rx_done_o
                    rx_done_o       <= 'd0;
                end
                else begin
                    if(!rx_done_o & (!rx_valid)) begin//同为低时进入接收
                        rx_addr_o   <= rx_addr_i;
                        sts_rx      <= 'd1;
                    end
                end
            end
            'd1:begin
                rx_len_o            <= rx_length[7:0];
                rx_data_o           <= rx_data;
                rx_valid_o          <= rx_valid;
                if(rx_valid)begin
                    if(hasdata)
                        rx_addr_o   <= rx_addr_o + 'd1;
                    hasdata         <= 'd1;
                end
                else if(hasdata) begin
                    rx_done_o       <= 'd1;    
                    sts_rx          <= 'd0;
                end
            end
        endcase 
    end   
	 
    
endmodule

