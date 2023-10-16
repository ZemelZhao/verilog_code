module main(
    input clk_p,
    input clk_n,

    input rst_n,
    output fan_n,

    output [3:0] usb0_txd_p,
    output [3:0] usb0_txd_n,
    output [1:0] usb0_rxd_p,
    output [1:0] usb0_rxd_n,
    output usb0_txf,
    output usb0_rxf,

    output [3:0] usb1_txd_p,
    output [3:0] usb1_txd_n,
    output [1:0] usb1_rxd_p,
    output [1:0] usb1_rxd_n,
    output usb1_txf
    output usb1_rxf
);


