module console(
    input clk,
    input rst,

// USB Section
    output [0:7] fs_usb_send,
    input [0:7] fd_usb_send,
    input [0:7] fs_usb_read,
    output [0:7] fd_usb_read,

    output [0:31] send_usb_btype,
    input [0:31] read_usb_btype,

    input [0:255] cache_stat,
    output [0:255] cache_cmd,
    output [95:0] cache_info,

// ETH Section
    output fs_eth_send,
    input fd_eth_send,
    input fs_eth_read,
    output fd_eth_read,

    output [3:0] send_eth_btype,
    input [3:0] read_eth_btype,

    input [15:0] com_cmd
);

    wire tick_work;

    wire fs_com_send, fd_com_send;
    wire fs_com_read, fd_com_read;
    wire fs_adc_conf, fd_adc_conf;
    wire fs_adc_conv, fd_adc_conv;
    wire fs_adc_tick, fd_adc_tick;

    wire [3:0] com_send_btype, com_read_btype;
    wire [3:0] data_idx;
    wire [3:0] freq_samp;
    wire [15:0] device_cmd;

    assign freq_samp = device_cmd[15:12];


    console_hq
    console_hq_dut(
        .clk(clk),
        .rst(rst),

        .fs_com_read(fs_com_read),
        .fd_com_read(fd_com_read),
        .fs_com_send(fs_com_send),
        .fd_com_send(fd_com_send),

        .fs_adc_conf(fs_adc_conf),
        .fd_adc_conf(fd_adc_conf),
        .fs_adc_conv(fs_adc_conv),
        .fd_adc_conv(fd_adc_conv),
        .fs_adc_tick(fs_adc_tick),
        .fd_adc_tick(fd_adc_tick),

        .com_send_btype(com_send_btype),
        .com_read_btype(com_read_btype),

        .data_idx(data_idx),
        .work(tick_work)
    );

    console_usb
    console_usb_dut(
        .clk(clk),
        .rst(rst),

        .fs_adc_conf(fs_adc_conf),
        .fd_adc_conf(fd_adc_conf),
        .fs_adc_conv(fs_adc_conv),
        .fd_adc_conv(fd_adc_conv),

        .device_cmd(device_cmd),
        .data_idx(data_idx),

        .fs_usb_send(fs_usb_send),
        .fd_usb_send(fd_usb_send),
        .fs_usb_read(fs_usb_read),
        .fd_usb_read(fd_usb_read),

        .send_usb_btype(send_usb_btype),
        .read_usb_btype(read_usb_btype),

        .cache_stat(cache_stat),
        .cache_cmd(cache_cmd),
        .adc_info(cache_info)
    );

    console_com
    console_com_dut(
        .clk(clk),
        .rst(rst),

        .fs_com_send(fs_com_send),
        .fd_com_send(fd_com_send),
        .fs_com_read(fs_com_read),
        .fd_com_read(fd_com_read),

        .com_send_btype(com_send_btype),
        .com_read_btype(com_read_btype),

        .fs_send(fs_eth_send),
        .fd_send(fd_eth_send),
        .fs_read(fs_eth_read),
        .fd_read(fd_eth_read),

        .send_btype(send_eth_btype),
        .read_btype(read_eth_btype),

        .com_cmd(com_cmd),
        .device_cmd(device_cmd)
    );

    console_tick
    console_tick_dut(
        .clk(clk),
        .work(tick_work),

        .freq_samp(freq_samp),

        .fs(fs_adc_tick),
        .fd(fd_adc_tick)
    );






endmodule