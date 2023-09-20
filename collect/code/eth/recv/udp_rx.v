module udp_rx(
    input clk,
    input rst,

    input [7:0] rxd,

    input fs,
    output fd,

    output reg [15:0] dlen,
    output reg [15:0] src_ip_port,
    output reg [15:0] det_ip_port,

    input fifo_full,
    output reg fifo_txen,
    output reg [7:0] fifo_txd
);

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam HD00 = 8'h10, HD01 = 8'h11, HD02 = 8'h12, HD03 = 8'h13;
    localparam HD04 = 8'h14, HD05 = 8'h15, HD06 = 8'h16, HD07 = 8'h17;

    reg [15:0] udp_rx_dlen;
    reg [15:0] cnt;

    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: begin
                if(fifo_full) next_state <= WAIT;
                else next_state <= IDLE;
            end
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
            HD07: next_state <= WORK;
            WORK: begin
                if(cnt >= dlen - 1'b1) next_state <= DONE;
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
        if(rst) src_ip_port <= 16'h0000; 
        else if(state == IDLE) src_ip_port <= 16'h0000;
        else if(state == HD00) src_ip_port[15:8] <= rxd;
        else if(state == HD01) src_ip_port[7:0] <= rxd;
        else src_ip_port <= src_ip_port;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) det_ip_port <= 16'h0000;
        else if(state == IDLE) det_ip_port <= 16'h0000;
        else if(state == HD02) det_ip_port[15:8] <= rxd;
        else if(state == HD03) det_ip_port[7:0] <= rxd;
        else det_ip_port <= det_ip_port;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) udp_rx_dlen <= 16'h0000;
        else if(state == IDLE) udp_rx_dlen <= 16'h0000;
        else if(state == HD04) udp_rx_dlen[15:8] <= rxd;
        else if(state == HD05) udp_rx_dlen[7:0] <= rxd;
        else udp_rx_dlen <= udp_rx_dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= 16'h0000;
        else if(state == IDLE) dlen <= 16'h0000;
        else if(state == HD06) dlen <= udp_rx_dlen - 8'h08;
        else dlen <= dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fifo_txd <= 8'h00;
        else if(state == WORK) fifo_txd <= rxd; 
        else fifo_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fifo_txen <= 1'h0;
        else if(state == WORK) fifo_txen <= 1'b1; 
        else fifo_txen <= 1'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 16'h0000;
        else if(state == IDLE) cnt <= 16'h0000;
        else if(state == WAIT) cnt <= 16'h0000;
        else if(state == WORK) cnt <= cnt + 1'b1;
        else cnt <= cnt;
    end








endmodule