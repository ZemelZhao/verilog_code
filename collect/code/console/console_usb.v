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
    localparam DEVICE_IDX = 64'h0123_4567_89AB_CDEF;

    wire [0:7] adc_stat;
    wire [15:0] conf_cmd;

    wire [0:7] fd_cs_send, fs_cs_read;
    wire fs_cs_send, fd_cs_read;
    wire [3:0] send_cs_btype, read_cs_btype;
    wire [0:63] device_idx;

    assign conf_cmd = adc_info[95:80];
    assign device_idx = DEVICE_IDX;

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

    genvar i;
    generate 
        for (i=0; i<8; i=i+1) begin : console_usb_branch_dut
            console_usb_branch
            console_usb_branch_inst(
                .clk(clk),
                .rst(rst),

                .fs_cs_send(fs_cs_send),
                .fd_cs_send(fd_cs_send[i]),
                .fs_cs_read(fs_cs_read[i]),
                .fd_cs_read(fd_cs_read),

                .fs_usb_send(fs_usb_send[i]),
                .fd_usb_send(fd_usb_send[i]),
                .fs_usb_read(fs_usb_read[i]),
                .fd_usb_read(fd_usb_read[i]),

                .stat(adc_stat[i]),

                .send_cs_btype(send_cs_btype),
                .read_cs_btype(read_cs_btype),
                .device_idx(device_idx[4*i +: 4]),
                .data_idx(data_idx),
                .conf_cmd(conf_cmd),

                .send_usb_btype(send_usb_btype[4*i +: 4]),
                .read_usb_btype(read_usb_btype[4*i +: 4]),

                .cache_cmd(cache_cmd[32*i +: 32])
            );
        end
    endgenerate

endmodule
