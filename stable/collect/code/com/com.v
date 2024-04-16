module com(
    input clk,
    input rst,
    input gmii_txc,
    input gmii_rxc,

    output e_mdc,
    inout e_mdio,
    output e_rstn,

    input [7:0] e_rxd,
    input e_rxdv,
    input e_rxer,
    output [7:0] e_txd,
    output e_txen,
    output e_txer,

    output fs_read,
    input fd_read,
    input fs_send,
    output fd_send,

    output [15:0] ram_data_rxa,
    input [7:0] ram_data_rxd,
    input [12:0] data_len,

    output ram_cmd_txen,
    output [7:0] ram_cmd_txa,
    output [7:0] ram_cmd_txd,
    output [7:0] ram_cmd_rxa,
    input [7:0] ram_cmd_rxd,

    output [3:0] com_btype,
    output [51:0] cache_cmd,

    input [3:0] data_idx
);

    wire fs_eth_read, fd_eth_read;
    wire fs_eth_send, fd_eth_send;

    wire [14:0] ram_data_rxa_init;
    wire [12:0] ram_data_dlen;

    wire fs_com_send, fd_com_send;
    wire fs_com_read, fd_com_read;

    wire [3:0] com_tx_btype, com_rx_btype;
    wire [15:0] ram_cmd_dlen;

    localparam CMD_RXA = 8'h0A;
    localparam PASSWORD = 16'h55AA;

    eth 
    eth_dut(
        .sys_clk(clk), 
        .rst(rst),

        .e_mdc(e_mdc),
        .e_mdio(e_mdio),
        .e_reset(e_rstn),

        .gmii_txc(gmii_txc),
        .gmii_rxc(gmii_rxc),
        .gmii_rxd(e_rxd),
        .gmii_rx_dv(e_rxdv),
        .gmii_rx_er(e_rxer),
        .gmii_txd(e_txd),
        .gmii_tx_en(e_txen),
        .gmii_tx_er(e_txer),
        
        .tx_send_i(fs_eth_send),
        .tx_done_o(fd_eth_send),
        .tx_len_i(ram_data_dlen),
        .tx_addr_i(ram_data_rxa_init),
        .tx_addr_o(ram_data_rxa),
        .tx_data_i(ram_data_rxd),

        .rx_addr_i(CMD_RXA),
        .rx_done_o(fs_eth_read),
        .rx_ready(fd_eth_read),
        .rx_addr_o(ram_cmd_txa),
        .rx_data_o(ram_cmd_txd),
        .rx_len_o(ram_cmd_dlen),
        .rx_valid_o(ram_cmd_txen)
    ); 

    com_read#(
        .RAM_ADDR_INIT(CMD_RXA)
    )com_read_dut(
        .clk(gmii_rxc),
        .rst(rst),

        .fs_eth(fs_eth_read),
        .fd_eth(fd_eth_read),
        .fs(fs_com_read),
        .fd(fd_com_read),

        .password(PASSWORD),

        .rxa(ram_cmd_rxa),
        .rxd(ram_cmd_rxd),

        .btype(com_rx_btype),
        .com_cmd(cache_cmd[51:40]),
        .trgg_cmd(cache_cmd[39:0])
    );

    com_send
    com_send_dut(
        .clk(gmii_txc),
        .rst(rst),

        .fs_eth(fs_eth_send),
        .fd_eth(fd_eth_send),
        .fs(fs_com_send),
        .fd(fd_com_send),

        .btype(com_tx_btype),
        .didx(data_idx),
        .dlen(data_len),

        .ram_data_rxa_init(ram_data_rxa_init),
        .data_len(ram_data_dlen)
    );

    com_cs
    com_cs_dut(
        .clk(clk),
        .rst(rst),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fs_read(fs_read),
        .fd_read(fd_read),

        .fs_com_send(fs_com_send),
        .fd_com_send(fd_com_send),
        .fs_com_read(fs_com_read),
        .fd_com_read(fd_com_read),

        .com_tx_btype(com_tx_btype),
        .com_rx_btype(com_rx_btype),

        .com_btype(com_btype)
    );

endmodule