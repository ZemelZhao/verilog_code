module mac_tx_mode(
    input clk,

    input [7:0] ip_txd,
    input [7:0] arp_txd,

    input [15:0] tx_mode,

    output reg [7:0] txd
);

    localparam IP = 16'h0800, ARP = 16'h0806;

    always@(posedge clk) begin
        if(tx_mode == IP) txd <= ip_txd;
        else if(tx_mode == ARP) txd <= arp_txd;
        else txd <= 8'h00;
    end



endmodule