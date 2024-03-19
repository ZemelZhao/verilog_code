module typec_rxf(
    input clk,
    input rst,

    input din,
    input fire,
    output reg [7:0] dout
);

    localparam SYNC_DATA = 8'h01;

    reg [3:0] state; 
    reg [3:0] next_state;
    localparam IDLE = 4'h0, WAIT = 4'h1, WORK = 4'h2, DONE = 4'h3;
    localparam R0 = 4'h4, R1 = 4'h5, R2 = 4'h6, R3 = 4'h7;
    localparam R4 = 4'h8, R5 = 4'h9, R6 = 4'hA, R7 = 4'hB;

    reg [6:0] tmp_rxd;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fire) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(din == SYNC_DATA[0]) next_state <= R0;
                else next_state <= WORK;
            end
            R0: next_state <= R1;
            R1: next_state <= R2;
            R2: next_state <= R3;
            R3: next_state <= R4;
            R4: next_state <= R5;
            R5: next_state <= R6;
            R6: next_state <= R7;
            R7: begin
                if(~fire) next_state <= DONE;
                else next_state <= R0;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk) begin
        if(state == IDLE) tmp_rxd <= 7'h00;
        else if(state == WAIT) tmp_rxd <= 7'h00;
        else if(state == R0) tmp_rxd[6] <= din;
        else if(state == R1) tmp_rxd[5] <= din;
        else if(state == R2) tmp_rxd[4] <= din;
        else if(state == R3) tmp_rxd[3] <= din;
        else if(state == R4) tmp_rxd[2] <= din;
        else if(state == R5) tmp_rxd[1] <= din;
        else if(state == R6) tmp_rxd[0] <= din;
        else if(state == DONE) tmp_rxd <= 7'h00;
        else tmp_rxd <= tmp_rxd;
    end 

    always@(posedge clk) begin
        if(state == IDLE) dout <= 8'h00;
        else if(state == WAIT) dout <= 8'h00;
        else if(state == WORK) dout <= {tmp_rxd, din};
        else if(state == R7) dout <= {tmp_rxd, din};
        else if(state == DONE) dout <= 8'h00;
        else dout <= dout;
    end

endmodule