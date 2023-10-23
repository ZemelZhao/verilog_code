module console_usb(
    input clk,
    input rst,

    input cache_fs_send,
    output cache_fd_send,
    output cache_fs_read,
    input cache_fs_read,

    input fs_

);

    console_usb_hq(
        .clk
    );




endmodule