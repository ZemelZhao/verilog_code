module typec(
    input sys_clk,
    input com_txc,
    input com_rxc,
    input pin_txc,
    input pin_rxc,
    input rst,

    input pin_rxd,
    output [3:0] pin_txd,
    // inout [1:0] pin_sbu,
    input fire_recv,
    output fire_send,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output [3:0] read_btype,
    output [3:0] read_bdata,
    input [3:0] send_btype,

    input [11:0] ram_rxa_init,
    input [11:0] data_len,
    output [11:0] ram_rxa,
    input [7:0] ram_rxd,

    input [7:0] device_type,
    input [7:0] device_temp,
    input [3:0] device_stat
);

    wire [3:0] device_idx;
    wire [3:0] data_idx;

    (*MARK_DEBUG = "true"*)wire fs_tx, fd_tx;
    (*MARK_DEBUG = "true"*)wire fs_rx, fd_rx;

    (*MARK_DEBUG = "true"*)wire [3:0] rx_btype, tx_btype;
    wire [3:0] rx_bdata;

    wire [7:0] data_head;

    (*MARK_DEBUG = "true"*)wire [7:0] com_txd, com_rxd;

    wire fire_send, fire_recv;

    assign data_head = {data_idx, device_stat};

    typec_cs
    typec_cs_dut(
        .clk(sys_clk),
        .rst(rst),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fs_read(fs_read),
        .fd_read(fd_read),

        .read_btype(read_btype),
        .read_bdata(read_bdata),
        .send_btype(send_btype),

        .device_idx(device_idx),
        .data_idx(data_idx),

        .fs_tx(fs_tx),
        .fd_tx(fd_tx),
        .fs_rx(fs_rx),
        .fd_rx(fd_rx),

        .rx_btype(rx_btype),
        .rx_bdata(rx_bdata),
        .tx_btype(tx_btype)
    );

    typec_tx
    typec_tx_dut(
        .clk(com_txc),
        .rst(rst),

        .fs(fs_tx),
        .fd(fd_tx),

        .ram_addr_init(ram_rxa_init),
        .data_len(data_len),

        .btype(tx_btype),

        .didx(device_idx),
        .type(device_type),
        .temp(device_temp),
        .head(data_head),

        .ram_rxd(ram_rxd),
        .ram_rxa(ram_rxa),
        .com_txd(com_txd)
    );
    
    typec_txf
    typec_txf_dut(
        .clk(pin_txc),
        .rst(rst),
        
        .fs(fs_tx),

        .din(com_txd),
        .dout(pin_txd),

        .fire(fire_send)
    );

    typec_rx
    typec_rx_dut(
        .clk(com_rxc),
        .rst(rst),

        .fs(fs_rx),
        .fd(fd_rx),

        .com_rxd(com_rxd),

        .btype(rx_btype),
        .bdata(rx_bdata)
    );

    typec_rxf
    typec_rxf_dut(
        .clk(pin_rxc),
        .rst(rst),

        .din(pin_rxd),
        .dout(com_rxd),

        .fire(fire_recv)
    );

endmodule