module main(

);

    usb
    usb_dut0(
        .sys_clk(),
        .usb_txc(),
        .usb_rxc(),
        .pin_txc(),
        .pin_rxc(),
        .pin_cc(),

        .rst(),

        .pin_rxd(),
        .pin_txd(),
        .fire_send(),
        .fire_read(),

        .fs_send(),
        .fd_send(),
        .send_btype(),
        .cache_cmd(),

        .fs_read(),
        .fd_read(),
        .read_btype(),
        .cache_stat(),

        .ram_addr_init(),
        .ram_txen(),
        .ram_txa(),
        .ram_txd()
    );

    com
    com_dut(
        // CRE

        // PIN

        .fs_send(),
        .fd_send(),
        .send_btype(),
        .send_dlen(),
        .ram_addr_init(),

        .fs_read(),
        .fd_read(),
        .read_btype(),
        .cache_cmd(),

        .ram_rxd(),
        .ram_rxa()
    );

    data_make
    data_make_dut(
        .clk(),
        .rst(),

        .fs(),
        .fd(),

        .btype(),
        .data_idx(),

        .cache_stat(),

        .cache_ram_rxa(),
        .cache_ram_rxd(),

        .ram_txa(),
        .ram_txd(),
        .ram_txen()
    );

    console
    console_dut(
        .clk(),
        .rst(),

        .cache_fs_usb_send(),
        .cache_fd_usb_send(),
        .cache_fs_usb_read(),
        .cache_fs_usb_read(),

        .usb_send_btype(),
        .usb_read_btype(),

        .fs_com_send(),
        .fd_com_send(),
        .fs_com_read(),
        .fd_com_read(),

        .com_send_btype(),
        .com_read_btype(),

        .cache_cmd(),
        .cache_stat()
    );




endmodule