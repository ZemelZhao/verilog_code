module typec_cs(
    input clk,
    input rst,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output reg [3:0] read_btype,
    output reg [3:0] read_bdata,
    input [3:0] send_btype,

    output reg [3:0] device_idx,
    output reg [3:0] data_idx,

    output fs_tx,
    input fd_tx,
    input fs_rx,
    output fd_rx,

    input [3:0] rx_btype,
    input [3:0] rx_bdata,
    output reg [3:0] tx_btype
);

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    localparam DATA_DLINK = 8'h23;

    reg [7:0] state; 
    reg [7:0] next_state;
    reg [7:0] state_goto;

    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01;
    localparam SEND_DATA = 8'h10, SEND_ACK = 8'h11, SEND_NAK = 8'h12, SEND_DONE = 8'h13;
    localparam SEND_PDATA0 = 8'h14, SEND_PDATA1 = 8'h15, SEND_PACK = 8'h16, SEND_PNAK = 8'h17;
    localparam SEND_WNAK = 8'h18;
    localparam RECV_WAIT = 8'h20, RECV_TAKE = 8'h21, RECV_DONE = 8'h22;
    localparam READ_DATA = 8'h40, READ_TAKE = 8'h41, READ_DONE = 8'h42, READ_WAIT = 8'h43;

    assign fd_send = (state == SEND_DONE);
    assign fs_read = (state == READ_DONE);
    assign fs_tx = (state == SEND_DATA) || (state == SEND_ACK) || (state == SEND_NAK);
    assign fd_rx = (state == RECV_DONE) || (state == READ_WAIT);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_send) next_state <= SEND_PDATA0;
                else if(fs_rx) next_state <= READ_DATA;
                else next_state <= MAIN_WAIT;
            end

            SEND_PDATA0: next_state <= SEND_DATA;
            SEND_PDATA1: next_state <= SEND_DATA;
            SEND_DATA: begin
                if(fd_tx) next_state <= RECV_WAIT;
                else next_state <= SEND_DATA;
            end
            RECV_WAIT: begin
                if(fs_rx) next_state <= RECV_TAKE;
                else next_state <= RECV_WAIT;
            end
            RECV_TAKE: next_state <= RECV_DONE;
            RECV_DONE: begin
                if(~fs_rx) next_state <= state_goto;
                else next_state <= RECV_DONE;
            end
            SEND_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= SEND_DONE;
            end

            READ_DATA: begin
                if(rx_btype == BAG_DIDX) next_state <= READ_TAKE;
                else if(rx_btype == BAG_DPARAM) next_state <= READ_TAKE;
                else if(rx_btype == BAG_DDIDX) next_state <= READ_TAKE;
                else next_state <= SEND_WNAK;
            end
            READ_TAKE: next_state <= READ_WAIT;
            READ_WAIT: begin
                if(~fs_rx) next_state <= SEND_PACK;
                else next_state <= READ_WAIT;
            end
            SEND_WNAK: begin
                if(~fs_rx) next_state <= SEND_PNAK;
                else next_state <= SEND_WNAK;
            end
            SEND_PACK: next_state <= SEND_ACK;
            SEND_ACK: begin
                if(fd_tx) next_state <= READ_DONE;
                else next_state <= SEND_ACK;
            end
            SEND_PNAK: next_state <= SEND_NAK;
            SEND_NAK: begin
                if(fd_tx) next_state <= READ_DONE;
                else next_state <= SEND_NAK;
            end
            READ_DONE: begin
                if(fd_read) next_state <= MAIN_WAIT;
                else next_state <= READ_DONE;
            end
            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin // read_btype
        if(rst) read_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) read_btype <= BAG_INIT;
        else if(state == MAIN_WAIT) read_btype <= BAG_INIT;
        else if(state == READ_TAKE) read_btype <= rx_btype;
        else read_btype <= read_btype;
    end

    always@(posedge clk or posedge rst) begin // read_bdata
        if(rst) read_bdata <= BAG_INIT;
        else if(state == MAIN_IDLE) read_bdata <= BAG_INIT;
        else if(state == MAIN_WAIT) read_bdata <= BAG_INIT;
        else if(state == READ_TAKE) read_bdata <= rx_bdata;
        else read_bdata <= read_bdata;
    end

    always@(posedge clk or posedge rst) begin // device_idx
        if(rst) device_idx <= 4'h0;
        else if(state == MAIN_IDLE) device_idx <= 4'h0;
        else if(state == READ_TAKE && rx_btype == BAG_DIDX) device_idx <= rx_bdata;
        else device_idx <= device_idx;
    end

    always@(posedge clk or posedge rst) begin // data_idx
        if(rst) data_idx <= 4'h0;
        else if(state == MAIN_IDLE) data_idx <= 4'h0;
        else if(state == READ_TAKE && rx_btype == BAG_DDIDX) data_idx <= rx_bdata;
        else data_idx <= data_idx;
    end

    always@(posedge clk or posedge rst) begin // tx_btype
        if(rst) tx_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) tx_btype <= BAG_INIT;
        else if(state == MAIN_WAIT) tx_btype <= BAG_INIT;
        else if(state == SEND_PDATA0) tx_btype <= send_btype;
        else if(state == SEND_PDATA1 && tx_btype == BAG_DATA0) tx_btype <= BAG_DATA1;
        else if(state == SEND_PDATA1) tx_btype <= send_btype;
        else if(state == SEND_PACK) tx_btype <= BAG_ACK;
        else if(state == SEND_PNAK) tx_btype <= BAG_NAK;
        else tx_btype <= tx_btype;
    end

    always@(posedge clk or posedge rst) begin // state_goto
        if(rst) state_goto <= MAIN_IDLE;
        else if(state == MAIN_IDLE) state_goto <= MAIN_IDLE;
        else if(state == MAIN_WAIT) state_goto <= MAIN_IDLE;
        else if(state == RECV_TAKE && rx_btype == BAG_ACK) state_goto <= SEND_DONE; 
        else if(state == RECV_TAKE && rx_btype == BAG_NAK) state_goto <= SEND_PDATA1;
        else state_goto <= state_goto;
    end

endmodule