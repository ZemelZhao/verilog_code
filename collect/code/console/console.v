module console(
    input clk,
    input rst,

    output fs_com_send,
    input fd_com_send,
    input fs_com_read,
    output fd_com_read,

    output [7:0] fs_usb_send,
    input [7:0] fd_usb_send,
    input [7:0] ff_usb_send,
    input [7:0] fs_usb_read,
    output [7:0] fd_usb_read,

    output fs_data,
    input fd_data,

    input [3:0] com_btype,
    input [51:0] cache_cmd,

    output [31:0] send_usb_btype,
    input [31:0] read_usb_btype,

    input [255:0] usb_stat,
    output [255:0] usb_cmd,
    output [79:0] dev_stat,

    output [12:0] com_dlen,
    output [3:0] data_btype
); 

    wire fs_conf, fd_conf;
    wire fs_conv, fd_conv;
    wire fs_send, fd_send;
    wire fs_read, fd_read;

    wire tick;

    wire [1:0] com_state;
    wire [3:0] fsamp;
    
    wire [11:0] com_cmd;
    wire [39:0] trgg_cmd;

    assign fsamp = cache_cmd[51:48];
    assign com_cmd = cache_cmd[51:40];
    assign trgg_cmd = cache_cmd[39:0];

    console_core
    console_core_dut(
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

        .tick(tick),
        .com_state(com_state)
    );

    console_com
    console_com_dut(
        .clk(clk),
        .rst(rst),

        .fs_send(fs_send),
        .fd_send(fd_send),
        .fs_read(fs_read),
        .fd_read(fd_read),

        .fs_com_send(fs_com_send),
        .fd_com_send(fd_com_send),
        .fs_com_read(fs_com_read),
        .fd_com_read(fd_com_read),

        .com_btype(com_btype),
        .com_state(com_state)
    );

    console_usb
    console_usb_dut(
        .clk(clk),
        .rst(rst),

        .fs_conf(fs_conf),
        .fd_conf(fd_conf),
        .fs_conv(fs_conv),
        .fd_conv(fd_conv),

        .fs_usb_send(fs_usb_send),
        .fd_usb_send(fd_usb_send),
        .ff_usb_send(ff_usb_send),
        .fs_usb_read(fs_usb_read),
        .fd_usb_read(fd_usb_read),

        .send_usb_btype(send_usb_btype),
        .read_usb_btype(read_usb_btype),

        .com_cmd(com_cmd),
        .usb_cmd(usb_cmd),
        .usb_stat(usb_stat),
        .dev_stat(dev_stat),

        .com_dlen(com_dlen)
    );

    console_data
    console_data_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_data),
        .fd(fd_data),
        .fs_com_send(fs_com_send),
        .fs_com_read(fs_com_read),

        .btype(data_btype)
    );

    console_tick
    console_tick_dut(
        .clk(clk),
        .fs_conf(fs_conf),
        .fsamp(fsamp),
        .tick(tick)
    );



endmodule