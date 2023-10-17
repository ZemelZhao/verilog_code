module pin_test(
    output [3:0] com_txd_p,
    output [3:0] com_txd_n,
    input com_rxd_p,
    input com_rxd_n,

    input [3:0] pin_txd,
    output pin_rxd,

    input com_rxf,
    output com_txf,

    input fire_send,
    output fire_read
);

    wire [3:0] com_txd;
    wire com_rxd;

    assign com_txd = pin_txd;
    assign pin_rxd = com_rxd;
    assign com_txf = fire_send;
    assign fire_read = com_rxf;

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
        .O(com_rxd),
        .I(com_rxd_p),
        .IB(com_rxd_n)
    );

endmodule
