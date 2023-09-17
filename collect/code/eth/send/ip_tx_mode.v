module ip_tx_mode(
    input clk,

    input [7:0] udp_txd,
    input [7:0] tcp_txd,
    input [7:0] icmp_txd,

    input [7:0] tx_mode,
    
    output reg [7:0] txd
);

    localparam ICMP = 8'h01, TCP = 8'h06, UDP = 8'h11; 

    always@(posedge clk) begin
        if(tx_mode == ICMP) txd <= icmp_txd;
        else if(tx_mode == TCP) txd <= tcp_txd;
        else if(tx_mode == UDP) txd <= udp_txd;
        else txd <= 8'h00;
    end




endmodule