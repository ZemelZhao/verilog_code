module tb_ram2fifo(
    input clk,
    input rst
);

    localparam RAM_RXA_INIT = 12'h031;
    localparam RAM_RXLEN = 12'h30;

    (*MARK_DEBUG = "true"*)reg [3:0] state; 
    reg [3:0] next_state;
    localparam IDLE = 4'h0, WAIT = 4'h1, DONE = 4'h2;
    localparam RAM_TX = 4'h8, TRAN = 4'h9, FIFO_RX = 4'hA;

    wire [95:0] ram_txa, ram_rxa;
    wire [63:0] ram_txd, ram_rxd;
    wire [7:0] ram_txen;

    (*MARK_DEBUG = "true"*)wire [7:0] fifo_txd, fifo_rxd;
    wire fifo_txen, fifo_rxen; 

    wire fs_tx, fd_tx;
    wire [7:0] cache_fd_tx;
    wire fs_rx, fd_rx;
    wire fs_tran, fd_tran;

    wire fifo_full;
    wire [7:0] link;

    reg [7:0] num;

    wire clk_25, clk_50, clk_100, clk_200;

    assign fs_tx = (state == RAM_TX);
    assign fs_tran = (state == TRAN) || (state == FIFO_RX);
    assign fs_rx = (state == FIFO_RX);
    assign link = 8'hFF;
    assign clk_50 = clk;
    assign fd_tx = &cache_fd_tx;

    always@(posedge clk_50 or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= RAM_TX;
            RAM_TX: begin
                if(fd_tx) next_state <= TRAN;
                else next_state <= RAM_TX;
            end
            TRAN: begin
                if(num >= 8'h20) next_state <= FIFO_RX; 
                else next_state <= TRAN;
            end
            // TRAN: begin
            //     if(fd_tran) next_state <= FIFO_RX;
            //     else next_state <= TRAN;
            // end
            FIFO_RX: begin
                if(fd_rx) next_state <= DONE;
                else next_state <= FIFO_RX;
            end
            DONE: next_state <= TRAN;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk_50 or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == TRAN) num <= num + 1'b1;
        else num <= 8'h00;
    end

    mmcm
    mmcm_dut(
        .clk_in(clk),
        .clk_out1(clk_25),
        .clk_out2(clk_100),
        .clk_out3(clk_200)
    );



    ram2fifo
    ram2fifo_dut(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tran),
        .fd(fd_tran),

        .ram_rxa_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .link(link),

        .ram_rxd(ram_rxd),
        .ram_rxa(ram_rxa),

        .fifo_full(fifo_full),
        .fifo_txd(fifo_txd),
        .fifo_txen(fifo_txen)
    );

    fifo_rx
    fifo_rx_dut(
        .clk(clk_100),
        .rst(rst),

        .fs(fs_rx),
        .fd(fd_rx),

        .data_len(16'h018A),

        .fifo_rxen(fifo_rxen),
        .fifo_rxd(fifo_rxd)
    );


    ram_tx
    ram_tx_dut_00(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tx),
        .fd(cache_fd_tx[7]),
        .bias(8'h01),

        .addr_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .ram_txa(ram_txa[95:84]),
        .ram_txd(ram_txd[63:56]),
        .ram_txen(ram_txen[7])
    );

    ram_tx
    ram_tx_dut_01(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tx),
        .fd(cache_fd_tx[6]),
        .bias(8'h03),

        .addr_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .ram_txa(ram_txa[83:72]),
        .ram_txd(ram_txd[55:48]),
        .ram_txen(ram_txen[6])
    );

    ram_tx
    ram_tx_dut_02(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tx),
        .fd(cache_fd_tx[5]),
        .bias(8'h05),

        .addr_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .ram_txa(ram_txa[71:60]),
        .ram_txd(ram_txd[47:40]),
        .ram_txen(ram_txen[5])
    );

    ram_tx
    ram_tx_dut_03(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tx),
        .fd(cache_fd_tx[4]),
        .bias(8'h07),

        .addr_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .ram_txa(ram_txa[59:48]),
        .ram_txd(ram_txd[39:32]),
        .ram_txen(ram_txen[4])
    );

    ram_tx
    ram_tx_dut_04(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tx),
        .fd(cache_fd_tx[3]),
        .bias(8'h09),

        .addr_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .ram_txa(ram_txa[47:36]),
        .ram_txd(ram_txd[31:24]),
        .ram_txen(ram_txen[3])
    );

    ram_tx
    ram_tx_dut_05(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tx),
        .fd(cache_fd_tx[2]),
        .bias(8'h0B),

        .addr_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .ram_txa(ram_txa[35:24]),
        .ram_txd(ram_txd[23:16]),
        .ram_txen(ram_txen[2])
    );

    ram_tx
    ram_tx_dut_06(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tx),
        .fd(cache_fd_tx[1]),
        .bias(8'h0D),

        .addr_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .ram_txa(ram_txa[23:12]),
        .ram_txd(ram_txd[15:8]),
        .ram_txen(ram_txen[1])
    );

    ram_tx
    ram_tx_dut_07(
        .clk(clk_200),
        .rst(rst),

        .fs(fs_tx),
        .fd(cache_fd_tx[0]),
        .bias(8'h0F),

        .addr_init(RAM_RXA_INIT),
        .data_len(RAM_RXLEN),
        .ram_txa(ram_txa[11:0]),
        .ram_txd(ram_txd[7:0]),
        .ram_txen(ram_txen[0])
    );

    ram
    ram_dut00(
        .clka(clk_200),
        .addra(ram_txa[95:84]),
        .dina(ram_txd[63:56]),
        .wea(ram_txen[7]),
        .clkb(clk_200),
        .addrb(ram_rxa[95:84]),
        .doutb(ram_rxd[63:56])
    );

    ram
    ram_dut01(
        .clka(clk_200),
        .addra(ram_txa[83:72]),
        .dina(ram_txd[55:48]),
        .wea(ram_txen[6]),
        .clkb(clk_200),
        .addrb(ram_rxa[83:72]),
        .doutb(ram_rxd[55:48])
    );

    ram
    ram_dut02(
        .clka(clk_200),
        .addra(ram_txa[71:60]),
        .dina(ram_txd[47:40]),
        .wea(ram_txen[5]),
        .clkb(clk_200),
        .addrb(ram_rxa[71:60]),
        .doutb(ram_rxd[47:40])
    );

    ram
    ram_dut03(
        .clka(clk_200),
        .addra(ram_txa[59:48]),
        .dina(ram_txd[39:32]),
        .wea(ram_txen[4]),
        .clkb(clk_200),
        .addrb(ram_rxa[59:48]),
        .doutb(ram_rxd[39:32])
    );

    ram
    ram_dut04(
        .clka(clk_200),
        .addra(ram_txa[47:36]),
        .dina(ram_txd[31:24]),
        .wea(ram_txen[3]),
        .clkb(clk_200),
        .addrb(ram_rxa[47:36]),
        .doutb(ram_rxd[31:24])
    );

    ram
    ram_dut05(
        .clka(clk_200),
        .addra(ram_txa[35:24]),
        .dina(ram_txd[23:16]),
        .wea(ram_txen[2]),
        .clkb(clk_200),
        .addrb(ram_rxa[35:24]),
        .doutb(ram_rxd[23:16])
    );

    ram
    ram_dut06(
        .clka(clk_200),
        .addra(ram_txa[23:12]),
        .dina(ram_txd[15:8]),
        .wea(ram_txen[1]),
        .clkb(clk_200),
        .addrb(ram_rxa[23:12]),
        .doutb(ram_rxd[15:8])
    );

    ram
    ram_dut07(
        .clka(clk_200),
        .addra(ram_txa[11:0]),
        .dina(ram_txd[7:0]),
        .wea(ram_txen[0]),
        .clkb(clk_200),
        .addrb(ram_rxa[11:0]),
        .doutb(ram_rxd[7:0])
    );

    fifo
    fifo_dut(
        .wr_clk(clk_200),
        .full(fifo_full),
        .din(fifo_txd),
        .wr_en(fifo_txen),

        .rd_clk(clk_100),
        .dout(fifo_rxd),
        .rd_en(fifo_rxen)
    );

endmodule

