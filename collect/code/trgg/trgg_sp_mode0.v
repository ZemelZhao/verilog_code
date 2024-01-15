module trgg_sp_mode0(
    input clk,
    input rst,

    input fs,
    output fd,

    output reg pin
);

    localparam STG0_CNT = 16'


    reg [7:0] state, next_state;
    reg [7:0] state_d0;

    localparam IDLE = 8'h00;


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= STG0;
                else next_state <= WAIT;
            end
            STG0: begin
                if(num_round >= )
            end

            COUNT: begin
                if(num_count >= COUNT_1MS - 1'b1) next_state <= state_d0;
                else next_state <= COUNT;
            end


        endcase

    end











endmodule