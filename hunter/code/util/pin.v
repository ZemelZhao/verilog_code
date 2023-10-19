module pin_test(
    output [3:0] com_txd_p,
    output [3:0] com_txd_n,
    input [1:0] com_rxd_p,
    input [1:0] com_rxd_n,
    input com_rxf,
    output com_txf,

    input [3:0] adc_miso_p,
    input [3:0] adc_miso_n,
    output [3:0] adc_cs_p,
    output [3:0] adc_cs_n,
    output [3:0] adc_mosi_p,
    output [3:0] adc_mosi_n,
    output [3:0] adc_sclk_p,
    output [3:0] adc_sclk_n,

    input [3:0] pin_txd,
    output pin_rxd,
    input fire_send,
    output fire_read,

    input [3:0] pin_cs,
    input [3:0] pin_sclk,
    input [3:0] pin_mosi,
    output [3:0] pin_miso
);

    wire [3:0] com_txd;
    wire [1:0] com_rxd;

    assign com_txd = pin_txd;
    assign pin_rxd = com_rxd[0];
    assign com_txf = fire_send;
    assign fire_read = com_rxf;

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

    IBUFDS
    ibufds_adc_miso0(
        .O(pin_miso[0]),
        .I(adc_miso_p[0]),
        .IB(adc_miso_n[0])
    );

    IBUFDS
    ibufds_adc_miso1(
        .O(pin_miso[1]),
        .I(adc_miso_p[1]),
        .IB(adc_miso_n[1])
    );

    IBUFDS
    ibufds_adc_miso2(
        .O(pin_miso[2]),
        .I(adc_miso_p[2]),
        .IB(adc_miso_n[2])
    );

    IBUFDS
    ibufds_adc_miso3(
        .O(pin_miso[3]),
        .I(adc_miso_p[3]),
        .IB(adc_miso_n[3])
    );

    OBUFDS
    obufds_adc_mosi0(
        .I(pin_mosi[0]),
        .O(adc_mosi_p[0]),
        .OB(adc_mosi_n[0])
    );

    OBUFDS
    obufds_adc_mosi1(
        .I(pin_mosi[1]),
        .O(adc_mosi_p[1]),
        .OB(adc_mosi_n[1])
    );

    OBUFDS
    obufds_adc_mosi2(
        .I(pin_mosi[2]),
        .O(adc_mosi_p[2]),
        .OB(adc_mosi_n[2])
    );

    OBUFDS
    obufds_adc_mosi3(
        .I(pin_mosi[3]),
        .O(adc_mosi_p[3]),
        .OB(adc_mosi_n[3])
    );

    OBUFDS
    obufds_adc_sclk0(
        .I(pin_sclk[0]),
        .O(adc_sclk_p[0]),
        .OB(adc_sclk_n[0])
    );


    OBUFDS
    obufds_adc_sclk1(
        .I(pin_sclk[1]),
        .O(adc_sclk_p[1]),
        .OB(adc_sclk_n[1])
    );


    OBUFDS
    obufds_adc_sclk2(
        .I(pin_sclk[2]),
        .O(adc_sclk_p[2]),
        .OB(adc_sclk_n[2])
    );


    OBUFDS
    obufds_adc_sclk3(
        .I(pin_sclk[3]),
        .O(adc_sclk_p[3]),
        .OB(adc_sclk_n[3])
    );

    OBUFDS
    obufds_adc_cs0(
        .I(pin_cs[0]),
        .O(adc_cs_p[0]),
        .OB(adc_cs_n[0])
    );

    OBUFDS
    obufds_adc_cs1(
        .I(pin_cs[1]),
        .O(adc_cs_p[1]),
        .OB(adc_cs_n[1])
    );

    OBUFDS
    obufds_adc_cs2(
        .I(pin_cs[2]),
        .O(adc_cs_p[2]),
        .OB(adc_cs_n[2])
    );

    OBUFDS
    obufds_adc_cs3(
        .I(pin_cs[3]),
        .O(adc_cs_p[3]),
        .OB(adc_cs_n[3])
    );









endmodule
