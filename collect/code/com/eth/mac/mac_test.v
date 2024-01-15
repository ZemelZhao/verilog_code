 `timescale 1 ns/1 ns
module mac_test
(
 input                      rst_n  , 
 input [31:0]               pack_total_len,  
 input                      gmii_tx_clk ,
 input                      gmii_rx_clk ,
 input                      gmii_rx_dv,
 input  [7:0]               gmii_rxd,
 output reg                 gmii_tx_en,
 output reg [7:0]           gmii_txd,    
 
 input                      tx_send_i           ,//发送使能，上升沿有效
 input[15:0]                tx_len_i            ,//发送长度， 单位Byte
 input[15:0]                tx_addr_i           ,//发送开始地址，单位Byte
 output reg [15:0]          tx_addr_o   = 'd0   ,//读取发送数据的地址 ---net to ram 
 input[7:0]                 tx_data_i           ,//发送的数据        --- ram to net
 output reg                 tx_done_o   = 'd0  ,//发送完拉高，发送使能变低，有点延迟无所谓，1us都可以
 
 output[15:0]               rx_length_o         ,
 output [7:0]               rx_data_o           ,
 output                     rx_valid_o                    
);

    reg[15:0]                         send_len  = 'd0;//当前包发送的数据长度
    
localparam UDP_WIDTH = 32 ;
localparam UDP_DEPTH = 5 ;


reg                  gmii_rx_dv_d0 ;
reg   [7:0]          gmii_rxd_d0 ;
wire                 gmii_tx_en_tmp ;
wire   [7:0]         gmii_txd_tmp ;
 
wire                udp_ram_data_req ; 
wire  [7:0]         tx_ram_wr_data  ;
reg                 tx_ram_wr_en   = 'd0 ;
reg                 udp_tx_req     = 'd0;
wire                arp_request_req ;
wire                mac_send_end ; 
 

wire                 udp_send_end  ;
reg[1:0]             udp_send_end_b = 'd0;
wire                 udp_tx_end  ;
wire                 almost_full ;

  
reg  [31:0]          wait_cnt ; 


  

wire mac_not_exist ;
wire arp_found ;

parameter IDLE          = 7'b0000001 ;
parameter ARP_REQ       = 7'b0000010 ;
parameter ARP_SEND      = 7'b0000100 ;
parameter ARP_WAIT      = 7'b0001000 ; 
parameter SEND          = 7'b0010000 ;
parameter WAIT          = 7'b0100000 ;
parameter CHECK_ARP     = 7'b1000000 ;


reg [6:0]    state = IDLE ;
reg [6:0]    next_state = IDLE; 
reg    almost_full_d0 ;
reg    almost_full_d1 ;
always @(posedge gmii_tx_clk or negedge rst_n)
  begin
    if (~rst_n)
      state  <=  IDLE  ;
    else
      state  <= next_state ;
  end
  
always @(*)
  begin
    case(state)
      IDLE        :
        begin
        if (wait_cnt == pack_total_len)    
            next_state <= ARP_REQ ;
          else
            next_state <= IDLE ;
        end
      ARP_REQ     :
        next_state <= ARP_SEND ;
      ARP_SEND    :
        begin
          if (mac_send_end)
            next_state <= ARP_WAIT ;
          else
            next_state <= ARP_SEND ;
        end
      ARP_WAIT    :
        begin
          if (arp_found)
            next_state <= WAIT ;
          else if (wait_cnt == pack_total_len)
            next_state <= ARP_REQ ;
          else
            next_state <= ARP_WAIT ;
        end 
      SEND        :
        begin
          if (udp_tx_end)
            next_state <= WAIT ;
          else
            next_state <= SEND ;
        end
        
      WAIT        :
        begin 
		  if (wait_cnt == pack_total_len)    
            next_state <= CHECK_ARP ;
          else
            next_state <= WAIT ;
        end
      CHECK_ARP   :
        begin
          if (mac_not_exist)
            next_state <= ARP_REQ ;
          else if (almost_full_d1)
            next_state <= CHECK_ARP ; 
          else
            next_state <= CHECK_ARP;
        end
      default     :
        next_state <= IDLE ;
    endcase
  end
  
   


always@(posedge gmii_rx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        gmii_rx_dv_d0 <= 1'b0 ;
        gmii_rxd_d0   <= 8'd0 ;
      end
    else
      begin
        gmii_rx_dv_d0 <= gmii_rx_dv ;
        gmii_rxd_d0   <= gmii_rxd ;
      end
  end
  
always@(posedge gmii_tx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        gmii_tx_en <= 1'b0 ;
        gmii_txd   <= 8'd0 ;
      end
    else
      begin
        gmii_tx_en <= gmii_tx_en_tmp ;
        gmii_txd   <= gmii_txd_tmp ;
      end
  end



  
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
              
 
  
//reg    almost_full_d0 ;
//reg    almost_full_d1 ;
  
always@(posedge gmii_rx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      begin
        almost_full_d0   <= 1'b0 ;
        almost_full_d1   <= 1'b0 ;
      end
    else
      begin
        almost_full_d0   <= almost_full ;
        almost_full_d1   <= almost_full_d0 ;
      end
  end

 
   
assign arp_request_req  = (state == ARP_REQ) ;

always@(posedge gmii_tx_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      wait_cnt <= 0 ;
    else if ((state==IDLE||state == WAIT || state == ARP_WAIT) && state != next_state)
      wait_cnt <= 0 ;
    else if (state==IDLE||state == WAIT || state == ARP_WAIT)
      wait_cnt <= wait_cnt + 1'b1 ;
	 else
	   wait_cnt <= 0 ;
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
    
 
  
endmodule