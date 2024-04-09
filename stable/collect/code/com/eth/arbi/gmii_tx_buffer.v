`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module gmii_tx_buffer
(
 input              clk,
 input              rst_n, 
 input              eth_100m_en,      //ethernet 10M/100M enable
 input              eth_10m_en,      //ethernet 10M/100M enable
// input              link,                //ethernet link signal
 input              gmii_tx_en,          //gmii tx enable
 input  [7:0]       gmii_txd,            //gmii txd
 output reg         e10_100_tx_en = 'd0,       //ethernet 10/100M tx enable
 output reg [7:0]   e10_100_txd   = 'd0       //ethernet 10/100M txd

 
);
 
reg  [7:0]            tx_wdata     = 'd0;      //tx data fifo write data
reg                   tx_wren      = 'd0;      //tx data fifo write enable
reg                   tx_rden      = 'd0;      //tx data fifo read enable
reg  [15:0]           tx_data_cnt  = 'd0;      //tx data counter
wire [7:0]            tx_rdata    ;      //tx fifo read data
 
                      
reg   [15:0]          tx_len_cnt     = 'd0;    //tx length counter           
reg   [1:0]           len_cnt        = 'd0;    //length latch counter
wire  [4:0]           pack_num      ;    //length fifo usedw
reg                   tx_len_wren    = 'd0;    //length fifo wren
reg                   tx_len_rden    = 'd0;    //length fifo rden
reg  [15:0]           tx_len_wdata   = 'd0;    //length fifo write data
wire  [15:0]          tx_len        ;    //length fifo read data

 
reg[0:0]              sts_wr       = 'd0;
reg[1:0]              sts_rd       = 'd0;
reg                   first        = 'd1;
reg                   tail         = 'd0;
reg                   head         = 'd1;


always @(posedge clk) begin  
    case(sts_wr)
        'd0:begin 
            tx_len_wren             <= 'd0;
            tx_len_wdata            <= 'd0;    
            if(gmii_tx_en) begin 
                sts_wr              <= 'd1;          
            end
        end  
        'd1:begin 
            tx_len_wdata            <= tx_len_wdata + 'd1;   
            if(!gmii_tx_en) begin    
                sts_wr              <= 'd0;   
                tx_len_wren         <= 'd1;
            end            
        end 
    endcase
end
 
 
always @(posedge clk) begin 
    if(tx_rden)
        tx_rden                     <= 'd0;
    case(sts_rd)
        'd0:begin
            e10_100_tx_en           <= 'd0; 
            tx_data_cnt             <= 'd1;
            if(pack_num > 'd0) begin
                tx_len_rden         <= 'd1;
                tx_rden             <= 'd1;
                sts_rd              <= 'd1;
            end
        end 
        'd1:begin 
            head                    <= 'd1;
            tail                    <= 'd0;
            first                   <= 'd1; 
            tx_len_rden             <= 'd0;
            sts_rd                  <= 'd2;
        end 
        'd2:begin   
            e10_100_tx_en               <= 'd1; 
            e10_100_txd[3:0]            <= first ? tx_rdata[3:0] : tx_rdata[7:4];
            if(head&eth_10m_en) 
                head                    <= 'd0;
            else begin
                first                   <= ~first;
                if(tail) 
                    sts_rd              <= 'd0;
                if(first) begin
                    if(tx_data_cnt < tx_len) begin
                        tx_rden         <= 'd1;
                        tail            <= 'd0;
                    end
                    else
                        tail            <= 'd1;
                end  
                else
                    tx_data_cnt         <= tx_data_cnt + 'd1; 
            end
        end
    endcase
 end

 eth_data_fifo tx_fifo 
 (
    .clk        (clk            ),                // input wire clk
    .rst        (~rst_n         ),                // input wire rst
    .din        (gmii_txd       ),                // input wire [7 : 0] din
    .wr_en      (gmii_tx_en     ),            // input wire wr_en
    .rd_en      (tx_rden        ),            // input wire rd_en
    .dout       (tx_rdata       ),              // output wire [7 : 0] dout
    .full       (               ),              // output wire full
    .empty      (               ),            // output wire empty
    .data_count (               )  // output wire [11 : 0] data_count
    );  
 
len_fifo tx_len_fifo
    (	
    .clk        (clk            ),                // input wire clk
    .rst        (~rst_n         ),                // input wire rst
    .din        (tx_len_wdata   ),                // input wire [7 : 0] din
    .wr_en      (tx_len_wren    ),            // input wire wr_en
    .rd_en      (tx_len_rden    ),            // input wire rd_en
    .dout       (tx_len         ),              // output wire [7 : 0] dout
    .full       (               ),              // output wire full
    .empty      (               ),            // output wire empty
    .data_count (pack_num       )  // output wire [11 : 0] data_count
    );  
    
endmodule
