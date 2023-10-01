module arp_tx(
    input clk,
    input rst,

    input fs,
    output fd,
    input btype,

    input [47:0] src_mac_addr,
    input [47:0] det_mac_addr,
    input [31:0] src_ip_addr,
    input [31:0] det_ip_addr,

    output reg [7:0] txd
);

    localparam ETHERNET = 16'h0001;
    localparam IPV4 = 16'h0800;
    localparam MAC_ADDR_LEN = 8'h06;
    localparam IP_ADDR_LEN = 8'h04;

    localparam ARP_REQUEST = 16'h00001;
    localparam ARP_ANSWER = 16'h0002;

    localparam HLEN = 8'h1C, DLEN = 8'h2E;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam ZERO = 8'h10;

    reg [47:0] arp_mac_addr;
    reg [15:0] op;
    reg [7:0] cnt;

    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(cnt >= HLEN - 1'b1) next_state <= ZERO;
                else next_state <= WORK;
            end
            ZERO: begin
                if(cnt >= DLEN - 1'b1) next_state <= DONE;
                else next_state <= ZERO;
            end
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txd <= 8'h00;
        else if(state == IDLE) txd <= 8'h00;
        else if(state == WAIT) txd <= 8'h00;
        else if(state == WORK && cnt == 8'h00) txd <= ETHERNET[15:8];
        else if(state == WORK && cnt == 8'h01) txd <= ETHERNET[7:0];
        else if(state == WORK && cnt == 8'h02) txd <= IPV4[15:8];
        else if(state == WORK && cnt == 8'h03) txd <= IPV4[7:0];
        else if(state == WORK && cnt == 8'h04) txd <= MAC_ADDR_LEN;
        else if(state == WORK && cnt == 8'h05) txd <= IP_ADDR_LEN;
        else if(state == WORK && cnt == 8'h06) txd <= op[15:8];
        else if(state == WORK && cnt == 8'h07) txd <= op[7:0];
        else if(state == WORK && cnt == 8'h08) txd <= src_mac_addr[47:40];
        else if(state == WORK && cnt == 8'h09) txd <= src_mac_addr[39:32];
        else if(state == WORK && cnt == 8'h0A) txd <= src_mac_addr[31:24];
        else if(state == WORK && cnt == 8'h0B) txd <= src_mac_addr[23:16];
        else if(state == WORK && cnt == 8'h0C) txd <= src_mac_addr[15:8];
        else if(state == WORK && cnt == 8'h0D) txd <= src_mac_addr[7:0];
        else if(state == WORK && cnt == 8'h0E) txd <= src_ip_addr[31:24];
        else if(state == WORK && cnt == 8'h0F) txd <= src_ip_addr[23:16];
        else if(state == WORK && cnt == 8'h10) txd <= src_ip_addr[15:8];
        else if(state == WORK && cnt == 8'h11) txd <= src_ip_addr[7:0];
        else if(state == WORK && cnt == 8'h12) txd <= arp_mac_addr[47:40];
        else if(state == WORK && cnt == 8'h13) txd <= arp_mac_addr[39:32];
        else if(state == WORK && cnt == 8'h14) txd <= arp_mac_addr[31:24];
        else if(state == WORK && cnt == 8'h15) txd <= arp_mac_addr[23:16];
        else if(state == WORK && cnt == 8'h16) txd <= arp_mac_addr[15:8];
        else if(state == WORK && cnt == 8'h17) txd <= arp_mac_addr[7:0];
        else if(state == WORK && cnt == 8'h18) txd <= det_ip_addr[31:24];
        else if(state == WORK && cnt == 8'h19) txd <= det_ip_addr[23:16];
        else if(state == WORK && cnt == 8'h1A) txd <= det_ip_addr[15:8];
        else if(state == WORK && cnt == 8'h1B) txd <= det_ip_addr[7:0];
        else if(state == ZERO) txd <= 8'h00;
        else txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 8'h00;
        else if(state == IDLE) cnt <= 8'h00;
        else if(state == WAIT) cnt <= 8'h00;
        else if(state == WORK) cnt <= cnt + 1'b1;
        else if(state == ZERO) cnt <= cnt + 1'b1;
        else cnt <= cnt + 1'b1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) op <= ARP_REQUEST;
        else if(state == IDLE) op <= ARP_REQUEST;
        else if(state == WAIT && btype) op <= ARP_REQUEST;
        else if(state == WAIT) op <= ARP_ANSWER;
        else op <= op;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) arp_mac_addr <= 48'h000000000000;
        else if(state == IDLE) arp_mac_addr <= 48'h000000000000;
        else if(state == WAIT && btype) arp_mac_addr <= 48'h000000000000;
        else if(state == WAIT) arp_mac_addr <= det_mac_addr;
        else arp_mac_addr <= arp_mac_addr;
    end





endmodule