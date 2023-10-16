module adc_test(
    input clk,
    input spi_clk,

    input fifo_txc,
    input fifo_rxc,

    input rst,

    input fs_init,
    input fs_type,
    input fs_conf,
    input fs_conv,

    output fd_init,
    output fd_type,
    output fd_conf,
    output fd_conv,

    input [31:0] cache_cmd,
    output [31:0] cache_stat,

    input [3:0] spi_miso,
    output [3:0] spi_mosi,
    output [3:0] spi_sclk,
    output [3:0] spi_cs,

    input [7:0] fifo_rxen,
    output [63:0] fifo_rxd
);

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01;
    localparam INIT_IDLE = 8'h10, INIT_WORK = 8'h11, INIT_DONE = 8'h12;
    localparam TYPE_IDLE = 8'h20, TYPE_WORK = 8'h21, TYPE_DONE = 8'h22;
    localparam CONF_IDLE = 8'h30, CONF_WORK = 8'h31, CONF_DONE = 8'h32;
    localparam CONV_IDLE = 8'h40, CONV_WORK = 8'h41, CONV_DONE = 8'h42;

    wire fs_fifo, fd_fifo;
    wire [63:0] fifo_txd;
    wire [7:0] full, fifo_txen;

    wire [3:0] freq_samp, filt_up, filt_low;
    reg [15:0] device_temp; 
    reg [7:0] device_type;
    wire [3:0] device_stat;

    assign device_stat = 4'hF;

    assign cache_stat = {device_temp, device_type, device_stat, 4'h0};
    assign freq_samp = cache_cmd[23:20];
    assign filt_up = cache_cmd[19:16];
    assign filt_low = cache_cmd[15:12];

    reg [11:0] num;
    localparam NUM_INIT = 12'h10, NUM_TYPE = 12'h10, NUM_CONF = 12'h20;

    assign fd_init = (state == INIT_DONE);
    assign fd_type = (state == TYPE_DONE);
    assign fd_conf = (state == CONF_DONE);
    assign fd_conv = (state == CONV_DONE);
    assign fs_fifo = (state == CONV_WORK);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs_init) next_state <= INIT_IDLE;
                else if(fs_type) next_state <= TYPE_IDLE;
                else if(fs_conf) next_state <= CONF_IDLE;
                else if(fs_conv) next_state <= CONV_IDLE;
                else next_state <= WAIT;
            end

            INIT_IDLE: next_state <= INIT_WORK;
            INIT_WORK: begin
                if(num >= NUM_INIT - 1'b1) next_state <= INIT_DONE; 
                else next_state <= INIT_WORK;
            end
            INIT_DONE: begin
                if(~fs_init) next_state <= WAIT;
                else next_state <= INIT_DONE;
            end

            TYPE_IDLE: next_state <= TYPE_WORK;
            TYPE_WORK: begin
                if(num >= NUM_TYPE - 1'b1) next_state <= TYPE_DONE;
                else next_state <= TYPE_WORK;
            end
            TYPE_DONE: begin
                if(~fs_type) next_state <= WAIT;
                else next_state <= TYPE_DONE;
            end

            CONF_IDLE: next_state <= CONF_WORK;
            CONF_WORK: begin
                if(num >= NUM_CONF - 1'b1) next_state <= CONF_DONE; 
                else next_state <= CONF_WORK;
            end
            CONF_DONE: begin
                if(~fs_conf) next_state <= WAIT;
                else next_state <= CONF_DONE;
            end

            CONV_IDLE: next_state <= CONV_WORK;
            CONV_WORK: begin
                if(fd_fifo) next_state <= CONV_DONE;
                else next_state <= CONV_WORK;
            end
            CONV_DONE: begin
                if(~fs_conv) next_state <= WAIT;
                else next_state <= CONV_DONE;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 12'h000;
        else if(state == IDLE) num <= 12'h000;
        else if(state == WAIT) num <= 12'h000;
        else if(state == INIT_WORK) num <= num + 1'b1;
        else if(state == TYPE_WORK) num <= num + 1'b1;
        else if(state == CONF_WORK) num <= num + 1'b1;
        else num <= 12'h000;
    end


    always@(posedge clk or posedge rst) begin
        if(rst) device_type <= 8'h00;
        else if(state == IDLE) device_type <= 8'h00;
        else if(state == TYPE_IDLE) device_type <= 8'hFF;
        else device_type <= device_type;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp <= 16'h0000;
        else if(state == IDLE) device_temp <= 16'h0000;
        else if(state == CONF_IDLE) device_temp <= 16'h73F4;
        else device_temp <= device_temp;
    end

    fifo_tx
    fifo_tx_dut(
        .clk(fifo_txc),
        .rst(rst),

        .cfull(full),
        .fs(fs_fifo),
        .fd(fd_fifo),

        .bias(64'h01030507090B0D0F),

        .fifo_txen(fifo_txen),
        .fifo_txd(fifo_txd)
    );



    fifo_intan
    fifo_intan_dut0(
        .wr_clk(fifo_txc),
        .din(fifo_txd[63:56]),
        .wr_en(fifo_txen[7]),
        .full(full[7]),
        
        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[63:56]),
        .rd_en(fifo_rxen[7])
    );

    fifo_intan
    fifo_intan_dut1(
        .wr_clk(fifo_txc),
        .din(fifo_txd[55:48]),
        .wr_en(fifo_txen[6]),
        .full(full[6]),
        
        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[55:48]),
        .rd_en(fifo_rxen[6])
    );

    fifo_intan
    fifo_intan_dut2(
        .wr_clk(fifo_txc),
        .din(fifo_txd[47:40]),
        .wr_en(fifo_txen[5]),
        .full(full[5]),
        
        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[47:40]),
        .rd_en(fifo_rxen[5])
    );

    fifo_intan
    fifo_intan_dut3(
        .wr_clk(fifo_txc),
        .din(fifo_txd[39:32]),
        .wr_en(fifo_txen[4]),
        .full(full[4]),
        
        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[39:32]),
        .rd_en(fifo_rxen[4])
    );

    fifo_intan
    fifo_intan_dut4(
        .wr_clk(fifo_txc),
        .din(fifo_txd[31:24]),
        .wr_en(fifo_txen[3]),
        .full(full[3]),
        
        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[31:24]),
        .rd_en(fifo_rxen[3])
    );

    fifo_intan
    fifo_intan_dut5(
        .wr_clk(fifo_txc),
        .din(fifo_txd[23:16]),
        .wr_en(fifo_txen[2]),
        .full(full[2]),
        
        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[23:16]),
        .rd_en(fifo_rxen[2])
    );

    fifo_intan
    fifo_intan_dut6(
        .wr_clk(fifo_txc),
        .din(fifo_txd[15:8]),
        .wr_en(fifo_txen[1]),
        .full(full[1]),
        
        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[15:8]),
        .rd_en(fifo_rxen[1])
    );

    fifo_intan
    fifo_intan_dut7(
        .wr_clk(fifo_txc),
        .din(fifo_txd[7:0]),
        .wr_en(fifo_txen[0]),
        .full(full[0]),
        
        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[7:0]),
        .rd_en(fifo_rxen[0])
    );









endmodule