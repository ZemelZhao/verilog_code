module usb_cc(
    input clk,

    input usb_txd,
    output reg pin_txd,

    input [3:0] pin_rxd,
    output reg [3:0] usb_rxd
);

    always@(posedge clk) begin
        pin_txd <= usb_txd;
        usb_rxd <= pin_rxd;
    end

    






endmodule