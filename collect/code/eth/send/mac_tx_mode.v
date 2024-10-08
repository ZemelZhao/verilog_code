module mac_tx_mode(
    input clk,

    input [7:0] ip_txd,
    input [7:0] arp_txd,

    input [15:0] mode,

    input fs_mode,
    output reg fd_mode,

    output reg fs_ip,
    input fd_ip,
    output reg fs_arp,
    input fd_arp,

    output reg [7:0] txd
);

    localparam IP = 16'h0800, ARP = 16'h0806;

    always@(posedge clk) begin
        if(mode == IP) txd <= ip_txd;
        else if(mode == ARP) txd <= arp_txd;
        else txd <= 8'h00;
    end

    always@(posedge clk) begin
        if(mode == IP) fs_ip <= fs_mode;
        else fs_ip <= 1'b0;
    end

    always@(posedge clk) begin
        if(mode == ARP) fs_arp <= fs_mode;
        else fs_arp <= 1'b0;
    end

    always@(posedge clk) begin
        if(mode == IP) fd_mode <= fd_ip;
        else if(mode == ARP) fd_mode <= fd_arp;
        else fd_mode <= 1'b0;
    end




endmodule