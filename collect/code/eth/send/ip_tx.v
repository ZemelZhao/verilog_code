module ip_tx(
    input clk,
    input rst,

    input [15:0] data_len,
    input [31:0] src_ip_addr,
    input [31:0] det_ip_addr,

    input fs,
    output fd,

    input [7:0] ip_mode,

    output reg fs_mode, 
    input fd_mode,

    input [7:0] ip_mode_txd,
    output reg [7:0] txd
);

    localparam IP_VERSION = 4'h4; // IPV4
    localparam HEADER_LENGTH = 4'h5; // 20 Btypes
    localparam DIFF_SERVE = 8'h00;
    localparam DATA_FLAG = 3'b010; // No Fragment
    localparam DATA_FRAGMENT = 13'h0000;
    localparam DATA_TTL = 8'h80;

    localparam UDP = 8'h11;
    localparam TCP = 8'h06;
    localparam ICMP = 8'h01;
    

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam HD00 = 8'h10, HD01 = 8'h11, HD02 = 8'h12, HD03 = 8'h13;
    localparam HD04 = 8'h14, HD05 = 8'h15, HD06 = 8'h16, HD07 = 8'h17;
    localparam HD08 = 8'h18, HD09 = 8'h19, HD0A = 8'h1A, HD0B = 8'h1B;
    localparam HD0C = 8'h1C, HD0D = 8'h1D, HD0E = 8'h1E, HD0F = 8'h1F;
    localparam HD10 = 8'h20, HD11 = 8'h21, HD12 = 8'h22, HD13 = 8'h23;

    reg [20:0] checksum_d2;
    reg [16:0] checksum_d1;
    reg [16:0] checksum_d0;
    reg [15:0] checksum;
    reg [15:0] data_idx;

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
            HD0D: next_state <= HD0E;
            HD0E: next_state <= HD0F;
            HD0F: next_state <= HD10;
            HD10: next_state <= HD11;
            HD11: next_state <= HD12;
            HD12: next_state <= HD13;
            HD13: next_state <= WORK;
            WORK: begin
                if(fd_mode) next_state <= DONE;
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
        else if(state == HD00) txd <= {IP_VERSION, HEADER_LENGTH};
        else if(state == HD01) txd <= DIFF_SERVE;
        else if(state == HD02) txd <= data_len[15:8];
        else if(state == HD03) txd <= data_len[7:0];
        else if(state == HD04) txd <= data_idx[15:8];
        else if(state == HD05) txd <= data_idx[7:0];
        else if(state == HD06) txd <= {DATA_FLAG, DATA_FRAGMENT[12:8]};
        else if(state == HD07) txd <= DATA_FRAGMENT[7:0];
        else if(state == HD08) txd <= DATA_TTL;
        else if(state == HD09) txd <= ip_mode;
        else if(state == HD0A) txd <= checksum[15:8]; 
        else if(state == HD0B) txd <= checksum[7:0];
        else if(state == HD0C) txd <= src_ip_addr[31:24];
        else if(state == HD0D) txd <= src_ip_addr[23:16];
        else if(state == HD0E) txd <= src_ip_addr[15:8];
        else if(state == HD0F) txd <= src_ip_addr[7:0];
        else if(state == HD10) txd <= det_ip_addr[31:24];
        else if(state == HD11) txd <= det_ip_addr[23:16];
        else if(state == HD12) txd <= det_ip_addr[15:8];
        else if(state == HD13) txd <= det_ip_addr[7:0];
        else if(state == WORK) txd <= ip_mode_txd;
        else txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_mode <= 1'b0;
        else if(state == IDLE) fs_mode <= 1'b0;
        else if(state == WAIT) fs_mode <= 1'b0;
        else if(state == HD0F) fs_mode <= 1'b1;
        else if(state == DONE) fs_mode <= 1'b0;
        else fs_mode <= fs_mode;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) checksum <= 16'h0000;
        else if(state == IDLE) checksum <= 16'h0000;
        else if(state == WAIT) checksum <= 16'h0000; 
        else if(state == HD04) checksum <= checksum_d0[16] + checksum_d0[15:0]; 
        else if(state == HD05) checksum <= ~checksum;
        else checksum <= checksum;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) checksum_d0 <= 17'h00000;
        else if(state == IDLE) checksum_d0 <= 17'h00000;
        else if(state == WAIT) checksum_d0 <= 17'h00000;
        else if(state == HD03) checksum_d0 <= checksum_d1[16] + checksum_d1[15:0];
        else checksum_d0 <= checksum_d0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) checksum_d1 <= 17'h00000;
        else if(state == IDLE) checksum_d1 <= 17'h00000;
        else if(state == WAIT) checksum_d1 <= 17'h00000;
        else if(state == HD02) checksum_d1 <= checksum_d2[20:16] + checksum_d2[15:0];
        else checksum_d1 <= checksum_d1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) checksum_d2 <= 21'h000000;
        else if(state == IDLE) checksum_d2 <= 21'h000000;
        else if(state == WAIT) checksum_d2 <= 21'h000000;
        else if(state == HD01) checksum_d2 <= {IP_VERSION, HEADER_LENGTH, DIFF_SERVE} + data_len + data_idx + {DATA_FLAG, DATA_FRAGMENT} + 
                                              {DATA_TTL, ip_mode} + src_ip_addr[31:16] + src_ip_addr[15:0] + det_ip_addr[31:16] + det_ip_addr[15:0];
        else checksum_d2 <= checksum_d2;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_idx <= 16'h0000;
        else if(state == IDLE) data_idx <= 16'h0000;
        else if(state == HD00) data_idx <= data_idx + 1'b1;
        else data_idx <= data_idx;
    end


endmodule