module frame_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    output reg crc_en,
    input [31:0] crc,

    output reg fs_mac,
    input fd_mac,

    input [7:0] mac_txd,
    output reg [7:0] eth_txd,
    output eth_txrdy
);

    reg state, next_state;

    assign eth_txrdy = (state == WAIT);

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
            HD01: next_state <= HD01;
            HD02: next_state <= HD01;
            HD03: next_state <= HD01;
            HD04: next_state <= HD01;
            HD05: next_state <= HD01;
            HD06: next_state <= HD01;
            HD07: next_state <= WORK;
            WORK: begin
                if(fd_mac) next_state <= PT00;
                else next_state <= WORK;
            end
            PT00: next_state <= PT01;
            PT01: next_state <= PT02;
            PT02: next_state <= PT03;
            PT03: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) eth_txd <= 8'h00;
        else if(state == IDLE) eth_txd <= 8'h00;
        else if(state == WAIT) eth_txd <= 8'h00;
        else if(state == HD00) eth_txd <= 8'h55;
        else if(state == HD01) eth_txd <= 8'h55;
        else if(state == HD02) eth_txd <= 8'h55;
        else if(state == HD03) eth_txd <= 8'h55;
        else if(state == HD04) eth_txd <= 8'h55;
        else if(state == HD05) eth_txd <= 8'h55;
        else if(state == HD06) eth_txd <= 8'h55;
        else if(state == HD07) eth_txd <= 8'hD5;
        else if(state == WORK) eth_txd <= mac_txd;
        else if(state == PT00) eth_txd <= crc[31:24];
        else if(state == PT01) eth_txd <= crc[23:16];
        else if(state == PT02) eth_txd <= crc[15:8];
        else if(state == PT03) eth_txd <= crc[7:0];
        else eth_txd <= 8'h00;
    end




endmodule