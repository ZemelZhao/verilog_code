module ram_tx(
    input clk,
    input rst,

    input fs,
    output fd,

    input [11:0] addr_init,
    input [11:0] data_len,

    output reg [11:0] ram_txa,
    output [7:0] ram_txd,
    output ram_txen
);

    reg [1:0] state, next_state;
    localparam IDLE = 2'b00, WAIT = 2'b01, WORK = 2'b10, DONE = 2'b11;

    reg [11:0] num;

    assign fd = (state == DONE);
    assign ram_txd = ram_txa[7:0];
    assign ram_txen = (state == WORK);

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
                if(num >= data_len - 1'b1) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@ (posedge clk or posedge rst) begin
        if(rst) ram_txa <= 12'h000;
        else if(state == IDLE) ram_txa <= addr_init;
        else if(state == WAIT) ram_txa <= addr_init;
        else if(state == WORK) ram_txa <= ram_txa + 1'b1;
        else ram_txa <= addr_init;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 12'h000;
        else if(state == IDLE) num <= 12'h000;
        else if(state == WAIT) num <= 12'h000;
        else if(state == WORK) num <= num + 1'b1;
        else num <= 12'h000;
    end


    



endmodule