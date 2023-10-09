module adc(
    input clk,
    input spi_clk,
    input fifo_txc,
    input fifo_rxc,

    input rst,

    input fs_init,
    input fs_type,
    input fs_conf,
    input fs_conv,

    output fd_init,
    output fd_type,
    output fd_conf,
    output fd_conv,

    input [2:0] freq,
    input [3:0] filt_up,
    input [3:0] filt_low,
    output [7:0] device_type,
    output [15:0] device_temp,

    input [3:0] spi_miso,
    output [3:0] spi_mosi,
    output [3:0] spi_sclk,
    output [3:0] spi_cs,

    input [7:0] fifo_rxen,
    output [63:0] fifo_rxd
);

    wire [3:0] fdc_init, fdc_type, fdc_conf, fdc_conv;
    wire [15:0] tempa, tempb, tempc, tempd;
    wire [17:0] temp;

    assign temp = tempa + tempb + tempc + tempd;
    assign device_temp = temp[17:2];

    assign fd_init = &fdc_init;
    assign fd_type = &fdc_type;
    assign fd_conf = &fdc_conf;
    assign fd_conv = &fdc_conv;

    intan
    intan_duta(
        .clk(clk),
        .spi_clk(spi_clk),
        .fifo_txc(fifo_txc),
        .fifo_rxc(fifo_rxc),

        .rst(rst),

        .fs_init(fs_init),
        .fs_type(fs_type),
        .fs_conf(fs_conf),
        .fs_conv(fs_conv),

        .fd_init(fdc_init[3]),
        .fd_type(fdc_type[3]),
        .fd_conf(fdc_conf[3]),
        .fd_conv(fdc_conv[3]),

        .fs(freq[2:0]),
        .type(device_type[7:6]),
        .chip_temp(tempa),

        .filt_up(filt_up),
        .filt_low(filt_low),

        .spi_miso(spi_miso[3]),
        .spi_mosi(spi_mosi[3]),
        .spi_sclk(spi_sclk[3]),
        .spi_cs(spi_cs[3]),
        
        .fifo_rxen(fifo_rxen[3]),
        .fifo_rxd(fifo_rxd[63:48])
    );

    intan
    intan_dutb(
        .clk(clk),
        .spi_clk(spi_clk),
        .fifo_txc(fifo_txc),
        .fifo_rxc(fifo_rxc),

        .rst(rst),

        .fs_init(fs_init),
        .fs_type(fs_type),
        .fs_conf(fs_conf),
        .fs_conv(fs_conv),

        .fd_init(fdc_init[2]),
        .fd_type(fdc_type[2]),
        .fd_conf(fdc_conf[2]),
        .fd_conv(fdc_conv[2]),

        .fs(freq[2:0]),
        .type(device_type[5:4]),
        .chip_temp(tempb),

        .filt_up(filt_up),
        .filt_low(filt_low),

        .spi_miso(spi_miso[2]),
        .spi_mosi(spi_mosi[2]),
        .spi_sclk(spi_sclk[2]),
        .spi_cs(spi_cs[2]),
        
        .fifo_rxen(fifo_rxen[2]),
        .fifo_rxd(fifo_rxd[47:32])
    );

    intan
    intan_dutc(
        .clk(clk),
        .spi_clk(spi_clk),
        .fifo_txc(fifo_txc),
        .fifo_rxc(fifo_rxc),

        .rst(rst),

        .fs_init(fs_init),
        .fs_type(fs_type),
        .fs_conf(fs_conf),
        .fs_conv(fs_conv),

        .fd_init(fdc_init[1]),
        .fd_type(fdc_type[1]),
        .fd_conf(fdc_conf[1]),
        .fd_conv(fdc_conv[1]),

        .fs(freq[2:0]),
        .type(device_type[3:2]),
        .chip_temp(tempc),

        .filt_up(filt_up),
        .filt_low(filt_low),

        .spi_miso(spi_miso[1]),
        .spi_mosi(spi_mosi[1]),
        .spi_sclk(spi_sclk[1]),
        .spi_cs(spi_cs[1]),
        
        .fifo_rxen(fifo_rxen[1]),
        .fifo_rxd(fifo_rxd[31:16])
    );

    intan
    intan_dutd(
        .clk(clk),
        .spi_clk(spi_clk),
        .fifo_txc(fifo_txc),
        .fifo_rxc(fifo_rxc),

        .rst(rst),

        .fs_init(fs_init),
        .fs_type(fs_type),
        .fs_conf(fs_conf),
        .fs_conv(fs_conv),

        .fd_init(fdc_init[0]),
        .fd_type(fdc_type[0]),
        .fd_conf(fdc_conf[0]),
        .fd_conv(fdc_conv[0]),

        .fs(freq[2:0]),
        .type(device_type[1:0]),
        .chip_temp(tempd),

        .filt_up(filt_up),
        .filt_low(filt_low),

        .spi_miso(spi_miso[0]),
        .spi_mosi(spi_mosi[0]),
        .spi_sclk(spi_sclk[0]),
        .spi_cs(spi_cs[0]),
        
        .fifo_rxen(fifo_rxen[0]),
        .fifo_rxd(fifo_rxd[15:0])
    );


endmodule



