module tb_ram(
    input clk,
    input rst
);
    localparam NUM = 4'h5;
    localparam DLEN = 12'h20;
    localparam RAM_ADDR = 12'h11;

    reg [3:0] state, next_state;
    localparam IDLE = 4'h0, WAIT = 4'h1, DONE = 4'h2;
    localparam RAM_TX = 4'h8, RAM_RX = 4'h9; 

    (*MARK_DEBUG = "true"*)wire fs_ram_tx, fs_ram_rx, fd_ram_tx, fd_ram_rx, fd_ram;
    (*MARK_DEBUG = "true"*)wire [11:0] ram_txa, ram_rxa;
    (*MARK_DEBUG = "true"*)wire [7:0] ram_txd, ram_rxd;
    (*MARK_DEBUG = "true"*)wire ram_txen;
    wire ram_txc, ram_rxc;

    reg [3:0] num;

    assign fd_ram = fd_ram_tx && fd_ram_rx;
    assign fs_ram_tx = (state == RAM_TX) || (state == RAM_RX);
    assign fs_ram_rx = (state == RAM_RX);
    assign ram_txc = clk;
    assign ram_rxc = clk;


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= RAM_TX;
            RAM_TX: begin
                if(num >= NUM - 1'b1) next_state <= RAM_RX;
                else next_state <= RAM_TX;
            end
            RAM_RX: begin
                if(fd_ram) next_state <= DONE;
                else next_state <= RAM_RX;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 4'h0;
        else if(state == IDLE) num <= 4'h0;
        else if(state == WAIT) num <= 4'h0;
        else if(state == RAM_TX) num <= num + 1'b1;
        else num <= 4'h0;
    end

    ram_tx
    ram_tx_dut(
        .clk(ram_txc),
        .rst(rst),

        .fs(fs_ram_tx),
        .fd(fd_ram_tx),

        .addr_init(RAM_ADDR),
        .data_len(DLEN),

        .ram_txa(ram_txa),
        .ram_txd(ram_txd),
        .ram_txen(ram_txen)
    );

    ram_rx
    ram_rx_dut(
        .clk(ram_rxc),
        .rst(rst),
        .fs(fs_ram_rx),
        .fd(fd_ram_rx),
        .ram_rxa_init(RAM_ADDR),
        .data_len(DLEN),
        .ram_rxa(ram_rxa),
        .ram_rxd(ram_rxd)
    );

    mmcm
    mmcm_dut(
        .clk_in(clk),
        .clk_out1(clk_25),
        .clk_out2(clk_100),
        .clk_out3(clk_200)
    );

    ram
    ram_dut(
        .clka(ram_txc),
        .addra(ram_txa),
        .dina(ram_txd),
        .wea(ram_txen),

        .clkb(ram_rxc),
        .addrb(ram_rxa),
        .doutb(ram_rxd)
    );





endmodule