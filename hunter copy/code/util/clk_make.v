module clk_make(
    input clk,
    output sys_clk,
    output com_txc,
    output com_rxc,
    output spi_clk,
    output pin_txc,
    output pin_rxc,
    output ram_txc,
    output ram_rxc,
    output fifo_txc,
    output fifo_rxc
);

    wire clk_25, clk_50, clk_80;
    wire clk_100, clk_200;

    assign sys_clk = clk_50;
    assign com_txc = clk_50;
    assign com_rxc = clk_25;
    assign pin_txc = clk_100;
    assign pin_rxc = clk_200;
    assign spi_clk = clk_80;
    assign fifo_txc = clk_50;
    assign fifo_rxc = clk_100;
    assign ram_txc = clk_100;
    assign ram_rxc = clk_50;


    mmcm
    mmcm_dut(
        .clk_in(clk),
        .clk_25(clk_25),
        .clk_50(clk_50),
        .clk_80(clk_80),
        .clk_100(clk_100),
        .clk_200(clk_200),
    );





endmodule