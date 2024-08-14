module ram_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    input [7:0] bias,

    output reg [11:0] ram_txa,
    output reg [7:0] ram_txd,
    output reg ram_txen
);
    localparam NUM = 12'hF00;

    reg [3:0] state, next_state;
    localparam IDLE = 4'h1, WAIT = 4'h2, WORK = 4'h4, DONE = 4'h8;

    reg [11:0] num;

    assign fd = (state == DONE);

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
                if(num >= NUM - 1'b1) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(~fs) next_state <= DONE;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txa <= 16'h0000;
        else if(state == IDLE) ram_txa <= 16'h0000;
        else if(state == WAIT) ram_txa <= 16'h0000;
        else if(state == WORK) ram_txa <= num;
        else ram_txa <= 16'h0000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txd <= 8'h00;
        else if(state == IDLE) ram_txd <= 8'h00;
        else if(state == WAIT) ram_txd <= 8'h00;
        else if(state == WORK) ram_txd <= num[11:8] + num[7:0] + bias; 
        else ram_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txen <= 1'b0;
        else if(state == IDLE) ram_txen <= 1'b0;
        else if(state == WAIT) ram_txen <= 1'b0;
        else if(state == WORK) ram_txen <= 1'b1;
        else ram_txen <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 12'h000;
        else if(state == IDLE) num <= 12'h000;
        else if(state == WAIT) num <= 12'h000;
        else if(state == WORK) num <= num + 1'b1;
        else num <= 12'h000;
    end

endmodule