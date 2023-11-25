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
    input [7:0] cache_stat, 
    input [95:0] cache_info,
    output [15:0] com_cmd,

// GPIO
    output e_rstn,
    output e_mdc,
    input e_mdio,

    input e_grxc,
    input e_rxdv,
    input e_rxer,
    input [7:0] e_rxd,

    input e_gtxc,
    output e_txen,
    output e_txer,
    output [7:0] e_txd
);

    wire fs_com_tran, fd_com_tran;
    wire fs_com_send, fd_com_send;
    wire fs_com_read, fd_com_read;
    wire fs_eth_send, fd_eth_send;
    wire fs_eth_read, fd_eth_read;

    wire [15:0] ram_data_rxa_init;
    wire [15:0] ram_data_dlen;


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
        .fd_com_read(fd_com_read)
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
        .ram_rxd(ram_cmd_rxd)
    );



    eth
    eth_dut(
        .clk(clk),
        .rst(rst),

        .fs_send(fs_eth_send),
        .fd_send(fd_eth_send),
        .fs_read(fs_eth_read),
        .fd_read(fd_eth_read),

        .eth_rxa_init(ram_data_rxa_init),
        .eth_rxd_len(ram_data_dlen),

        .eth_txa(ram_cmd_txa),
        .eth_txd(ram_cmd_txd),
        .eth_txen(ram_cmd_txen),

        .eth_rxa(ram_data_rxa),
        .eth_rxd(ram_data_rxd),

// GPIO
        .e_mdc(e_mdc),
        .e_mdio(e_mdio),
        .e_rstn(e_rstn),

        .e_grxc(e_grxc),
        .e_gtxc(e_gtxc),
        .e_rxdv(e_rxdv),
        .e_txen(e_txen),
        .e_rxer(e_rxer),
        .e_txer(e_txer),

        .e_txd(e_txd),
        .e_rxd(e_rxd)
    );

    ram_cmd
    ram_cmd_dut(
        .clka(),
        .addra(ram_cmd_txa),
        .dina(ram_cmd_txd),
        .wea(ram_cmd_txen),

        .clkb(clk),
        .addrb(ram_cmd_rxa),
        .doutb(ram_cmd_rxd)
    );






endmodule