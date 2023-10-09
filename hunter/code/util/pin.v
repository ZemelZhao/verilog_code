module pin(
    input [3:0] miso_p,
    input [3:0] miso_n,
    output [3:0] mosi_p,
    output [3:0] mosi_n,
    output [3:0] cs_p,
    output [3:0] cs_n,
    output [3:0] sclk_p,
    output [3:0] sclk_n,

    input [1:0] com_cc,
    inout [1:0] com_sbu,
    output [3:0] com_txd_p,
    output [3:0] com_txd_n,
    input [1:0] com_rxd_p,
    input [1:0] com_rxd_n,

    output [3:0] miso,
    input [3:0] mosi,
    input [3:0] cs,
    input [3:0] sclk,

    input [3:0] pin_txd,
    output pin_rxd,

    input fire_send,
    output fire_read
);


    wire [3:0] com_txd;
    wire [1:0] com_rxd;

    assign com_txd = pin_txd;
    assign pin_rxd = com_rxd[0];
    


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

    OBUFDS
    obufds_txd0(
        .I(com_txd[0]),
        .O(com_txd_p[0]),
        .OB(com_txd_n[0])
    );

    OBUFDS
    obufds_txd1(
        .I(com_txd[1]),
        .O(com_txd_p[1]),
        .OB(com_txd_n[1])
    );

    OBUFDS
    obufds_txd2(
        .I(com_txd[2]),
        .O(com_txd_p[2]),
        .OB(com_txd_n[2])
    );
    
    OBUFDS
    obufds_txd3(
        .I(com_txd[3]),
        .O(com_txd_p[3]),
        .OB(com_txd_n[3])
    );

    IBUFDS
    ibufds_rxd0(
        .O(com_rxd[0]),
        .I(com_rxd_p[0]),
        .IB(com_rxd_n[0])
    );

    IBUFDS
    ibufds_rxd1(
        .O(com_rxd[1]),
        .I(com_rxd_p[1]),
        .IB(com_rxd_n[1])
    );







endmodule