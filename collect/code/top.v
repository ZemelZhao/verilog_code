module top(
    input clk_in_p,
    input clk_in_n,

    input rst_n,
    output fan_n
);

    wire fs_eth_send, fd_eth_send;
    wire fs_eth_read, fd_eth_read;
    wire [3:0] send_eth_btype, read_eth_btype;

    wire [0:7] fs_usb_send, fd_usb_send;
    wire [0:7] fs_udb_read, fd_usb_read;
    wire [0:31] send_usb_btype, read_usb_btype;

    wire [15:0] com_cmd;
    wire [3:0] data_idx;
    wire [95:0] cache_info; 

    wire [0:255] cache_stat, cache_cmd;

    wire [15:0] ram_data_rxa, ram_data_txa;
    wire [7:0] ram_data_rxd, ram_data_txd;
    wire ram_data_txen;

    wire [11:0] ram_usb_rxa;
    wire [0:63] ram_usb_rxd;

    console
    console_dut(
        .clk(),
        .rst(),

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

        .cache_stat(cache_stat),
        .cache_cmd(cache_cmd),
        .adc_info(cache_info),
        .com_cmd(com_cmd)
    );

    com
    com_dut(
        .clk(),
        .rst(),

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

        .e_grxc(e_grxc),
        .e_gtxc(e_gtxc),
        .e_rxdv(e_rxdv),
        .e_txen(e_txen),
        .e_rxer(e_rxer),
        .e_txer(e_txer),

        .e_txd(e_txd),
        .e_rxd(e_rxd)
    );

    data_make
    data_make_dut(
        .clk(),
        .rst(),

        .fs(fs_com_send),

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
        for (i=0; i<8; i=i+1) begin : usb_module_
            usb
            usb_dut(
                .sys_clk(),
                .usb_txc(),
                .usb_rxc(),
                .pin_txc(),
                .pin_rxc(),
                .pin_cc(),

                .rst(rst),

                .fs_send(fs_usb_send[i]),
                .fd_send(fd_usb_send[i]),
                .fs_read(fs_usb_read[i]),
                .fd_read(fd_usb_read[i]),

                .send_btype(send_usb_btype[3*i +: 4]),
                .read_btype(read_usb_btype[3*i +: 4]),

                .data_idx(data_idx),
                .cache_cmd(cache_cmd[32*i +: 32]),
                .cache_stat(cache_stat[32*i +: 32]),

                .ram_rxa(ram_usb_rxa),
                .ram_rxd(ram_usb_rxd[8*i +: 8]),

                .pin_rxd(pin_rxd[4*i +: 4]),
                .pin_txd(pin_txd[i]),
                .pin_send(pin_send[i]),
                .pin_read(pin_read[i])
            );
        end
    endgenerate


endmodule