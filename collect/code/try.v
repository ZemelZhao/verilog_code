module try(
    input clk_in_p,
    input clk_in_n,
    input rst_n,

    output fan_n,
    output led_n,

    output [3:0] usb_rxd_p,
    output [3:0] usb_rxd_n,
    output usb_txd_p,
    output usb_txd_n,
    output usb_txf,
    output usb_rxf
);

    wire clk, clk_in;
    wire [3:0] usb_rxd;
    wire usb_txd;

    (*MARK_DEBUG = "true"*)wire [3:0] pin_rxd;
    (*MARK_DEBUG = "true"*)wire pin_txd;
    (*MARK_DEBUG = "true"*)wire fire_read, fire_send;
    wire rst;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01;

    reg [4:0] num;

    assign usb_txf = fire_send;
    assign usb_rxf = fire_read;
    assign usb_txd = pin_txd;
    assign usb_rxd = pin_rxd;
    assign clk = clk_in;

    assign pin_txd = num[0];
    assign pin_rxd = num[4:1];
    assign fire_read = num[1];
    assign fire_send = num[2];
    assign fan_n = 1'b0;
    assign led_n = 1'b0;
    assign rst = ~rst_n;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 4'h0;
        else if(state == IDLE) num <= 4'h0;
        else if(state == WAIT) num <= num + 1'b1;
        else num <= 4'h0;
    end

    IBUFGDS
    ibufgds_clk(
        .I(clk_in_p),
        .IB(clk_in_n),
        .O(clk_in)
    );

    OBUFDS
    obufds_usb_rxd0(
        .I(usb_rxd[0]),
        .O(usb_rxd_p[0]),
        .OB(usb_rxd_n[0])
    );
    OBUFDS
    obufds_usb_rxd1(
        .I(usb_rxd[1]),
        .O(usb_rxd_p[1]),
        .OB(usb_rxd_n[1])
    );
    OBUFDS
    obufds_usb_rxd2(
        .I(usb_rxd[2]),
        .O(usb_rxd_p[2]),
        .OB(usb_rxd_n[2])
    );
    OBUFDS
    obufds_usb_rxd3(
        .I(usb_rxd[3]),
        .O(usb_rxd_p[3]),
        .OB(usb_rxd_n[3])
    );
    OBUFDS
    obufds_usb_txd(
        .I(usb_txd),
        .O(usb_txd_p),
        .OB(usb_txd_n)
    );






        



endmodule