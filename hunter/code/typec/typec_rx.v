module typec_rx(
    input clk,
    input rst,

    output fs,
    input fd,

    input [7:0] com_rxd,
    output reg [3:0] btype,
    output reg [3:0] bdata
);


    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    localparam PID_SYNC = 8'h01;
    localparam PID_ACK = 8'h2D, PID_NAK = 8'hA5, PID_STALL = 8'hE1;
    localparam PID_CMD = 8'h1E, PID_STAT = 8'hD2; 
    localparam PID_DATA0 = 8'h96, PID_DATA1 = 8'h5A;    

    localparam HEAD_DDIDX = 4'h1, HEAD_DPARAM = 4'h5, HEAD_DIDX = 4'h9;

    (*MARK_DEBUG = "true"*)reg [3:0] state; 
    reg [3:0] next_state;
    wire crcen;
    wire [7:0] crc_in, crc_out;

    assign crc_in = com_rxd; // 

    localparam IDLE = 4'h0, WAIT = 4'h1, DONE = 4'h2;
    localparam RPID = 4'h4, RACK = 4'h5, RNAK = 4'h6, RSTALL = 4'h7;
    localparam NUM0 = 4'h8, NUM1 = 4'h9, RCMD = 4'hA;
    localparam CRC5 = 4'hC;

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
                else if(com_rxd == PID_CMD) next_state <= NUM0;
                else next_state <= DONE;
            end
            RACK: next_state <= DONE;
            RNAK: next_state <= DONE;
            RSTALL: next_state <= DONE;
            NUM0: next_state <= NUM1;
            NUM1: next_state <= RCMD;
            RCMD: next_state <= CRC5;
            CRC5: next_state <= DONE;
            DONE: begin
                if(fd) next_state <= WAIT; 
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin // btype
        if(rst) btype <= BAG_INIT; 
        else if(state == IDLE) btype <= BAG_INIT;
        else if(state == RACK) btype <= BAG_ACK;
        else if(state == RNAK) btype <= BAG_NAK;
        else if(state == RSTALL) btype <= BAG_STALL;
        else if(state == RCMD && com_rxd[7:4] == HEAD_DIDX) btype <= BAG_DIDX;
        else if(state == RCMD && com_rxd[7:4] == HEAD_DDIDX) btype <= BAG_DDIDX;
        else if(state == RCMD && com_rxd[7:4] == HEAD_DPARAM) btype <= BAG_DPARAM;
        else btype <= btype;
    end

    always@(posedge clk or posedge rst) begin // bdata
        if(rst) bdata <= 4'h0;
        else if(state == IDLE) bdata <= 4'h0;
        else if(state == RCMD) bdata <= com_rxd[3:0];
        else bdata <= bdata;
    end

    crc5
    crc5_dut(
        .clk(clk),
        .enable(crcen),
        .din(crc_in),
        .dout(crc_out)
    );

endmodule

