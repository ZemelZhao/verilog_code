module top(
    input clk_in_p,
    input clk_in_n,
    input sfp_clk_p,
    input sfp_clk_n,

    output sfp_tx_p,
    output sfp_tx_n,
    input sfp_rx_p,
    input sfp_rx_n,

    input rst_n,
    output fan_n
);

    wire rst;
    wire clk_in, clk_100;

    wire gtx_rxc, gtx_txc;
    wire [3:0] gtx_rxk, gtx_txk;
    wire [31:0] gtx_rxd, gtx_txd;
    
    assign rst = ~rst_n;

    gtx_exdes
    gtx_exdes_dut(
        .reset(rst),
        .reset_done(),

        .gtx_txc(gtx_txc),
        .gtx_txd(gtx_txd),
        .gtx_txk(gtx_txk),
        .gtx_rxc(gtx_rxc),
        .gtx_rxd(gtx_rxd),
        .gtx_rxk(gtx_rxk),

        .ref_clk_p(sfp_clk_p),
        .ref_clk_n(sfp_clk_n),

        .drp_clk(clk_100),
        .sfp_tx_p(sfp_tx_p),
        .sfp_tx_n(sfp_tx_n),
        .sfp_rx_p(sfp_rx_p),
        .sfp_rx_n(sfp_rx_n)
    );

    IBUFGDS
    ibfugds_dut(
        .I(clk_in_p),
        .IB(clk_in_n),
        .O(clk_in)
    );

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk_in),
        .clk_100(clk_100)
    );





endmodule