module typecm_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    input [3:0] btype,
    input [3:0] didx,
    input [3:0] freq,
    input [3:0] ddidx,

    output reg [7:0] com_txd
);

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'h1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    localparam PID_SYNC = 8'h01;
    localparam PID_ACK = 8'h2D, PID_NAK = 8'hA5, PID_STALL = 8'hE1;
    localparam PID_CMD = 8'h1E, PID_STAT = 8'hD2; 
    localparam PID_DATA0 = 8'h96, PID_DATA1 = 8'h5A;

    localparam HEAD_DDIDX = 4'h1, HEAD_DPARAM = 4'h5, HEAD_DIDX = 4'h9;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 4'h01, DONE = 4'h02;
    localparam SYNC = 8'h10, WPID = 8'h11, WCMD = 8'h12, CRC5 = 8'h13;
    localparam DLEN0 = 8'h14, DLEN1 = 8'h15;

    reg [7:0] pid;

    wire [7:0] crc_in;
    wire [7:0] crc5_out;
    wire crcen;

    assign fd = (state == DONE);
    assign crcen = (state == WCMD);
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
            DLEN1: next_state <= WCMD;
            WCMD: next_state <= CRC5;
            CRC5: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT; 
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_txd <= 8'h00;
        else if(state == SYNC) com_txd <= PID_SYNC;
        else if(state == WPID) com_txd <= pid;
        else if(state == DLEN0) com_txd <= 8'h00;
        else if(state == DLEN1) com_txd <= 8'h01;
        else if(state == WCMD && btype == BAG_DIDX) com_txd <= {HEAD_DIDX, didx};
        else if(state == WCMD && btype == BAG_DPARAM) com_txd <= {HEAD_DPARAM, freq};
        else if(state == WCMD && btype == BAG_DDIDX) com_txd <= {HEAD_DDIDX, ddidx};
        else if(state == CRC5) com_txd <= crc5_out;
        else com_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pid <= 8'h00;
        else if(state == IDLE) pid <= 8'h00;
        else if(state == WAIT) pid <= 8'h00;
        else if(state == SYNC && btype == BAG_ACK) pid <= PID_ACK;
        else if(state == SYNC && btype == BAG_NAK) pid <= PID_NAK;
        else if(state == SYNC && btype == BAG_STALL) pid <= PID_STALL;
        else if(state == SYNC && btype == BAG_DIDX) pid <= PID_CMD;
        else if(state == SYNC && btype == BAG_DPARAM) pid <= PID_CMD;
        else if(state == SYNC && btype == BAG_DDIDX) pid <= PID_CMD;
        else pid <= pid;
    end

    crc5
    crc5_dut(
        .clk(clk),
        .enable(crcen),
        .din(crc_in),
        .dout(crc5_out)
    );


endmodule