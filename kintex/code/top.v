module top(
    input clk_p,
    input clk_n,
    input rst_n,

    output [7:0] led,
    output fan_n,

    output [3:0] usb_rxd0p,
    output [3:0] usb_rxd0n,
    input [3:0] usb_rxd1p,
    input [3:0] usb_rxd1n,
    input [3:0] usb_rxd2p,
    input [3:0] usb_rxd2n,
    input [3:0] usb_rxd3p,
    input [3:0] usb_rxd3n,
    input [3:0] usb_rxd4p,
    input [3:0] usb_rxd4n,
    input [3:0] usb_rxd5p,
    input [3:0] usb_rxd5n,
    input [3:0] usb_rxd6p,
    input [3:0] usb_rxd6n,
    input [3:0] usb_rxd7p,
    input [3:0] usb_rxd7n,

    output usb_txd0p,
    output usb_txd0n,
    output usb_txd1p,
    output usb_txd1n,
    output usb_txd2p,
    output usb_txd2n,
    output usb_txd3p,
    output usb_txd3n,
    output usb_txd4p,
    output usb_txd4n,
    output usb_txd5p,
    output usb_txd5n,
    output usb_txd6p,
    output usb_txd6n,
    output usb_txd7p,
    output usb_txd7n,

    (*MARK_DEBUG = "true"*)output [7:0] usb_txf,
    (*MARK_DEBUG = "true"*)output [7:0] usb_rxf
);

    localparam NUM = 32'h40;

    reg [1:0] state, next_state;
    localparam IDLE = 2'h0, WAIT = 2'h1, WORK = 2'h2, DONE = 2'h3;

    (*MARK_DEBUG = "true"*)reg [3:0] res_rxd;
    (*MARK_DEBUG = "true"*)reg res_txd;

    wire [3:0] usb_rxd0, usb_rxd1; 
    wire [3:0] usb_rxd2, usb_rxd3; 
    wire [3:0] usb_rxd4, usb_rxd5, usb_rxd6, usb_rxd7; 
    wire usb_txd0, usb_txd1, udb_txd2, usb_txd3;
    wire usb_txd4, usb_txd5, udb_txd6, usb_txd7;

    wire clk_in;
    wire clk;
    reg [7:0] num;
    reg [3:0] txd;
    wire rst;

    assign rst = ~rst_n;
    assign fan_n = 1'b0;
    assign led = 8'hFE;
    assign usb_rxd0 = txd;
    assign usb_txd0 = 1'b0;
    assign usb_txd1 = 1'b0;
    assign usb_txd2 = 1'b0;
    assign usb_txd3 = 1'b0;
    assign usb_txd4 = res_txd;
    assign usb_txd5 = 1'b0;
    assign usb_txd6 = 1'b0;
    assign usb_txd7 = 1'b0;
    assign usb_txf = {8{num[3]}};
    assign usb_rxf = {8{num[4]}};

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= WORK;
            WORK: next_state <= WORK;
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == IDLE) num <= 8'h00; 
        else if(state == WAIT) num <= 8'h00; 
        else if(state == WORK) num <= num + 1'b1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) res_txd <= 1'b0;
        else if(state == IDLE) res_txd <= 1'b0;
        else if(state == WAIT) res_txd <= 1'b0;
        else if(state == WORK) res_txd <= ~res_txd;
    end

    always@(posedge clk) begin
        res_rxd <= usb_rxd4;
    end

    // always@(posedge clk or posedge rst) begin
    //     if(rst) txd <= 4'h0;
    //     else if(state == IDLE) txd <= 4'h0;
    //     else if(state == WAIT) txd <= 4'h0;
    //     else if(state == WORK) txd <= txd + 1'b1;
    //     else if(state == DONE) txd <= 4'h0;
    //     else txd <= txd;
    // end

    // always@(posedge clk or posedge rst) begin
    //     if(rst) num <= 32'h00;
    //     else if(state == IDLE) num <= 32'h00;
    //     else if(state == WAIT) num <= 32'h00;
    //     else if(state == WORK) num <= num + 1'b1;
    //     else num <= 32'h00;
    // end

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk_in),
        .clk_out_200(clk),
        .clk_out_100(),
        .clk_out_50(),
        .clk_out_80(),
        .clk_out_40(),
        .clk_out_20(),
        .clk_out_10()
    );

    IBUFGDS 
    u_ibufg_clk(
        .I(clk_p),
        .IB(clk_n),
        .O(clk_in)
    );

    OBUFDS
    obufds_usb_rxd00(
        .O(usb_rxd0p[0]),
        .OB(usb_rxd0n[0]),
        .I(usb_rxd0[0])
    );
    OBUFDS
    obufds_usb_rxd01(
        .O(usb_rxd0p[1]),
        .OB(usb_rxd0n[1]),
        .I(usb_rxd0[1])
    );
    OBUFDS
    obufds_usb_rxd02(
        .O(usb_rxd0p[2]),
        .OB(usb_rxd0n[2]),
        .I(usb_rxd0[2])
    );
    OBUFDS
    obufds_usb_rxd03(
        .O(usb_rxd0p[3]),
        .OB(usb_rxd0n[3]),
        .I(usb_rxd0[3])
    );

    // IBUFDS
    // ibufds_usb_rxd00(
    //     .I(usb_rxd0p[0]),
    //     .IB(usb_rxd0n[0]),
    //     .O(usb_rxd0[0])
    // );
    // IBUFDS
    // ibufds_usb_rxd01(
    //     .I(usb_rxd0p[1]),
    //     .IB(usb_rxd0n[1]),
    //     .O(usb_rxd0[1])
    // );
    // IBUFDS
    // ibufds_usb_rxd02(
    //     .I(usb_rxd0p[2]),
    //     .IB(usb_rxd0n[2]),
    //     .O(usb_rxd0[2])
    // );
    // IBUFDS
    // ibufds_usb_rxd03(
    //     .I(usb_rxd0p[3]),
    //     .IB(usb_rxd0n[3]),
    //     .O(usb_rxd0[3])
    // );

    IBUFDS
    ibufds_usb_rxd10(
        .I(usb_rxd1p[0]),
        .IB(usb_rxd1n[0]),
        .O(usb_rxd1[0])
    );
    IBUFDS
    ibufds_usb_rxd11(
        .I(usb_rxd1p[1]),
        .IB(usb_rxd1n[1]),
        .O(usb_rxd1[1])
    );
    IBUFDS
    ibufds_usb_rxd12(
        .I(usb_rxd1p[2]),
        .IB(usb_rxd1n[2]),
        .O(usb_rxd1[2])
    );
    IBUFDS
    ibufds_usb_rxd13(
        .I(usb_rxd1p[3]),
        .IB(usb_rxd1n[3]),
        .O(usb_rxd1[3])
    );

    IBUFDS
    ibufds_usb_rxd20(
        .I(usb_rxd2p[0]),
        .IB(usb_rxd2n[0]),
        .O(usb_rxd2[0])
    );
    IBUFDS
    ibufds_usb_rxd21(
        .I(usb_rxd2p[1]),
        .IB(usb_rxd2n[1]),
        .O(usb_rxd2[1])
    );
    IBUFDS
    ibufds_usb_rxd22(
        .I(usb_rxd2p[2]),
        .IB(usb_rxd2n[2]),
        .O(usb_rxd2[2])
    );
    IBUFDS
    ibufds_usb_rxd23(
        .I(usb_rxd2p[3]),
        .IB(usb_rxd2n[3]),
        .O(usb_rxd2[3])
    );

    IBUFDS
    ibufds_usb_rxd30(
        .I(usb_rxd3p[0]),
        .IB(usb_rxd3n[0]),
        .O(usb_rxd3[0])
    );
    IBUFDS
    ibufds_usb_rxd31(
        .I(usb_rxd3p[1]),
        .IB(usb_rxd3n[1]),
        .O(usb_rxd3[1])
    );
    IBUFDS
    ibufds_usb_rxd32(
        .I(usb_rxd3p[2]),
        .IB(usb_rxd3n[2]),
        .O(usb_rxd3[2])
    );
    IBUFDS
    ibufds_usb_rxd33(
        .I(usb_rxd3p[3]),
        .IB(usb_rxd3n[3]),
        .O(usb_rxd3[3])
    );

    IBUFDS
    ibufds_usb_rxd40(
        .I(usb_rxd4p[0]),
        .IB(usb_rxd4n[0]),
        .O(usb_rxd4[0])
    );
    IBUFDS
    ibufds_usb_rxd41(
        .I(usb_rxd4p[1]),
        .IB(usb_rxd4n[1]),
        .O(usb_rxd4[1])
    );
    IBUFDS
    ibufds_usb_rxd42(
        .I(usb_rxd4p[2]),
        .IB(usb_rxd4n[2]),
        .O(usb_rxd4[2])
    );
    IBUFDS
    ibufds_usb_rxd43(
        .I(usb_rxd4p[3]),
        .IB(usb_rxd4n[3]),
        .O(usb_rxd4[3])
    );

    IBUFDS
    ibufds_usb_rxd50(
        .I(usb_rxd5p[0]),
        .IB(usb_rxd5n[0]),
        .O(usb_rxd5[0])
    );
    IBUFDS
    ibufds_usb_rxd51(
        .I(usb_rxd5p[1]),
        .IB(usb_rxd5n[1]),
        .O(usb_rxd5[1])
    );
    IBUFDS
    ibufds_usb_rxd52(
        .I(usb_rxd5p[2]),
        .IB(usb_rxd5n[2]),
        .O(usb_rxd5[2])
    );
    IBUFDS
    ibufds_usb_rxd53(
        .I(usb_rxd5p[3]),
        .IB(usb_rxd5n[3]),
        .O(usb_rxd5[3])
    );

    IBUFDS
    ibufds_usb_rxd60(
        .I(usb_rxd6p[0]),
        .IB(usb_rxd6n[0]),
        .O(usb_rxd6[0])
    );
    IBUFDS
    ibufds_usb_rxd61(
        .I(usb_rxd6p[1]),
        .IB(usb_rxd6n[1]),
        .O(usb_rxd6[1])
    );
    IBUFDS
    ibufds_usb_rxd62(
        .I(usb_rxd6p[2]),
        .IB(usb_rxd6n[2]),
        .O(usb_rxd6[2])
    );
    IBUFDS
    ibufds_usb_rxd63(
        .I(usb_rxd6p[3]),
        .IB(usb_rxd6n[3]),
        .O(usb_rxd6[3])
    );

    IBUFDS
    ibufds_usb_rxd70(
        .I(usb_rxd7p[0]),
        .IB(usb_rxd7n[0]),
        .O(usb_rxd7[0])
    );
    IBUFDS
    ibufds_usb_rxd71(
        .I(usb_rxd7p[1]),
        .IB(usb_rxd7n[1]),
        .O(usb_rxd7[1])
    );
    IBUFDS
    ibufds_usb_rxd72(
        .I(usb_rxd7p[2]),
        .IB(usb_rxd7n[2]),
        .O(usb_rxd7[2])
    );
    IBUFDS
    ibufds_usb_rxd73(
        .I(usb_rxd7p[3]),
        .IB(usb_rxd7n[3]),
        .O(usb_rxd7[3])
    );

    OBUFDS
    obufds_usb_txd0(
        .I(usb_txd0),
        .O(usb_txd0p),
        .OB(usb_txd0n)
    );
    OBUFDS
    obufds_usb_txd1(
        .I(usb_txd1),
        .O(usb_txd1p),
        .OB(usb_txd1n)
    );
    OBUFDS
    obufds_usb_txd2(
        .I(usb_txd2),
        .O(usb_txd2p),
        .OB(usb_txd2n)
    );
    OBUFDS
    obufds_usb_txd3(
        .I(usb_txd3),
        .O(usb_txd3p),
        .OB(usb_txd3n)
    );
    OBUFDS
    obufds_usb_txd4(
        .I(usb_txd4),
        .O(usb_txd4p),
        .OB(usb_txd4n)
    );
    OBUFDS
    obufds_usb_txd5(
        .I(usb_txd5),
        .O(usb_txd5p),
        .OB(usb_txd5n)
    );
    OBUFDS
    obufds_usb_txd6(
        .I(usb_txd6),
        .O(usb_txd6p),
        .OB(usb_txd6n)
    );
    OBUFDS
    obufds_usb_txd7(
        .I(usb_txd7),
        .O(usb_txd7p),
        .OB(usb_txd7n)
    );



endmodule