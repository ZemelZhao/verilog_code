module com_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    output reg [7:0] com_txd,

    input [11:0] ram_addr_init,
    input [11:0] tx_dlen,

    input [3:0] btype,

    input [7:0] ram_rxd,
    output reg [11:0] ram_rxa
);

    localparam RAM_LATANECY = 4'h2;
    localparam NLEN = 8'h02, CLEN = 8'h02, PLEN = 8'h00;

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    localparam PID_INIT = 8'h00, PID_SYNC = 8'h0F, PID_PREM = 8'h5A;
    localparam PID_ACK = 8'h2D, PID_NAK = 8'hA5, PID_STL = 8'hE1;
    localparam PID_STAT = 8'hD2, PID_DATA0 = 8'h96, PID_DATA1 = 8'h5A;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam SYNC = 8'h10, WPID = 8'h11, DNUM = 8'h12;
    localparam PREM = 8'h20;
    localparam CRC5 = 8'h30, CRC16 = 8'h31; 
    localparam GAP0 = 8'h40, GAP1 = 8'h41;

    localparam RAM_ADDR_INIT = 12'hFF0;

    reg [11:0] num;
    reg [7:0] txd;
    reg [7:0] pid;

    wire cen;
    wire [7:0] cin;
    wire [7:0] cout5;
    wire [15:0] cout16;

    assign cen = (state == WORK) || (state == CRC5) || ((state == CRC16) && (num == 12'h000));
    assign cin = txd;
    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs && PLEN == 4'h0) next_state <= SYNC;
                else if(fs) next_state <= PREM;
                else next_state <= WAIT;
            end
            PREM: begin
                if(num >= PLEN - 1'b1) next_state <= SYNC;
                else next_state <= PREM;
            end
            SYNC: next_state <= WPID;
            WPID: begin
                if(btype == BAG_ACK) next_state <= DONE;
                else if(btype == BAG_NAK) next_state <= DONE;
                else if(btype == BAG_STL) next_state <= DONE;
                else next_state <= DNUM;
            end
            DNUM: begin
                if(num >= NLEN - 1'b1) next_state <= WORK;
                else next_state <= DNUM;
            end
            WORK: begin
                if(num >= tx_dlen - 1'b1 && btype == BAG_DLINK) next_state <= CRC5;
                else if(num >= tx_dlen - 1'b1 && btype == BAG_DTYPE) next_state <= CRC5;
                else if(num >= tx_dlen - 1'b1 && btype == BAG_DTEMP) next_state <= CRC5;
                else if(num >= tx_dlen - 1'b1 && btype == BAG_DATA0) next_state <= CRC16;
                else if(num >= tx_dlen - 1'b1 && btype == BAG_DATA1) next_state <= CRC16;
                else next_state <= WORK;
            end
            CRC5: next_state <= GAP0;
            CRC16: begin
                if(num >= CLEN - 1'b1) next_state <= GAP1;
                else next_state <= CRC16;
            end
            GAP0: next_state <= DONE;
            GAP1: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 12'h000;
        else if(state == IDLE) num <= 12'h000;
        else if(state == WAIT) num <= 12'h000;
        else if(state == PREM && num < PLEN - 1'b1) num <= num + 1'b1;
        else if(state == DNUM && num < NLEN - 1'b1) num <= num + 1'b1;
        else if(state == WORK && num < tx_dlen - 1'b1) num <= num + 1'b1;
        else if(state == CRC16 && num < CLEN - 1'b1) num <= num + 1'b1;
        else num <= 12'h000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txd <= 8'h00;
        else if(state == IDLE) txd <= 8'h00;
        else if(state == WAIT) txd <= 8'h00;
        else if(state == PREM) txd <= PID_PREM;
        else if(state == SYNC) txd <= PID_SYNC;
        else if(state == WPID) txd <= pid;
        else if(state == DNUM && num == 12'h000) txd <= {4'h0, tx_dlen[11:8]};
        else if(state == DNUM && num == 12'h001) txd <= tx_dlen[7:0];
        else if(state == WORK) txd <= ram_rxd;
        else if(state == CRC5) txd <= cout5;
        else if(state == CRC16 && num == 12'h000) txd <= cout16[15:8];
        else if(state == CRC16 && num == 12'h001) txd <= cout16[7:0];
        else txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pid <= PID_INIT;
        else if(state == IDLE) pid <= PID_INIT;
        else if(state == WAIT) pid <= PID_INIT;
        else if(state == SYNC && btype == BAG_ACK) pid <= PID_ACK;
        else if(state == SYNC && btype == BAG_NAK) pid <= PID_NAK;
        else if(state == SYNC && btype == BAG_STL) pid <= PID_STL;
        else if(state == SYNC && btype == BAG_DLINK) pid <= PID_STAT;
        else if(state == SYNC && btype == BAG_DTYPE) pid <= PID_STAT;
        else if(state == SYNC && btype == BAG_DTEMP) pid <= PID_STAT;
        else if(state == SYNC && btype == BAG_DATA0) pid <= PID_DATA0;
        else if(state == SYNC && btype == BAG_DATA1) pid <= PID_DATA1;
        else pid <= pid;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_rxa <= RAM_ADDR_INIT;
        else if(state == IDLE) ram_rxa <= ram_addr_init;
        else if(state == WAIT) ram_rxa <= ram_addr_init;
        else if(state == SYNC && RAM_LATANECY >= 4'h3) ram_rxa <= ram_addr_init + 1'b1;
        else if(state == DNUM && RAM_LATANECY >= 4'h2 && num == 12'h000) ram_rxa <= ram_rxa + 1'b1;
        else if(state == DNUM && RAM_LATANECY >= 4'h1 && num == 12'h001) ram_rxa <= ram_rxa + 1'b1;
        else if(state == WORK) ram_rxa <= ram_rxa + 1'b1;
        else ram_rxa <= ram_rxa;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_txd <= 8'h00;
        else if(state == GAP0) com_txd <= cout5;
        else if(state == CRC16 && num == 8'h01) com_txd <= cout16[15:8];
        else if(state == GAP1) com_txd <= cout16[7:0];
        else com_txd <= txd;
    end



    crc5
    crc5_dut(
        .clk(clk),
        .enable(cen),
        .din(cin),
        .dout(cout5)
    );

    crc16
    crc16_dut(
        .clk(clk),
        .enable(cen),
        .din(cin),
        .dout(cout16)
    );





endmodule