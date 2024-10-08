module usb(
    input sys_clk,
    input usb_txc,
    input usb_rxc,
    input pin_txc,
    input pin_rxc,

    input rst,

    input [3:0] pin_rxd,
    output pin_txd,
    (*MARK_DEBUG = "true"*)output pin_send,
    (*MARK_DEBUG = "true"*)input pin_read,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    input [3:0] send_btype,
    output [3:0] read_btype,

    input [31:0] cache_cmd,
    output [31:0] cache_stat,

    input [11:0] ram_rxa,
    output [7:0] ram_rxd
);

    wire [3:0] usb_rxd;
    wire usb_txd;
    (*MARK_DEBUG = "true"*)wire [7:0] com_rxd, com_txd;

    wire fs_tx, fd_tx;
    wire fs_rx, fd_rx;

    wire [3:0] tx_btype, rx_btype;
    wire [11:0] rx_ram_init;

    wire [7:0] ram_txd;
    wire [11:0] ram_txa;
    wire ram_txen;

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
        .fire(pin_read)
    );

    usb_txf
    usb_txf_dut(
        .clk(pin_txc),
        .rst(rst),
        .fs(fs_tx),

        .din(com_txd),
        .dout(usb_txd),
        .fire(pin_send)
    );

    usb_cc
    usb_cc_dut(
        .usb_txd(usb_txd),
        .pin_txd(pin_txd),

        .usb_rxd(usb_rxd),
        .pin_rxd(pin_rxd)
    );

    ram_usb
    ram_usb_dut(
        .clka(usb_rxc),
        .addra(ram_txa),
        .dina(ram_txd),
        .wea(ram_txen),

        .clkb(pin_rxc),
        .addrb(ram_rxa),
        .doutb(ram_rxd)
    );


endmodule