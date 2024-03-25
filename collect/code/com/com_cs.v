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

    (*MARK_DEBUG = "true"*)reg [9:0] state; 
    reg [9:0] next_state;
    localparam MAIN_IDLE = 10'h001, MAIN_WAIT = 10'h002;
    localparam READ_IDLE = 10'h004, READ_WAIT = 10'h008, READ_WORK = 10'h010, READ_DONE = 10'h020;
    localparam SEND_IDLE = 10'h040, SEND_WAIT = 10'h080, SEND_WORK = 10'h100, SEND_DONE = 10'h200;

    (*MARK_DEBUG = "true"*)reg [31:0] time_cnt;
    reg [7:0] num_cnt;

    localparam NUM_OUT = 8'h03;
    localparam TIMEOUT = 32'd450; // 6us here

    assign fd_send = (state == SEND_DONE);
    assign fs_read = (state == READ_WAIT);
    assign fs_com_send = (state == READ_DONE) || (state == SEND_IDLE);
    assign fd_com_read = (state == READ_WORK) || (state == SEND_WORK);

    localparam DATA_IDX = 4'h5, DATA_IDX_INIT = 4'h1;
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

            READ_IDLE: next_state <= READ_WAIT;
            READ_WAIT: begin
                if(fd_read) next_state <= READ_WORK;
                else next_state <= READ_WAIT;
            end
            READ_WORK: begin
                if(~fs_com_read) next_state <= READ_DONE;
                else next_state <= READ_WORK;
            end
            READ_DONE: begin
                if(fd_com_send) next_state <= MAIN_WAIT;
                else next_state <= READ_DONE;
            end

            SEND_IDLE: begin
                if(fd_com_send) next_state <= SEND_WAIT;
                else next_state <= SEND_IDLE;
            end
            SEND_WAIT: begin
                if(num_cnt >= NUM_OUT - 1'b1) next_state <= SEND_DONE;
                else if(time_cnt >= TIMEOUT - 1'b1) next_state <= SEND_IDLE;
                else if(fs_com_read) next_state <= SEND_WORK;
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
        if(rst) num_cnt <= 8'h00;
        else if(state == MAIN_IDLE) num_cnt <= 8'h00;
        else if(state == MAIN_WAIT && fs_send) num_cnt <= 8'h00; 
        else if(state == SEND_DONE) num_cnt <= 8'h00;
        else if(state == SEND_WAIT && time_cnt >= TIMEOUT-1'b1) num_cnt <= num_cnt + 1'b1;
        else num_cnt <= num_cnt;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) time_cnt <= 32'h00;
        else if(state == SEND_WAIT) time_cnt <= time_cnt + 1'b1;
        else time_cnt <= 32'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_idx <= DATA_IDX;
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
        else if(state == SEND_WAIT && fs_com_read) com_btype <= com_rx_btype;
        else if(state == READ_IDLE) com_btype <= com_rx_btype;
        else if(state == MAIN_WAIT) com_btype <= BTYPE_INIT;
        else com_btype <= com_btype;
    end

endmodule