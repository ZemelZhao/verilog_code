module ram_rx(
    input clk,
    input rst,

    input fs,
    output fd,
    input [11:0] ram_rxa_init,

    output reg [11:0] ram_rxa,
    input [7:0] ram_rxd,
    output ram_rxen
);

    localparam DATA_LEN = 8'h100;
    reg [3:0] state, next_state;

    localparam IDLE = 4'h0, WAIT = 4'h1, WORK = 4'h2, DONE = 4'h3;
    localparam INIT = 4'h4;

    reg [7:0] num;

    assign fd = (state == DONE);
    assign ram_rxen = (state == WORK);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= INIT;
                else next_state <= WAIT;
            end
            INIT: next_state <= WORK;
            WORK: begin
                if(num >= DATA_LEN - 1'b1) next_state <= DONE;
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
        if(rst) ram_rxa <= 12'h000;
        else if(state == WAIT) ram_rxa <= ram_rxa_init;
        else if(state == WORK) ram_rxa <= ram_rxa + 1'b1;
        else ram_rxa <= ram_rxa;
    end


    always@(posedge clk or posedge rst) begin // num
        if(rst) num <= 8'h00;
        else if(state == INIT) num <= 8'h00;
        else if(state == WORK) num <= num + 1'b1;
        else num <= 8'h00;
    end


endmodule