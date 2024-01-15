module top(
    input clk_in_p,
    input clk_in_n,

    input rst_n,
    output fan_n,

// Ethernet
    output e_rstn,
    output e_mdc,
    inout e_mdio,

    input e_grxc,
    input e_rxdv,
    input e_rxer,
    input [7:0] e_rxd,

    output e_gtxc,
    output e_txen,
    output e_txer,
    output [7:0] e_txd,

// USB
    input [0:31] u_rxd,
    input [0:7] u_read,
    output [0:7] u_txd,
    output [0:7] u_send
);

// CRE

    wire clk_slow, clk_norm, clk_fast;
    wire gmii_rxc, gmii_txc;

    wire locked;

    wire rst;

    assign e_gtxc = ~gmii_rxc;
    assign gmii_txc = gmii_rxc;


// CONTROL
    wire fs_eth_send, fd_eth_send;
    wire fs_eth_read, fd_eth_read;
    wire [3:0] send_eth_btype, read_eth_btype;

    wire [0:7] fs_usb_send, fd_usb_send;
    wire [0:7] fs_usb_read, fd_usb_read;
    wire [0:31] send_usb_btype, read_usb_btype;

// DATA
    wire [15:0] com_cmd;
    wire [3:0] data_idx;
    wire [95:0] cache_info; 

    wire [0:255] cache_stat, cache_cmd;

// RAM
    wire [15:0] ram_data_rxa, ram_data_txa;
    wire [7:0] ram_data_rxd, ram_data_txd;
    wire ram_data_txen;

    wire [11:0] ram_usb_rxa;
    wire [0:63] ram_usb_rxd;


// Combinational Circuit
    BUFG
    BUFG_inst(
        .I(e_grxc),
        .O(gmii_rxc)
    );

    assign e_gtxc = ~gmii_rxc;
    assign gmii_txc = gmii_rxc;
    assign rst = ~rst_n;

    console
    console_dut(
        .clk(clk_norm),
        .rst(~locked),

        .fs_eth_send(fs_eth_send),
        .fd_eth_send(fd_eth_send),
        .fs_eth_read(fs_eth_read),
        .fd_eth_read(fd_eth_read),

        .fs_usb_send(fs_usb_send),
        .fd_usb_send(fd_usb_send),
        .fs_usb_read(fs_usb_read),
        .fd_usb_read(fd_usb_read),

        .send_eth_btype(send_eth_btype),
        .read_eth_btype(read_eth_btype),
        .send_usb_btype(send_usb_btype),
        .read_usb_btype(read_usb_btype),

        .cache_cmd(cache_cmd),
        .cache_info(cache_info),
        .com_cmd(com_cmd)
    );

    com
    com_dut(
        .clk(clk_norm),
        .rst(~locked),

        .fs_send(fs_eth_send),
        .fd_send(fd_eth_send),
        .fs_read(fs_eth_read),
        .fd_read(fd_eth_read),

        .send_btype(send_eth_btype),
        .read_btype(read_eth_btype),

        .ram_data_rxa(ram_data_rxa),
        .ram_data_rxd(ram_data_rxd),

        .cache_stat(cache_stat),
        .cache_info(cache_info),
        .data_idx(data_idx),
        .com_cmd(com_cmd),

        .e_mdc(e_mdc),
        .e_mdio(e_mdio),
        .e_rstn(e_rstn),

        .e_grxc(gmii_rxc),
        .e_gtxc(gmii_txc),
        .e_rxdv(e_rxdv),
        .e_txen(e_txen),
        .e_rxer(e_rxer),
        .e_txer(e_txer),

        .e_txd(e_txd),
        .e_rxd(e_rxd)
    );

    data_make
    data_make_dut(
        .clk(clk_fast),
        .rst(~locked),

        .fs(fs_eth_send),
        .fd(),

        .btype(send_eth_btype),
        .data_idx(data_idx),

        .cache_info(cache_info),

        .cache_ram_rxa(ram_usb_rxa),
        .cache_ram_rxd(ram_usb_rxd),

        .ram_txa(ram_data_txa),
        .ram_txd(ram_data_txd),
        .ram_txen(ram_data_txen)
    );

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : usb_dut
            usb
            usb_inst(
                .sys_clk(clk_norm),
                .usb_txc(clk_slow),
                .usb_rxc(clk_norm),
                .pin_txc(clk_fast),
                .pin_rxc(clk_fast),

                .rst(~locked),

                .fs_send(fs_usb_send[i]),
                .fd_send(fd_usb_send[i]),
                .fs_read(fs_usb_read[i]),
                .fd_read(fd_usb_read[i]),

                .send_btype(send_usb_btype[4*i +: 4]),
                .read_btype(read_usb_btype[4*i +: 4]),

                .data_idx(data_idx),
                .cache_cmd(cache_cmd[32*i +: 32]),
                .cache_stat(cache_stat[32*i +: 32]),

                .ram_rxa(ram_usb_rxa),
                .ram_rxd(ram_usb_rxd[8*i +: 8]),

                .pin_rxd(u_rxd[4*i +: 4]),
                .pin_txd(u_txd[i]),
                .pin_send(u_send[i]),
                .pin_read(u_read[i])
            );
        end
    endgenerate

    clk_wiz
    clk_wiz_dut(
        .clk_in1_p(clk_in_p),
        .clk_in1_n(clk_in_n),
        .reset(rst),
        .locked(locked),
        .clk_slow(clk_slow),
        .clk_norm(clk_norm),
        .clk_fast(clk_fast)
    );

    ram_data
    ram_data_dut(
        .clka(clk_fast),
        .addra(ram_data_txa),
        .dina(ram_data_txd),
        .wea(ram_data_txen),

        .clkb(e_gtxc),
        .addrb(ram_data_rxa),
        .doutb(ram_data_rxd)
    );


endmodule