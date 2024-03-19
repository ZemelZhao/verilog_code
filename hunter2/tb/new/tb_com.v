module tb_com(
    input clk_25,
    input clk_50,
    input clk_100, 
    input clk_200,
    input clk_400,
    input rst
);

    wire ud_fire_send, ud_fire_read;
    wire dd_fire_send, dd_fire_read;
    wire [3:0] ud_pin_txd, dd_pin_rxd;
    wire ud_pin_rxd, dd_pin_txd;

    assign dd_fire_read = ud_fire_send;
    assign ud_fire_read = dd_fire_send;
    assign dd_pin_rxd = ud_pin_txd;
    assign ud_pin_rxd = dd_pin_txd;

    test_hunter
    test_hunter_dut(
        .clk_25(clk_25),
        .clk_50(clk_50),
        .clk_100(clk_100),
        .clk_200(clk_200),
        .clk_400(clk_400),

        .rst(rst),

        .pin_txd(ud_pin_txd),
        .pin_rxd(ud_pin_rxd),

        .fire_send(ud_fire_send),
        .fire_read(ud_fire_read)
    );

    test_collect
    test_collect_dut(
        .clk_25(clk_25),
        .clk_50(clk_50),
        .clk_100(clk_100),
        .clk_200(clk_200),
        .clk_400(clk_400),

        .rst(rst),

        .pin_txd(dd_pin_txd),
        .pin_rxd(dd_pin_rxd),

        .fire_send(dd_fire_send),
        .fire_read(dd_fire_read),
        .link(link)
    );


endmodule