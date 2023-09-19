module ip_rx(
    input clk,
    input rst,

    input [7:0] rxd,

    input fs,
    output fd,

    output reg fs_mode,
    input fd_mode,

    output reg [7:0] ip_mode,
    output reg [31:0] src_ip_addr,
    output reg [31:0] det_ip_addr,
    output reg [7:0] mode_rxd

);

    localparam MIN_HLEN = 8'h14;

    reg [7:0] state, next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam HEAD = 8'h04, REST = 8'h05;

    reg [15:0] cnt;

    reg [7:0] hlen;
    reg [15:0] dlen;

    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= HEAD;
                else next_state <= WAIT;
            end
            HEAD: begin
                if(cnt >= hlen - 1'b1) next_state <= WORK;
                else next_state <= HEAD;
            end
            WORK: begin
                if(cnt >= dlen - 1'b1) next_state <= REST;
                else next_state <= WORK;
            end
            REST: begin
                if(fd_mode) next_state <= DONE;
                else next_state <= REST;
            end
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ip_mode <= 8'h00;
        else if(state == IDLE) ip_mode <= MIN_HLEN;
        else if(state == WAIT) ip_mode <= MIN_HLEN;
        else if(state == HEAD && cnt == 8'h09) ip_mode <= rxd;
        else ip_mode <= ip_mode;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) hlen <= 8'h00;
        else if(state == IDLE) hlen <= 8'h00;
        else if(state == WAIT) hlen <= 8'h00;
        else if(state == HEAD && cnt == 8'h00) hlen <= {2'h0, rxd[3:0], 2'h0};
        else hlen <= hlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= 16'h0000;
        else if(state == IDLE) dlen <= 16'h0000;
        else if(state == WAIT) dlen <= 16'h0000;
        else if(state == HEAD && cnt == 8'h02) dlen[15:8] <= rxd;
        else if(state == HEAD && cnt == 8'h03) dlen[7:0] <= rxd;
        else if(state == HEAD && cnt == 8'h04) dlen <= dlen - hlen;
        else dlen <= dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 16'h0000;
        else if(state == IDLE) cnt <= 16'h0000;
        else if(state == WAIT) cnt <= 16'h0000;
        else if(state == HEAD && cnt < hlen - 1'b1) cnt <= cnt + 1'b1;
        else if(state == HEAD && cnt >= hlen - 1'b1) cnt <= 16'h0000;
        else if(state == WORK) cnt <= cnt + 1'b1;
        else cnt <= 16'h0000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) src_ip_addr <= 32'h00000000;
        else if(state == IDLE) src_ip_addr <= 32'h00000000;
        else if(state == HEAD && cnt == 8'h0C) src_ip_addr[31:24] <= rxd;
        else if(state == HEAD && cnt == 8'h0D) src_ip_addr[23:16] <= rxd;
        else if(state == HEAD && cnt == 8'h0E) src_ip_addr[15:8] <= rxd;
        else if(state == HEAD && cnt == 8'h0F) src_ip_addr[7:0] <= rxd;
        else src_ip_addr <= src_ip_addr;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) det_ip_addr <= 32'h00000000;
        else if(state == IDLE) det_ip_addr <= 32'h00000000;
        else if(state == HEAD && cnt == 8'h10) det_ip_addr[31:24] <= rxd;
        else if(state == HEAD && cnt == 8'h11) det_ip_addr[23:16] <= rxd;
        else if(state == HEAD && cnt == 8'h12) det_ip_addr[15:8] <= rxd;
        else if(state == HEAD && cnt == 8'h13) det_ip_addr[7:0] <= rxd;
        else det_ip_addr <= det_ip_addr;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) mode_rxd <= 8'h00;
        else if(state == IDLE) mode_rxd <= 8'h00;
        else if(state == WAIT) mode_rxd <= 8'h00;
        else if(state == WORK) mode_rxd <= rxd;
        else mode_rxd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_mode <= 1'b0;
        else if(state == IDLE) fs_mode <= 1'b0;
        else if(state == WAIT) fs_mode <= 1'b0;
        else if(state == HEAD && cnt >= hlen - 4'h1) fs_mode <= 1'b1;
        else if(state == WORK) fs_mode <= 1'b1;
        else if(state == REST) fs_mode <= 1'b1;
        else if(state == DONE) fs_mode <= 1'b0;
        else fs_mode <= fs_mode;
    end


endmodule