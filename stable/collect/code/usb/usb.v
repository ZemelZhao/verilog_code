module usb(
    input sys_clk,
    input clk_ult,
    input usb_txc,
    input usb_rxc,
    input pin_txc,
    input pin_rxc,

    input rst,

    input [3:0] pin_rxd,
    output pin_txd,
    output pin_send,
    input pin_read,

    input fs_send,
    output fd_send,
    output ff_send,
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
    wire [7:0] com_rxd, com_txd;

    wire fs_tx, fd_tx;
    wire fs_rx, fd_rx;

    wire fs_ram, fd_ram;

    wire [3:0] tx_btype, rx_btype;
    wire [11:0] rx_ram_init, rm_ram_init;

    wire [7:0] rx_ram_txd, rm_ram_txd; 
    wire [11:0] rx_ram_txa, rm_ram_txa; 
    wire rx_ram_txen, rm_ram_txen; 

    (*MARK_DEBUG = "true"*)wire [7:0] ram_txd;
    (*MARK_DEBUG = "true"*)wire [11:0] ram_txa;
    (*MARK_DEBUG = "true"*)wire ram_txen;

    assign ram_txd = rx_ram_txen ?rx_ram_txd :rm_ram_txd;
    assign ram_txa = rx_ram_txen ?rx_ram_txa :rm_ram_txa;
    assign ram_txen = rx_ram_txen ?rx_ram_txen :rm_ram_txen;

    usb_cs
    usb_cs_dut(
        .clk(sys_clk),
        .rst(rst),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .ff_send(ff_send),
        .fs_read(fs_read),
        .fd_read(fd_read),

        .read_btype(read_btype),
        .send_btype(send_btype),

        .fs_tx(fs_tx),
        .fd_tx(fd_tx),
        .fs_rx(fs_rx),
        .fd_rx(fd_rx),

        .fs_ram(fs_ram),
        .fd_ram(fd_ram),

        .tx_btype(tx_btype),
        .rx_btype(rx_btype),
        .cache_cmd(cache_cmd),
        .rx_ram_init(rx_ram_init),
        .rm_ram_init(rm_ram_init)
    );

    usb_rx
    usb_rx_dut(
        .clk(usb_rxc),
        .rst(rst),

        .fs(fs_rx),
        .fd(fd_rx),

        .fire(pin_read),
        .usb_rxd(com_rxd),
        .btype(rx_btype),
        .cache_stat(cache_stat),

        .ram_txa_init(rx_ram_init),
        .ram_txa(rx_ram_txa),
        .ram_txd(rx_ram_txd),
        .ram_txen(rx_ram_txen)
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
        .clk(clk_ult),
        .clk_fast(pin_rxc),
        .fire(pin_read),

        .usb_txd(usb_txd),
        .pin_txd(pin_txd),

        .usb_rxd(usb_rxd),
        .pin_rxd(pin_rxd)
    );

    usb_rm
    usb_rm_dut(
        .clk(usb_rxc),
        .rst(rst),

        .fs(fs_ram),
        .fd(fd_ram),

        .ram_txa_init(rm_ram_init),
        .ram_txa(rm_ram_txa),
        .ram_txd(rm_ram_txd),
        .ram_txen(rm_ram_txen)
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