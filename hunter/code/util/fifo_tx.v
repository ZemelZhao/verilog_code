module fifo_tx(
    input clk,
    input rst,

    input [7:0] cfull,
    input fs,
    output fd,

    input [63:0] bias,

    output [7:0] fifo_txen,
    output [63:0] fifo_txd
);

    localparam DATA_NUM = 8'h40;

    reg [1:0] state, next_state;
    localparam IDLE = 2'h0, WAIT = 2'h1, WORK = 2'h2, DONE = 2'h3;

    reg [7:0] num;
    wire full;

    assign fifo_txd = {8{num}} + bias;
    assign fifo_txen = {8{(state == WORK)}};
    assign fd = (state == DONE);

    assign full = |cfull; 

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: begin
                if(~full) next_state <= WAIT;
                else next_state <= IDLE;
            end
            WAIT: begin
                if(fs) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(num >= DATA_NUM - 1'b1) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(~fs) next_state <= IDLE;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == IDLE) num <= 8'h00;
        else if(state == WAIT) num <= 8'h00;
        else if(state == WORK) num <= num + 1'b1;
        else num <= num;
    end


endmodule