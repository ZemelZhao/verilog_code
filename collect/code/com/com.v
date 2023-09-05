module com(
    input sys_clk,
    input com_txc,
    input com_rxc,
    input pin_txc,
    input pin_rxc,
    input rst,

    output pin_txd,
    input [3:0] pin_rxd,
    input fire_recv,
    output fire_send,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output [3:0] read_btype,
    output [7:0] device_type,
    output [7:0] device_temp,
    input [3:0] send_btype,
    input [3:0] device_idx,
    input [3:0] data_idx,
    input [3:0] device_freq,

    input [11:0] ram_txa_init,
    input [11:0] data_len,
    output [11:0] ram_txa,
    output [7:0] ram_txd,
    output ram_txen,

    output link,
    output error
);

    wire fs_send, fd_send;
    wire fs_read, fd_read; 
    wire fs_tx, fd_tx;
    wire fs_rx, fd_rx;

    wire [3:0] tx_btype, rx_btype;
    wire [7:0] rx_bdata;
    wire [11:0] rx_data_len; 
    wire [3:0] rx_device_idx, rx_device_stat, rx_data_idx;

    wire [7:0] com_txd, com_rxd;

    com_cs
    com_cs_dut(
        .clk(sys_clk),
        .rst(rst),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fs_read(fs_read),
        .fd_read(fd_read),

        .fs_tx(fs_tx),
        .fd_tx(fd_tx),
        .fs_rx(fs_rx),
        .fd_rx(fd_rx),

        .send_btype(send_btype),
        .read_btype(read_btype),

        .tx_btype(tx_btype),
        .rx_btype(rx_btype),
        .rx_bdata(rx_bdata),

        .device_type(device_type),
        .device_temp(device_temp),

        .tx_data_len(data_len),
        .rx_data_len(rx_data_len),

        .tx_device_idx(device_idx),
        .tx_data_idx(data_idx),
        .rx_device_idx(rx_device_idx),
        .rx_data_idx(rx_data_idx),
        
        .rx_device_stat(rx_device_stat),
        .link(link),
        .error(error)
    );

    com_tx
    com_tx_dut(
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

    com_txf
    com_txf_dut(
        .clk(pin_txc),
        .rst(rst),

        .fs(fs_tx),

        .fire(fire_send),
        .din(com_txd),
        .dout(pin_txd)
    );

    com_rx
    com_rx_dut(
        .clk(com_rxc),
        .rst(rst),

        .fs(fs_rx),
        .fd(fd_rx),

        .com_rxd(com_rxd),
        .btype(rx_btype),
        .bdata(rx_bdata),

        .device_idx(rx_device_idx),
        .data_idx(rx_data_idx),
        .device_stat(rx_device_stat),

        .ram_txa_init(ram_txa_init),
        .ram_txa(ram_txa),
        .ram_txd(ram_txd),
        .ram_txen(ram_txen),
        .data_len(rx_data_len)
    );

    com_rxf
    com_rxf_dut(
        .clk(pin_rxc),
        .rst(rst),

        .fire(fire_recv),
        .din(pin_rxd),
        .dout(com_rxd)
    );

endmodule