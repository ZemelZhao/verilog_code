module tb_data_make(
    input clk,
    input rst
);

    wire [11:0] cache_ram_txa0, cache_ram_txa1, cache_ram_txa2, cache_ram_txa3;
    wire [11:0] cache_ram_txa4, cache_ram_txa5, cache_ram_txa6, cache_ram_txa7;
    wire [7:0] cache_ram_txd0, cache_ram_txd1, cache_ram_txd2, cache_ram_txd3;
    wire [7:0] cache_ram_txd4, cache_ram_txd5, cache_ram_txd6, cache_ram_txd7;
    wire cache_ram_txen0, cache_ram_txen1, cache_ram_txen2, cache_ram_txen3;
    wire cache_ram_txen4, cache_ram_txen5, cache_ram_txen6, cache_ram_txen7;

    wire [7:0] fd_ram_tx;

    wire [63:0] cache_ram_rxd;
    wire [11:0] cache_ram_rxa;
    wire [47:0] cache_stat;

    wire [15:0] ram_txa;
    wire [7:0] ram_txd;
    wire ram_txen;

    reg [3:0] num, btype, data_idx;

    localparam BAG_STAT = 4'h1, BAG_DATA = 4'h5, BAG_INIT = 4'h0;

    assign cache_stat = 48'hC3007F3A1234;
    assign fs_ram_tx = (state == RAM_TX);
    assign fs_tran = (state == STAT_WORK) || (state == DATA_WORK);

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, RAM_TX = 8'h02;
    localparam STAT_IDLE = 8'h10, STAT_WORK = 8'h11;
    localparam DATA_IDLE = 8'h20, DATA_WORK = 8'h21, DATA_DONE = 8'h22;

    localparam NUM = 4'h8;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= RAM_TX;
            RAM_TX: begin
                if(&fd_ram_tx) next_state <= STAT_IDLE;
                else next_state <= RAM_TX;
            end

            STAT_IDLE: next_state <= STAT_WORK;
            STAT_WORK: begin
                if(fd_tran) next_state <= DATA_IDLE;
                else next_state <= STAT_WORK;
            end

            DATA_IDLE: next_state <= DATA_WORK;
            DATA_WORK: begin
                if(fd_tran)  next_state <= DATA_DONE;
                else next_state <= DATA_WORK;
            end
            DATA_DONE: begin
                if(num >= NUM - 1'b1) next_state <= DATA_IDLE;
                else next_state <= DATA_DONE;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 4'h0;
        else if(state == DATA_DONE) num <= num + 1'b1;
        else num <= 4'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) btype <= BAG_INIT;
        else if(state == IDLE) btype <= BAG_INIT;
        else if(state == WAIT) btype <= BAG_INIT;
        else if(state == STAT_IDLE) btype <= BAG_STAT;
        else if(state == DATA_IDLE) btype <= BAG_DATA;
        else btype <= btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_idx <= 4'h0;
        else if(state == IDLE) data_idx <= 4'h0; 
        else if(state == WAIT) data_idx <= 4'h0;
        else if(state == DATA_IDLE && data_idx >= 4'h5) data_idx <= 4'h0; 
        else if(state == DATA_IDLE) data_idx <= data_idx + 1'b1;
        else data_idx <= data_idx;
    end




    data_make
    data_make_dut(
        .clk(clk),
        .rst(rst),

        .fs(fs_tran),
        .fd(fd_tran),
        .btype(btype),
        .data_idx(data_idx),
        .cache_stat(cache_stat),
        .cache_ram_rxa(cache_ram_rxa),
        .cache_ram_rxd(cache_ram_rxd),

        .ram_txa(ram_txa),
        .ram_txd(ram_txd),
        .ram_txen(ram_txen)
    );


    ram_tx
    ram_tx_dut0(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx[0]),

        .bias(8'h01),
        .ram_txa(cache_ram_txa0),
        .ram_txd(cache_ram_txd0),
        .ram_txen(cache_ram_txen0)
    );

    ram_tx
    ram_tx_dut1(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx[1]),

        .bias(8'h03),
        .ram_txa(cache_ram_txa1),
        .ram_txd(cache_ram_txd1),
        .ram_txen(cache_ram_txen1)
    );

    ram_tx
    ram_tx_dut2(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx[2]),

        .bias(8'h05),
        .ram_txa(cache_ram_txa2),
        .ram_txd(cache_ram_txd2),
        .ram_txen(cache_ram_txen2)
    );

    ram_tx
    ram_tx_dut3(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx[3]),

        .bias(8'h07),
        .ram_txa(cache_ram_txa3),
        .ram_txd(cache_ram_txd3),
        .ram_txen(cache_ram_txen3)
    );

    ram_tx
    ram_tx_dut4(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx[4]),

        .bias(8'h09),
        .ram_txa(cache_ram_txa4),
        .ram_txd(cache_ram_txd4),
        .ram_txen(cache_ram_txen4)
    );


    ram_tx
    ram_tx_dut5(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx[5]),

        .bias(8'h0B),
        .ram_txa(cache_ram_txa5),
        .ram_txd(cache_ram_txd5),
        .ram_txen(cache_ram_txen5)
    );

    ram_tx
    ram_tx_dut6(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx[6]),

        .bias(8'h0D),
        .ram_txa(cache_ram_txa6),
        .ram_txd(cache_ram_txd6),
        .ram_txen(cache_ram_txen6)
    );

    ram_tx
    ram_tx_dut7(
        .clk(clk),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx[7]),

        .bias(8'h0F),
        .ram_txa(cache_ram_txa7),
        .ram_txd(cache_ram_txd7),
        .ram_txen(cache_ram_txen7)
    );

    ram_usb
    ram_usb_dut0(
        .clka(clk),
        .addra(cache_ram_txa0),
        .dina(cache_ram_txd0),
        .wea(cache_ram_txen0),

        .clkb(clk),
        .addrb(cache_ram_rxa),
        .doutb(cache_ram_rxd[63:56])
    );

    ram_usb
    ram_usb_dut1(
        .clka(clk),
        .addra(cache_ram_txa1),
        .dina(cache_ram_txd1),
        .wea(cache_ram_txen1),

        .clkb(clk),
        .addrb(cache_ram_rxa),
        .doutb(cache_ram_rxd[55:48])
    );

    ram_usb
    ram_usb_dut2(
        .clka(clk),
        .addra(cache_ram_txa2),
        .dina(cache_ram_txd2),
        .wea(cache_ram_txen2),

        .clkb(clk),
        .addrb(cache_ram_rxa),
        .doutb(cache_ram_rxd[47:40])
    );

    ram_usb
    ram_usb_dut3(
        .clka(clk),
        .addra(cache_ram_txa3),
        .dina(cache_ram_txd3),
        .wea(cache_ram_txen3),

        .clkb(clk),
        .addrb(cache_ram_rxa),
        .doutb(cache_ram_rxd[39:32])
    );

    ram_usb
    ram_usb_dut4(
        .clka(clk),
        .addra(cache_ram_txa4),
        .dina(cache_ram_txd4),
        .wea(cache_ram_txen4),

        .clkb(clk),
        .addrb(cache_ram_rxa),
        .doutb(cache_ram_rxd[31:24])
    );

    ram_usb
    ram_usb_dut5(
        .clka(clk),
        .addra(cache_ram_txa5),
        .dina(cache_ram_txd5),
        .wea(cache_ram_txen5),

        .clkb(clk),
        .addrb(cache_ram_rxa),
        .doutb(cache_ram_rxd[23:16])
    );

    ram_usb
    ram_usb_dut6(
        .clka(clk),
        .addra(cache_ram_txa6),
        .dina(cache_ram_txd6),
        .wea(cache_ram_txen6),

        .clkb(clk),
        .addrb(cache_ram_rxa),
        .doutb(cache_ram_rxd[15:8])
    );

    ram_usb
    ram_usb_dut7(
        .clka(clk),
        .addra(cache_ram_txa7),
        .dina(cache_ram_txd7),
        .wea(cache_ram_txen7),

        .clkb(clk),
        .addrb(cache_ram_rxa),
        .doutb(cache_ram_rxd[7:0])
    );





endmodule