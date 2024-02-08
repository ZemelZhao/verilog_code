module com_test(
    input clk,
    input rst,

    input fs,
    output fd,

    output reg [14:0] ram_data_txa,
    output reg [7:0] ram_data_txd,
    output reg ram_data_txen
);

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02;
    localparam INFO = 8'h10, DINFO = 8'h11;
    localparam DAT0 = 8'h20, DDAT0 = 8'h21;
    localparam DAT1 = 8'h30, DDAT1 = 8'h31;
    localparam DAT2 = 8'h40, DDAT2 = 8'h41;
    localparam DAT3 = 8'h50, DDAT3 = 8'h51;
    localparam DAT4 = 8'h60, DDAT4 = 8'h61;
    localparam DAT5 = 8'h70, DDAT5 = 8'h71;

    localparam INFO_NUM = 12'h010, DATA_NUM = 12'h64;

    localparam RAM_DATA_RXA_INIT = 15'h0000, RAM_DATA_RXA_INFO = 15'h0100;
    localparam RAM_DATA_RXA_DAT0 = 15'h1000, RAM_DATA_RXA_DAT1 = 15'h2200;
    localparam RAM_DATA_RXA_DAT2 = 15'h3400, RAM_DATA_RXA_DAT3 = 15'h4600;
    localparam RAM_DATA_RXA_DAT4 = 15'h5800, RAM_DATA_RXA_DAT5 = 15'h6A00;

    reg [11:0] num;

    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= INFO;
                else next_state <= WAIT;
            end
            INFO: begin
                if(num >= INFO_NUM - 1'b1) next_state <= DINFO;
                else next_state <= INFO;
            end
            DINFO: next_state <= DAT0;
            DAT0: begin
                if(num >= DATA_NUM - 1'b1) next_state <= DDAT0;
                else next_state <= DAT0;
            end
            DDAT0: next_state <= DAT1;
            DAT1: begin
                if(num >= DATA_NUM - 1'b1) next_state <= DDAT1;
                else next_state <= DAT1;
            end
            DDAT1: next_state <= DAT2;
            DAT2: begin
                if(num >= DATA_NUM - 1'b1) next_state <= DDAT2;
                else next_state <= DAT2;
            end
            DDAT2: next_state <= DAT3;
            DAT3: begin
                if(num >= DATA_NUM - 1'b1) next_state <= DDAT3;
                else next_state <= DAT3;
            end
            DDAT3: next_state <= DAT4;
            DAT4: begin
                if(num >= DATA_NUM - 1'b1) next_state <= DDAT4;
                else next_state <= DAT4;
            end
            DDAT4: next_state <= DAT5;
            DAT5: begin
                if(num >= DATA_NUM - 1'b1) next_state <= DDAT5;
                else next_state <= DAT5;
            end
            DDAT5: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin // num
        if(rst) num <= 12'h000;
        else if(state == WAIT) num <= 12'h000;
        else if(state == DINFO) num <= 12'h000;
        else if(state == DDAT0) num <= 12'h000;
        else if(state == DDAT1) num <= 12'h000;
        else if(state == DDAT2) num <= 12'h000;
        else if(state == DDAT3) num <= 12'h000;
        else if(state == DDAT4) num <= 12'h000;
        else if(state == DDAT5) num <= 12'h000;
        else if(state == INFO) num <= num + 1'b1;
        else if(state == DAT0) num <= num + 1'b1;
        else if(state == DAT1) num <= num + 1'b1;
        else if(state == DAT2) num <= num + 1'b1;
        else if(state == DAT3) num <= num + 1'b1;
        else if(state == DAT4) num <= num + 1'b1;
        else if(state == DAT5) num <= num + 1'b1;
        else num <= 12'h000;
    end 

    always@(posedge clk or posedge rst) begin // ram_data_txa
        if(rst) ram_data_txa <= 15'h0000;
        else if(state == IDLE) ram_data_txa <= RAM_DATA_RXA_INIT;
        else if(state == INFO && num == 8'h00) ram_data_txa <= RAM_DATA_RXA_INFO;
        else if(state == DAT0 && num == 8'h00) ram_data_txa <= RAM_DATA_RXA_DAT0;
        else if(state == DAT1 && num == 8'h00) ram_data_txa <= RAM_DATA_RXA_DAT1;
        else if(state == DAT2 && num == 8'h00) ram_data_txa <= RAM_DATA_RXA_DAT2;
        else if(state == DAT3 && num == 8'h00) ram_data_txa <= RAM_DATA_RXA_DAT3;
        else if(state == DAT4 && num == 8'h00) ram_data_txa <= RAM_DATA_RXA_DAT4;
        else if(state == DAT5 && num == 8'h00) ram_data_txa <= RAM_DATA_RXA_DAT5;
        else if(state == INFO) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == DAT0) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == DAT1) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == DAT2) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == DAT3) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == DAT4) ram_data_txa <= ram_data_txa + 1'b1;
        else if(state == DAT5) ram_data_txa <= ram_data_txa + 1'b1;
        else ram_data_txa <= ram_data_txa;
    end 

    always@(posedge clk or posedge rst) begin // ram_data_txd
        if(rst) ram_data_txd <= 8'h00;
        else if(state == INFO && num == 8'h00) ram_data_txd <= 8'h66;
        else if(state == INFO && num == 8'h01) ram_data_txd <= 8'hBB;
        else if(state == INFO) ram_data_txd <= num + 8'h10;
        else if(state == DAT0 && num == 8'h00) ram_data_txd <= 8'h55;
        else if(state == DAT0 && num == 8'h01) ram_data_txd <= 8'hAA;
        else if(state == DAT0 && num == 8'h02) ram_data_txd <= 8'hFF;
        else if(state == DAT0 && num == 8'h03) ram_data_txd <= 8'h01;
        else if(state == DAT0) ram_data_txd <= num + 8'h20;
        else if(state == DAT1 && num == 8'h00) ram_data_txd <= 8'h55;
        else if(state == DAT1 && num == 8'h01) ram_data_txd <= 8'hAA;
        else if(state == DAT1 && num == 8'h02) ram_data_txd <= 8'hFF;
        else if(state == DAT1 && num == 8'h03) ram_data_txd <= 8'h02;
        else if(state == DAT1) ram_data_txd <= num + 8'h30;
        else if(state == DAT2 && num == 8'h00) ram_data_txd <= 8'h55;
        else if(state == DAT2 && num == 8'h01) ram_data_txd <= 8'hAA;
        else if(state == DAT2 && num == 8'h02) ram_data_txd <= 8'hFF;
        else if(state == DAT2 && num == 8'h03) ram_data_txd <= 8'h03;
        else if(state == DAT2) ram_data_txd <= num + 8'h40;
        else if(state == DAT3 && num == 8'h00) ram_data_txd <= 8'h55;
        else if(state == DAT3 && num == 8'h01) ram_data_txd <= 8'hAA;
        else if(state == DAT3 && num == 8'h02) ram_data_txd <= 8'hFF;
        else if(state == DAT3 && num == 8'h03) ram_data_txd <= 8'h04;
        else if(state == DAT3) ram_data_txd <= num + 8'h50;
        else if(state == DAT4 && num == 8'h00) ram_data_txd <= 8'h55;
        else if(state == DAT4 && num == 8'h01) ram_data_txd <= 8'hAA;
        else if(state == DAT4 && num == 8'h02) ram_data_txd <= 8'hFF;
        else if(state == DAT4 && num == 8'h03) ram_data_txd <= 8'h05;
        else if(state == DAT4) ram_data_txd <= num + 8'h60;
        else if(state == DAT5 && num == 8'h00) ram_data_txd <= 8'h55;
        else if(state == DAT5 && num == 8'h01) ram_data_txd <= 8'hAA;
        else if(state == DAT5 && num == 8'h02) ram_data_txd <= 8'hFF;
        else if(state == DAT5 && num == 8'h03) ram_data_txd <= 8'h06;
        else if(state == DAT5) ram_data_txd <= num + 8'h70;
        else ram_data_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_data_txen <= 1'b0;
        else if(state == INFO) ram_data_txen <= 1'b1;
        else if(state == DAT0) ram_data_txen <= 1'b1;
        else if(state == DAT1) ram_data_txen <= 1'b1;
        else if(state == DAT2) ram_data_txen <= 1'b1;
        else if(state == DAT3) ram_data_txen <= 1'b1;
        else if(state == DAT4) ram_data_txen <= 1'b1;
        else if(state == DAT5) ram_data_txen <= 1'b1;
        else ram_data_txen <= 1'b0;
    end



endmodule