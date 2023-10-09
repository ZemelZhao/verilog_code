module tb_adc2ram(
    input clk,
    input rst
);

    (*MARK_DEBUG = "true"*)wire [7:0] fifo_txd;
    (*MARK_DEBUG = "true"*)wire fifo_txen;
    (*MARK_DEBUG = "true"*)wire [63:0] fifo_rxd;
    (*MARK_DEBUG = "true"*)wire [7:0] fifo_rxen;

    (*MARK_DEBUG = "true"*)wire ram_txen;
    (*MARK_DEBUG = "true"*)wire [11:0] ram_tx_addr;
    (*MARK_DEBUG = "true"*)wire [7:0] ram_txd;

    (*MARK_DEBUG = "true"*)wire [11:0] ram_rx_addr;
    (*MARK_DEBUG = "true"*)wire [7:0] ram_rxd;

    (*MARK_DEBUG = "true"*)wire fs_fifo_tx;
    (*MARK_DEBUG = "true"*)wire fd_fifo_tx;
    (*MARK_DEBUG = "true"*)wire fs_tran;
    (*MARK_DEBUG = "true"*)wire fd_tran;
    (*MARK_DEBUG = "true"*)wire fs_ram_rx;
    (*MARK_DEBUG = "true"*)wire fd_ram_rx;


    wire [7:0] cache_fifo_full;
    wire fifo_full;

    (*MARK_DEBUG = "true"*)reg [7:0] state; 
    reg [7:0] next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h03, REST = 8'h02;
    localparam FIFO_TX = 8'h10, FIFO_RX = 8'h11, RAM_TX = 8'h12, RAM_RX = 8'h13;

    assign fifo_full = |(cache_fifo_full);
    assign fs_tran = (state == FIFO_RX) || (state == RAM_TX);
    assign fs_ram_rx = (state == RAM_RX);
    assign fs_fifo_tx = (state == FIFO_TX);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= FIFO_TX;
            FIFO_TX: begin
                if(fd_fifo_tx) next_state <= FIFO_RX; 
                else next_state <= FIFO_TX;
            end
            FIFO_RX: begin
                if(fd_tran) next_state <= REST;
                else next_state <= FIFO_RX;
            end
            REST: next_state <= RAM_TX;
            RAM_TX: begin
                if(fd_tran) next_state <= RAM_RX;
                else next_state <= RAM_TX;
            end
            RAM_RX: begin
                if(fd_ram_rx) next_state <= DONE; 
                else next_state <= RAM_RX;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end


    fifo
    fifo_duta(
        .wr_clk(clk),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd[63:56]),
        .rd_en(fifo_rxen[7]),

        .full(cache_fifo_full[7])
    );

    fifo
    fifo_dutb(
        .wr_clk(clk),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd[55:48]),
        .rd_en(fifo_rxen[6]),

        .full(cache_fifo_full[6])
    );

    fifo
    fifo_dutc(
        .wr_clk(clk),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd[47:40]),
        .rd_en(fifo_rxen[5]),

        .full(cache_fifo_full[5])
    );

    fifo
    fifo_dutd(
        .wr_clk(clk),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd[39:32]),
        .rd_en(fifo_rxen[4]),

        .full(cache_fifo_full[4])
    );

    fifo
    fifo_dute(
        .wr_clk(clk),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd[31:24]),
        .rd_en(fifo_rxen[3]),

        .full(cache_fifo_full[3])
    );

    fifo
    fifo_dutf(
        .wr_clk(clk),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd[23:16]),
        .rd_en(fifo_rxen[2]),

        .full(cache_fifo_full[2])
    );

    fifo
    fifo_dutg(
        .wr_clk(clk),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd[15:8]),
        .rd_en(fifo_rxen[1]),

        .full(cache_fifo_full[1])
    );

    fifo
    fifo_duth(
        .wr_clk(clk),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk),
        .dout(fifo_rxd[7:0]),
        .rd_en(fifo_rxen[0]),

        .full(cache_fifo_full[0])
    );

    fifo_tx
    fifo_tx_dut(
        .clk(clk),
        .rst(rst),
        .full(fifo_full),
        .fs(fs_fifo_tx),
        .fd(fd_fifo_tx),
        .fifo_txen(fifo_txen),
        .fifo_txd(fifo_txd)
    );

    adc2ram
    adc2ram_dut(
        .clk(clk),
        .rst(rst),
        .fs(fs_tran),
        .fd(fd_tran),
        .ram_txa_init(12'h100),
        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd),
        .ram_txen(ram_txen),
        .ram_txd(ram_txd),
        .ram_txa(ram_tx_addr)
    );

    ram_rx
    ram_rx_dut(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_rx),
        .fd(fd_ram_rx),
        .ram_rxa_init(12'h100),
        .ram_rxa(ram_rx_addr),
        .ram_rxd(ram_rxd),
        .ram_rxen(ram_rxen)
    );

    ram
    ram_dut(
        .clka(clk),
        .addra(ram_tx_addr),
        .dina(ram_txd),
        .wea(ram_txen),

        .clkb(clk),
        .addrb(ram_rx_addr),
        .doutb(ram_rxd)
    );


endmodule