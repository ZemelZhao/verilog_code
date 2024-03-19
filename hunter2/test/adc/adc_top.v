module adc_top(
    input clk,
    input rst_n,

    input [3:0] miso_p,
    input [3:0] miso_n,

    output [3:0] mosi_p,
    output [3:0] mosi_n,

    output [3:0] cs_p,
    output [3:0] cs_n,

    output [3:0] sclk_p,
    output [3:0] sclk_n
);

    wire clk;
    wire [3:0] miso;
    wire [3:0] mosi;
    wire [3:0] cs;
    wire [3:0] sclk;
    wire rst;

    reg [3:0] state, next_state;
    localparam IDLE = 4'h0, WAIT = 4'h1, WORK = 4'h2, DONE = 4'h3;
    localparam INIT = 4'h4, TYPE = 4'h5, CONF = 4'h6, CONV = 4'h7;
    localparam GAP0 = 4'h8, GAP1 = 4'h9, GAP2 = 4'hA, GAP3 = 4'hB;

    wire fs_init, fd_init;
    wire fs_type, fd_type;
    wire fs_conf, fd_conf;
    wire sys_clk, spi_clk, fifo_clk;

    (*MARK_DEBUG = "true"*)wire [7:0] chip_type;
    (*MARK_DEBUG = "true"*)wire [15:0] chip_temp;

    reg [31:0] num;
    localparam NUM = 32'd50_000_000;
    localparam GNUM = 32'h10;


    assign rst = ~rst_n;
    assign fs_init = (state == INIT);
    assign fs_type = (state == TYPE);
    assign fs_conf = (state == CONF);

    always@(posedge sys_clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(num >= NUM - 1'b1) next_state <= INIT;
                else next_state <= WAIT;
            end
            INIT: begin
                if(fd_init) next_state <= GAP0;
                else next_state <= INIT;
            end
            GAP0: begin
                if(num >= GNUM - 1'b1) next_state <= TYPE;
                else next_state <= GAP0;
            end
            TYPE: begin
                if(fd_type) next_state <= GAP1;
                else next_state <= TYPE;
            end
            GAP1: begin
                if(num >= GNUM - 1'b1) next_state <= CONF;
                else next_state <= GAP1;
            end
            CONF: begin
                if(fd_conf) next_state <= DONE;
                else next_state <= CONF;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge sys_clk or posedge rst) begin
        if(rst) num <= 32'h00;
        else if(state == IDLE) num <= 32'h00;
        else if(state == WAIT) num <= num + 1'b1;
        else if(state == GAP0) num <= num + 1'b1;
        else if(state == GAP1) num <= num + 1'b1;
        else num <= 32'h00;
    end


    clk_wiz
    clk_wiz_dut(
        .clk_in1(clk),
        .clk_out1(sys_clk),
        .clk_out2(spi_clk),
        .clk_out3(fifo_clk)
    );

    adc
    adc_dut(
        .clk(sys_clk),
        .spi_clk(spi_clk),
        .fifo_txc(fifo_clk),
        .fifo_rxc(fifo_clk),

        .rst(rst),

        .fs_init(fs_init),
        .fd_init(fd_init),
        .fs_type(fs_type),
        .fd_type(fd_type),
        .fs_conf(fs_conf),
        .fd_conf(fd_conf),
        
        .freq(3'h1),
        .filt_up(4'h0),
        .filt_low(4'h0),
        .type(chip_type),
        .chip_temp(chip_temp),

        .spi_miso(miso),
        .spi_mosi(mosi),
        .spi_sclk(sclk),
        .spi_cs(cs)

    );

    // IBUFGDS 
    // u_ibufg_clk(
    //     .I(clk_p),
    //     .IB(clk_n),
    //     .O(clk)
    // );

    IBUFDS
    ibufds_miso0(
        .I(miso_p[0]),
        .IB(miso_n[0]),
        .O(miso[0])
    );

    IBUFDS
    ibufds_miso1(
        .I(miso_p[1]),
        .IB(miso_n[1]),
        .O(miso[1])
    );

    IBUFDS
    ibufds_miso2(
        .I(miso_p[2]),
        .IB(miso_n[2]),
        .O(miso[2])
    );

    IBUFDS
    ibufds_miso3(
        .I(miso_p[3]),
        .IB(miso_n[3]),
        .O(miso[3])
    );

    OBUFDS
    obufds_mosi0(
        .I(mosi[0]),
        .O(mosi_p[0]),
        .OB(mosi_n[0])
    );

    OBUFDS
    obufds_mosi1(
        .I(mosi[1]),
        .O(mosi_p[1]),
        .OB(mosi_n[1])
    );

    OBUFDS
    obufds_mosi2(
        .I(mosi[2]),
        .O(mosi_p[2]),
        .OB(mosi_n[2])
    );

    OBUFDS
    obufds_mosi3(
        .I(mosi[3]),
        .O(mosi_p[3]),
        .OB(mosi_n[3])
    );

    OBUFDS
    obufds_cs0(
        .I(cs[0]),
        .O(cs_p[0]),
        .OB(cs_n[0])
    );

    OBUFDS
    obufds_cs1(
        .I(cs[1]),
        .O(cs_p[1]),
        .OB(cs_n[1])
    );

    OBUFDS
    obufds_cs2(
        .I(cs[2]),
        .O(cs_p[2]),
        .OB(cs_n[2])
    );

    OBUFDS
    obufds_cs3(
        .I(cs[3]),
        .O(cs_p[3]),
        .OB(cs_n[3])
    );

    OBUFDS
    obufds_sclk0(
        .I(sclk[0]),
        .O(sclk_p[0]),
        .OB(sclk_n[0])
    );

    OBUFDS
    obufds_sclk1(
        .I(sclk[1]),
        .O(sclk_p[1]),
        .OB(sclk_n[1])
    );

    OBUFDS
    obufds_sclk2(
        .I(sclk[2]),
        .O(sclk_p[2]),
        .OB(sclk_n[2])
    );

    OBUFDS
    obufds_sclk3(
        .I(sclk[3]),
        .O(sclk_p[3]),
        .OB(sclk_n[3])
    );
















endmodule