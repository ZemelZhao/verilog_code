module mac_rx_mode(
    input clk,

    input [15:0] mode,

    input fs_mode,
    output reg fd_mode,

    output reg fs_ip,
    output reg fs_arp,

    input fd_ip,
    input fd_arp,

    input [7:0] rxd,

    output reg [7:0] ip_rxd,
    output reg [7:0] arp_rxd
);

    localparam IP = 16'h0800, ARP = 16'h0806;

    always@(posedge clk) begin
        if(mode == IP) ip_rxd <= rxd; 
        else ip_rxd <= 8'h00;
    end

    always@(posedge clk) begin
        if(mode == ARP) arp_rxd <= rxd; 
        else arp_rxd <= 8'h00;
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