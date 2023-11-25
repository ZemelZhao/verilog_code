module console_usb(
    input clk,
    input rst,

    input fs_adc_conf,
    output fd_adc_conf,
    input fs_adc_conv,
    output fd_adc_conv,

    input [15:0] device_cmd,
    input [3:0] data_idx,

    output [0:7] fs_usb_send,
    input [0:7] fd_usb_send,
    input [0:7] fs_usb_read,
    output [0:7] fd_usb_read,

    output [0:31] send_usb_btype,
    input [0:31] read_usb_btype, 

    input [0:255] cache_stat,
    output [0:255] cache_cmd,
    output [95:0] adc_info 
);

    wire [0:7] adc_stat;
    wire [15:0] conf_cmd;

    wire [0:7] fd_cs_send, fs_cs_read;
    wire fs_cs_send, fd_cs_read;
    wire [3:0] send_cs_btype, read_cs_btype;

    assign conf_cmd = adc_info[95:80];

    console_usb_hq
    console_usb_hq_dut(
        .clk(clk),
        .rst(rst),

        .fs_adc_conf(fs_adc_conf),
        .fd_adc_conf(fd_adc_conf),

        .fs_adc_conv(fs_adc_conv),
        .fd_adc_conv(fd_adc_conv),

        .fs_send(fs_cs_send),
        .fd_send(fd_cs_send),
        .fs_read(fs_cs_read),
        .fd_read(fd_cs_read),
        .send_btype(send_cs_btype),
        .read_btype(read_cs_btype),

        .cache_stat(cache_stat),
        .com_cmd(device_cmd),
        .adc_stat(adc_stat),
        .adc_info(adc_info)
    );

    console_usb_branch
    console_usb_branch_dut0(
        .clk(clk),
        .rst(rst),

        .fs_cs_send(fs_cs_send),
        .fd_cs_send(fd_cs_send[0]),
        .fs_cs_read(fs_cs_read[0]),
        .fd_cs_read(fd_cs_read),

        .fs_usb_send(fs_usb_send[0]),
        .fd_usb_send(fd_usb_send[0]),
        .fs_usb_read(fs_usb_read[0]),
        .fd_usb_read(fd_usb_read[0]),

        .stat(adc_stat[0]),

        .send_cs_btype(send_cs_btype),
        .read_cs_btype(read_cs_btype),
        .device_idx(4'h0),
        .data_idx(data_idx),
        .conf_cmd(conf_cmd),

        .send_usb_btype(send_usb_btype[0:3]),
        .read_usb_btype(read_usb_btype[0:3]),

        .cache_cmd(cache_cmd[0:31])
    );

    console_usb_branch
    console_usb_branch_dut1(
        .clk(clk),
        .rst(rst),

        .fs_cs_send(fs_cs_send),
        .fd_cs_send(fd_cs_send[1]),
        .fs_cs_read(fs_cs_read[1]),
        .fd_cs_read(fd_cs_read),

        .fs_usb_send(fs_usb_send[1]),
        .fd_usb_send(fd_usb_send[1]),
        .fs_usb_read(fs_usb_read[1]),
        .fd_usb_read(fd_usb_read[1]),

        .stat(adc_stat[1]),

        .send_cs_btype(send_cs_btype),
        .read_cs_btype(read_cs_btype),
        .device_idx(4'h1),
        .data_idx(data_idx),
        .conf_cmd(conf_cmd),

        .send_usb_btype(send_usb_btype[4:7]),
        .read_usb_btype(read_usb_btype[4:7]),

        .cache_cmd(cache_cmd[32:63])
    );

    console_usb_branch
    console_usb_branch_dut2(
        .clk(clk),
        .rst(rst),

        .fs_cs_send(fs_cs_send),
        .fd_cs_send(fd_cs_send[2]),
        .fs_cs_read(fs_cs_read[2]),
        .fd_cs_read(fd_cs_read),

        .fs_usb_send(fs_usb_send[2]),
        .fd_usb_send(fd_usb_send[2]),
        .fs_usb_read(fs_usb_read[2]),
        .fd_usb_read(fd_usb_read[2]),

        .stat(adc_stat[2]),

        .send_cs_btype(send_cs_btype),
        .read_cs_btype(read_cs_btype),
        .device_idx(4'h2),
        .data_idx(data_idx),
        .conf_cmd(conf_cmd),

        .send_usb_btype(send_usb_btype[8:11]),
        .read_usb_btype(read_usb_btype[8:11]),

        .cache_cmd(cache_cmd[64:95])
    );

    console_usb_branch
    console_usb_branch_dut3(
        .clk(clk),
        .rst(rst),

        .fs_cs_send(fs_cs_send),
        .fd_cs_send(fd_cs_send[3]),
        .fs_cs_read(fs_cs_read[3]),
        .fd_cs_read(fd_cs_read),

        .fs_usb_send(fs_usb_send[3]),
        .fd_usb_send(fd_usb_send[3]),
        .fs_usb_read(fs_usb_read[3]),
        .fd_usb_read(fd_usb_read[3]),

        .stat(adc_stat[3]),

        .send_cs_btype(send_cs_btype),
        .read_cs_btype(read_cs_btype),
        .device_idx(4'h3),
        .data_idx(data_idx),
        .conf_cmd(conf_cmd),

        .send_usb_btype(send_usb_btype[12:15]),
        .read_usb_btype(read_usb_btype[12:15]),

        .cache_cmd(cache_cmd[96:127])
    );

    console_usb_branch
    console_usb_branch_dut4(
        .clk(clk),
        .rst(rst),

        .fs_cs_send(fs_cs_send),
        .fd_cs_send(fd_cs_send[4]),
        .fs_cs_read(fs_cs_read[4]),
        .fd_cs_read(fd_cs_read),

        .fs_usb_send(fs_usb_send[4]),
        .fd_usb_send(fd_usb_send[4]),
        .fs_usb_read(fs_usb_read[4]),
        .fd_usb_read(fd_usb_read[4]),

        .stat(adc_stat[4]),

        .send_cs_btype(send_cs_btype),
        .read_cs_btype(read_cs_btype),
        .device_idx(4'h4),
        .data_idx(data_idx),
        .conf_cmd(conf_cmd),

        .send_usb_btype(send_usb_btype[16:19]),
        .read_usb_btype(read_usb_btype[16:19]),

        .cache_cmd(cache_cmd[128:159])
    );

    console_usb_branch
    console_usb_branch_dut5(
        .clk(clk),
        .rst(rst),

        .fs_cs_send(fs_cs_send),
        .fd_cs_send(fd_cs_send[5]),
        .fs_cs_read(fs_cs_read[5]),
        .fd_cs_read(fd_cs_read),

        .fs_usb_send(fs_usb_send[5]),
        .fd_usb_send(fd_usb_send[5]),
        .fs_usb_read(fs_usb_read[5]),
        .fd_usb_read(fd_usb_read[5]),

        .stat(adc_stat[5]),

        .send_cs_btype(send_cs_btype),
        .read_cs_btype(read_cs_btype),
        .device_idx(4'h5),
        .data_idx(data_idx),
        .conf_cmd(conf_cmd),

        .send_usb_btype(send_usb_btype[20:23]),
        .read_usb_btype(read_usb_btype[20:23]),

        .cache_cmd(cache_cmd[160:191])
    );

    console_usb_branch
    console_usb_branch_dut6(
        .clk(clk),
        .rst(rst),

        .fs_cs_send(fs_cs_send),
        .fd_cs_send(fd_cs_send[6]),
        .fs_cs_read(fs_cs_read[6]),
        .fd_cs_read(fd_cs_read),

        .fs_usb_send(fs_usb_send[6]),
        .fd_usb_send(fd_usb_send[6]),
        .fs_usb_read(fs_usb_read[6]),
        .fd_usb_read(fd_usb_read[6]),

        .stat(adc_stat[6]),

        .send_cs_btype(send_cs_btype),
        .read_cs_btype(read_cs_btype),
        .device_idx(4'h6),
        .data_idx(data_idx),
        .conf_cmd(conf_cmd),

        .send_usb_btype(send_usb_btype[24:27]),
        .read_usb_btype(read_usb_btype[24:27]),

        .cache_cmd(cache_cmd[192:223])
    );

    console_usb_branch
    console_usb_branch_dut7(
        .clk(clk),
        .rst(rst),

        .fs_cs_send(fs_cs_send),
        .fd_cs_send(fd_cs_send[7]),
        .fs_cs_read(fs_cs_read[7]),
        .fd_cs_read(fd_cs_read),

        .fs_usb_send(fs_usb_send[7]),
        .fd_usb_send(fd_usb_send[7]),
        .fs_usb_read(fs_usb_read[7]),
        .fd_usb_read(fd_usb_read[7]),

        .stat(adc_stat[7]),

        .send_cs_btype(send_cs_btype),
        .read_cs_btype(read_cs_btype),
        .device_idx(4'h7),
        .data_idx(data_idx),
        .conf_cmd(conf_cmd),

        .send_usb_btype(send_usb_btype[28:31]),
        .read_usb_btype(read_usb_btype[28:31]),

        .cache_cmd(cache_cmd[224:255])
    );


endmodule
