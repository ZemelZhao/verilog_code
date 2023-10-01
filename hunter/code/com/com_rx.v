module com_rx(
    input clk,
    input rst,

    output fs,
    input fd,

    input [7:0] com_rxd,

    output reg [3:0] btype,
    output reg [3:0] ram_tlen,

    output reg [7:0] ram_txa,
    output reg [7:0] ram_txd,
    output reg ram_txen
);

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_ERROR = 4'b1111;

    localparam PID_SYNC = 8'h01, PID_CMD = 8'h1E; 
    localparam PID_ACK = 8'h2D, PID_NAK = 8'hA5, PID_STL = 8'hE1;

    localparam RAM_DEVICE_IDX_ADDR = 8'h10, RAM_DATA_IDX_ADDR = 8'h20, RAM_DPARAM_ADDR = 8'h80;
    localparam RAM_ADDR_INIT = 8'h00;

    localparam HEAD_DDIDX = 4'h1, HEAD_DPARAM = 4'h5, HEAD_DIDX = 4'h9;

    localparam NLEN = 16'h0002;

    reg [7:0] state, next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam RPID = 8'h04, DNUM = 8'h05, CRC5 = 8'h06;
    localparam EROR = 8'h10;

    reg [15:0] num;

    wire cen;
    wire [7:0] cin, cout;

    assign fs = (state == DONE);
    assign cen = (state == WORK) || ((state == DNUM) && (num >= NLEN - 1'b1));
    assign cin = com_rxd;

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
                if(com_rxd == PID_CMD) next_state <= DNUM;
                else if(com_rxd == PID_ACK) next_state <= DONE;
                else if(com_rxd == PID_NAK) next_state <= DONE;
                else if(com_rxd == PID_STL) next_state <= DONE;
                else next_state <= EROR;
            end
            DNUM: begin
                if(num >= NLEN - 1'b1) next_state <= WORK;
                else next_state <= DNUM;
            end 
            WORK: begin
                if(num >= ram_tlen - 1'b1) next_state <= CRC5;
                else next_state <= WORK;
            end
            CRC5: begin
                if(com_rxd == cout) next_state <= DONE;
                else next_state <= EROR;
            end
            DONE: begin
                if(fd) next_state <= WAIT;
                else next_state <= DONE;
            end
            EROR: next_state <= DONE;
            default: next_state <= IDLE;
        endcase
    end


    always@(posedge clk or posedge rst) begin
        if(rst) num <= 16'h0000;
        else if(state == IDLE) num <= 16'h0000;
        else if(state == WAIT) num <= 16'h0000;
        else if(state == DNUM && num < NLEN - 1'b1) num <= num + 1'b1;
        else if(state == WORK && num < ram_tlen - 1'b1) num <= num + 1'b1;
        else num <= 16'h0000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_tlen <= 16'h0000;
        else if(state == IDLE) ram_tlen <= 16'h0000;
        else if(state == WAIT) ram_tlen <= 16'h0000;
        else if(state == DNUM && num == 16'h0000) ram_tlen[15:8] <= com_rxd;
        else if(state == DNUM && num == 16'h0001) ram_tlen[7:0] <= com_rxd;
        else ram_tlen <= ram_tlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) btype <= BAG_INIT;
        else if(state == IDLE) btype <= BAG_INIT;
        else if(state == WAIT) btype <= BAG_INIT;
        else if(state == RPID && com_rxd == PID_ACK) btype <= BAG_ACK; 
        else if(state == RPID && com_rxd == PID_NAK) btype <= BAG_NAK; 
        else if(state == RPID && com_rxd == PID_STL) btype <= BAG_STL; 
        else if(state == WORK && num == 16'h0000 && com_rxd[7:4] == HEAD_DIDX) btype <= BAG_DIDX;
        else if(state == WORK && num == 16'h0000 && com_rxd[7:4] == HEAD_DDIDX) btype <= BAG_DDIDX;
        else if(state == WORK && num == 16'h0000 && com_rxd[7:4] == HEAD_DPARAM) btype <= BAG_DPARAM;
        else if(state == EROR) btype <= BAG_ERROR;
        else btype <= btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txa <= RAM_ADDR_INIT; 
        else if(state == IDLE) ram_txa <= RAM_ADDR_INIT;
        else if(state == WAIT) ram_txa <= RAM_ADDR_INIT;
        else if(state == WORK && num == 16'h0000 && com_rxd[7:4] == HEAD_DIDX) ram_txa <= RAM_DEVICE_IDX_ADDR;
        else if(state == WORK && num == 16'h0000 && com_rxd[7:4] == HEAD_DDIDX) ram_txa <= RAM_DATA_IDX_ADDR;
        else if(state == WORK && num == 16'h0000 && com_rxd[7:4] == HEAD_DPARAM) ram_txa <= RAM_DPARAM_ADDR;
        else if(state == WORK && num > 16'h0000) ram_txa <= ram_txa + 1'b1;
        else ram_txa <= ram_txa;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txd <= 8'h00;
        else if(state == IDLE) ram_txd <= 8'h00;
        else if(state == WAIT) ram_txd <= 8'h00;
        else if(state == WORK) ram_txd <= com_rxd;
        else ram_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txen <= 1'b0;
        else if(state == IDLE) ram_txen <= 1'b0;
        else if(state == WAIT) ram_txen <= 1'b0;
        else if(state == WORK) ram_txen <= 1'b1;
        else ram_txen <= 1'b0;
    end

    crc5
    crc5_dut(
        .clk(clk),
        .enable(cen),
        .din(cin),
        .dout(cout)
    );





endmodule