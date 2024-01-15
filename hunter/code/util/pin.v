module pin(
    output [3:0] com_txd_p,
    output [3:0] com_txd_n,
    input [1:0] com_rxd_p,
    input [1:0] com_rxd_n,
    input com_rxf,
    output com_txf,

    input [3:0] adc_miso,
    output [3:0] adc_cs,
    output [3:0] adc_mosi,
    output [3:0] adc_sclk,

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
    assign pin_rxd = com_rxd[1];
    assign com_txf = fire_send;
    assign fire_read = com_rxf;

    assign adc_cs = pin_cs;
    assign adc_mosi = pin_mosi;
    assign adc_sclk = pin_sclk;
    assign pin_miso = adc_miso;

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
