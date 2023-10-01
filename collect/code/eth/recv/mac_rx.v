module mac_rx(
    input clk,
    input rst,

    input [7:0] rxd,

    input fs,
    output fd,

    output reg fs_mode,
    input fd_mode,

    input [15:0] data_len,

    output reg [15:0] mac_mode,
    output reg [47:0] src_mac_addr,
    output reg [47:0] det_mac_addr,
    output reg [7:0] mode_rxd
);

    localparam MIN_FLEN = 8'h40, MIN_DLEN = 8'h2E;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam DM00 = 8'h10, DM01 = 8'h11, DM02 = 8'h12, DM03 = 8'h13;
    localparam DM04 = 8'h14, DM05 = 8'h15;
    localparam SM00 = 8'h20, SM01 = 8'h21, SM02 = 8'h22, SM03 = 8'h23;
    localparam SM04 = 8'h24, SM05 = 8'h25;
    localparam TP00 = 8'h30, TP01 = 8'h31;
    localparam REST = 8'h40;

    reg [15:0] cnt;
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
                if(fs) next_state <= DM00; 
                else next_state <= WAIT;
            end
            DM00: next_state <= DM01;
            DM01: next_state <= DM02;
            DM02: next_state <= DM03;
            DM03: next_state <= DM04;
            DM04: next_state <= DM05;
            DM05: next_state <= SM00;
            SM00: next_state <= SM01;
            SM01: next_state <= SM02;
            SM02: next_state <= SM03;
            SM03: next_state <= SM04;
            SM04: next_state <= SM05;
            SM05: next_state <= TP00;
            TP00: next_state <= TP01;
            TP01: next_state <= WORK;
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
        if(rst) dlen <= MIN_DLEN;
        else if(state == IDLE) dlen <= MIN_DLEN;
        else if(state == WAIT) dlen <= MIN_DLEN;
        else if(state == WORK && data_len >= MIN_FLEN) dlen <= data_len - 8'h0E; 
        else dlen <= dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 16'h0000;
        else if(state == IDLE) cnt <= 16'h0000;
        else if(state == WAIT) cnt <= 16'h0000;
        else if(state == WORK) cnt <= cnt + 1'b1;
        else cnt <= 16'h0000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) src_mac_addr <= 48'h000000000000;
        else if(state == IDLE) src_mac_addr <= 48'h000000000000;
        else if(state == DM00) src_mac_addr[47:40] <= rxd;
        else if(state == DM01) src_mac_addr[39:32] <= rxd;
        else if(state == DM02) src_mac_addr[31:24] <= rxd;
        else if(state == DM03) src_mac_addr[23:16] <= rxd;
        else if(state == DM04) src_mac_addr[15:8] <= rxd;
        else if(state == DM05) src_mac_addr[7:0] <= rxd;
        else src_mac_addr <= src_mac_addr;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) det_mac_addr <= 48'h000000000000;
        else if(state == IDLE) det_mac_addr <= 48'h000000000000;
        else if(state == SM00) det_mac_addr[47:40] <= rxd;
        else if(state == SM01) det_mac_addr[39:32] <= rxd;
        else if(state == SM02) det_mac_addr[31:24] <= rxd;
        else if(state == SM03) det_mac_addr[23:16] <= rxd;
        else if(state == SM04) det_mac_addr[15:8] <= rxd;
        else if(state == SM05) det_mac_addr[7:0] <= rxd;
        else det_mac_addr <= det_mac_addr;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) mac_mode <= 16'h0000;
        else if(state == TP00) mac_mode[15:8] <= rxd;
        else if(state == TP00) mac_mode[7:0] <= rxd;
        else mac_mode <= mac_mode;
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
        else if(state == TP01) fs_mode <= 1'b1;
        else if(state == WORK) fs_mode <= 1'b1;
        else if(state == REST) fs_mode <= 1'b1;
        else if(state == DONE) fs_mode <= 1'b0;
        else fs_mode <= fs_mode;
    end





endmodule