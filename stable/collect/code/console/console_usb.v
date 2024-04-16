module console_usb(
    input clk,
    input rst,

    input fs_conf,
    output fd_conf,
    input fs_conv,
    output fd_conv,

    output [0:7] fs_usb_send,
    input [0:7] fd_usb_send,
    input [0:7] ff_usb_send,
    input [0:7] fs_usb_read,
    output [0:7] fd_usb_read,

    output [0:31] send_usb_btype,
    input [0:31] read_usb_btype,

    input [11:0] com_cmd,
    output [0:255] usb_cmd,

    input [0:255] usb_stat,
    output [0:79] dev_stat,

    input [3:0] core_data_idx,

    output [12:0] com_dlen
);

    wire [3:0] data_idx;
    wire [0:31] device_idx;
    wire [3:0] send_btype, read_btype;

    wire fs_send, fd_read;
    wire [0:7] fd_send, fs_read;
    wire [15:0] stat;

    assign stat = {dev_stat[0:1], dev_stat[10:11], dev_stat[20:21], dev_stat[30:31],
                   dev_stat[40:41], dev_stat[50:51], dev_stat[60:61], dev_stat[70:71]};

    console_usb_core
    console_usb_core_dut(
        .clk(clk),
        .rst(rst),

        .fs_conf(fs_conf),
        .fd_conf(fd_conf),
        .fs_conv(fs_conv),
        .fd_conv(fd_conv),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fs_read(fs_read),
        .fd_read(fd_read),

        .send_btype(send_btype),
        .read_btype(read_btype),

        .core_data_idx(core_data_idx),
        .data_idx(data_idx),
        .device_idx(device_idx)
    );

    console_usb_num
    console_usb_num_dut(
        .clk(clk),
        .rst(rst),

        .dev_stat(stat),
        .data_len(com_dlen)
    );


    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : console_usb_dev_inst
            console_usb_dev
            console_usb_dev_dut(
                .clk(clk),
                .rst(rst),

                .fs_send(fs_send),
                .fd_send(fd_send[i]),
                .fs_read(fs_read[i]),
                .fd_read(fd_read),

                .fs_usb_send(fs_usb_send[i]),
                .fd_usb_send(fd_usb_send[i]),
                .ff_usb_send(ff_usb_send[i]),
                .fs_usb_read(fs_usb_read[i]),
                .fd_usb_read(fd_usb_read[i]),

                .send_btype(send_btype),
                .read_btype(read_btype),
                .send_usb_btype(send_usb_btype[4*i +: 4]),
                .read_usb_btype(read_usb_btype[4*i +: 4]),

                .device_idx(device_idx[4*i +: 4]),
                .data_idx(data_idx),
                .com_cmd(com_cmd),
                .usb_cmd(usb_cmd[32*i +: 32]),

                .usb_stat(usb_stat[32*i +: 32]),
                .dev_stat(dev_stat[10*i +: 10])
            );
        end
    endgenerate







endmodule