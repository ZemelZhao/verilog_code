module com(
    input sys_clk,
    input com_txc,
    input com_rxc,
    input pin_txc,
    input pin_rxc,
    input pin_cc,

    input rst,

    output [3:0] pin_txd,
    input pin_rxd,
    output fire_txd,
    input fire_rxd,

    input fs_send,
    input [3:0] send_btype,
    input [11:0] send_dlen,
    input [11:0] ram_addr_init,
    output fd_send,
    output fd_txer,

    output fs_read,
    output [3:0] read_btype,
    input fd_read,

    input [7:0] ram_rxd,
    output [11:0] ram_rxa,

    output [31:0] cache_cmd
);

    wire fs_tx, fd_tx;
    wire fs_rx, fd_rx;

    wire [11:0] tx_dlen;
    wire [3:0] rx_btype, tx_btype;
    wire [7:0] com_rxd, com_txd;
    wire [3:0] usb_txd;
    wire usb_rxd;
    wire [11:0] tx_ram_init;



    com_cs
    com_cs_dut(
        .clk(sys_clk),
        .rst(rst),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fd_txer(fd_txer),
        .send_dlen(send_dlen),
        .send_btype(send_btype),
        .ram_addr_init(ram_addr_init),

        .fs_read(fs_read),
        .fd_read(fd_read),
        .read_btype(read_btype),

        .fs_tx(fs_tx),
        .fd_tx(fd_tx),
        .tx_btype(tx_btype),
        .tx_ram_rlen(tx_dlen),
        .tx_ram_init(tx_ram_init),

        .fs_rx(fs_rx),
        .fd_rx(fd_rx),
        .rx_btype(rx_btype)
    );

    com_rx
    com_rx_dut(
        .clk(com_rxc),
        .rst(rst),

        .fs(fs_rx),
        .fd(fd_rx),

        .com_rxd(com_rxd),
        .btype(rx_btype),
        .cache_cmd(cache_cmd)

    );

    com_tx
    com_tx_dut(
        .clk(com_txc),
        .rst(rst),

        .fs(fs_tx),
        .fd(fd_tx),

        .com_txd(com_txd),
        .btype(tx_btype),
        .tx_dlen(tx_dlen),
        .ram_addr_init(tx_ram_init),
        
        .ram_rxa(ram_rxa),
        .ram_rxd(ram_rxd)
    );

    com_rxf
    com_rxf_dut(
        .clk(pin_rxc),
        .rst(rst),
        
        .din(usb_rxd),
        .dout(com_rxd),
        .fire(fire_rxd)
    );

    com_txf
    com_txf_dut(
        .clk(pin_txc),
        .rst(rst),
        .fs(fs_tx),

        .din(com_txd),
        .dout(usb_txd),
        .fire(fire_txd)
    );


    com_cc
    com_cc_dut(
        .clk(pin_cc),
        .fire(fire_rxd),

        .usb_txd(usb_txd),
        .usb_rxd(usb_rxd),

        .pin_txd(pin_txd),
        .pin_rxd(pin_rxd)
    );








endmodule