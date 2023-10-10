module tb_data_make(
    input clk_25,
    input clk_50,
    input clk_100, 
    input clk_200,
    input rst
);

    wire clk;
    assign clk = clk_50;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam FIFO = 8'h10, TRAN = 8'h11, COUNT = 8'h12;
    
    localparam NUM = 4'h4;

    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    wire fs_conv, fd_conv;
    wire fs_tran, fd_tran;

    wire [7:0] device_type;
    wire [15:0] device_temp;

    wire [7:0] fifo_adc_rxen;
    wire [63:0] fifo_adc_rxd;

    wire [11:0] ram_data_txa;
    wire [7:0] ram_data_txd;
    wire ram_data_txen;
    reg [11:0] ram_txa_init;
    
    reg [3:0] num;
    reg [3:0] btype;

    assign fs_conv = (state == FIFO);
    assign fs_tran = (state == WORK);


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= FIFO;
            FIFO: begin
                if(fd_conv) next_state <= TRAN;
                else next_state <= FIFO;
            end
            TRAN: next_state <= WORK;
            WORK: begin
                if(fd_tran) next_state <= COUNT;
                else next_state <= WORK;
            end
            COUNT: begin
                if(num >= NUM - 1'b1) next_state <= DONE;
                else next_state <= TRAN;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) btype <= 4'h0;
        else if(state == IDLE) btype <= 4'h0;
        else if(state == WAIT) btype <= 4'h0;
        else if(state == TRAN && num == 4'h0) btype <= BAG_DLINK;
        else if(state == TRAN && num == 4'h1) btype <= BAG_DTYPE;
        else if(state == TRAN && num == 4'h2) btype <= BAG_DTEMP;
        else if(state == TRAN && num == 4'h3) btype <= BAG_DATA0;
        else btype <= btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 4'h0;
        else if(state == IDLE) num <= 4'h0;
        else if(state == WAIT) num <= 4'h0;
        else if(state == COUNT) num <= num + 1'b1;
        else num <= num;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txa_init <= 12'h000;
        else if(state == IDLE) ram_txa_init <= 12'h000;
        else if(state == WAIT) ram_txa_init <= 12'h000;
        else if(state == TRAN && num == 4'h0) ram_txa_init <= 12'hFCC;
        else if(state == TRAN && num == 4'h1) ram_txa_init <= 12'hFC0;
        else if(state == TRAN && num == 4'h2) ram_txa_init <= 12'hFC8;
        else if(state == TRAN && num == 4'h3) ram_txa_init <= 12'h000;
        else ram_txa_init <= ram_txa_init;
    end

    data_make
    data_make_dut(
        .clk(clk_100),
        .rst(rst),

        .fs(fs_tran),
        .fd(fd_tran),

        .btype(btype),
        .ram_data_init(ram_txa_init),

        .fifo_adc_rxen(fifo_adc_rxen),
        .fifo_adc_rxd(fifo_adc_rxd),

        .data_reg(32'h17000000),
        .data_stat(32'h73F4FFF0),

        .ram_data_txa(ram_data_txa),
        .ram_data_txd(ram_data_txd),
        .ram_data_txen(ram_data_txen)
    );

    adc_test
    adc_test_dut(
        .clk(clk_50),

        .fifo_txc(clk_100),
        .fifo_rxc(clk_100),

        .rst(rst),

        .fs_init(fs_init),
        .fd_init(fd_init),
        .fs_type(fs_type),
        .fd_type(fd_type),
        .fs_conf(fs_conf),
        .fd_conf(fd_conf),
        .fs_conv(fs_conv),
        .fd_conv(fd_conv),

        .device_type(device_type),
        .device_temp(device_temp),

        .fifo_rxen(fifo_adc_rxen),
        .fifo_rxd(fifo_adc_rxd)
    );



endmodule