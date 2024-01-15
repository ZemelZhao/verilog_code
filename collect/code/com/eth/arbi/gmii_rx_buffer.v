`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module gmii_rx_buffer
(
 input              clk,
 input              rst_n,
 input              eth_100m_en,   //ethernet 100M enable
 input              eth_10m_en,    //ethernet 100M enable
// input              link,          //ethernet link signal
 input              gmii_rx_dv,    //gmii rx dv
 input  [7:0]       gmii_rxd,      //gmii rxd
 
 output reg         e10_100_rx_dv, //ethernet 10/100 rx_dv
 output    [7:0]    e10_100_rxd    //ethernet 10/100 rxd
 
);


reg  [15:0]           rx_cnt        = 'd0;   //write fifo counter
reg                   rx_wren       = 'd0;   //write fifo wren
reg  [7:0]            rx_wdata      = 'd0;   //write fifo data
reg  [15:0]           rx_data_cnt   = 'd0;   //read fifo counter
reg                   rx_rden       = 'd0;   //read fifo rden
wire [7:0]            rx_rdata      ;   //read fifo data 
                       
wire [4:0]            pack_num      ;   //length fifo usedw
reg                   rx_len_wren   = 'd0;   //length wren
reg  [15:0]           rx_len_wdata  = 'd0;   //length write data
reg                   rx_len_rden   = 'd0;   //length rden
wire [15:0]           rx_len        ;   //legnth read data
 

reg[1:0]              sts_wr       = 'd0;
reg[1:0]              sts_rd       = 'd0;

always @(posedge clk) begin
    rx_wdata                        <= {gmii_rxd[3:0],rx_wdata[7:4]};
    if(rx_wren)
        rx_wren                     <= 'd0;
    case(sts_wr)
        'd0:begin
            rx_cnt                  <= 'd1;   
            rx_len_wren             <= 'd0;
            if(gmii_rx_dv) begin
                if(eth_100m_en)     
                    sts_wr          <= 'd2;  
                else    
                    sts_wr          <= 'd1;          
            end
        end 
        'd1:begin
            sts_wr                  <= 'd2;  
        end
        'd2:begin
            rx_len_wdata            <= {1'b0,rx_cnt[15:1]};
            rx_cnt                  <= rx_cnt + 'd1;   
            if(gmii_rx_dv) begin
                if(rx_cnt[0])
                    rx_wren         <= 'd1;        
            end
            else
                sts_wr              <= 'd3;              
        end
        'd3:begin
            rx_len_wren             <= 'd1;
            sts_wr                  <= 'd0; 
        end
    endcase
end
 
 assign                         e10_100_rxd = rx_rdata;
 always @(posedge clk) begin
    e10_100_rx_dv                   <= rx_rden;
    case(sts_rd)
        'd0:begin
            rx_data_cnt             <= 'd0;
            if(pack_num > 'd0) begin
                rx_len_rden         <= 'd1;
                sts_rd              <= 'd1;
            end
        end 
        'd1:begin 
            rx_len_rden             <= 'd0;
            sts_rd                  <= 'd2;
        end 
        'd2:begin
            rx_data_cnt             <= rx_data_cnt + 'd1;
            if(rx_data_cnt < rx_len)
                rx_rden                 <= 'd1;
            else begin
                rx_rden                 <= 'd0;
                sts_rd                  <= 'd0;
            end
        end 
    endcase
 end
 

 eth_data_fifo rx_fifo 
 (
    .clk        (clk            ),                // input wire clk
    .rst        (~rst_n         ),                // input wire rst
    .din        (rx_wdata       ),                // input wire [7 : 0] din
    .wr_en      (rx_wren        ),            // input wire wr_en
    .rd_en      (rx_rden        ),            // input wire rd_en
    .dout       (rx_rdata       ),              // output wire [7 : 0] dout
    .full       (               ),              // output wire full
    .empty      (               ),            // output wire empty
    .data_count (               )  // output wire [11 : 0] data_count
    );  
 
len_fifo rx_len_fifo
    (	
    .clk        (clk            ),                // input wire clk
    .rst        (~rst_n         ),                // input wire rst
    .din        (rx_len_wdata   ),                // input wire [7 : 0] din
    .wr_en      (rx_len_wren    ),            // input wire wr_en
    .rd_en      (rx_len_rden    ),            // input wire rd_en
    .dout       (rx_len         ),              // output wire [7 : 0] dout
    .full       (               ),              // output wire full
    .empty      (               ),            // output wire empty
    .data_count (pack_num       )  // output wire [11 : 0] data_count
    );  
endmodule
