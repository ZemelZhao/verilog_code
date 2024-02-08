module por(
    input clk,
    input rst_n,
    output rst
);

    localparam RST_NUM = 16'd10_000;

    reg [3:0] state, next_state;
    reg [15:0] num;

    localparam IDLE = 4'h1, WAIT = 4'h2, WORK = 4'h4, DONE = 4'h8;

    assign rst = (state == WORK) || (~rst_n);

    always@(posedge clk or negedge rst_n) begin
        if (~rst_n) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(num == RST_NUM) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(num == 4'h0) next_state <= DONE;
                else next_state <= DONE;
            end 
            DONE: next_state <= DONE;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk) begin
        if(state == IDLE) num <= 4'h0;
        else if(state == WAIT) num <= num + 1'b1;
        else if(state == WORK) num <= num - 1'b1;
        else if(state == DONE) num <= 4'h0;
        else num <= num;
    end



endmodule