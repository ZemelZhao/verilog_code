module spi2fifo(
    input clk,
    input rst,
    
    input fs,
    output fd,

    input [15:0] chip_rxda, 
    input [15:0] chip_rxdb,

    input [3:0] fifo_full,
    output [1:0] fifo_txen,
    output [15:0] fifo_txd 
);

    reg [7:0] state; 
    reg [7:0] next_state;
    localparam IDLE = 8'h01, WAIT = 8'h02, WORK = 8'h04, DONE = 8'h08;
    localparam DAT0 = 8'h10, DAT1 = 8'h20;

    wire txen;

    assign fd = (state == DONE);
    assign fifo_txen = {txen, txen};
    assign fifo_txd = (state == DAT1) ?{chip_rxda[7:0], chip_rxdb[7:0]} :{chip_rxda[15:8], chip_rxdb[15:8]};
    assign txen = (state == DAT0) || (state == DAT1);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;

            WAIT: begin
                if(~|fifo_full) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(fs) next_state <= DAT0;
                else next_state <= WORK;
            end
            DAT0: next_state <= DAT1;
            DAT1: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

endmodule