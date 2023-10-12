module usb_tx(
    input clk,
    input rst,

    input fs,
    input fd,

    input [3:0] btype,
    input [31:0] data_cmd,

    output reg [7:0] com_txd
);

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;

    localparam PID_INIT = 8'h00, PID_SYNC = 8'h01;
    localparam PID_ACK = 8'h2D, PID_NAK = 8'hA5, PID_STALL = 8'hE1;
    localparam PID_CMD = 8'h1E;

    localparam HEAD_DDIDX = 4'h1, HEAD_DPARAM = 4'h5, HEAD_DIDX = 4'h9;

    reg [3:0] num;
    reg [7:0] dlen;

    reg [7:0] state, next_state;

    reg [7:0] pid, txd;

    wire [7:0] cin, cout;
    wire cen;

    wire [3:0] data_idx, device_idx;
    wire [3:0] freq_samp, filt_up, filt_low;

    assign device_idx = data_cmd[31:28];
    assign data_idx = data_cmd[27:24];
    assign freq_samp = data_cmd[23:20];
    assign filt_up = data_cmd[19:16];
    assign filt_low = data_cmd[15:12];

    assign fd = (state == DONE);
    assign cin = txd;
    assign cen = (state == WCMD) && (state == CRC5);

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
                else if(btype == BAG_STL) next_state <= DONE;
                else next_state <= DNUM0;
            end

            DNUM0: next_state <= DNUM1;
            DNUM1: next_state <= WCMD;
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
        if(rst) num <= 4'h0;
        else if(state == IDLE) num <= 4'h0;
        else if(state == WAIT) num <= 4'h0;
        else if(state == WCMD) num <= num + 1'b1;
        else num <= 4'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= 8'h00;
        else if(state == IDLE) dlen <= 8'h00;
        else if(state == WAIT) dlen <= 8'h00;
        else if(state == WPID && btype == BAG_DIDX) dlen <= 8'h01; 
        else if(state == WPID && btype == BAG_DDIDX) dlen <= 8'h01; 
        else if(state == WPID && btype == BAG_DPARAM) dlen <= 8'h02; 
        else dlen <= dlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pid <= PID_INIT;
        else if(state == IDLE) pid <= PID_INIT;
        else if(state == WAIT) pid <= PID_INIT;
        else if(state == SYNC && btype == BAG_ACK) pid <= PID_ACK;
        else if(state == SYNC && btype == BAG_NAK) pid <= PID_NAK;
        else if(state == SYNC && btype == BAG_STL) pid <= PID_STL;
        else if(state == SYNC && btype == BAG_DIDX) pid <= PID_CMD;
        else if(state == SYNC && btype == BAG_DDIDX) pid <= PID_CMD;
        else if(state == SYNC && btype == BAG_DPARAM) pid <= PID_CMD;
        else pid <= pid;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_txd <= 8'h00;
        else if(state == WORK) com_txd <= cout;
        else com_txd <= txd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txd <= 8'h00;
        else if(state == SYNC) txd <= PID_SYNC;
        else if(state == WPID) txd <= pid;
        else if(state == DNUM0) txd <= 8'h00;
        else if(state == DNUM1) txd <= dlen;
        else if(state == WCMD && btype == BAG_DIDX) txd <= {HEAD_DIDX, device_idx};
        else if(state == WCMD && btype == BAG_DDIDX) txd <= {HEAD_DIDX, data_idx};
        else if(state == WCMD && btype == BAG_DPARAM && num == 4'h0) txd <= {HEAD_DIDX, freq_samp};
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