module crep(
    input clk,

    output clk_slow,
    output clk_norm,
    output clk_fast,
    output clk_ulta,

    output [3:0] com_txd_p,
    output [3:0] com_txd_n,
    input [1:0] com_rxd_p,
    input [1:0] com_rxd_n,
    input com_rxf,
    output com_txf,
    input [1:0] com_cc,

    input [3:0] adc_miso,
    output [3:0] adc_cs,
    output [3:0] adc_mosi,
    output [3:0] adc_sclk,

    input [3:0] pin_txd,
    output pin_rxd,
    (*MARK_DEBUG = "true"*)input fire_send,
    (*MARK_DEBUG = "true"*)output fire_read,

    input [3:0] pin_cs,
    input [3:0] pin_sclk,
    input [3:0] pin_mosi,
    output [3:0] pin_miso,

    input rst_n,
    output rst
);

    localparam RST_NUM = 16'd15_000;

    reg [3:0] state, next_state;
    reg [15:0] rst_cnt;

    // (*MARK_DEBUG = "true"*)wire [1:0] pin_cc;

    (*MARK_DEBUG = "true"*)wire [3:0] com_txd;
    (*MARK_DEBUG = "true"*)wire [1:0] com_rxd;

    assign pin_rxd = com_rxd[1];
    assign com_txd = pin_txd;
    assign com_txf = fire_send;
    assign fire_read = com_rxf;

    // assign pin_rxd = &com_rxd;
    // assign pin_cc = com_cc;

    assign adc_cs = pin_cs;
    assign adc_mosi = pin_mosi;
    assign adc_sclk = pin_sclk;
    assign pin_miso = adc_miso;

    localparam IDLE = 4'b0001, WAIT = 4'b0010, WORK = 4'b0100, DONE = 4'b1000;

    assign rst = (state == WORK) || (~rst_n);

    always@(posedge clk_norm or negedge rst_n) begin
        if(~rst_n) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(rst_cnt == RST_NUM) next_state <= WORK;
                else next_state <= WORK;
            end
            WORK: begin
                if(rst_cnt == 16'h0000) next_state <= DONE;
                else next_state <= DONE;
            end
            DONE: next_state <= DONE;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk_norm or negedge rst_n) begin
        if(~rst_n) rst_cnt <= 16'h0000;
        else if(state == IDLE) rst_cnt <= 16'h0000;
        else if(state == WAIT) rst_cnt <= rst_cnt + 1'b1;
        else if(state == WORK) rst_cnt <= rst_cnt - 1'b1;
        else if(state == DONE) rst_cnt <= 16'h0000;
        else rst_cnt <= rst_cnt;
    end

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk),
        .clk_slow(clk_slow),
        .clk_norm(clk_norm),
        .clk_fast(clk_fast),
        .clk_ulta(clk_ulta)
    );

    OBUFDS
    obufds_com_txd0(
        .I(com_txd[0]),
        .O(com_txd_p[0]),
        .OB(com_txd_n[0])
    );

    OBUFDS
    obufds_com_txd1(
        .I(com_txd[1]),
        .O(com_txd_p[1]),
        .OB(com_txd_n[1])
    );

    OBUFDS
    obufds_com_txd2(
        .I(com_txd[2]),
        .O(com_txd_p[2]),
        .OB(com_txd_n[2])
    );
    
    OBUFDS
    obufds_com_txd3(
        .I(com_txd[3]),
        .O(com_txd_p[3]),
        .OB(com_txd_n[3])
    );

    IBUFDS
    ibufds_com_rxd0(
        .O(com_rxd[0]),
        .I(com_rxd_p[0]),
        .IB(com_rxd_n[0])
    );

    IBUFDS
    ibufds_com_rxd1(
        .O(com_rxd[1]),
        .I(com_rxd_p[1]),
        .IB(com_rxd_n[1])
    );

endmodule