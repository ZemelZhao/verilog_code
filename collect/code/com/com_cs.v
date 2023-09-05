module com_cs(
    input clk,
    input rst,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output reg [3:0] read_btype,
    output reg [7:0] read_bdata,
    input [3:0] send_btype,

    output fs_tx,
    input fd_tx,
    input fs_rx,
    output fd_rx,

    input [3:0] rx_btype,
    input [7:0] rx_bdata,
    output reg [3:0] tx_btype,

    output reg [7:0] device_type,
    output reg [7:0] device_temp,
 
    input [11:0] tx_data_len,
    input [11:0] rx_data_len,

    input [3:0] tx_device_idx,
    output [3:0] rx_device_idx,

    input [3:0] tx_data_idx,
    output [3:0] rx_data_idx,

    input [3:0] rx_device_stat,
    output reg link,
    output error
);

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    localparam LINK_TIMEOUT = 8'h80;
    localparam NAK_NUMBER = 8'h20;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01;
    localparam SEND_PDATA = 8'h10, SEND_DATA = 8'h11, SEND_DONE = 8'h12;
    localparam RECV_WAIT = 8'h20, RECV_TAKE = 8'h21, RECV_DONE = 8'h22;
    localparam READ_DATA = 8'h30,  READ_WAIT = 8'h31, READ_DONE = 8'h32;
    localparam STAT_TAKE = 8'h33, DATA_TAKE = 8'h34;
    localparam SEND_PACK = 8'h40, SEND_ACK = 8'h41, SEND_PNAK = 8'h42, SEND_NAK = 8'h43;
    localparam SEND_WNAK = 8'h44;
    localparam LINK_CLOSE = 8'h50, LINK_OPEN = 8'h51, ERROR = 8'h52;

    reg [7:0] state_goto;

    reg [7:0] num;

    assign error = (state == ERROR);
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
                if(fs_send) next_state <= SEND_PDATA;
                else if(fs_rx) next_state <= READ_DATA;
                else next_state <= MAIN_WAIT;
            end

            SEND_PDATA: next_state <= SEND_DATA;
            SEND_DATA: begin
                if(fd_tx) next_state <= RECV_WAIT;
                else next_state <= SEND_DATA;
            end
            RECV_WAIT: begin
                if(fs_rx) next_state <= RECV_TAKE;
                else if(num >= LINK_TIMEOUT) next_state <= LINK_OPEN;
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
                if(rx_btype == BAG_DLINK) next_state <= LINK_CLOSE;
                else if(rx_btype == BAG_DTYPE) next_state <= STAT_TAKE;
                else if(rx_btype == BAG_DTEMP) next_state <= STAT_TAKE;
                else if(rx_btype == BAG_DATA0) next_state <= DATA_TAKE;
                else if(rx_btype == BAG_DATA1) next_state <= DATA_TAKE;
                else next_state <= SEND_WNAK;
            end  
            STAT_TAKE: begin
                if(rx_device_idx == tx_device_idx) next_state <= READ_WAIT;
                else next_state <= SEND_WNAK;
            end
            DATA_TAKE: begin
                if(rx_device_idx == tx_device_idx || rx_data_idx == tx_data_idx || rx_data_len == tx_data_len) next_state <= READ_WAIT;
                else next_state <= SEND_WNAK;
            end
            READ_WAIT: begin
                if(~fs_rx) next_state <= SEND_PACK;
                else next_state <= READ_WAIT;
            end
            SEND_PACK: next_state <= SEND_ACK;
            SEND_ACK: begin
                if(fd_tx) next_state <= READ_DONE;
                else next_state <= SEND_ACK;
            end
            SEND_WNAK: begin
                if(~fs_rx) next_state <= SEND_PNAK;
                else next_state <= SEND_WNAK;
            end
            SEND_PNAK: begin
                if(num >= NAK_NUMBER) next_state <= ERROR;
                else next_state <= SEND_NAK;
            end
            SEND_NAK: begin
                if(fd_tx) next_state <= READ_DONE;
                else next_state <= SEND_NAK;
            end
            READ_DONE: begin
                if(fd_read) next_state <= MAIN_WAIT;
                else next_state <= READ_DONE;
            end

            LINK_CLOSE: next_state <= READ_WAIT;
            LINK_OPEN: next_state <= LINK_OPEN;
            ERROR: next_state <= ERROR;

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) link <= 1'b0;
        else if(state == MAIN_IDLE) link <= 1'b0;
        else if(state == LINK_CLOSE) link <= 1'b1;
        else if(state == LINK_OPEN) link <= 1'b0;
        else link <= link;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == MAIN_IDLE) num <= 8'h00;
        else if(state == MAIN_WAIT) num <= 8'h00;
        else if(state == RECV_WAIT) num <= num + 1'b1;
        else if(state == SEND_PNAK) num <= num + 1'b1;
        else if(state == SEND_PACK) num <= 8'h00;
        else num <= num;
    end
    
    always@(posedge clk or posedge rst) begin
        if(rst) read_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) read_btype <= BAG_INIT;
        else if(state == MAIN_WAIT) read_btype <= BAG_INIT;
        else if(state == STAT_TAKE) read_btype <= rx_btype;
        else if(state == DATA_TAKE) read_bdata <= rx_btype;
        else read_btype <= read_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) read_bdata <= 8'h00;
        else if(state == MAIN_IDLE) read_bdata <= 8'h00;
        else if(state == MAIN_WAIT) read_bdata <= 8'h00;
        else if(state == STAT_TAKE) read_bdata <= rx_bdata;
        else read_bdata <= read_bdata;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) tx_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) tx_btype <= BAG_INIT;
        else if(state == MAIN_WAIT) tx_btype <= BAG_INIT;
        else if(state == SEND_PDATA) tx_btype <= send_btype;
        else if(state == SEND_PACK) tx_btype <= BAG_ACK;
        else if(state == SEND_PNAK) tx_btype <= BAG_NAK;
        else tx_btype <= tx_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type <= 8'h00;
        else if(state == MAIN_IDLE) device_type <= 8'h00;
        else if(state == STAT_TAKE && rx_btype == BAG_DTYPE) device_type <= rx_bdata;
        else device_type <= device_type;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type <= 8'h00;
        else if(state == MAIN_IDLE) device_temp <= 8'h00;
        else if(state == STAT_TAKE && rx_btype == BAG_DTEMP) device_temp <= rx_bdata;
        else device_temp <= device_temp;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) state_goto <= MAIN_IDLE;
        else if(state == MAIN_IDLE) state_goto <= MAIN_IDLE;
        else if(state == MAIN_WAIT) state_goto <= MAIN_WAIT;
        else if(state == RECV_TAKE && rx_btype == BAG_ACK) state_goto <= SEND_DONE;
        else if(state == RECV_TAKE && rx_btype == BAG_NAK) state_goto <= SEND_PDATA;
        else state_goto <= state_goto;
    end

endmodule