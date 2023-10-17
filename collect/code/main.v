module main(
    input clk_p,
    input clk_n,

    input rst_n,
    output fan_n,

    input [3:0] usb0_rxd_p,
    input [3:0] usb0_rxd_n,
    output usb0_txd_p,
    output usb0_txd_n,
    (*MARK_DEBUG = "true"*)output usb0_txf,
    (*MARK_DEBUG = "true"*)input usb0_rxf,

    output led_n,

    output [3:0] usb1_rxd_p,
    output [3:0] usb1_rxd_n,
    input usb1_txd_p,
    input usb1_txd_n,
    output usb1_txf,
    input usb1_rxf
);

    wire clk_in;
    wire clk_25, clk_50, clk_100, clk_200;


    IBUFGDS
    ibufgds_clk(
        .I(clk_p),
        .IB(clk_n),
        .O(clk_in)
    );

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk_in),
        .clk_25(clk_25),
        .clk_50(clk_50),
        .clk_100(clk_100),
        .clk_200(clk_200)
    );

    test_hunter
    test_hunter_dut(
        .clk_25(clk_25),
        .clk_50(clk_50),
        .clk_100(clk_100),
        .clk_200(clk_200),

        .rst_n(rst_n),

        .com_txd_p(usb1_rxd_p),
        .com_txd_n(usb1_rxd_n),
        .com_rxd_p(usb1_txd_p),
        .com_rxd_n(usb1_txd_n),
        .com_rxf(usb1_rxf),
        .com_txf(usb1_txf)
    );

    test_collect
    test_collect_dut(
        .clk_25(clk_25),
        .clk_50(clk_50),
        .clk_100(clk_100),
        .clk_200(clk_200),

        .rst_n(rst_n),

        .led_n(led_n),
        .fan_n(fan_n),

        .usb_rxd0p(usb0_rxd_p),
        .usb_rxd0n(usb0_rxd_n),
        .usb_txd0p(usb0_txd_p),
        .usb_txd0n(usb0_txd_n),

        .usb_rxf(usb0_rxf),
        .usb_txf(usb0_txf)
    );



endmodule