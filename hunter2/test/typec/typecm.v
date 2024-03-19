module typecm(
    input sys_clk,
    input com_txc,
    input com_rxc,
    input pin_rxc,
    input pin_txc,
    input rst,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output fire_send,
    input fire_recv, 
    output pin_txd,
    input [3:0] pin_rxd,

    output [3:0] read_btype,
    input [3:0] send_btype,

    input [3:0] device_idx,
    input [3:0] device_freq,
    input [3:0] data_idx
);
    
    wire fs_tx, fd_tx;
    wire fs_rx, fd_rx;

    wire [3:0] tx_btype, rx_btype;
    wire [7:0] com_txd, com_rxd;
    wire [7:0] rx_bdata;
    wire [3:0] rx_didx;
    wire [7:0] ram_txd;

    
    typecm_cs
    typecm_cs_dut(
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
        .fs_rx(fs_rx),
        .fd_rx(fd_rx),

        .tx_btype(tx_btype),
        .rx_btype(rx_btype)
    );

    typecm_tx
    typecm_tx_dut(
        .clk(com_txc),
        .rst(rst),

        .fs(fs_tx),
        .fd(fd_tx),

        .btype(tx_btype),
        .didx(device_idx),
        .freq(device_freq),
        .ddidx(data_idx),
        .com_txd(com_txd)
    );

    typecm_txf
    typecm_txf_dut(
        .clk(pin_txc),
        .rst(rst),

        .fs(fs_tx),
        .fire(fire_send),
        .din(com_txd),
        .dout(pin_txd)
    );

    typecm_rx
    typecm_rx_dut(
        .clk(com_rxc),
        .rst(rst),

        .fs(fs_rx),
        .fd(fd_rx),

        .com_rxd(com_rxd),
        .btype(rx_btype),
        .bdata(rx_bdata),
        .didx(rx_didx),

        .ram_txd(ram_txd)
    );

    typecm_rxf
    typecm_rxf_dut(
        .clk(pin_rxc),
        .rst(rst),
        .din(pin_rxd),
        .fire(fire_recv),
        .dout(com_rxd)
    );

    


endmodule