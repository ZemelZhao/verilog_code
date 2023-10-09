module com_cc(
    input clk,

    input [3:0] usb_txd,
    output reg [3:0] pin_txd,

    input pin_rxd,
    output reg usb_rxd 
);

    always@(posedge clk) begin
        pin_txd <= usb_txd;
        usb_rxd <= pin_rxd;
    end




endmodule