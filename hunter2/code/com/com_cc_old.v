module com_cc(
    input [3:0] usb_txd,
    output [3:0] pin_txd,

    input pin_rxd,
    output usb_rxd 
);

    assign pin_txd = usb_txd;
    assign usb_rxd = pin_rxd;

endmodule