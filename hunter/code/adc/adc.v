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

    input [31:0] cache_cmd,
    output [31:0] cache_stat,

    input [0:3] pin_miso,
    output [0:3] pin_mosi,
    output [0:3] pin_sclk,
    output [0:3] pin_cs,

    input [0:7] fifo_rxen,
    output [0:63] fifo_rxd
);
    localparam INTAN_NUM = 4;

    wire [0:3] fdc_init, fdc_type, fdc_conf, fdc_conv;
    wire [15:0] temp[0:3];
    wire [17:0] temp_all;

    wire [15:0] device_temp;
    wire [0:7] device_type;
    wire [0:3] device_stat;
    wire [0:3] device_idx;
    wire [3:0] freq_samp, filt_up, filt_low;

    assign temp_all = temp[0] + temp[1] + temp[2] + temp[3];
    assign device_temp = temp_all[17:2];

    assign fd_init = &fdc_init;
    assign fd_type = &fdc_type;
    assign fd_conf = &fdc_conf;
    assign fd_conv = &fdc_conv;

    assign cache_stat = {device_temp, device_type, device_stat, 4'h0};
    assign device_idx = cache_cmd[31:28];
    assign freq_samp = cache_cmd[23:20];
    assign filt_up = cache_cmd[19:16];
    assign filt_low = cache_cmd[15:12];

    genvar i;
    generate
        for (i=0; i<INTAN_NUM; i=i+1) begin : intan_inst
            intan
            intan_dut(
                .clk(clk),
                .spi_clk(spi_clk),
                .fifo_txc(fifo_txc),
                .fifo_rxc(fifo_rxc),

                .rst(rst),

                .fs_init(fs_init),
                .fs_type(fs_type),
                .fs_conf(fs_conf),
                .fs_conv(fs_conv),

                .fd_init(fdc_init[i]),
                .fd_type(fdc_type[i]),
                .fd_conf(fdc_conf[i]),
                .fd_conv(fdc_conv[i]),

                .freq_samp(freq_samp),
                .device_type(device_type[2*i +: 2]),
                .device_temp(temp[i]),

                .filt_up(filt_up),
                .filt_low(filt_low),

                .miso(pin_miso[i]),
                .mosi(pin_mosi[i]),
                .sclk(pin_sclk[i]),
                .cs(pin_cs[i]),
                
                .fifo_rxen(fifo_rxen[2*i +: 2]),
                .fifo_rxd(fifo_rxd[16*i +: 16]),

                .led(device_idx[i]),
                .stat(device_stat[i])
            );
        end
    endgenerate

endmodule