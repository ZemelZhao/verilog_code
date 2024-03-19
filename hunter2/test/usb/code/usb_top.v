module usb_top(
    input clk,
    input rst_n,

    output [3:0] com_txd_p,
    output [3:0] com_txd_n,

    input [1:0] com_rxd_p,
    input [1:0] com_rxd_n,

    input [1:0] cc,
    input [1:0] sbu
);

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;

    (*MARK_DEBUG = "true"*)reg [1:0] res_cc, res_sbu;

    (*MARK_DEBUG = "true"*)reg [3:0] com_txd;
    wire [1:0] com_rxd;
    wire clk_out;
    wire rst;
    (*MARK_DEBUG = "true"*)reg [1:0] res_rxd;

    assign rst = ~rst_n;

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

    always@(posedge clk_out or posedge rst) begin
        if(rst) com_txd <= 4'h0; 
        else if(state == IDLE) com_txd <= 4'h0;
        else if(state == WAIT) com_txd <= 4'h0;
        else if(state == WORK) com_txd <= com_txd + 1'b1;
        else com_txd <= 4'h0;
    end

    always@(posedge clk_out) begin
        res_rxd <= com_rxd;
        res_cc <= cc;
        res_sbu <= sbu;
    end

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk),
        .clk_out_400(clk_out),
        .clk_out_200(),
        .clk_out_100(),
        .clk_out_80(),
        .clk_out_40(),
        .clk_out_20(),
        .clk_out_10()
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