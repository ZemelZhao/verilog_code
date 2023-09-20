module frame_rx(
    input clk,
    input rst,

    input rxdv,
    input [7:0] rxd,

    output reg fs_mac,
    input fd_mac,

    output fs_read,
    input fd_read,

    output fs_fifo,
    input fd_fifo,

    input [31:0] crc,
    output reg crc_en,

    input [15:0] data_len,
    output reg [7:0] mac_rxd
);

    localparam HEAD_DATA = 8'h55, WAKE_DATA = 8'h5D, PART_LEN = 8'h04, MIN_DLEN = 8'h40;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam HEAD = 8'h10, WAKE = 8'h11, PART = 8'h12, ERROR = 8'h13; 
    localparam CK00 = 8'h20, CK01 = 8'h21, CK02 = 8'h22;

    reg [31:0] checksum;
    reg [15:0] dlen;
    reg [15:0] cnt;

    assign fs_read = (state == DONE);
    assign fs_fifo = (state == ERROR);

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(rxdv && rxd == HEAD_DATA) next_state <= HEAD;
                else next_state <= WAIT;
            end
            HEAD: begin
                if(rxdv && rxd == HEAD_DATA && cnt >= HEAD_LEN - 1'b1) next_state <= WAKE;
                else if(rxdv && rxd == HEAD_DATA) next_state <= HEAD;
                else next_state <= WAIT;
            end 
            WAKE: begin
                if(rxdv && rxd == WAKE_DATA) next_state <= WORK;
                else next_state <= IDLE;
            end
            WORK: begin
                if(rxdv && cnt >= dlen - 1'b1) next_state <= PART;
                else if(rxdv) next_state <= WORK;
                else next_state <= IDLE;
            end
            PART: begin
                if(rxdv && cnt >= PART_LEN - 1'b1) next_state <= CK00;
                else if(rxdv) next_state <= PART;
                else next_state <= IDLE;
            end
            CK00: next_state <= CK01;
            CK01: next_state <= CK02;
            CK02: begin
                if(crc == checksum) next_state <= DONE;
                else next_state <= ERROR;
            end
            ERROR: begin
                if(fd_fifo) next_state <= WAIT;
                else next_state <= ERROR;
            end
            DONE: begin
                if(fd_read) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;

        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) mac_rxd <= 8'h00;
        else if(state == WORK) mac_rxd <= rxd;
        else mac_rxd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_mac <= 1'b0;
        else if(state == IDLE) fs_mac <= 1'b0;
        else if(state == WAIT) fs_mac <= 1'b0;
        else if(state == WAKE) fs_mac <= 1'b1;
        else if(state == WORK) fs_mac <= 1'b1;
        else fs_mac <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) checksum <= 32'h00000000;
        else if(state == IDLE) checksum <= 32'h00000000;
        else if(state == WAIT) checksum <= 32'h00000000;
        else if(state == WORK) checksum <= 32'h00000000;
        else if(state == PART && cnt == 4'h0) checksum[31:24] <= rxd;
        else if(state == PART && cnt == 4'h1) checksum[23:16] <= rxd;
        else if(state == PART && cnt == 4'h2) checksum[15:8] <= rxd;
        else if(state == PART && cnt == 4'h3) checksum[7:0] <= rxd;
        else checksum <= checksum;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= 16'h0000;
        else if(state == IDLE) dlen <= 16'h0000;
        else if(state == WAIT) dlen <= 16'h0000;
        else if(state == WAKE) dlen <= 16'h0000;
        else if(state == WORK && data_len >= MIN_DLEN) dlen <= data_len - 4'h4; 
        else if(state == WORK && data_len < MIN_DLEN) dlen <= MIN_DLEN - 4'h4; 
        else dlen <= dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 16'h0000;
        else if(state == IDLE) cnt <= 16'h0000; 
        else if(state == WAIT) cnt <= 16'h0000;
        else if(state == HEAD) cnt <= cnt + 1'b1;
        else if(state == WAKE) cnt <= 16'h0000;
        else if(state == WORK && cnt < dlen - 1'b1) cnt <= cnt + 1'b1;
        else if(state == WORK && cnt >= dlen - 1'b1) cnt <= 16'h0000;
        else if(state == PART) cnt <= cnt + 1'b1;
        else cnt <= 16'h0000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) crc_en <= 1'b0;
        else if(state == WAKE) crc_en <= 1'b1;
        else if(state == WORK) crc_en <= 1'b1;
        else if(state == PART) crc_en <= 1'b0;
        else crc_en <= 1'b0;
    end

endmodule