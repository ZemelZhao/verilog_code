module usb_rm(
    input clk,
    input rst,

    input fs,
    output fd,

    (*MARK_DEBUG = "true"*)input [11:0] ram_txa_init,

    (*MARK_DEBUG = "true"*)output reg [11:0] ram_txa,
    output [7:0] ram_txd,
    output reg ram_txen
);

    localparam NUM = 8'h20;
    localparam RAM_ADDR_INIT = 12'h000;

    (*MARK_DEBUG = "true"*)reg [3:0] state; 
    reg [7:0] next_state;
    localparam IDLE = 4'h1, WAIT = 4'h2, WORK = 4'h4, DONE =  4'h8;

    reg [7:0] num;

    assign ram_txd = 8'hFF;
    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state = IDLE;
        else state = next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state = WAIT;
            WAIT: begin
                if(fs) next_state = WORK;
                else next_state = WAIT;
            end
            WORK: begin
                if(num + 2'h2 >= NUM) next_state = DONE;
                else next_state = WORK;
            end
            DONE: begin
                if(~fs) next_state = WAIT;
                else next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == IDLE) num <= 8'h00;
        else if(state == WORK) num <= num + 1'b1;
        else num <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txa <= RAM_ADDR_INIT;
        else if(state == IDLE) ram_txa <= RAM_ADDR_INIT;
        else if(state == WAIT) ram_txa <= ram_txa_init;
        else if(state == WORK) ram_txa <= ram_txa + 1'b1;
        else ram_txa <= ram_txa;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txen <= 1'b0;
        else if(state == IDLE) ram_txen <= 1'b0;
        else if(state == WAIT && next_state == WORK) ram_txen <= 1'b1;
        else if(state == WAIT) ram_txen <= 1'b0;
        else if(state == WORK) ram_txen <= 1'b1;
        else ram_txen <= 1'b0;
    end

endmodule