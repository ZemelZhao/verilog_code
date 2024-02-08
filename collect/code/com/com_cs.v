module com_cs(
    input clk,
    input rst,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output fs_com_send,
    input fd_com_send,
    input fs_com_read,
    output fd_com_read,

    output reg [3:0] com_tx_btype,
    input [3:0] com_rx_btype,

    output reg [3:0] data_idx,
    output reg [3:0] com_btype
);

    reg [9:0] state, next_state;
    localparam MAIN_IDLE = 10'h001, MAIN_WAIT = 10'h002;
    localparam READ_IDLE = 10'h004, READ_WAIT = 10'h008, READ_WORK = 10'h010, READ_DONE = 10'h020;
    localparam SEND_IDLE = 10'h040, SEND_WAIT = 10'h080, SEND_WORK = 10'h100, SEND_DONE = 10'h200;

    assign fd_send = (state == SEND_DONE);
    assign fs_read = (state == READ_IDLE);
    assign fs_com_send = (state == READ_WORK) || (state == SEND_IDLE);
    assign fd_com_read = (state == READ_WAIT) || (state == SEND_WORK);

    localparam DATA_IDX = 4'h5;
    localparam BTYPE_INIT = 4'h0, BTYPE_INFO = 4'h1, BTYPE_DATA = 4'hE;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_com_read) next_state <= READ_IDLE;
                else if(fs_send) next_state <= SEND_IDLE;
                else next_state <= MAIN_WAIT;
            end

            READ_IDLE: begin
                if(fd_read) next_state <= READ_WAIT;
                else next_state <= READ_IDLE;
            end
            READ_WAIT: begin
                if(~fs_com_read) next_state <= READ_WORK;
                else next_state <= READ_WAIT;
            end
            READ_WORK: begin
                if(fd_com_send) next_state <= READ_DONE;
                else next_state <= READ_WORK;
            end
            READ_DONE: next_state <= MAIN_IDLE;

            SEND_IDLE: begin
                if(fd_com_send) next_state <= SEND_WAIT;
                else next_state <= SEND_IDLE;
            end
            SEND_WAIT: begin
                if(fs_com_read) next_state <= SEND_WORK;
                else next_state <= SEND_WAIT;
            end
            SEND_WORK: begin
                if(~fs_com_read) next_state <= SEND_DONE;
                else next_state <= SEND_WORK;
            end
            SEND_DONE: begin
                if(~fs_send) next_state <= MAIN_IDLE;
                else next_state <= SEND_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_idx <= 4'h0;
        else if(state == MAIN_WAIT && fs_send && data_idx == DATA_IDX) data_idx <= 4'h0;
        else if(state == MAIN_WAIT && fs_send) data_idx <= data_idx + 1'b1;
        else data_idx <= data_idx;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_tx_btype <= BTYPE_INIT;
        else if(state == MAIN_IDLE) com_tx_btype <= BTYPE_INIT;
        else if(state == MAIN_WAIT && fs_send) com_tx_btype <= BTYPE_DATA;
        else if(state == MAIN_WAIT && fs_com_read) com_tx_btype <= BTYPE_INFO;
        else com_tx_btype <= com_tx_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_btype <= BTYPE_INIT;
        else if(state == MAIN_IDLE) com_btype <= BTYPE_INIT;
        else if(state == MAIN_WAIT && fs_com_read) com_btype <= com_rx_btype;
        else if(state == MAIN_WAIT) com_btype <= BTYPE_INIT;
        else com_btype <= com_btype;
    end







endmodule