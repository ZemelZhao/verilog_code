module trgg_sp(
    input clk,
    input rst,

    input fs,
    output fd,

    input [3:0] trgg_cmd,
    input [15:0] trgg_dly,

    output trgg_pin
);

    localparam COUNT_1MS = 20'd75_000; 


    reg [7:0] state, next_state;

    reg [15:0] num_round;
    reg [20:0] num_count;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= DELAY;
                else next_state <= WAIT;
            end
            PREP: begin
                if (trgg_cmd[3]) next_state <= DELAY;
                else next_state <= DONE; 
            end
            DELAY: begin
                if(num_round < trgg_dly) next_state <= COUNT;
                else next_state <= WORK;
            end
            COUNT: begin
                if(num_count >= COUNT_1MS - 1'b1) next_state <= DELAY;
                else next_state <= COUNT;
            end
            WORK: begin
                
            end

        endcase
    end




endmodule