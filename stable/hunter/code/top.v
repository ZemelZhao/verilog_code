module top(
    input clk_in,
    input rst_n,

    output [3:0] com_txd_p,
    output [3:0] com_txd_n,
    input [1:0] com_rxd_p,
    input [1:0] com_rxd_n,

    input [3:0] adc_miso,
    output [3:0] adc_mosi,
    output [3:0] adc_cs,
    output [3:0] adc_sclk,

    input com_rxf,
    output com_txf,

    input [1:0] com_cc
);

    wire clk_slow, clk_norm, clk_fast;
    wire clk_ulta, clk_chip;

    wire [3:0] pin_txd;
    wire pin_rxd;
    wire fire_read, fire_send;

    wire [3:0] pin_cs, pin_sclk, pin_miso, pin_mosi;
    wire rst;

    // Control Section
    wire fs_adc_init, fd_adc_init;
    wire fs_adc_type, fd_adc_type;
    wire fs_adc_conf, fd_adc_conf;
    wire fs_adc_conv, fd_adc_conv;
    wire fs_adc_tran, fd_adc_tran;
    wire fs_com_send, fd_com_send;
    wire fs_com_read, fd_com_read;
    wire fd_com_txer;

    // DATA Section
    wire [31:0] cache_cmd; 
    wire [31:0] cache_stat;

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

    console
    console_dut(
        .clk(clk_norm),
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
        .fd_com_txer(fd_com_txer),
        
        .idx(idx),
        .cache_cmd(cache_cmd),

        .read_btype(read_btype),
        .send_btype(send_btype),

        .ram_dlen(send_dlen),
        .ram_addr_init(ram_addr_init)
    );

    com
    com_dut(
        .sys_clk(clk_norm),
        .com_txc(clk_norm),
        .com_rxc(clk_slow),
        .pin_txc(clk_fast),
        .pin_rxc(clk_fast),
        .clk_ult(clk_ulta),

        .rst(rst),

        .pin_txd(pin_txd),
        .pin_rxd(pin_rxd),
        .fire_txd(fire_send),
        .fire_rxd(fire_read),

        .fs_send(fs_com_send),
        .fd_send(fd_com_send),
        .fd_txer(fd_com_txer),
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

    adc
    adc_dut(
        .clk(clk_norm),
        .spi_clk(clk_norm),
        .fifo_txc(clk_norm),
        .fifo_rxc(clk_fast),

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

        .pin_miso(pin_miso),
        .pin_mosi(pin_mosi),
        .pin_sclk(pin_sclk),
        .pin_cs(pin_cs),

        .idx(idx),

        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd)
    );


    data_make
    data_make_dut(
        .clk(clk_fast),
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

    crep
    crep_dut(
        .clk(clk_in),

        .clk_slow(clk_slow),
        .clk_norm(clk_norm),
        .clk_fast(clk_fast),
        .clk_ulta(clk_ulta),
        .clk_chip(clk_chip),

        .com_txd_p(com_txd_p),
        .com_txd_n(com_txd_n),
        .com_rxd_p(com_rxd_p),
        .com_rxd_n(com_rxd_n),
        .com_txf(com_txf),
        .com_rxf(com_rxf),
        .com_cc(com_cc),

        .adc_miso(adc_miso),
        .adc_cs(adc_cs),
        .adc_mosi(adc_mosi),
        .adc_sclk(adc_sclk),

        .pin_txd(pin_txd),
        .pin_rxd(pin_rxd),
        .fire_send(fire_send),
        .fire_read(fire_read),

        .pin_cs(pin_cs),
        .pin_sclk(pin_sclk),
        .pin_mosi(pin_mosi),
        .pin_miso(pin_miso),

        .rst_n(rst_n),
        .rst(rst)
    );

    ram_data
    ram_data_dut(
        .clka(clk_fast),
        .addra(ram_txa),
        .dina(ram_txd),
        .wea(ram_txen),

        .clkb(clk_norm),
        .addrb(ram_rxa),
        .doutb(ram_rxd)
    );


endmodule