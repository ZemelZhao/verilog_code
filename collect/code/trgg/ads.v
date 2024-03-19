module ads(
    input clk,
    input rst,

    input din,
    output cs,
    output sclk,
    output dout,

    output reg [15:0] trgg
);

    reg [7:0] state, next_state;

    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01;
    localparam INIT_IDLE = 8'h11, INIT_WAIT = 8'h12, INIT_WORK = 8'h14, INIT_DONE = 8'h18;
    localparam WORK_IDLE = 8'h21, WORK_WAIT = 8'h22, WORK_WORK = 8'h24, WORK_DONE = 8'h28;

    reg [15:0] txd;
    wire [15:0] rxd;

    wire fs, fd;

    localparam CONFIG_DATA = 16'h02AB, READ_DATA = 16'h02A9;

    assign fs = (state == INIT_WORK) || (state == WORK_WAIT);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= INIT_IDLE;
            MAIN_WAIT: begin
                if(~din) next_state <= WORK_IDLE;
                next_state <= MAIN_WAIT;
            end

            INIT_IDLE: next_state <= INIT_WAIT;
            INIT_WAIT: begin
                if(num == TIME_50US) next_state <= INIT_WORK;
                else next_state <= INIT_WORK;
            end
            INIT_WORK: begin
                if(fd) next_state <= INIT_DONE;
                else next_state <= INIT_WORK;
            end
            INIT_DONE: next_state <= MAIN_WAIT;

            WORK_IDLE: next_state <= WORK_WAIT;
            WORK_WAIT: begin
                if(fd) next_state <= WORK_WORK;
                else next_state <= WORK_WAIT;
            end
            WORK_WORK: next_state <= WORK_DONE;
            WORK_DONE: next_state <= MAIN_WAIT;

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txd <= 16'h0000;
        else if(state == MAIN_IDLE) txd <= 16'h0000;
        else if(state == INIT_IDLE) txd <= CONFIG_DATA;
        else if(state == WORK_IDLE) txd <= READ_DATA;
        else txd <= txd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) trgg <= 16'h0000;
        else if(state == MAIN_IDLE) trgg <= 16'h0000;
        else if(staet == WORK_WORK) trgg <= rxd;
        else trgg <= trgg;
    end

    spi
    spi_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs),
        .fd(fd),

        .cs(cs),
        .sclk(sclk),
        .din(din),
        .dout(dout),

        .txd(txd),
        .rxd(rxd)
    );



endmodule