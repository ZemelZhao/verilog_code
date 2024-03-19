module test_com(
    input clk_in,
    input rst_n,

    output [3:0] com_txd_p,
    output [3:0] com_txd_n,
    input [1:0] com_rxd_p,
    input [1:0] com_rxd_n,

    input com_rxf,
    output com_txf
);

    wire clk_12m5, clk_50, clk_100, clk_400;
    wire clk_80;

    (*MARK_DEBUG = "true"*)wire [3:0] pin_txd;
    (*MARK_DEBUG = "true"*)wire pin_rxd;
    (*MARK_DEBUG = "true"*)wire fire_read, fire_send;

    wire rst;

    // Control Section
    wire fs_adc_init, fd_adc_init;
    wire fs_adc_type, fd_adc_type;
    wire fs_adc_conf, fd_adc_conf;
    wire fs_adc_conv, fd_adc_conv;
    wire fs_adc_tran, fd_adc_tran;
    wire fs_com_send, fd_com_send;
    wire fs_com_read, fd_com_read;

    // DATA Section
    wire [31:0] cache_cmd, cache_stat;

    // ADC Section
    wire [63:0] fifo_rxd;
    wire [7:0] fifo_rxen;

    // COM Section
    wire [3:0] send_btype, read_btype;
    wire [11:0] send_dlen;
    wire [11:0] ram_addr_init;

    // RAM Section
    wire [7:0] ram_txd, ram_rxd;
    wire [11:0] ram_txa, ram_rxa;
    wire ram_txen;

    assign rst = ~rst_n;

    console
    console_dut(
        .clk(clk_50),
        .rst(rst),

        .fs_adc_init(fs_adc_init),
        .fd_adc_init(fd_adc_init),
        .fs_adc_type(fs_adc_type),
        .fd_adc_type(fd_adc_type),
        .fs_adc_conf(fs_adc_conf),
        .fd_adc_conf(fd_adc_conf),
        .fs_adc_conv(fs_adc_conv),
        .fd_adc_conv(fd_adc_conv),

        .fs_adc_tran(fs_adc_tran),
        .fd_adc_tran(fd_adc_tran),
        .fs_com_send(fs_com_send),
        .fd_com_send(fd_com_send),
        .fs_com_read(fs_com_read),
        .fd_com_read(fd_com_read),

        .read_btype(read_btype),
        .send_btype(send_btype),

        .ram_dlen(send_dlen),
        .ram_addr_init(ram_addr_init)
    );

    com
    com_dut(
        .sys_clk(clk_50),
        .com_txc(clk_50),
        .com_rxc(clk_12m5),
        .pin_txc(clk_100),
        .pin_rxc(clk_100),
        .pin_cc(clk_400),

        .rst(rst),

        .pin_txd(pin_txd),
        .pin_rxd(pin_rxd),
        .fire_txd(fire_send),
        .fire_rxd(fire_read),

        .fs_send(fs_com_send),
        .fd_send(fd_com_send),
        .send_btype(send_btype),
        .send_dlen(send_dlen),
        .ram_addr_init(ram_addr_init),

        .fs_read(fs_com_read),
        .fd_read(fd_com_read),
        .read_btype(read_btype),

        .ram_rxd(ram_rxd),
        .ram_rxa(ram_rxa),
        .cache_cmd(cache_cmd)
    );

    adc_test
    adc_test_dut(
        .clk(clk_50),
        .fifo_txc(clk_50),
        .fifo_rxc(clk_100),

        .rst(rst),

        .fs_init(fs_adc_init),
        .fs_type(fs_adc_type),
        .fs_conf(fs_adc_conf),
        .fs_conv(fs_adc_conv),
        .fd_init(fd_adc_init),
        .fd_type(fd_adc_type),
        .fd_conf(fd_adc_conf),
        .fd_conv(fd_adc_conv),

        .cache_cmd(cache_cmd),
        .cache_stat(cache_stat),

        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd)
    );

    data_make
    data_make_dut(
        .clk(clk_100),
        .rst(rst),

        .fs(fs_adc_tran),
        .fd(fd_adc_tran),

        .btype(send_btype),
        .ram_addr_init(ram_addr_init),

        .cache_cmd(cache_cmd),
        .cache_stat(cache_stat),

        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd),

        .ram_txa(ram_txa),
        .ram_txd(ram_txd),
        .ram_txen(ram_txen)
    );

    pin_test
    pin_test_dut(
        .com_txd_p(com_txd_p),
        .com_txd_n(com_txd_n),
        .com_rxd_p(com_rxd_p),
        .com_rxd_n(com_rxd_n),

        .pin_txd(pin_txd),
        .pin_rxd(pin_rxd),

        .com_rxf(com_rxf),
        .com_txf(com_txf),

        .fire_send(fire_send),
        .fire_read(fire_read)
    );

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk_in),
        .clk_12m5(clk_12m5),
        .clk_50(clk_50),
        .clk_80(clk_80),
        .clk_100(clk_100),
        .clk_400(clk_400)
    );

    ram_data
    ram_data_dut(
        .clka(clk_100),
        .addra(ram_txa),
        .dina(ram_txd),
        .wea(ram_txen),

        .clkb(clk_50),
        .addrb(ram_rxa),
        .doutb(ram_rxd)
    );


endmodule