module console_trgg(
    input clk,
    input rst,

    input [39:0] com_cmd,
    output reg [39:0] trgg_cmd,

    input fs,
    output fd,

    input fd_trgg,
    output fs_trgg
);

    reg [3:0] state, next_state;
    localparam IDLE = 4'b0001, WAIT = 4'b0010, WORK = 4'b0100, DONE = 4'b1000;

    assign fd = (state == DONE);
    assign fs_trgg = (state == WORK);

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
                if(fd_trgg) next_state <= DONE;
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
        if(rst) trgg_cmd <= 40'h00;
        else if(state == IDLE) trgg_cmd <= 40'h00;
        else if(state == WAIT) trgg_cmd <= com_cmd;
        else trgg_cmd <= trgg_cmd;
    end

endmodule