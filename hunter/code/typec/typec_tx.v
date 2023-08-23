module typec_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    input [11:0] ram_addr_init,
    input [11:0] data_len,

    input [3:0] btype,

    input [3:0] didx,
    input [7:0] type,
    input [7:0] temp,
    input [7:0] head,

    input [7:0] ram_rxd,
    output reg [11:0] ram_rxa,
    output reg [7:0] com_txd
);

    localparam RAM_LATANECY = 4'h2;

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
    localparam DATA_DLINK = 12'h123;

    reg [7:0] state, next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, SYNC = 8'h02, DONE = 8'h03;
    localparam WPID = 8'h10, DLEN0 = 8'h11, DLEN1 = 8'h12;
    localparam STAT0 = 8'h20, STAT1 = 8'h21;
    localparam HEAD0 = 8'h30, HEAD1 = 8'h31, DATA = 8'h32;
    localparam CRC5 = 8'h40, CRC160 = 8'h41, CRC161 = 8'h42;

    reg [7:0] pid;
    reg [11:0] num;

    wire [11:0] dLen;

    wire [7:0] crc5_out;
    wire [15:0] crc16_out;
    wire [7:0] crc_in;
    wire crcen;

    assign fd = (state == DONE);
    assign dLen = data_len + 2'h2;

    assign crcen = (state == DATA) || (state == STAT0) || (state == STAT1) || (state == HEAD0) || (state == HEAD1);
    assign crc_in = com_txd; // 

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= SYNC;
                else next_state <= WAIT;
            end
            SYNC: next_state <= WPID;
            WPID: begin
                if(btype == BAG_ACK) next_state <= DONE;
                else if(btype == BAG_NAK) next_state <= DONE;
                else if(btype == BAG_STALL) next_state <= DONE;
                else next_state <= DLEN0;
            end
            DLEN0: next_state <= DLEN1;
            DLEN1: begin
                if(btype == BAG_DLINK) next_state <= STAT0;
                else if(btype == BAG_DTYPE) next_state <= STAT0;
                else if(btype == BAG_DTEMP) next_state <= STAT0;
                else next_state <= HEAD0;
            end
            STAT0: next_state <= STAT1;
            STAT1: next_state <= CRC5;
            HEAD0: next_state <= HEAD1;
            HEAD1: next_state <= DATA;
            DATA: begin
                if(num >= data_len - 1'b1) next_state <= CRC160;
                else next_state <= DATA;
            end

            CRC5: next_state <= DONE;
            CRC160: next_state <= CRC161;
            CRC161: next_state <= DONE;

            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin // com_txd
        if(rst) com_txd <= 8'h00;
        else if(state == SYNC) com_txd <= PID_SYNC;
        else if(state == WPID) com_txd <= pid;
        else if(state == DLEN0 && btype == BAG_DLINK) com_txd <= 8'h00;
        else if(state == DLEN0 && btype == BAG_DTYPE) com_txd <= 8'h00;
        else if(state == DLEN0 && btype == BAG_DTEMP) com_txd <= 8'h00;
        else if(state == DLEN0 && btype == BAG_DATA0) com_txd <= {4'h0, dLen[11:8]};
        else if(state == DLEN0 && btype == BAG_DATA1) com_txd <= {4'h0, dLen[11:8]};
        else if(state == DLEN1 && btype == BAG_DLINK) com_txd <= 8'h02;
        else if(state == DLEN1 && btype == BAG_DTYPE) com_txd <= 8'h02;
        else if(state == DLEN1 && btype == BAG_DTEMP) com_txd <= 8'h02;
        else if(state == DLEN1 && btype == BAG_DATA0) com_txd <= {dLen[7:0]};
        else if(state == DLEN1 && btype == BAG_DATA1) com_txd <= {dLen[7:0]};        
        else if(state == STAT0 && btype == BAG_DLINK) com_txd <= {HEAD_DLINK, DATA_DLINK[11:8]};
        else if(state == STAT0 && btype == BAG_DTYPE) com_txd <= {HEAD_DTYPE, didx};
        else if(state == STAT0 && btype == BAG_DTEMP) com_txd <= {HEAD_DTEMP, didx};
        else if(state == STAT1 && btype == BAG_DLINK) com_txd <= DATA_DLINK[7:0];
        else if(state == STAT1 && btype == BAG_DTYPE) com_txd <= type;
        else if(state == STAT1 && btype == BAG_DTEMP) com_txd <= temp;
        else if(state == HEAD0) com_txd <= {HEAD_DHEAD, didx};
        else if(state == HEAD1) com_txd <= head;
        else if(state == DATA) com_txd <= ram_rxd;
        else if(state == CRC5) com_txd <= crc5_out;
        else if(state == CRC160) com_txd <= crc16_out[15:8];
        else if(state == CRC161) com_txd <= crc16_out[7:0];
        else com_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin // pid
        if(rst) pid <= 8'h00;
        else if(state == IDLE) pid <= 8'h00;
        else if(state == WAIT) pid <= 8'h00;
        else if(state == SYNC && btype == BAG_ACK) pid <= PID_ACK;
        else if(state == SYNC && btype == BAG_NAK) pid <= PID_NAK;
        else if(state == SYNC && btype == BAG_STALL) pid <= PID_STALL;
        else if(state == SYNC && btype == BAG_DLINK) pid <= PID_STAT;
        else if(state == SYNC && btype == BAG_DTYPE) pid <= PID_STAT;
        else if(state == SYNC && btype == BAG_DTEMP) pid <= PID_STAT;
        else if(state == SYNC && btype == BAG_DATA0) pid <= PID_DATA0;
        else if(state == SYNC && btype == BAG_DATA1) pid <= PID_DATA1;
        else pid <= pid;
    end

    always@(posedge clk or posedge rst) begin // ram_rxa

        if(rst) ram_rxa <= ram_addr_init;
        else if(state == IDLE) ram_rxa <= ram_addr_init;
        else if(state == WAIT) ram_rxa <= ram_addr_init;
        else if(state == SYNC) ram_rxa <= ram_addr_init; 
        else if(state == DLEN0 && RAM_LATANECY >= 4'h4) ram_rxa <= ram_rxa + 1'b1;
        else if(state == DLEN1 && RAM_LATANECY >= 4'h3) ram_rxa <= ram_rxa + 1'b1;
        else if(state == HEAD0 && RAM_LATANECY >= 4'h2) ram_rxa <= ram_rxa + 1'b1;
        else if(state == HEAD1 && RAM_LATANECY >= 4'h1) ram_rxa <= ram_rxa + 1'b1;
        else if(state == DATA) ram_rxa <= ram_rxa + 1'b1;
        else ram_rxa <= ram_rxa;
    end

    always@(posedge clk or posedge rst) begin // num
        if(rst) num <= 12'h0000;
        else if(state == DATA) num <= num + 1'b1;
        else num <= 12'h000;
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