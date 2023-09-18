module mac_tx(
    input clk,
    input rst,

    input [47:0] src_mac_addr,
    input [47:0] det_mac_addr,

    input fs,
    output fd,

    input [15:0] mac_mode,

    output reg fs_ip,
    input fd_ip,
    output reg fs_arp,
    input fd_arp,

    input [7:0] mac_mode_txd,
    output reg [7:0] txd
);

    localparam IP = 16'h0800, ARP = 16'h0806;


    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam HD00 = 8'h10, HD01 = 8'h11, HD02 = 8'h12, HD03 = 8'h13;
    localparam HD04 = 8'h14, HD05 = 8'h15, HD06 = 8'h16, HD07 = 8'h17;
    localparam HD08 = 8'h18, HD09 = 8'h19, HD0A = 8'h1A, HD0B = 8'h1B;
    localparam HD0C = 8'h1C, HD0D = 8'h1D; 

    wire fd_up;
    reg fd_up_s0;
    assign fd_up = |{fd_ip, fd_arp};
    assign fd = (state == DONE);


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= HD00;
                else next_state <= WAIT;
            end
            HD00: next_state <= HD01;
            HD01: next_state <= HD02;
            HD02: next_state <= HD03;
            HD03: next_state <= HD04;
            HD04: next_state <= HD05;
            HD05: next_state <= HD06;
            HD06: next_state <= HD07;
            HD07: next_state <= HD08;
            HD08: next_state <= HD09;
            HD09: next_state <= HD0A;
            HD0A: next_state <= HD0B;
            HD0B: next_state <= HD0C;
            HD0C: next_state <= HD0D;
            HD0D: next_state <= WORK;
            WORK: begin
                if(fd_up_s0) next_state <= DONE;
                else next_state <= WORK;
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
        else if(state == HD00) txd <= det_mac_addr[47:40];
        else if(state == HD01) txd <= det_mac_addr[39:32];
        else if(state == HD02) txd <= det_mac_addr[31:24];
        else if(state == HD03) txd <= det_mac_addr[23:16];
        else if(state == HD04) txd <= det_mac_addr[15:8];
        else if(state == HD05) txd <= det_mac_addr[7:0];
        else if(state == HD06) txd <= src_mac_addr[47:40];
        else if(state == HD07) txd <= src_mac_addr[39:32];
        else if(state == HD08) txd <= src_mac_addr[31:24];
        else if(state == HD09) txd <= src_mac_addr[23:16];
        else if(state == HD0A) txd <= src_mac_addr[15:8];
        else if(state == HD0B) txd <= src_mac_addr[7:0];
        else if(state == HD0C) txd <= mac_mode[15:8];
        else if(state == HD0D) txd <= mac_mode[7:0];
        else if(state == WORK) txd <= mac_mode_txd;
        else txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_ip <= 1'b0;
        else if(state == IDLE) fs_ip <= 1'b0;
        else if(state == WAIT) fs_ip <= 1'b0;
        else if(state == HD0A && mac_mode == IP) fs_ip <= 1'b1;
        else if(state == DONE) fs_ip <= 1'b0;
        else fs_ip <= fs_ip;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_arp <= 1'b0;
        else if(state == IDLE) fs_arp <= 1'b0;
        else if(state == WAIT) fs_arp <= 1'b0;
        else if(state == HD0A && mac_mode == ARP) fs_arp <= 1'b1;
        else if(state == DONE) fs_arp <= 1'b0;
        else fs_arp <= fs_arp;
    end

    always@(posedge clk) begin
        fd_up_s0 <= fd_up;
    end


endmodule