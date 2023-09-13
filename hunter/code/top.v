module top(
    input clk,
    input rst_n,

    input pin_01p,
    input pin_01n,
    input pin_02p,
    input pin_02n,
    input pin_03p,
    input pin_03n,
    input pin_04p,
    output pin_04n,
    input pin_05p,
    input pin_05n,
    input pin_06p,
    input pin_06n,
    output pin_07p,
    input pin_07n,
    input pin_08p,
    input pin_08n,
    output pin_09p,
    input pin_09n,
    input pin_10p,
    input pin_10n,
    input pin_11p,
    input pin_11n,
    output pin_12p,
    input pin_12n,
    output pin_13p,
    input pin_13n,
    output pin_14p,
    input pin_14n,
    output pin_15p,
    input pin_15n,
    input pin_16p,
    input pin_16n,
    input pin_17p,
    input pin_17n
);

    wire rst;

    wire [3:0] pm_rxd, ps_txd;
    wire pm_txd, ps_rxd;
    wire pm_recv, ps_recv;
    wire pm_send, ps_send;

    assign pin_12p = ps_txd[3];
    assign pin_13p = ps_txd[2];
    assign pin_14p = ps_txd[1];
    assign pin_15p = ps_txd[0];
    assign ps_rxd = pin_16p;
    assign pin_09p = ps_send;
    assign ps_recv = pin_09n;

    assign pm_rxd[3] = pin_01p;
    assign pm_rxd[2] = pin_02p;
    assign pm_rxd[1] = pin_03p;
    assign pm_rxd[0] = pin_06p;
    assign pin_07p = pm_txd;
    assign pm_recv = pin_04p;
    assign pin_04n = pm_send;

    assign rst = ~rst_n;


    tb_com_pin
    tb_com_pin_dut(
        .clk(clk),
        .rst(rst),

        .pm_rxd(pm_rxd),
        .ps_rxd(ps_rxd),
        .pm_txd(pm_txd),
        .ps_txd(ps_txd),
        .pm_recv(pm_recv),
        .ps_recv(ps_recv),
        .pm_send(pm_send),
        .ps_send(ps_send)
    );


endmodule