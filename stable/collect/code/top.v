module top(
    input clk_in_p,
    input clk_in_n,

    input rst_n,
    output fan_n,

    output e_mdc,
    inout e_mdio,
    output e_rstn,

    output e_gtxc,
    input e_grxc,

    input e_rxdv,
    input [7:0] e_rxd,
    input e_rxer,

    output e_txen,
    output [7:0] e_txd,
    output e_txer,

    input [0:31] u_rxd_p,
    input [0:31] u_rxd_n,
    output [0:7] u_txd_p,
    output [0:7] u_txd_n,

    output [0:7] u_txen,
    input [0:7] u_rxdv,

    input [1:0] pin_miso,
    output [1:0] pin_mosi,
    output [1:0] pin_cs,
    output [1:0] pin_sclk,
    output [1:0] pin_trgg,

    output [7:0] led_n
);

    wire clk_slow, clk_norm, clk_fast, clk_ulta;
    wire gmii_txc, gmii_rxc;

    wire [0:7] fs_usb_send, fd_usb_send, ff_usb_send;
    wire [0:7] fs_usb_read, fd_usb_read;

    wire fs_data, fd_data;
    wire [3:0] com_btype, data_btype;
    wire [0:31] send_usb_btype, read_usb_btype;

    wire fs_trgg_out, fd_trgg_out;

    wire [51:0] cache_cmd;
    wire [0:255] usb_stat; 
    wire [0:255] usb_cmd;
    wire [0:79] dev_stat;

    wire [12:0] com_dlen;

    wire [39:0] trgg_cmd;
    wire [31:0] trgg_rxd;

    wire [11:0] ram_usb_rxa;
    wire [0:63] ram_usb_rxd;
    
    wire [15:0] ram_data_rxa;
    wire [7:0] ram_data_rxd;
    wire [14:0] ram_data_txa;
    wire [7:0] ram_data_txd;

    wire [7:0] ram_cmd_txa;
    wire [7:0] ram_cmd_txd;
    wire [7:0] ram_cmd_rxa;
    wire [7:0] ram_cmd_rxd;
    wire ram_cmd_txen;

    wire [0:31] u_rxd;
    wire [0:7] u_txd;

    wire rst;

    wire [3:0] com_data_idx, ram_data_idx;

    assign led_n[7] = |dev_stat[0:1] ?1'b0 : 1'b1;
    assign led_n[6] = |dev_stat[10:11] ?1'b0 : 1'b1;
    assign led_n[5] = |dev_stat[20:21] ?1'b0 : 1'b1;
    assign led_n[4] = |dev_stat[30:31] ?1'b0 : 1'b1;
    assign led_n[3] = |dev_stat[40:41] ?1'b0 : 1'b1;
    assign led_n[2] = |dev_stat[50:51] ?1'b0 : 1'b1;
    assign led_n[1] = |dev_stat[60:61] ?1'b0 : 1'b1;
    assign led_n[0] = |dev_stat[70:71] ?1'b0 : 1'b1;


    console
    console_dut(
        .clk(clk_norm),
        .rst(rst),

        .fs_com_send(fs_com_send),
        .fd_com_send(fd_com_send),
        .fs_com_read(fs_com_read),
        .fd_com_read(fd_com_read),

        .fs_usb_send(fs_usb_send),
        .fd_usb_send(fd_usb_send),
        .ff_usb_send(ff_usb_send),
        .fs_usb_read(fs_usb_read),
        .fd_usb_read(fd_usb_read),

        .fs_trgg_out(fs_trgg_out),
        .fd_trgg_out(fd_trgg_out),

        .fs_data(fs_data),
        .fd_data(fd_data),

        .com_btype(com_btype),
        .cache_cmd(cache_cmd),

        .send_usb_btype(send_usb_btype),
        .read_usb_btype(read_usb_btype),

        .usb_stat(usb_stat),
        .usb_cmd(usb_cmd),
        .dev_stat(dev_stat),

        .com_dlen(com_dlen),
        .data_btype(data_btype),

        .com_data_idx(com_data_idx),
        .ram_data_idx(ram_data_idx),

        .trgg_info(trgg_cmd)
    );


    com
    com_dut(
        .clk(clk_norm),
        .rst(rst),

        .fs_read(fs_com_read),
        .fd_read(fd_com_read),
        .fs_send(fs_com_send),
        .fd_send(fd_com_send),

        .com_btype(com_btype),
        .cache_cmd(cache_cmd),

        .ram_data_rxa(ram_data_rxa),
        .ram_data_rxd(ram_data_rxd),
        .data_len(com_dlen),

        .ram_cmd_txen(ram_cmd_txen),
        .ram_cmd_txa(ram_cmd_txa),
        .ram_cmd_txd(ram_cmd_txd),
        .ram_cmd_rxa(ram_cmd_rxa),
        .ram_cmd_rxd(ram_cmd_rxd),

        .data_idx(com_data_idx),

        .e_mdc(e_mdc),
        .e_mdio(e_mdio),
        .e_rstn(e_rstn),

        .gmii_txc(gmii_txc),
        .gmii_rxc(gmii_rxc),
        .e_rxd(e_rxd),
        .e_rxdv(e_rxdv),
        .e_rxer(e_rxer),
        .e_txen(e_txen),
        .e_txd(e_txd),
        .e_txer(e_txer)
    );

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : usb_inst
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
            .ff_send(ff_usb_send[i]),
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
            .pin_send(u_txen[i]),
            .pin_read(u_rxdv[i])
        );
        end
    endgenerate

    trgg
    trgg_dut(
        .clk(clk_norm),
        .rst(rst),
        
        .fs(fs_trgg_out),
        .fd(fd_trgg_out),

        .pin_miso(pin_miso),
        .pin_mosi(pin_mosi),
        .pin_cs(pin_cs),
        .pin_sclk(pin_sclk),

        .pin_out(pin_trgg),

        .trgg_cmd(trgg_cmd),
        .trgg_data(trgg_rxd)
    );

    data_make
    data_make_dut(
        .clk(clk_fast),
        .rst(rst),

        .fs(fs_data),
        .fd(fd_data),

        .btype(data_btype),
        
        .usb_stat(dev_stat),
        .trgg_rxd(trgg_rxd),

        .ram_rxa(ram_usb_rxa),
        .ram_rxd(ram_usb_rxd),

        .data_idx(ram_data_idx),

        .ram_data_txa(ram_data_txa),
        .ram_data_txd(ram_data_txd),
        .ram_data_txen(ram_data_txen)
    );


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

        .u_rxd(u_rxd),
        .u_txd(u_txd),

        .u_rxd_p(u_rxd_p),
        .u_rxd_n(u_rxd_n),
        .u_txd_p(u_txd_p),
        .u_txd_n(u_txd_n),

        .fan_n(fan_n)
    );

    ram_data
    ram_data_dut(
        .clka(clk_fast),
        .wea(ram_data_txen),
        .addra(ram_data_txa),
        .dina(ram_data_txd),

        .clkb(gmii_txc),
        .addrb(ram_data_rxa),
        .doutb(ram_data_rxd)
    );

    ram_cmd
    ram_cmd_dut(
        .clka(gmii_rxc),
        .wea(ram_cmd_txen),
        .addra(ram_cmd_txa),
        .dina(ram_cmd_txd),

        .clkb(gmii_rxc),
        .addrb(ram_cmd_rxa),
        .doutb(ram_cmd_rxd)
    );

endmodule