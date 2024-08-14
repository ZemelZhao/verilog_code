module fifo_rx(
    input clk,
    input rst,
    
    input fs,
    output fd,

    input [15:0] data_len,

    output fifo_rxen,
    input [7:0] fifo_rxd
);


    reg [1:0] state, next_state;
    localparam IDLE = 2'h0, WAIT = 2'h1, WORK = 2'h2, DONE = 2'h3;

    reg [15:0] num;

    assign fifo_rxen = (state == WORK);
    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(num >= data_len - 1'b1) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 16'h00;
        else if(state == IDLE) num <= 16'h00;
        else if(state == WAIT) num <= 16'h00;
        else if(state == WORK) num <= num + 1'b1;
        else num <= num;
    end



endmodule