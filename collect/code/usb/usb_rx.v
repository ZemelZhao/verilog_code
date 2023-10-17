module usb_rx(
    input clk,
    input rst,

    output fs,
    input fd,

    input [7:0] usb_rxd,
    output reg [3:0] btype, 
    output [31:0] cache_stat,

    input [11:0] ram_txa_init,

    output reg [11:0] ram_txa,
    output reg [7:0] ram_txd,
    output reg ram_txen
);

    localparam PID_INIT = 8'h00, PID_SYNC = 8'h0F;
    localparam PID_ACK = 8'h2D, PID_NAK = 8'hA5, PID_STL = 8'hE1;
    localparam PID_STAT = 8'hD2, PID_DATA0 = 8'h96, PID_DATA1 = 8'h5A;

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    localparam HEAD_DTYPE = 4'h1, HEAD_DTEMP = 4'h9, HEAD_DATA = 4'h3;
    localparam HEAD_DLINK = 4'hD;

    localparam RAM_ADDR_INIT = 12'h000;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, EROR = 8'h02, DONE = 8'h03;
    localparam RPID = 8'h04, RACK = 8'h05, RNAK = 8'h06, RSTL = 8'h07;
    localparam SNUM0 = 8'h10, SNUM1 = 8'h11, STAT0 = 8'h12, STAT1 = 8'h13;
    localparam DNUM0 = 8'h20, DNUM1 = 8'h21, HEAD0 = 8'h22, HEAD1 = 8'h23;
    localparam PDATA = 8'h24, RDATA = 8'h25;
    localparam CRC5 = 8'h30, CRC160 = 8'h31, CRC161 = 8'h32;

    reg [7:0] device_type, device_temp;
    reg [3:0] device_stat, device_idx, data_idx;

    reg cen;
    wire [7:0] cin;
    wire [7:0] cout5;
    wire [15:0] cout16;

    reg [11:0] data_len;
    reg [11:0] num;

    assign fs = (state == DONE);
    assign cache_stat = {device_temp, device_type, device_stat, device_idx, data_idx, 4'h0};
    assign cin = usb_rxd;


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(usb_rxd == PID_SYNC) next_state <= RPID;
                else next_state <= WAIT;
            end
            EROR: next_state <= DONE;
            DONE: begin
                if(fd) next_state <= WAIT;
                else next_state <= DONE;
            end

            RPID: begin
                if(usb_rxd == PID_ACK) next_state <= RACK;
                else if(usb_rxd == PID_NAK) next_state <= RNAK;
                else if(usb_rxd == PID_STL) next_state <= RSTL;
                else if(usb_rxd == PID_STAT) next_state <= SNUM0;
                else if(usb_rxd == PID_DATA0) next_state <= DNUM0;
                else if(usb_rxd == PID_DATA1) next_state <= DNUM0;
                else next_state <= EROR;
            end

            RACK: next_state <= DONE;
            RNAK: next_state <= DONE;
            RSTL: next_state <= DONE;

            SNUM0: next_state <= SNUM1;
            SNUM1: next_state <= STAT0;
            STAT0: next_state <= STAT1;
            STAT1: next_state <= CRC5;

            DNUM0: next_state <= DNUM1;
            DNUM1: next_state <= HEAD0;
            HEAD0: next_state <= HEAD1;
            HEAD1: next_state <= PDATA;
            PDATA: next_state <= RDATA;
            RDATA: begin
                if(num >= data_len - 3'h4) next_state <= CRC160;
                else next_state <= RDATA;
            end

            CRC5: begin
                if(usb_rxd == cout5) next_state <= DONE;
                else next_state <= EROR;
            end
            CRC160: begin
                if(usb_rxd == cout16[15:8]) next_state <= CRC161;
                else next_state <= EROR;
            end
            CRC161: begin
                if(usb_rxd == cout16[7:0]) next_state <= DONE;
                else next_state <= EROR;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type <= 8'h00;
        else if(state == IDLE) device_type <= 8'h00;
        else if(state == STAT1 && btype == BAG_DTYPE) device_type <= usb_rxd;
        else device_type <= device_type;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp <= 8'h00;
        else if(state == IDLE) device_temp <= 8'h00;
        else if(state == STAT1 && btype == BAG_DTEMP) device_temp <= usb_rxd;
        else device_temp <= device_temp;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_stat <= 4'h0;
        else if(state == IDLE) device_stat <= 4'h0;
        else if(state == HEAD1) device_stat <= usb_rxd[3:0];
        else device_stat <= device_stat;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_idx <= 4'h0;
        else if(state == IDLE) device_idx <= 4'h0;
        else if(state == STAT0) device_idx <= usb_rxd[3:0];
        else if(state == HEAD0) device_idx <= usb_rxd[3:0];
        else device_idx <= device_idx;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_idx <= 4'h0;
        else if(state == IDLE) data_idx <= 4'h0;
        else if(state == HEAD1) data_idx <= usb_rxd[7:4];
        else data_idx <= data_idx;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) btype <= BAG_INIT;
        else if(state == RACK) btype <= BAG_ACK;
        else if(state == RNAK) btype <= BAG_NAK;
        else if(state == RSTL) btype <= BAG_STL;
        else if(state == STAT0 && usb_rxd[7:4] == HEAD_DLINK) btype <= BAG_DLINK; 
        else if(state == STAT0 && usb_rxd[7:4] == HEAD_DTYPE) btype <= BAG_DTYPE; 
        else if(state == STAT0 && usb_rxd[7:4] == HEAD_DTEMP) btype <= BAG_DTEMP; 
        else if(state == RPID && usb_rxd == PID_DATA0) btype <= BAG_DATA0; 
        else if(state == RPID && usb_rxd == PID_DATA1) btype <= BAG_DATA1; 
        else if(state == EROR) btype <= BAG_ERROR;
        else btype <= btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txa <= RAM_ADDR_INIT;
        else if(state == IDLE) ram_txa <= RAM_ADDR_INIT;
        else if(state == WAIT) ram_txa <= RAM_ADDR_INIT;
        else if(state == PDATA) ram_txa <= ram_txa_init;
        else if(state == RDATA) ram_txa <= ram_txa + 1'b1;
        else ram_txa <= ram_txa;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txd <= 8'h00;
        else if(state == IDLE) ram_txd <= 8'h00;
        else if(state == WAIT) ram_txd <= 8'h00;
        else if(state == PDATA) ram_txd <= usb_rxd;
        else if(state == RDATA) ram_txd <= usb_rxd;
        else ram_txd <= ram_txd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txen <= 1'b0;
        else if(state == IDLE) ram_txen <= 1'b0;
        else if(state == WAIT) ram_txen <= 1'b0;
        else if(state == PDATA) ram_txen <= 1'b1;
        else if(state == RDATA) ram_txen <= 1'b1;
        else ram_txen <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_len <= 12'h000;
        else if(state == IDLE) data_len <= 12'h000;
        else if(state == WAIT) data_len <= 12'h000;
        else if(state == DNUM0) data_len[11:8] <= usb_rxd[3:0];
        else if(state == DNUM1) data_len[7:0] <= usb_rxd;
        else data_len <= data_len;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 12'h000;
        else if(state == IDLE) num <= 12'h000;
        else if(state == WAIT) num <= 12'h000;
        else if(state == RDATA) num <= num + 1'b1;
        else num <= 12'h000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cen <= 1'b0;
        else if(state == IDLE) cen <= 1'b0;
        else if(state == WAIT) cen <= 1'b0;
        else if(state == SNUM0) cen <= 1'b1;
        else if(state == SNUM1) cen <= 1'b1;
        else if(state == STAT0) cen <= 1'b1;
        else if(state == DNUM0) cen <= 1'b1;
        else if(state == DNUM1) cen <= 1'b1;
        else if(state == HEAD0) cen <= 1'b1;
        else if(state == HEAD1) cen <= 1'b1;
        else if(state == PDATA) cen <= 1'b1;
        else if(state == RDATA && num < data_len - 3'h4) cen <= 1'b1;
        else cen <= 1'b0;
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

