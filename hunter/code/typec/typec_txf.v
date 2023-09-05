module typec_txf(
    input clk,
    input rst,

    input fs,

    input [7:0] din,
    output reg [3:0] dout,
    output reg fire
);

    localparam SYNC_DATA = 8'h0F;

    reg [3:0] state, next_state;
    localparam IDLE = 4'h0, WAIT = 4'h2, WORK = 4'h3, DONE = 4'h4;
    localparam W0 = 4'h8, W1 = 4'h9, G0 = 4'hA, G1 = 4'hB;

    // reg fire_s0, fire_s1;

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
                if(din == SYNC_DATA) next_state <= W1;
                else next_state <= WORK;
            end
            W0: next_state <= W1;
            W1: begin
                if(~fs) next_state <= G0;
                else next_state <= W0;
            end
            G0: next_state <= G1;
            G1: next_state <= DONE;
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fire <= 1'b0;
        else if(state == WORK) fire <= 1'b1;
        else if(state == W0) fire <= 1'b1;
        else if(state == W1) fire <= 1'b1;
        else if(state == G0) fire <= 1'b1;
        else if(state == G1) fire <= 1'b1;
        else fire <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dout <= 4'h0;
        else if(state == W0) dout <= din[7:4];
        else if(state == W1) dout <= din[3:0];
        else if(state == WORK) dout <= din[7:4];
        else dout <= 4'h0;
    end

        
endmodule