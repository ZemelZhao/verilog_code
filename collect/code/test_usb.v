module test_usb(
    input clk_in_p,
    input clk_in_n,

    input rst_n,
    output fan_n,

    input [0:31] u_rxd_p,
    input [0:31] u_rxd_n,
    output [0:7] u_txd_p,
    output [0:7] u_txd_n,

    output [0:7] u_txen,
    input [0:7] u_rxdv
);

    wire clk_slow, clk_norm, clk_fast, clk_ulta;

    wire [7:0] fs_usb_send, fd_usb_send;
    wire [7:0] fs_usb_read, fd_usb_read;
    wire [0:31] send_usb_btype, read_usb_btype;

    wire [0:255] usb_stat, usb_cmd;

    wire [11:0] ram_usb_rxa;
    wire [0:63] ram_usb_rxd;

    wire [0:31] u_rxd;
    wire [0:7] u_txd;
    wire [0:7] usb_send, usb_read;

    wire rst;
    assign fd_usb_read = 8'hFF;


    genvar i;
    generate
        for (i=0; i<1; i=i+1) begin : usb_inst
        usb
        usb_dut(
            .sys_clk(clk_norm),
            .clk_ult(clk_ulta),
            .usb_txc(clk_slow),
            .usb_rxc(clk_norm),
            .pin_txc(clk_fast),
            .pin_rxc(clk_fast),

            .rst(rst),

            .fs_send(fs_usb_send[i]),
            .fd_send(fd_usb_send[i]),
            .fs_read(fs_usb_read[i]),
            .fd_read(fd_usb_read[i]),

            .send_btype(send_usb_btype[4*i +: 4]),
            .read_btype(read_usb_btype[4*i +: 4]),

            .cache_cmd(usb_cmd[32*i +: 32]),
            .cache_stat(usb_stat[32*i +: 32]),

            .ram_rxa(ram_usb_rxa),
            .ram_rxd(ram_usb_rxd[8*i +: 8]),

            .pin_rxd(u_rxd[4*i +: 4]),
            .pin_txd(u_txd[i]),
            .pin_send(usb_send[i]),
            .pin_read(usb_read[i])
        );
        end
    endgenerate

    crep
    crep_dut(
        .clk_in_p(clk_in_p),
        .clk_in_n(clk_in_n),

        .e_grxc(e_grxc),
        .e_gtxc(e_gtxc),
        
        .clk_slow(clk_slow),
        .clk_norm(clk_norm),
        .clk_fast(clk_fast),
        .clk_ulta(clk_ulta),

        .gmii_txc(gmii_txc),
        .gmii_rxc(gmii_rxc),
        
        .rst_n(rst_n),
        .rst(rst),

        .u_txen(u_txen),
        .u_rxdv(u_rxdv),

        .usb_send(usb_send),
        .usb_read(usb_read),

        .u_rxd(u_rxd),
        .u_txd(u_txd),

        .u_rxd_p(u_rxd_p),
        .u_rxd_n(u_rxd_n),
        .u_txd_p(u_txd_p),
        .u_txd_n(u_txd_n),

        .fan_n(fan_n)
    );

endmodule