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
    output reg [7:0] txd,
    output reg txen,

    output eth_txrdy
);

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam HD00 = 8'h10, HD01 = 8'h11, HD02 = 8'h12, HD03 = 8'h13;
    localparam HD04 = 8'h14, HD05 = 8'h15, HD06 = 8'h16, HD07 = 8'h17;
    localparam PT00 = 8'h20, PT01 = 8'h21, PT02 = 8'h23, PT03 = 8'h24;

    assign eth_txrdy = (state == WAIT);
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
        if(rst) txd <= 8'h00;
        else if(state == IDLE) txd <= 8'h00;
        else if(state == WAIT) txd <= 8'h00;
        else if(state == HD00) txd <= 8'h55;
        else if(state == HD01) txd <= 8'h55;
        else if(state == HD02) txd <= 8'h55;
        else if(state == HD03) txd <= 8'h55;
        else if(state == HD04) txd <= 8'h55;
        else if(state == HD05) txd <= 8'h55;
        else if(state == HD06) txd <= 8'h55;
        else if(state == HD07) txd <= 8'hD5;
        else if(state == WORK) txd <= mac_txd;
        else if(state == PT00) txd <= crc[31:24];
        else if(state == PT01) txd <= crc[23:16];
        else if(state == PT02) txd <= crc[15:8];
        else if(state == PT03) txd <= crc[7:0];
        else txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_mac <= 1'b0;
        else if(state == IDLE) fs_mac <= 1'b0;
        else if(state == WAIT) fs_mac <= 1'b0;
        else if(state == HD05) fs_mac <= 1'b1;
        else if(state == DONE) fs_mac <= 1'b0;
        else fs_mac <= fs_mac;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) crc_en <= 1'b0;
        else if(state == HD06) crc_en <= 1'b1;
        else if(state == HD07) crc_en <= 1'b1;
        else if(state == WORK && (~fd_mac)) crc_en <= 1'b1;
        else crc_en <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txen <= 1'b0;
        else if(state == IDLE) txen <= 1'b0;
        else if(state == WAIT) txen <= 1'b0;
        else if(state == DONE) txen <= 1'b0;
        else if(state == HD00) txen <= 1'b1;
        else if(state == HD01) txen <= 1'b1;
        else if(state == HD02) txen <= 1'b1;
        else if(state == HD03) txen <= 1'b1;
        else if(state == HD04) txen <= 1'b1;
        else if(state == HD05) txen <= 1'b1;
        else if(state == HD06) txen <= 1'b1;
        else if(state == HD07) txen <= 1'b1;
        else if(state == WORK) txen <= 1'b1;
        else if(state == PT00) txen <= 1'b1;
        else if(state == PT01) txen <= 1'b1;
        else if(state == PT02) txen <= 1'b1;
        else if(state == PT03) txen <= 1'b1;
    end


endmodule