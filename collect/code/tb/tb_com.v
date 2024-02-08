module tb_com(
    input clk_in_p,
    input clk_in_n,

    output fan_n,
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

    wire [11:0] data_dlen;

    wire [3:0] com_btype;
    wire [51:0] cache_cmd;

    reg [3:0] state, next_state;
    localparam IDLE = 4'b1, WAIT = 4'h2, WORK = 4'h4, DONE = 4'h8;
    localparam REST = 4'h3;

    reg [31:0] num;
    localparam TIMEOUT = 32'd75_000_000;

    wire rst1;

    assign e_gtxc = ~e_grxc_g;
    assign gmii_txc = e_grxc_g;
    assign gmii_rxc = e_grxc_g;
    assign rst = (~locked) || rst1; 

    assign led_n = ~{com_btype, cache_cmd[51:48]};
    assign fan_n = 1'b0;

    assign fs_test = (state == WAIT);
    assign fs_send = (state == WORK);
    assign data_dlen = 8'h40;
    assign fd_read = 1'b1;

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
            REST: begin
                if(num >= TIMEOUT)  next_state <= WORK;
                else next_state <= REST;
            end
            WORK: begin
                if(fd_send) next_state <= DONE; 
                else next_state <= WORK;
            end
            DONE: next_state <= WORK;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk_norm or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == REST) num <= num + 1'b1;
        else num <= 8'h00;
    end 


    BUFG
    bufg_dut(
        .I(e_grxc),
        .O(e_grxc_g)
    );

    clk_wiz
    clk_wiz_dut(
        .clk_in1_p(clk_in_p),
        .clk_in1_n(clk_in_n),

        .clk_norm(clk_norm),

        .locked(locked)
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





endmodule
