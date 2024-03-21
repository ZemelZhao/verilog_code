module usb_rxf(
    input clk,
    input rst,

    input [3:0] din,
    input fire,
    (*MARK_DEBUG = "true"*)output reg [7:0] dout
);

    localparam SYNC_DATA = 8'h0F;

    (*MARK_DEBUG = "true"*)reg [3:0] state; 
    reg [3:0] next_state;
    localparam IDLE = 4'h0, WAIT = 4'h1, WORK = 4'h2, DONE = 4'h3;
    localparam R0 = 4'h5, R1 = 4'h6;

    (*MARK_DEBUG = "true"*)reg [3:0] tmp_rxd;

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
                if(din == SYNC_DATA[3:0]) next_state <= R0;
                else next_state <= WORK;
            end
            R0: next_state <= R1;
            R1: begin
                if(~fire) next_state <= DONE;
                else next_state <= R0;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk) begin
        if(state == IDLE) tmp_rxd <= 4'h0;
        else if(state == WAIT) tmp_rxd <= 4'h0; 
        else if(state == R0) tmp_rxd <= din;
        else if(state == DONE) tmp_rxd <= 4'h0;
        else tmp_rxd <=  tmp_rxd;
    end

    always@(posedge clk) begin
        if(state ==  IDLE) dout <= 8'h00;
        else if(state == WAIT) dout <= 8'h00;
        else if(state == WORK) dout <= {tmp_rxd, din};
        else if(state == R1)  dout <= {tmp_rxd, din};
        else if(state == DONE) dout <= 8'h00;
        else dout <= dout;
    end

endmodule