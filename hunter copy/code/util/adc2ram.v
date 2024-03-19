module adc2ram(
    input clk,
    input rst,

    input fs,
    output fd,
    input [11:0] ram_txa_init,

    output reg [7:0] fifo_rxen,
    input [63:0] fifo_rxd,

    output ram_txen,
    output reg [7:0] ram_txd,
    output reg [11:0] ram_txa
);
    localparam DATA_LEN = 8'h40, CHIP_LEN = 4'h8;

    reg [3:0] state, next_state;

    localparam IDLE = 4'h0, WAIT = 4'h1, WORK = 4'h2, DONE = 4'h3;
    localparam INIT = 4'h4, REST = 4'h5;


    reg [7:0] data_num; 
    reg [3:0] chip_num;

    wire rxen;

    assign rxen = (state == WORK);
    assign ram_txen = (state == WORK);
    assign fd = (state == DONE);


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
                if(data_num >= DATA_LEN - 1'b1) next_state <= REST;
                else next_state <= WORK;
            end
            REST: begin
                if(chip_num >= CHIP_LEN - 1'b1) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin // data_num
        if(rst) data_num <= 8'h00;
        else if(state == INIT) data_num <= 8'h00;
        else if(state == WORK) data_num <= data_num + 1'b1;
        else data_num <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin // chip_num
        if(rst) chip_num <= 4'h0;
        else if(state == INIT) chip_num <= 4'h0;
        else if(state == REST) chip_num <= chip_num + 1'b1;
        else if(state == DONE) chip_num <= 4'h0;
        else chip_num <= chip_num;
    end

    always@(posedge clk or posedge rst) begin // ram_txa
        if(rst) ram_txa <= 12'h000;
        else if(state == INIT) ram_txa <= ram_txa_init;
        else if(state == WORK) ram_txa <= ram_txa + 1'b1;
        else ram_txa <= ram_txa;
    end

    always@(*) begin // fifo_rxd
        case(chip_num) 
            4'h0: ram_txd <= fifo_rxd[63:56];
            4'h1: ram_txd <= fifo_rxd[55:48];
            4'h2: ram_txd <= fifo_rxd[47:40];
            4'h3: ram_txd <= fifo_rxd[39:32];
            4'h4: ram_txd <= fifo_rxd[31:24];
            4'h5: ram_txd <= fifo_rxd[23:16];
            4'h6: ram_txd <= fifo_rxd[15:8];
            4'h7: ram_txd <= fifo_rxd[7:0];
            default: ram_txd <= 8'h00;
        endcase
    end

    always@(*) begin // fifo_rxen
        case(chip_num) 
            4'h0: fifo_rxen <= {rxen, 7'h00};
            4'h1: fifo_rxen <= {1'h0, rxen, 6'h00};
            4'h2: fifo_rxen <= {2'h0, rxen, 5'h00};
            4'h3: fifo_rxen <= {3'h0, rxen, 4'h0};
            4'h4: fifo_rxen <= {4'h0, rxen, 3'h0};
            4'h5: fifo_rxen <= {5'h00, rxen, 2'h0};
            4'h6: fifo_rxen <= {6'h00, rxen, 1'h0};
            4'h7: fifo_rxen <= {7'h00, rxen};
            default: fifo_rxen <= 8'h00;
        endcase
    end

endmodule