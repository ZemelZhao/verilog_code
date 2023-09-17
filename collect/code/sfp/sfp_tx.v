module gtx_send(
    input sfp_txc,
    input rst,

    input fs,
    output fd,

    input [15:0] data_len,

    input [7:0] tx_type,
    input [31:0] tx_data,

    output reg [31:0] gtx_txd,
    output reg [3:0] gtx_txctl
);

    reg [3:0] state, next_state;

    localparam IDLE = 4'h0, WAIT = 4'h1, DONE = 4'h2;
    localparam HEAD = 4'h4, SNUM = 4'h5, CTRL = 4'h6, DATA = 4'h7;
    localparam PART = 4'h8;

    reg [15:0] cnt;
    reg [31:0] part;

    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= HEAD; 
                else next_state <= WAIT;
            end
            HEAD: next_state <= SNUM;
            SNUM: next_state <= CTRL;
            CTRL: next_state <= DATA;
            DATA: begin
                if(cnt <= data_len - 1'b1) next_state <= PART;
                else next_state <= DATA;
            end
            PART: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 16'h0000;
        else if(state == IDLE) cnt <= 16'h0000;
        else if(state == WAIT) cnt <= 16'h0000;
        else if(state == DATA) cnt <= cnt + 1'b1;
        else cnt <= 16'h0000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) part <= 32'h0000;
        else if(state == IDLE) part <= 32'h0000;
        else if(state == WAIT) part <= 32'h0000;
        else if(state == SNUM) part <= 32'h0000;
        else if(state == DATA) part <= part + tx_data;
        else part <= part;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) gtx_txd <= 32'h0000_0000;
        else if(state == IDLE) gtx_txd <= 32'h0000_0000;
        else if(state == WAIT) gtx_txd <= 32'h0000_0000;
        
    end









endmodule