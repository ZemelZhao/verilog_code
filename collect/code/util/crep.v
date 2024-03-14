module crep(
    input clk_in_p,
    input clk_in_n,

    input e_grxc,
    output e_gtxc,

    output clk_slow,
    output clk_norm,
    output clk_fast,
    output clk_ulta,
    
    output gmii_txc,
    output gmii_rxc,

    output [0:31] u_rxd,
    input [0:7] u_txd,

    output reg [0:7] usb_read,
    input [0:7] usb_send,

    output reg [0:7] u_txen,
    input [0:7] u_rxdv,

    input [0:31] u_rxd_p,
    input [0:31] u_rxd_n,
    output [0:7] u_txd_p,
    output [0:7] u_txd_n,

    input rst_n,
    output rst,

    output fan_n
);

    localparam RST_NUM = 16'd7_500;

    reg [3:0] state, next_state;
    reg [15:0] rst_cnt;

    localparam IDLE = 4'b0001, WAIT = 4'b0010, WORK = 4'b0100, DONE = 4'b1000;

    wire e_grxc_g;

    assign e_gtxc = ~e_grxc_g;
    assign gmii_txc = e_grxc_g;
    assign gmii_rxc = e_grxc_g;

    assign rst = (state == WORK);

    assign fan_n = 1'b0;

    always@(posedge clk_norm or negedge rst_n) begin
        if(~rst_n) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(rst_cnt == RST_NUM) next_state <= WORK;
                else next_state <= WORK;
            end
            WORK: begin
                if(rst_cnt == 16'h0000) next_state <= DONE;
                else next_state <= DONE;
            end
            DONE: next_state <= DONE;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk_norm or negedge rst_n) begin
        if(~rst_n) rst_cnt <= 16'h0000;
        else if(state == IDLE) rst_cnt <= 16'h0000;
        else if(state == WAIT) rst_cnt <= rst_cnt + 1'b1;
        else if(state == WORK) rst_cnt <= rst_cnt - 1'b1;
        else if(state == DONE) rst_cnt <= 16'h0000;
        else rst_cnt <= rst_cnt;
    end

    BUFG
    bufg_dut(
        .I(e_grxc),
        .O(e_grxc_g)
    );

    clk_wiz
    clk_wiz_dut(
        .clk_in1_p(clk_in_p),
        .clk_in1_n(clk_in_n),

        .clk_slow(clk_slow),
        .clk_norm(clk_norm),
        .clk_fast(clk_fast),
        .clk_ulta(clk_ulta)
    );

    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin : u_rxd_inst
            IBUFDS
            ibufds_u_rxd(
                .O(u_rxd[i]),
                .I(u_rxd_p[i]),
                .IB(u_rxd_n[i])
            );
        end
    endgenerate

    generate
        for (i=0; i<8; i=i+1) begin : u_txd_inst
            OBUFDS
            obufds_u_txd(
                .I(u_txd[i]),
                .O(u_txd_p[i]),
                .OB(u_txd_n[i])
            );
        end
    endgenerate

    always@(posedge clk_fast) begin
        usb_read <= u_rxdv;
        u_txen <= usb_send;
    end












endmodule