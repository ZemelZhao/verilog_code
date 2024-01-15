module usb_cc(
    input usb_txd,
    output pin_txd,

    input [3:0] pin_rxd,
    output [3:0] usb_rxd
);

    assign pin_txd = usb_txd;
    assign usb_rxd = pin_rxd;

endmodule