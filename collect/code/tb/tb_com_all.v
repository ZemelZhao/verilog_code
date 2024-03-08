module tb_com_all(
    input clk_in_p,
    input clk_in_n,

    output fan_n,
    input rst_n,
    output [7:0] led_n,

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
    output e_txer
);

    wire clk_norm, clk_slow, clk_fast;
    wire locked;
    wire rst;

    wire e_grxc_g;
    wire gmii_txc, gmii_rxc;

    wire fs_read, fd_read;
    wire fs_send, fd_send;

    wire fs_test, fd_test;

    wire [7:0] ram_cmd_txa, ram_cmd_rxa;
    wire [7:0] ram_cmd_txd, ram_cmd_rxd;
    wire ram_cmd_txen;

    wire [15:0] ram_data_txa, ram_data_rxa;
    wire [7:0] ram_data_txd, ram_data_rxd;
    wire ram_data_txen;

    wire [12:0] data_dlen;

    wire [3:0] com_btype;
    wire [51:0] cache_cmd;

    reg [3:0] state, next_state;
    localparam IDLE = 4'b1, WAIT = 4'h2, WORK = 4'h4, DONE = 4'h8;
    localparam REST = 4'h3;

    reg [31:0] num;
    localparam TIMEOUT = 32'd75_000_000;

    assign led_n = ~{com_btype, cache_cmd[51:48]};

    assign fs_test = (state == WAIT);
    assign data_dlen = 8'h40;

    vio_0 
    vio_dut(
        .clk(clk_norm),
        .probe_out0(rst1)
    );
 
    always@(posedge clk_norm or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fd_test) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                next_state <= WORK;
            end
            default: next_state <= IDLE;
        endcase
    end


    console
    console_dut(
        .clk(clk_norm),
        .rst(rst),
        .fs_com_send(fs_send),
        .fd_com_send(fd_send),
        .fs_com_read(fs_read),
        .fd_com_read(fd_read),

        .com_btype(com_btype),
        .cache_cmd(cache_cmd)
    );

    com
    com_dut(
        .clk(clk_norm),
        .rst(rst),

        .fs_read(fs_read),
        .fd_read(fd_read),
        .fs_send(fs_send),
        .fd_send(fd_send),

        .com_btype(com_btype),
        .cache_cmd(cache_cmd),

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
        .e_txer(e_txer),

        .ram_data_rxa(ram_data_rxa),
        .ram_data_rxd(ram_data_rxd),
        .data_len(data_dlen),

        .ram_cmd_txen(ram_cmd_txen),
        .ram_cmd_txa(ram_cmd_txa),
        .ram_cmd_txd(ram_cmd_txd),
        .ram_cmd_rxa(ram_cmd_rxa),
        .ram_cmd_rxd(ram_cmd_rxd)
    );

    com_test
    com_test_dut(
        .clk(gmii_txc),
        .rst(rst),
        .fs(fs_test),
        .fd(fd_test),
        .ram_data_txa(ram_data_txa),
        .ram_data_txd(ram_data_txd),
        .ram_data_txen(ram_data_txen)
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


    ram_data
    ram_data_dut(
        .clka(gmii_txc),
        .wea(ram_data_txen),
        .addra(ram_data_txa),
        .dina(ram_data_txd),

        .clkb(gmii_txc),
        .addrb(ram_data_rxa),
        .doutb(ram_data_rxd)
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




endmodule
