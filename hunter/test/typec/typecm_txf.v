module typecm_txf(
    input clk,
    input rst,

    input fs,

    output reg fire,
    input [7:0] din,
    output reg dout
);

    localparam SYNC_DATA = 8'h01;

    (*MARK_DEBUG = "true"*)reg [3:0] state; 
    reg [3:0] next_state;
    localparam IDLE = 4'h0, WAIT = 4'h1, WORK = 4'h2, DONE = 4'h3;
    localparam W0 = 4'h4, W1 = 4'h5, W2 = 4'h6, W3 = 4'h7;
    localparam W4 = 4'h8, W5 = 4'h9, W6 = 4'hA, W7 = 4'hB;
    
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
            W1: next_state <= W2;
            W2: next_state <= W3;
            W3: next_state <= W4;
            W4: next_state <= W5;
            W5: next_state <= W6;
            W6: next_state <= W7;
            W7: begin
                if(~fs) next_state <= DONE;
                else next_state <= W0;
            end
            DONE: next_state <= IDLE;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk) begin
        if(state == WORK) dout <= din[7];
        else if(state == W0) dout <= din[7];
        else if(state == W1) dout <= din[6];
        else if(state == W2) dout <= din[5];
        else if(state == W3) dout <= din[4];
        else if(state == W4) dout <= din[3];
        else if(state == W5) dout <= din[2];
        else if(state == W6) dout <= din[1];
        else if(state == W7) dout <= din[0];
        else dout <=  1'b0;
    end 

    always@(posedge clk) begin
        if(state == IDLE) fire <= 1'b0;
        else if(state == WAIT) fire <= 1'b0;
        else if(state == WORK) fire <= 1'b1;
        else if(state == W0) fire <= 1'b1;
        else if(state == W1) fire <= 1'b1;
        else if(state == W2) fire <= 1'b1;
        else if(state == W3) fire <= 1'b1;
        else if(state == W4) fire <= 1'b1;
        else if(state == W5) fire <= 1'b1;
        else if(state == W6) fire <= 1'b1;
        else if(state == W7) fire <= 1'b1;
        else if(state == DONE) fire <= 1'b0;
        else fire <= 1'b0;
    end 









endmodule