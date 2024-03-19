module try(
    input clk_in,
    input rst_n,

    input [3:0] com_txd_p,
    input [3:0] com_txd_n,
    input [1:0] com_rxd_p,
    input [1:0] com_rxd_n,
    input com_rxf,
    input com_txf
);

    wire clk;
    wire [3:0] com_txd;
    wire [1:0] com_rxd;
    (*MARK_DEBUG = "true"*)reg [3:0] pin_txd;
    (*MARK_DEBUG = "true"*)reg [1:0] pin_rxd;
    (*MARK_DEBUG = "true"*)reg fire_read, fire_send;

    always@(posedge clk) begin
        pin_txd <= com_txd;
        pin_rxd <= com_rxd;
        fire_send <= com_txf;
        fire_read <= com_rxf;
    end

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk_in),
        .clk_200(clk)
    );

    IBUFDS
    ibufds_com_txd0(
        .I(com_txd_p[0]),
        .IB(com_txd_n[0]),
        .O(com_txd[0])
    );
    IBUFDS
    ibufds_com_txd1(
        .I(com_txd_p[1]),
        .IB(com_txd_n[1]),
        .O(com_txd[1])
    );
    IBUFDS
    ibufds_com_txd2(
        .I(com_txd_p[2]),
        .IB(com_txd_n[2]),
        .O(com_txd[2])
    );
    IBUFDS
    ibufds_com_txd3(
        .I(com_txd_p[3]),
        .IB(com_txd_n[3]),
        .O(com_txd[3])
    );
    IBUFDS
    ibufds_com_rxd0(
        .I(com_rxd_p[0]),
        .IB(com_rxd_n[0]),
        .O(com_rxd[0])
    );
    IBUFDS
    ibufds_com_rxd1(
        .I(com_rxd_p[1]),
        .IB(com_rxd_n[1]),
        .O(com_rxd[1])
    );



endmodule