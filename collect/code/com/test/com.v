module com(
    input clk,
    input rst,

// CONTROL
    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,
    
    input [3:0] send_btype,
    output [3:0] read_btype,

// RAM
    output [15:0] ram_data_rxa,
    input [7:0] ram_data_rxd,

// DATA
    input [3:0] data_idx,
    input [95:0] cache_info,
    output [15:0] com_cmd,

// GPIO
    output e_rstn,
    output e_mdc,
    inout e_mdio,

    input e_grxc,
    input e_rxdv,
    input e_rxer,
    input [7:0] e_rxd,

    input e_gtxc,
    output e_txen,
    output e_txer,
    output [7:0] e_txd
);

    wire fs_com_send, fd_com_send;
    wire fs_com_read, fd_com_read;
    wire fs_eth_send, fd_eth_send;
    wire fs_eth_read, fd_eth_read;

    wire [15:0] ram_data_rxa_init;
    wire [11:0] ram_cmd_rxa_init;
    wire [15:0] ram_data_dlen;
    
    wire [7:0] ram_cmd_txa, ram_cmd_rxa;
    wire [7:0] ram_cmd_txd, ram_cmd_rxd;
    wire ram_cmd_txen;
    wire [11:0] ram_cmd_dlen;


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

        .btype(read_btype)
    );

    com_send
    com_send_dut(
        .clk(clk),
        .rst(rst),

        .fs_send(fs_com_send),
        .fd_send(fd_com_send),

        .fs_eth_send(fs_eth_send),
        .fd_eth_send(fd_eth_send),

        .send_btype(send_btype),

        .cache_info(cache_info),
        .data_idx(data_idx),

        .ram_rxa_init(ram_data_rxa_init),
        .ram_dlen(ram_data_dlen)
    );

    com_read
    com_read_dut(
        .clk(clk),
        .rst(rst),

        .fs_read(fs_com_read),
        .fd_read(fd_com_read),

        .fs_eth_read(fs_eth_read),
        .fd_eth_read(fd_eth_read),

        .read_btype(read_btype),
        .com_cmd(com_cmd),

        .ram_rxa(ram_cmd_rxa),
        .ram_rxd(ram_cmd_rxd),
        .ram_rxa_init(ram_cmd_rxa_init)
    );


    eth 
    eth_dut(
        .sys_clk(clk), 
        .rst(rst),

        .e_mdc(e_mdc),
        .e_mdio(e_mdio),
        .e_reset(e_rstn),

        .gmii_tx_clk(e_gtxc),
        .gmii_rx_clk(e_grxc),
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



    ram_cmd
    ram_cmd_dut(
        .clka(e_grxc),
        .addra(ram_cmd_txa),
        .dina(ram_cmd_txd),
        .wea(ram_cmd_txen),

        .clkb(clk),
        .addrb(ram_cmd_rxa),
        .doutb(ram_cmd_rxd)
    );






endmodule