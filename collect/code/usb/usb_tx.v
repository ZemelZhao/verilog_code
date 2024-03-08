module usb_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    input [3:0] btype,
    input [31:0] cache_cmd,

    output reg [7:0] usb_txd
);

    localparam NLEN = 4'h2, PLEN = 4'h0;

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_LINK = 4'b0100;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;

    localparam PID_INIT = 8'h00, PID_SYNC = 8'h01, PID_PREM = 8'h5A;
    localparam PID_ACK = 8'h2D, PID_NAK = 8'hA5, PID_STL = 8'hE1;
    localparam PID_CMD = 8'h1E;

    localparam HEAD_DDIDX = 4'h1, HEAD_DPARAM = 4'h5, HEAD_DIDX = 4'h9;
    localparam HEAD_LINK = 4'hB;

    reg [3:0] num;
    reg [7:0] dlen;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam DNUM = 8'h04;
    localparam SYNC = 8'h08, WPID = 8'h09, WCMD = 8'h0A, CRC5 = 8'h0B;
    localparam PREM = 8'h0C; 

    reg [7:0] pid, txd;

    wire [7:0] cin, cout;
    reg cen;

    wire [3:0] data_idx, device_idx;
    wire [3:0] freq_samp, filt_up, filt_low;

    assign device_idx = cache_cmd[31:28];
    assign data_idx = cache_cmd[27:24];
    assign freq_samp = cache_cmd[23:20];
    assign filt_up = cache_cmd[19:16];
    assign filt_low = cache_cmd[15:12];

    assign fd = (state == DONE);
    assign cin = txd;

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
                if(num >= NLEN - 1'b1) next_state <= WCMD;
                else next_state <= DNUM;
            end
            WCMD: begin
                if(num >= dlen - 1'b1) next_state <= CRC5;
                else next_state <= WCMD;
            end
            CRC5: next_state <= WORK;
            WORK: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
                
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cen <= 1'b0;
        else if(state == IDLE) cen <= 1'b0;
        else if(state == WAIT) cen <= 1'b0;
        else if(state == DNUM && num == 1'b1) cen <= 1'b1;
        else if(state == WCMD) cen <= 1'b1;
        else cen <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 4'h0;
        else if(state == IDLE) num <= 4'h0;
        else if(state == WAIT) num <= 4'h0;
        else if(state == PREM && num < PLEN - 1'b1) num <= num + 1'b1;
        else if(state == WCMD && num < dlen - 1'b1) num <= num + 1'b1;
        else if(state == DNUM && num < NLEN - 1'b1) num <= num + 1'b1;
        else num <= 4'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= 8'h00;
        else if(state == IDLE) dlen <= 8'h00;
        else if(state == WAIT) dlen <= 8'h00;
        else if(state == WPID && btype == BAG_DIDX) dlen <= 8'h01; 
        else if(state == WPID && btype == BAG_DDIDX) dlen <= 8'h01; 
        else if(state == WPID && btype == BAG_DPARAM) dlen <= 8'h02; 
        else if(state == WPID && btype == BAG_LINK) dlen <= 8'h01;
        else dlen <= dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pid <= PID_INIT;
        else if(state == IDLE) pid <= PID_INIT;
        else if(state == WAIT) pid <= PID_INIT;
        else if(state == SYNC && btype == BAG_ACK) pid <= PID_ACK;
        else if(state == SYNC && btype == BAG_NAK) pid <= PID_NAK;
        else if(state == SYNC && btype == BAG_STL) pid <= PID_STL;
        else if(state == SYNC && btype == BAG_LINK) pid <= PID_CMD;
        else if(state == SYNC && btype == BAG_DIDX) pid <= PID_CMD;
        else if(state == SYNC && btype == BAG_DDIDX) pid <= PID_CMD;
        else if(state == SYNC && btype == BAG_DPARAM) pid <= PID_CMD;
        else pid <= pid;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) usb_txd <= 8'h00;
        else if(state == WORK) usb_txd <= cout;
        else usb_txd <= txd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txd <= 8'h00;
        else if(state == PREM) txd <= PID_PREM;
        else if(state == SYNC) txd <= PID_SYNC;
        else if(state == WPID) txd <= pid;
        else if(state == DNUM && num == 4'h0) txd <= 8'h00;
        else if(state == DNUM && num == 4'h1) txd <= dlen;
        else if(state == WCMD && btype == BAG_DIDX) txd <= {HEAD_DIDX, device_idx};
        else if(state == WCMD && btype == BAG_DDIDX) txd <= {HEAD_DDIDX, data_idx};
        else if(state == WCMD && btype == BAG_LINK)  txd <= {HEAD_LINK, 4'h0};
        else if(state == WCMD && btype == BAG_DPARAM && num == 4'h0) txd <= {HEAD_DPARAM, freq_samp};
        else if(state == WCMD && btype == BAG_DPARAM && num == 4'h1) txd <= {filt_up, filt_low};
        else txd <= 8'h00;
    end

    crc5
    crc5_dut(
        .clk(clk),
        .enable(cen),
        .din(cin),
        .dout(cout)
    );








endmodule