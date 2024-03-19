module typecm_rx(
    input clk,
    input rst,

    output fs,
    input fd,

    input [7:0] com_rxd,
    output reg [3:0] btype,
    output reg [7:0] bdata,
    output reg [3:0] didx,

    output reg [7:0] ram_txd
);

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    localparam PID_SYNC = 8'h0F;
    localparam PID_ACK = 8'h2D, PID_NAK = 8'hA5, PID_STALL = 8'hE1;
    localparam PID_CMD = 8'h1E, PID_STAT = 8'hD2; 
    localparam PID_DATA0 = 8'h96, PID_DATA1 = 8'h5A;

    localparam HEAD_DLINK = 4'hD;
    localparam HEAD_DTYPE = 4'h1, HEAD_DTEMP = 4'h9, HEAD_DHEAD = 4'h3;
    localparam DATA_DLINK = 12'h101;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, DATA = 8'h02, DONE = 8'h03;
    localparam RPID = 8'h10, RACK = 8'h11, RNAK = 8'h12, RSTALL = 8'h13; 
    localparam SNUM0 = 8'h20, SNUM1 = 8'h21, STAT0 = 8'h22, STAT1 = 8'h23;
    localparam DNUM0 = 8'h30, DNUM1 = 8'h31, HEAD0 = 8'h32, HEAD1 = 8'h33;
    localparam CRC5 = 8'h40, CRC160 = 8'h41, CRC161 = 8'h42;

    reg [11:0] num;
    reg [11:0] data_len;
    wire [7:0] crc_in;
    wire [7:0] crc5_out;
    wire [15:0] crc16_out;

    assign fs = (state == DONE);


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(com_rxd == PID_SYNC) next_state <= RPID;
                else next_state <= WAIT;
            end
            RPID: begin
                if(com_rxd == PID_ACK) next_state <= RACK;
                else if(com_rxd == PID_NAK) next_state <= RNAK;
                else if(com_rxd == PID_STALL) next_state <= RSTALL;
                else if(com_rxd == PID_STAT) next_state <= SNUM0;
                else if(com_rxd == PID_DATA0) next_state <= DNUM0;
                else if(com_rxd == PID_DATA1) next_state <= DNUM0;
                else next_state <= DONE;
            end

            RACK: next_state <= DONE;
            RNAK: next_state <= DONE;
            RSTALL: next_state <= DONE;

            SNUM0: next_state <= SNUM1;
            SNUM1: next_state <= STAT0;
            STAT0: next_state <= STAT1;
            STAT1: next_state <= CRC5;

            DNUM0: next_state <= DNUM1;
            DNUM1: next_state <= HEAD0;
            HEAD0: next_state <= HEAD1;
            HEAD1: next_state <= DATA;
            DATA: begin
                if(num >= data_len - 2'h3) next_state <= CRC160;
                else next_state <= DATA;
            end

            CRC5: next_state <= DONE;
            CRC160: next_state <= CRC161;
            CRC161: next_state <= DONE;

            DONE: begin
                if(fd) next_state <= WAIT;
                else next_state <= DONE;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin // btype
        if(rst) btype <= BAG_INIT;
        else if(state == RACK) btype <= BAG_ACK;
        else if(state == RNAK) btype <= BAG_NAK;
        else if(state == RSTALL) btype <= BAG_STALL;
        else if(state == STAT0 && com_rxd[7:4] == HEAD_DLINK) btype <= BAG_DLINK; 
        else if(state == STAT0 && com_rxd[7:4] == HEAD_DTYPE) btype <= BAG_DTYPE; 
        else if(state == STAT0 && com_rxd[7:4] == HEAD_DTEMP) btype <= BAG_DTEMP; 
        else if(state == RPID && com_rxd == PID_DATA0) btype <= BAG_DATA0;
        else if(state == RPID && com_rxd == PID_DATA1) btype <= BAG_DATA1;
        else btype <= btype;
    end

    always@(posedge clk or posedge rst) begin // didx
        if(rst) didx <= 4'h0;
        else if(state == IDLE) didx <= 4'h0;
        else if(state == STAT0) didx <= com_rxd[3:0];
        else if(state == HEAD0) didx <= com_rxd[3:0];
        else didx <= didx;
    end

    always@(posedge clk or posedge rst) begin // bdata
        if(rst) bdata <= 8'h00;
        else if(state == IDLE) bdata <= 4'h0;
        else if(state == STAT1) bdata <= com_rxd;
        else if(state == HEAD1) bdata <= com_rxd;
        else bdata <= bdata;
    end

    always@(posedge clk or posedge rst) begin // data_len
        if(rst) data_len <= 12'h000;
        else if(state == IDLE) data_len <= 12'h000;
        else if(state == WAIT) data_len <= 12'h000;
        else if(state == DNUM0) data_len[11:8] <= com_rxd[3:0];
        else if(state == DNUM1) data_len[7:0] <= com_rxd;
        else data_len <= data_len;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 12'h000;
        else if(state == IDLE) num <= 12'h000;
        else if(state == WAIT) num <= 12'h000;
        else if(state == DATA) num <= num + 1'b1;
        else num <= 12'h000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txd <= 8'h00;
        else if(state == DATA) ram_txd <= com_rxd;
        else ram_txd <= 8'h00;
    end

    crc5
    crc5_dut(
        .clk(clk),
        .enable(crcen),
        .din(crc_in),
        .dout(crc5_out)
    );

    crc16
    crc16_dut(
        .clk(clk),
        .enable(crcen),
        .din(crc_in),
        .dout(crc16_out)
    );

endmodule