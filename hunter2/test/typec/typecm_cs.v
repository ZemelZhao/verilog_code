module typecm_cs(
    input clk,
    input rst,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output reg [3:0] read_btype,
    input [3:0] send_btype,

    output fs_tx,
    input fd_tx,
    input fs_rx,
    output fd_rx,

    output reg [3:0] tx_btype,
    input [3:0] rx_btype
);

    localparam BAG_INIT = 4'b0000; 
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STALL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;


    (*MARK_DEBUG = "true"*)reg [7:0] state; 
    reg [7:0] next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01;
    localparam SEND_DATA = 8'h10, RECV_WAIT = 8'h11, RECV_TAKE = 8'h12, RECV_DONE = 8'h13;
    localparam SEND_PDATA = 8'h14, SEND_DONE = 8'h15;
    localparam READ_DATA = 8'h20, READ_TAKE = 8'h21, READ_DONE = 8'h22; 
    localparam SEND_PACK = 8'h30, SEND_ACK = 8'h31, SEND_PNAK = 8'h32, SEND_NAK = 8'h33; 

    assign fd_send = (state == SEND_DONE);
    assign fs_read = (state == READ_DONE);
    assign fs_tx = (state == SEND_DATA) || (state == SEND_ACK) || (state == SEND_NAK);
    assign fd_rx = (state == RECV_DONE) || (state == READ_TAKE);


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
                else next_state <= RECV_WAIT;
            end
            RECV_TAKE: next_state <= RECV_DONE;
            RECV_DONE: begin
                if(~fs_rx) next_state <= SEND_DONE;
                else next_state <= RECV_DONE;
            end
            SEND_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <=  SEND_DONE;
            end

            READ_DATA: next_state <= READ_TAKE;
            READ_TAKE: begin
                if(~fs_rx) next_state <= SEND_PACK;
                else next_state <= READ_TAKE;
            end
            SEND_PACK: next_state <= SEND_ACK;
            SEND_ACK: begin
                if(fd_tx) next_state <= READ_DONE;
                else next_state <= SEND_ACK;
            end
            READ_DONE: begin
                if(fd_read) next_state <=  MAIN_WAIT;
                else next_state <= READ_DONE;
            end
            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) read_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) read_btype <= BAG_INIT; 
        else if(state == MAIN_WAIT) read_btype <= BAG_INIT; 
        else if(state == READ_TAKE) read_btype <= rx_btype; 
        else read_btype <= read_btype;
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

endmodule