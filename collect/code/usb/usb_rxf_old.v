module usb_rxf(
    input clk,
    input rst,

    input fire,
    (*MARK_DEBUG = "true"*)input [3:0] din,
    (*MARK_DEBUG = "true"*)output reg [7:0] dout
);

    // PREAMBLE CODE 5A 5A 5A 5A 0F
    localparam PID_PREM = 8'h5A;
    localparam PID_SYNC = 8'h0F;

    (*MARK_DEBUG = "true"*)reg [11:0] state, next_state;
    localparam IDLE = 12'h001, WAIT = 12'h002, WORK = 12'h004, DONE = 12'h008; 
    localparam SYNC = 12'h010, READ0 = 12'h020, READ1 = 12'h040;
    localparam SYNC0 = 12'h100, SYNC1 = 12'h200, SYNC2 = 12'h400, SYNC3 = 12'h800;

    (*MARK_DEBUG = "true"*)reg [7:0] pos_rxd0, pos_rxd1; 
    (*MARK_DEBUG = "true"*)reg [7:0] neg_rxd0, neg_rxd1;

    (*MARK_DEBUG = "true"*)reg [3:0] sync;
    (*MARK_DEBUG = "true"*)reg [7:0] data;
    (*MARK_DEBUG = "true"*)reg num;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fire) next_state <= SYNC;
                else next_state <= WAIT;
            end
            SYNC: begin
                if(pos_rxd0 == PID_PREM) next_state <= SYNC0;
                else if(pos_rxd1 == PID_PREM) next_state <= SYNC1;
                else if(neg_rxd0 == PID_PREM) next_state <= SYNC2;
                else if(neg_rxd1 == PID_PREM) next_state <= SYNC3;
                else next_state <= SYNC;
            end
            SYNC0: begin
                if(pos_rxd0 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC1: begin
                if(pos_rxd1 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC2: begin
                if(neg_rxd0 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC3: begin
                if(neg_rxd1 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end

            WORK: begin
                if(data == PID_SYNC) next_state <= READ1;
                else next_state <= WORK;
            end
            READ0: next_state <= READ1;
            READ1: begin
                if(~fire) next_state <= DONE;
                else next_state <= READ0;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) sync <= 4'h0;
        else if(state == WAIT) sync <= 4'h0;
        else if(state == SYNC) sync <= 4'h0;
        else if(state == DONE) sync <= 4'b0;
        else if(state == SYNC0) sync <= 4'h1;
        else if(state == SYNC1) sync <= 4'h2;
        else if(state == SYNC2) sync <= 4'h4;
        else if(state == SYNC3) sync <= 4'h8;
        else sync <= sync;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data <= 8'h00;
        else if(sync == 4'h0) data <= 8'h00;
        else if(sync == 4'h1) data <= pos_rxd0;
        else if(sync == 4'h2) data <= pos_rxd1;
        else if(sync == 4'h4) data <= neg_rxd0;
        else if(sync == 4'h8) data <= neg_rxd1;
        else data <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dout <= 8'h00;
        else if(state == IDLE) dout <= 8'h00;
        else if(state == WAIT) dout <= 8'h00;
        else if(state == DONE) dout <= 8'h00;
        else if(state == WORK && data == PID_SYNC) dout <= data;
        else if(state == READ0) dout <= data;
        else dout <= dout;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd0 <= 8'h00;
        else if(state == WAIT) pos_rxd0 <= 8'h00;
        else if(num == 1'b0) pos_rxd0 <= {din, pos_rxd0[3:0]};
        else if(num == 1'b1) pos_rxd0 <= {pos_rxd0[7:4], din};
        else pos_rxd0 <= pos_rxd0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd1 <= 8'h00;
        else if(state == WAIT) pos_rxd1 <= 8'h00;
        else if(num == 1'b0) pos_rxd1 <= {pos_rxd1[7:4], din};
        else if(num == 1'b1) pos_rxd1 <= {din, pos_rxd1[3:0]};
        else pos_rxd1 <= pos_rxd1;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd0 <= 8'h00;
        else if(state == WAIT) neg_rxd0 <= 8'h00;
        else if(num == 1'b0) neg_rxd0 <= {din, neg_rxd0[3:0]};
        else if(num == 1'b1) neg_rxd0 <= {neg_rxd0[7:4], din};
        else neg_rxd0 <= neg_rxd0;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd1 <= 8'h00;
        else if(state == WAIT) neg_rxd1 <= 8'h00;
        else if(num == 1'b0) neg_rxd1 <= {neg_rxd1[7:4], din};
        else if(num == 1'b1) neg_rxd1 <= {din, neg_rxd1[3:0]};
        else neg_rxd1 <= neg_rxd1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 1'b0;
        else if(state == IDLE) num <= 1'b0;
        else num <= ~num;
    end

endmodule