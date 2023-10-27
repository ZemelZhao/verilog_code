module usb(
    input sys_clk,
    input usb_txc,
    input usb_rxc,
    input pin_txc,
    input pin_rxc,
    input pin_cc,

    input rst,

    input [3:0] pin_rxd,
    output pin_txd,
    output fire_send,
    input fire_read,

    input fs_send,
    input [3:0] send_btype,
    output fd_send,
    input [31:0] cache_cmd,

    output fs_read,
    output [3:0] read_btype,
    input [11:0] read_ram_init,
    input fd_read,
    output [31:0] cache_stat,

    output [7:0] ram_txd,
    output [11:0] ram_txa,
    output ram_txen
);

    wire [3:0] usb_rxd;
    wire usb_txd;
    (*MARK_DEBUG = "true"*)wire [7:0] com_rxd, com_txd;

    wire fs_tx, fd_tx;
    wire fs_rx, fd_rx;

    wire [3:0] tx_btype, rx_btype;
    wire [11:0] rx_ram_init;

    usb_cs
    usb_cs_dut(
        .clk(sys_clk),
        .rst(rst),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fs_read(fs_read),
        .fd_read(fd_read),

        .read_btype(read_btype),
        .send_btype(send_btype),
        .read_ram_init(read_ram_init),

        .fs_tx(fs_tx),
        .fd_tx(fd_tx),
        .tx_btype(tx_btype),

        .fs_rx(fs_rx),
        .fd_rx(fd_rx),
        .rx_btype(rx_btype),
        .rx_ram_init(rx_ram_init)
    );

    usb_rx
    usb_rx_dut(
        .clk(usb_rxc),
        .rst(rst),

        .fs(fs_rx),
        .fd(fd_rx),

        .usb_rxd(com_rxd),
        .btype(rx_btype),
        .cache_stat(cache_stat),

        .ram_txa_init(rx_ram_init),
        .ram_txa(ram_txa),
        .ram_txd(ram_txd),
        .ram_txen(ram_txen)
    );

    usb_tx
    usb_tx_dut(
        .clk(usb_txc),
        .rst(rst),

        .fs(fs_tx),
        .fd(fd_tx),

        .btype(tx_btype),
        .cache_cmd(cache_cmd),
        .usb_txd(com_txd)
    );

    usb_rxf
    usb_rxf_dut(
        .clk(pin_rxc),
        .rst(rst),

        .din(usb_rxd),
        .dout(com_rxd),
        .fire(fire_read)
    );

    usb_txf
    usb_txf_dut(
        .clk(pin_txc),
        .rst(rst),
        .fs(fs_tx),

        .din(com_txd),
        .dout(usb_txd),
        .fire(fire_send)
    );

    usb_cc
    usb_cc_dut(
        .clk(pin_cc),
        .clk_fast(pin_rxc),
        .fire(fire_read),

        .usb_txd(usb_txd),
        .pin_txd(pin_txd),

        .usb_rxd(usb_rxd),
        .pin_rxd(pin_rxd)
    );









endmodule