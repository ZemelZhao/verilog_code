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

    input [31:0] data_cmd,
    output [31:0] data_stat,

    input [3:0] miso,
    output [3:0] mosi,
    output [3:0] sclk,
    output [3:0] cs,

    input [7:0] fifo_rxen,
    output [63:0] fifo_rxd
);

    wire [3:0] fdc_init, fdc_type, fdc_conf, fdc_conv;
    wire [15:0] tempa, tempb, tempc, tempd;
    wire [17:0] temp_all;

    wire [15:0] device_temp;
    wire [7:0] device_type;
    wire [3:0] device_stat;
    wire [3:0] freq_samp, filt_up, filt_low;

    assign temp_all = tempa + tempb + tempc + tempd;
    assign device_temp = temp[17:2];

    assign data_stat = {device_temp, device_type, device_stat, 4'h0};

    assign fd_init = &fdc_init;
    assign fd_type = &fdc_type;
    assign fd_conf = &fdc_conf;
    assign fd_conv = &fdc_conv;

    assign freq_samp = data_cmd[23:20];
    assign filt_up = data_cmd[19:16];
    assign filt_low = data_cmd[15:12];

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

        .fs(freq_samp[2:0]),
        .type(device_type[7:6]),
        .chip_temp(tempa),

        .filt_up(filt_up),
        .filt_low(filt_low),

        .miso(miso[3]),
        .mosi(mosi[3]),
        .sclk(sclk[3]),
        .cs(cs[3]),
        
        .fifo_rxen(fifo_rxen[3]),
        .fifo_rxd(fifo_rxd[63:48]),

        .stat(device_stat[3])
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

        .fs(freq_samp[2:0]),
        .type(device_type[5:4]),
        .chip_temp(tempb),

        .filt_up(filt_up),
        .filt_low(filt_low),

        .miso(miso[2]),
        .mosi(mosi[2]),
        .sclk(sclk[2]),
        .cs(cs[2]),
        
        .fifo_rxen(fifo_rxen[2]),
        .fifo_rxd(fifo_rxd[47:32]),

        .stat(device_stat[2])
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

        .fs(freq_samp[2:0]),
        .type(device_type[3:2]),
        .chip_temp(tempc),

        .filt_up(filt_up),
        .filt_low(filt_low),

        .miso(miso[1]),
        .mosi(mosi[1]),
        .sclk(sclk[1]),
        .cs(cs[1]),
        
        .fifo_rxen(fifo_rxen[1]),
        .fifo_rxd(fifo_rxd[31:16]),

        .stat(device_stat[1])
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

        .fs(freq_samp[2:0]),
        .type(device_type[1:0]),
        .chip_temp(tempd),

        .filt_up(filt_up),
        .filt_low(filt_low),

        .miso(miso[0]),
        .mosi(mosi[0]),
        .sclk(sclk[0]),
        .cs(cs[0]),
        
        .fifo_rxen(fifo_rxen[0]),
        .fifo_rxd(fifo_rxd[15:0]),

        .stat(device_stat[0])
    );


endmodule



