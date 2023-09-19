module ip_tx_mode(
    input clk,

    input [7:0] udp_txd,
    input [7:0] tcp_txd,
    input [7:0] icmp_txd,

    input [7:0] mode,

    input fs_mode,
    output reg fd_mode,

    output reg fs_udp,
    input fd_udp,

    output reg fs_tcp,
    input fd_tcp,

    output reg fs_icmp,
    input fd_icmp,
    
    output reg [7:0] txd
);

    localparam ICMP = 8'h01, TCP = 8'h06, UDP = 8'h11; 

    always@(posedge clk) begin
        if(mode == ICMP) txd <= icmp_txd;
        else if(mode == TCP) txd <= tcp_txd;
        else if(mode == UDP) txd <= udp_txd;
        else txd <= 8'h00;
    end

    always@(posedge clk) begin
        if(mode == ICMP) fs_icmp <= fs_mode;   
        else fs_icmp <= 1'b0;
    end

    always@(posedge clk) begin
        if(mode == TCP) fs_tcp <= fs_mode;   
        else fs_tcp <= 1'b0;
    end

    always@(posedge clk) begin
        if(mode == UDP) fs_udp <= fs_mode;   
        else fs_udp <= 1'b0;
    end

    always@(posedge clk) begin
        if(mode == ICMP) fd_mode <= fd_icmp;
        else if(mode == TCP) fd_mode <= fd_tcp;
        else if(mode == UDP) fd_mode <= fd_udp;
        else fd_mode <= 1'b0;
    end






endmodule