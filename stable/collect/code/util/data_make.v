module data_make(
    input clk,
    input rst,

    input fs,
    output fd,

    input [3:0] btype,

    input [0:79] usb_stat,
    input [31:0] trgg_rxd,

    output reg [14:0] ram_data_txa,
    (*MARK_DEBUG = "true"*)output reg [7:0] ram_data_txd,
    output reg ram_data_txen,

    input [3:0] data_idx,

    output reg [11:0] ram_rxa,
    input [0:63] ram_rxd
); 

    (*MARK_DEBUG = "true"*)reg [7:0] test0, test1, test2, test3;
    (*MARK_DEBUG = "true"*)reg [7:0] test4, test5, test6, test7;
    (*MARK_DEBUG = "true"*)wire same4, same5, same6, same7;

    assign same4 = (test0 == test4);
    assign same5 = (test0 == test5);
    assign same6 = (test0 == test6);
    assign same7 = (test0 == test7);


    localparam DATA_LATENCY = 4'h2;
    localparam DEVICE_NUM = 4'h8;

    localparam RAM_DATA_TXA_INIT = 15'h0000, RAM_DATA_TXA_INFO = 15'h0100;
    localparam RAM_DATA_TXA_DAT0 = 15'h1000, RAM_DATA_TXA_DAT1 = 15'h2200;
    localparam RAM_DATA_TXA_DAT2 = 15'h3400, RAM_DATA_TXA_DAT3 = 15'h4600;
    localparam RAM_DATA_TXA_DAT4 = 15'h5800, RAM_DATA_TXA_DAT5 = 15'h6A00;

    localparam RAM_RXA_DAT0 = 12'h000, RAM_RXA_DAT1 = 12'h240;
    localparam RAM_RXA_DAT2 = 12'h480, RAM_RXA_DAT3 = 12'h6C0;
    localparam RAM_RXA_DAT4 = 12'h900, RAM_RXA_DAT5 = 12'hB40;
    localparam RAM_RXA_INIT = 12'hF00;

    localparam BTYPE_INIT = 4'h0, BTYPE_INFO = 4'h1, BTYPE_DATA = 4'hE;
    
    localparam SLEN = 8'h0E, HLEN = 8'h04, TLEN = 12'h04;
    localparam DLEN_00 = 12'h000, DLEN_01 = 12'h080, DLEN_10 = 12'h100, DLEN_11 = 12'h200; 

    localparam DATA_IDX = 4'h5;

    reg [19:0] state, next_state;
    localparam MAIN_IDLE = 20'h00001, MAIN_WAIT = 20'h00002, MAIN_WORK = 20'h00004, MAIN_DONE = 20'h00008;
    localparam STAT_IDLE = 20'h00010, STAT_WAIT = 20'h00020, STAT_WORK = 20'h00040, STAT_DONE = 20'h00080;
    localparam DATA_IDLE = 20'h00100, DATA_WAIT = 20'h00200, DATA_WORK = 20'h00400, DATA_DONE = 20'h00800;
    localparam DATA_HEAD = 20'h01000, DATA_REST = 20'h02000, DATA_DOOR = 20'h04000, DATA_CRIT = 20'h08000;
    localparam DATA_MAKE = 20'h10000, DATA_LAST = 20'h20000, DATA_TRGG = 20'h40000;

    reg [11:0] dlen;
    reg [11:0] num;
    reg [3:0] dev;

    wire [1:0] dev_stat[0:7];
    wire [7:0] dev_temp[0:7];
    wire [0:7] com_stat;

    assign dev_stat[0] = usb_stat[0:1];
    assign dev_stat[1] = usb_stat[10:11];
    assign dev_stat[2] = usb_stat[20:21];
    assign dev_stat[3] = usb_stat[30:31];
    assign dev_stat[4] = usb_stat[40:41];
    assign dev_stat[5] = usb_stat[50:51];
    assign dev_stat[6] = usb_stat[60:61];
    assign dev_stat[7] = usb_stat[70:71];

    assign dev_temp[0] = usb_stat[2:9];
    assign dev_temp[1] = usb_stat[12:19];
    assign dev_temp[2] = usb_stat[22:29];
    assign dev_temp[3] = usb_stat[32:39];
    assign dev_temp[4] = usb_stat[42:49];
    assign dev_temp[5] = usb_stat[52:59];
    assign dev_temp[6] = usb_stat[62:69];
    assign dev_temp[7] = usb_stat[72:79];

    assign com_stat[0] = ~(dev_stat[0] == 2'b00);
    assign com_stat[1] = ~(dev_stat[1] == 2'b00);
    assign com_stat[2] = ~(dev_stat[2] == 2'b00);
    assign com_stat[3] = ~(dev_stat[3] == 2'b00);
    assign com_stat[4] = ~(dev_stat[4] == 2'b00);
    assign com_stat[5] = ~(dev_stat[5] == 2'b00);
    assign com_stat[6] = ~(dev_stat[6] == 2'b00);
    assign com_stat[7] = ~(dev_stat[7] == 2'b00);
    
    assign fd = (state == MAIN_DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs) next_state <= MAIN_WORK;
                else next_state <= MAIN_WAIT;
            end
            MAIN_WORK: begin
                if(btype == BTYPE_INFO) next_state <= STAT_IDLE;
                else if(btype == BTYPE_DATA) next_state <= DATA_IDLE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_DONE: begin
                if(~fs) next_state <= MAIN_WAIT;
                else next_state <= MAIN_DONE;
            end

            STAT_IDLE: next_state <= STAT_WAIT;
            STAT_WAIT: next_state <= STAT_WORK;
            STAT_WORK: begin
                if(num >= SLEN - 1'b1) next_state <= STAT_DONE;
                else next_state <= STAT_WORK;
            end
            STAT_DONE: next_state <= MAIN_DONE;

            DATA_IDLE: next_state <= DATA_WAIT;
            DATA_WAIT: next_state <= DATA_HEAD;
            DATA_HEAD: begin
                if(num >= HLEN - 1'b1) next_state <= DATA_REST;
                else next_state <= DATA_HEAD;
            end
            DATA_MAKE: next_state <= DATA_LAST;
            DATA_LAST: begin
                if(num >= DATA_LATENCY - 1'b1) next_state <= DATA_WORK;
                else next_state <= DATA_LAST;
            end
            DATA_WORK: begin
                if(num >= dlen - 1'b1) next_state <= DATA_DOOR;
                else next_state <= DATA_WORK;
            end

            DATA_REST: next_state <= DATA_CRIT;
            DATA_DOOR: next_state <= DATA_CRIT;
            DATA_CRIT: begin
                if(dev >= DEVICE_NUM - 1'b1) next_state <= DATA_TRGG;
                else if(dev_stat[dev] != 2'b00) next_state <= DATA_MAKE;
                else next_state <= DATA_DOOR;
            end
            DATA_TRGG: begin
                if(num >= TLEN - 1'b1) next_state <= DATA_DONE;
                else next_state <= DATA_TRGG;
            end
            DATA_DONE: next_state <= MAIN_DONE;

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 12'h000;
        else if(state == MAIN_IDLE) num <= 12'h000;
        else if(state != next_state) num <= 12'h000;
        else if(state == STAT_WORK) num <= num + 1'b1;
        else if(state == DATA_HEAD) num <= num + 1'b1;
        else if(state == DATA_LAST) num <= num + 1'b1;
        else if(state == DATA_WORK) num <= num + 1'b1;
        else if(state == DATA_TRGG) num <= num + 1'b1;
        else num <= 12'h000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dev <= 4'h0;
        else if(state == MAIN_WAIT) dev <= 4'h0;
        else if(state == DATA_DONE) dev <= 4'h0;
        else if(state == DATA_DOOR) dev <= dev + 1'b1;
        else dev <= dev;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= DLEN_00;
        else if(state == DATA_MAKE && dev_stat[dev] == 2'b00) dlen <= DLEN_00;
        else if(state == DATA_MAKE && dev_stat[dev] == 2'b01) dlen <= DLEN_01;
        else if(state == DATA_MAKE && dev_stat[dev] == 2'b10) dlen <= DLEN_10;
        else if(state == DATA_MAKE && dev_stat[dev] == 2'b11) dlen <= DLEN_11;
        else if(state == DATA_MAKE) dlen <= 2'b00;
        else dlen <= dlen;
    end 

    always@(posedge clk or posedge rst) begin
        if(rst) ram_data_txa <= RAM_DATA_TXA_INIT;
        else if(state == STAT_WAIT) ram_data_txa <= RAM_DATA_TXA_INFO - 1'b1;
        else if(state == DATA_WAIT && data_idx == 4'h0) ram_data_txa <= RAM_DATA_TXA_DAT0 - 1'b1;
        else if(state == DATA_WAIT && data_idx == 4'h1) ram_data_txa <= RAM_DATA_TXA_DAT1 - 1'b1;
        else if(state == DATA_WAIT && data_idx == 4'h2) ram_data_txa <= RAM_DATA_TXA_DAT2 - 1'b1;
        else if(state == DATA_WAIT && data_idx == 4'h3) ram_data_txa <= RAM_DATA_TXA_DAT3 - 1'b1;
        else if(state == DATA_WAIT && data_idx == 4'h4) ram_data_txa <= RAM_DATA_TXA_DAT4 - 1'b1;
        else if(state == DATA_WAIT && data_idx == 4'h5) ram_data_txa <= RAM_DATA_TXA_DAT5 - 1'b1;
        else if(state == STAT_WORK) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == DATA_HEAD) ram_data_txa <= ram_data_txa + 1'b1; 
        else if(state == DATA_WORK) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == DATA_TRGG) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == MAIN_WAIT) ram_data_txa <= RAM_DATA_TXA_INIT;
        else if(state == MAIN_DONE) ram_data_txa <= RAM_DATA_TXA_INIT;
        else ram_data_txa <= ram_data_txa;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_rxa <= RAM_RXA_INIT;
        else if(state == DATA_MAKE && data_idx == 4'h0) ram_rxa <= RAM_RXA_DAT0;
        else if(state == DATA_MAKE && data_idx == 4'h1) ram_rxa <= RAM_RXA_DAT1;
        else if(state == DATA_MAKE && data_idx == 4'h2) ram_rxa <= RAM_RXA_DAT2;
        else if(state == DATA_MAKE && data_idx == 4'h3) ram_rxa <= RAM_RXA_DAT3;
        else if(state == DATA_MAKE && data_idx == 4'h4) ram_rxa <= RAM_RXA_DAT4;
        else if(state == DATA_MAKE && data_idx == 4'h5) ram_rxa <= RAM_RXA_DAT5;
        else if(state == DATA_LAST) ram_rxa <= ram_rxa + 1'b1;
        else if(state == DATA_WORK) ram_rxa <= ram_rxa + 1'b1;
        else if(state == DATA_DONE) ram_rxa <= RAM_RXA_INIT;
        else if(state == MAIN_WAIT) ram_rxa <= RAM_RXA_INIT;
        else ram_rxa <= ram_rxa;
    end 

    always@(posedge clk or posedge rst) begin
        if(rst) ram_data_txd <= 8'h00;
        else if(state == STAT_WORK && num == 8'h00) ram_data_txd <= 8'h66;
        else if(state == STAT_WORK && num == 8'h01) ram_data_txd <= 8'hBB;
        else if(state == STAT_WORK && num == 8'h02) ram_data_txd <= 8'h00;
        else if(state == STAT_WORK && num == 8'h03) ram_data_txd <= 8'h1E;
        else if(state == STAT_WORK && num == 8'h04) ram_data_txd <= {dev_stat[0], dev_stat[1], dev_stat[2], dev_stat[3]};  
        else if(state == STAT_WORK && num == 8'h05) ram_data_txd <= {dev_stat[4], dev_stat[5], dev_stat[6], dev_stat[7]};  
        else if(state == STAT_WORK && num == 8'h06) ram_data_txd <= dev_temp[0];
        else if(state == STAT_WORK && num == 8'h07) ram_data_txd <= dev_temp[1];
        else if(state == STAT_WORK && num == 8'h08) ram_data_txd <= dev_temp[2];
        else if(state == STAT_WORK && num == 8'h09) ram_data_txd <= dev_temp[3];
        else if(state == STAT_WORK && num == 8'h0A) ram_data_txd <= dev_temp[4];
        else if(state == STAT_WORK && num == 8'h0B) ram_data_txd <= dev_temp[5];
        else if(state == STAT_WORK && num == 8'h0C) ram_data_txd <= dev_temp[6];
        else if(state == STAT_WORK && num == 8'h0D) ram_data_txd <= dev_temp[7];
        else if(state == DATA_WORK && dev == 4'h0) ram_data_txd <= ram_rxd[0:7];
        else if(state == DATA_WORK && dev == 4'h1) ram_data_txd <= ram_rxd[8:15];
        else if(state == DATA_WORK && dev == 4'h2) ram_data_txd <= ram_rxd[16:23];
        else if(state == DATA_WORK && dev == 4'h3) ram_data_txd <= ram_rxd[24:31];
        else if(state == DATA_WORK && dev == 4'h4) ram_data_txd <= ram_rxd[32:39];
        else if(state == DATA_WORK && dev == 4'h5) ram_data_txd <= ram_rxd[40:47];
        else if(state == DATA_WORK && dev == 4'h6) ram_data_txd <= ram_rxd[48:55];
        else if(state == DATA_WORK && dev == 4'h7) ram_data_txd <= ram_rxd[56:63];
        else if(state == DATA_HEAD && num == 8'h00) ram_data_txd <= 8'h55;
        else if(state == DATA_HEAD && num == 8'h01) ram_data_txd <= 8'hAA;
        else if(state == DATA_HEAD && num == 8'h02) ram_data_txd <= com_stat;
        else if(state == DATA_HEAD && num == 8'h03) ram_data_txd <= data_idx;
        else if(state == DATA_TRGG && num == 8'h00) ram_data_txd <= trgg_rxd[31:24];
        else if(state == DATA_TRGG && num == 8'h01) ram_data_txd <= trgg_rxd[23:16];
        else if(state == DATA_TRGG && num == 8'h02) ram_data_txd <= trgg_rxd[15:8];
        else if(state == DATA_TRGG && num == 8'h03) ram_data_txd <= {trgg_rxd[7:4], same4, same5, same6, same7}; // 
        else if(state == DATA_WORK) ram_data_txd <= 8'h00;
        else if(state == MAIN_WAIT) ram_data_txd <= 8'h00;
        else if(state == DATA_DONE) ram_data_txd <= 8'h00;
        else ram_data_txd <= ram_data_txd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_data_txen <= 1'b0;
        else if(state == DATA_HEAD) ram_data_txen <= 1'b1;
        else if(state == DATA_WORK) ram_data_txen <= 1'b1;
        else if(state == DATA_TRGG) ram_data_txen <= 1'b1;
        else if(state == STAT_WORK) ram_data_txen <= 1'b1;
        else ram_data_txen <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) test0 <= 8'h00;
        else if(state == MAIN_IDLE) test0 <= 8'h00;
        else if(state == DATA_WORK && dev == 4'h0 && num == 12'h001) test0 <= ram_data_txd;
        else test0 <= test0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) test1 <= 8'h00;
        else if(state == MAIN_IDLE) test1 <= 8'h00;
        else if(state == DATA_WORK && dev == 4'h0 && num == 12'h001) test1 <= test0;
        else test1 <= test1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) test2 <= 8'h00;
        else if(state == MAIN_IDLE) test2 <= 8'h00;
        else if(state == DATA_WORK && dev == 4'h0 && num == 12'h001) test2 <= test1;
        else test2 <= test2;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) test3 <= 8'h00;
        else if(state == MAIN_IDLE) test3 <= 8'h00;
        else if(state == DATA_WORK && dev == 4'h0 && num == 12'h001) test3 <= test2;
        else test3 <= test3;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) test4 <= 8'h00;
        else if(state == MAIN_IDLE) test4 <= 8'h00;
        else if(state == DATA_WORK && dev == 4'h0 && num == 12'h001) test4 <= test3;
        else test4 <= test4;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) test5 <= 8'h00;
        else if(state == MAIN_IDLE) test5 <= 8'h00;
        else if(state == DATA_WORK && dev == 4'h0 && num == 12'h001) test5 <= test4;
        else test5 <= test5;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) test6 <= 8'h00;
        else if(state == MAIN_IDLE) test6 <= 8'h00;
        else if(state == DATA_WORK && dev == 4'h0 && num == 12'h001) test6 <= test5;
        else test6 <= test6;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) test7 <= 8'h00;
        else if(state == MAIN_IDLE) test7 <= 8'h00;
        else if(state == DATA_WORK && dev == 4'h0 && num == 12'h001) test7 <= test6;
        else test7 <= test7;
    end

endmodule