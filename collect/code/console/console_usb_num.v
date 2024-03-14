module console_usb_num(
    input clk,
    input rst,

    input [0:15] dev_stat, 
    output reg [12:0] data_len,

    input fd_read,
    input [3:0] read_btype
);

    reg [4:0] state; 
    reg [4:0] next_state;
    localparam IDLE = 5'h01, WAIT = 5'h02, WORK = 5'h04, DONE = 5'h08;
    localparam MAKE = 5'h10;

    localparam BAG_DATA = 4'b0101;

    reg [11:0] num0, num1, num2, num3;
    reg [11:0] num4, num5, num6, num7;


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fd_read && read_btype == BAG_DATA) next_state <= MAKE;
                else next_state <= WAIT;
            end
            MAKE: next_state <= WORK;
            WORK: next_state <= DONE;
            DONE: begin
                if(~fd_read) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num0 <= 12'h000;
        else if(state == MAKE && dev_stat[0:1] == 2'b00) num0 <= 12'h000;
        else if(state == MAKE && dev_stat[0:1] == 2'b01) num0 <= 12'h080;
        else if(state == MAKE && dev_stat[0:1] == 2'b10) num0 <= 12'h100;
        else if(state == MAKE && dev_stat[0:1] == 2'b11) num0 <= 12'h200;
        else num0 <= num0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num1 <= 12'h000;
        else if(state == MAKE && dev_stat[2:3] == 2'b00) num1 <= 12'h000;
        else if(state == MAKE && dev_stat[2:3] == 2'b01) num1 <= 12'h080;
        else if(state == MAKE && dev_stat[2:3] == 2'b10) num1 <= 12'h100;
        else if(state == MAKE && dev_stat[2:3] == 2'b11) num1 <= 12'h200;
        else num1 <= num1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num2 <= 12'h000;
        else if(state == MAKE && dev_stat[4:5] == 2'b00) num2 <= 12'h000;
        else if(state == MAKE && dev_stat[4:5] == 2'b01) num2 <= 12'h080;
        else if(state == MAKE && dev_stat[4:5] == 2'b10) num2 <= 12'h100;
        else if(state == MAKE && dev_stat[4:5] == 2'b11) num2 <= 12'h200;
        else num2 <= num2;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num3 <= 12'h000;
        else if(state == MAKE && dev_stat[6:7] == 2'b00) num3 <= 12'h000;
        else if(state == MAKE && dev_stat[6:7] == 2'b01) num3 <= 12'h080;
        else if(state == MAKE && dev_stat[6:7] == 2'b10) num3 <= 12'h100;
        else if(state == MAKE && dev_stat[6:7] == 2'b11) num3 <= 12'h200;
        else num3 <= num3;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num4 <= 12'h000;
        else if(state == MAKE && dev_stat[8:9] == 2'b00) num4 <= 12'h000;
        else if(state == MAKE && dev_stat[8:9] == 2'b01) num4 <= 12'h080;
        else if(state == MAKE && dev_stat[8:9] == 2'b10) num4 <= 12'h100;
        else if(state == MAKE && dev_stat[8:9] == 2'b11) num4 <= 12'h200;
        else num4 <= num4;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num5 <= 12'h000;
        else if(state == MAKE && dev_stat[10:11] == 2'b00) num5 <= 12'h000;
        else if(state == MAKE && dev_stat[10:11] == 2'b01) num5 <= 12'h080;
        else if(state == MAKE && dev_stat[10:11] == 2'b10) num5 <= 12'h100;
        else if(state == MAKE && dev_stat[10:11] == 2'b11) num5 <= 12'h200;
        else num5 <= num5;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num6 <= 12'h000;
        else if(state == MAKE && dev_stat[12:13] == 2'b00) num6 <= 12'h000;
        else if(state == MAKE && dev_stat[12:13] == 2'b01) num6 <= 12'h080;
        else if(state == MAKE && dev_stat[12:13] == 2'b10) num6 <= 12'h100;
        else if(state == MAKE && dev_stat[12:13] == 2'b11) num6 <= 12'h200;
        else num6 <= num6;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num7 <= 12'h000;
        else if(state == MAKE && dev_stat[14:15] == 2'b00) num7 <= 12'h000;
        else if(state == MAKE && dev_stat[14:15] == 2'b01) num7 <= 12'h080;
        else if(state == MAKE && dev_stat[14:15] == 2'b10) num7 <= 12'h100;
        else if(state == MAKE && dev_stat[14:15] == 2'b11) num7 <= 12'h200;
        else num7 <= num7;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_len <= 13'h0000;
        else if(state == IDLE) data_len <= 13'h0000;
        else if(state == WORK) data_len <= num0 + num1 + num2 + num3 + num4 + num5 + num6 + num7;
        else data_len <= data_len;
    end








endmodule