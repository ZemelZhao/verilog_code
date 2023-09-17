module udp_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    input [15:0] src_port,
    input [15:0] det_port,
    input [15:0] data_len,

    output fifo_rxen,
    input [7:0] fifo_rxd,
    output reg [7:0] udp_txd
);

    localparam CHECKSUM = 16'h0000; // no checksum

    (*MARK_DEBUG = "true"*)reg [7:0] state; 
    reg [7:0] next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam HD00 = 8'h10, HD01 = 8'h11, HD02 = 8'h12, HD03 = 8'h13;
    localparam HD04 = 8'h14, HD05 = 8'h15, HD06 = 8'h16, HD07 = 8'h17;

    reg [15:0] cnt;

    reg [15:0] udp_tx_dlen;

    assign fd = (state == DONE);
    assign fifo_rxen = (state == WORK);

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
            HD07: next_state <= WORK;
            WORK: begin
                if(cnt >= udp_tx_dlen - 1'h1) next_state <= DONE;
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
        if(rst) udp_txd <= 8'h00;
        else if(state == IDLE) udp_txd <= 8'h00;
        else if(state == WAIT) udp_txd <= 8'h00;
        else if(state == HD00) udp_txd <= src_port[15:8];
        else if(state == HD01) udp_txd <= src_port[7:0];
        else if(state == HD02) udp_txd <= det_port[15:8];
        else if(state == HD03) udp_txd <= det_port[7:0];
        else if(state == HD04) udp_txd <= data_len[15:8];
        else if(state == HD05) udp_txd <= data_len[7:0];
        else if(state == HD06) udp_txd <= CHECKSUM[15:8];
        else if(state == HD07) udp_txd <= CHECKSUM[7:0];
        else if(state == WORK) udp_txd <= fifo_rxd;
        else udp_txd <= 8'h00;
    end


    always@(posedge clk or posedge rst) begin
        if(rst) udp_tx_dlen <= 16'h0000;
        else if(state == IDLE) udp_tx_dlen <= 16'h0000;
        else if(state == WAIT) udp_tx_dlen <= 16'h0000;
        else if(state == HD00) udp_tx_dlen <= data_len - 8'h8;
        else udp_tx_dlen <= udp_tx_dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 16'h0000;
        else if(state == WORK) cnt <= cnt + 1'b1;
        else cnt <= 16'h0000;
    end

endmodule