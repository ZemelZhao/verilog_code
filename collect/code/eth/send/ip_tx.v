module ip_tx(
    input clk,
    input rst,

    input [15:0] data_len,
    input [31:0] src_ip_addr,
    input [31:0] det_ip_addr,

    input fs,
    output fd,

    input [7:0] ip_mode,

    output fs_udp,
    input fd_udp,
    output fs_icmp,
    input fd_icmp,

    input [7:0] ip_mode_txd,
    output reg [7:0] ip_txd,
);

    localparam IP_VERSION = 4'h4; // IPV4
    localparam HEADER_LENGTH = 4'h5; // 20 Btypes
    localparam DIFF_SERVE = 8'h00;
    localparam DATA_FLAG = 3'b010; // No Fragment
    localparam DATA_FRAGMENT = 13'h0000;
    localparam DATA_TTL = 8'h80;
    localparam UDP = 8'h11; // UDP
    localparam ICMP = 8'h06;


    reg state, next_state;

    localparam IDLE

    reg [15:0] checksum;
    reg [15:0] data_idx;

    wire fd_up;

    assign fd_up = |{fd_udp, fd_icmp};




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
            HD0D: next_state <= HD0E;
            HD0E: next_state <= HD0F;
            HD0F: next_state <= HD10;
            HD10: next_state <= HD11;
            HD11: next_state <= HD12;
            HD12: next_state <= HD13;
            HD13: next_state <= WORK;
            WORK: begin
                if(fd_up) next_state <= DONE;
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
        if(rst) ip_txd <= 8'h00;
        else if(state == IDLE) ip_txd <= 8'h00;
        else if(state == WAIT) ip_txd <= 8'h00;
        else if(state == HD00) ip_txd <= {IP_VERSION, HEADER_LENGTH};
        else if(state == HD01) ip_txd <= DIFF_SERVE;
        else if(state == HD02) ip_txd <= data_len[15:8];
        else if(state == HD03) ip_txd <= data_len[7:0];
        else if(state == HD04) ip_txd <= data_idx[15:8];
        else if(state == HD05) ip_txd <= data_idx[7:0];
        else if(state == HD06) ip_txd <= {DATA_FLAG, DATA_FRAGMENT[12:8]};
        else if(state == HD07) ip_txd <= DATA_FRAGMENT[7:0];
        else if(state == HD08) ip_txd <= DATA_TTL;
        else if(state == HD09) ip_txd <= ip_mode;
        else if(state == HD0A) ip_txd <= checksum[15:8]; 
        else if(state == HD0B) ip_txd <= checksum[7:0];
        else if(state == HD0C) ip_txd <= src_ip_addr[31:24];
        else if(state == HD0D) ip_txd <= src_ip_addr[23:16];
        else if(state == HD0E) ip_txd <= src_ip_addr[15:8];
        else if(state == HD0F) ip_txd <= src_ip_addr[7:0];
        else if(state == HD10) ip_txd <= det_ip_addr[31:24];
        else if(state == HD11) ip_txd <= det_ip_addr[23:16];
        else if(state == HD12) ip_txd <= det_ip_addr[15:8];
        else if(state == HD13) ip_txd <= det_ip_addr[7:0];
        else if(state == WORK) ip_txd <= ip_mode_txd;
        else ip_txd <= 8'h00;
    end



endmodule