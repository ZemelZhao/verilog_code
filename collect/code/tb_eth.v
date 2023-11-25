module tb_eth(
    input clk_in_p,
    input clk_in_n,
    input rst_n,

    output fan_n,

    output e_rstn,
    output e_mdc,
    input e_mdio,

    input e_grxc,
    input e_rxdv,
    input e_rxer,
    input [7:0] e_rxd,

    output e_gtxc,
    output e_txen,
    output e_txer,
    output [7:0] e_txd
);

    localparam GAP = 8'd90;

    wire clk_in; // 200MHz
    wire clk; // 75Mhz

    wire rst;

    assign rst = ~rst_n;
    assign fan_n = 1'b0;


    reg [7:0] state, next_state;
    localparam IDLE = 8'h01,  WAIT = 8'h02, DONE = 8'h04;
    localparam ETH_RX = 8'h10, ETH_TX = 8'h20;

    wire fs_eth_tx, fd_eth_tx;
    wire fs_eth_rx, fd_eth_rx;

    wire [12:0] eth_taddr;
    wire [6:0] eth_raddr;
    wire [7:0] eth_txd, eth_rxd;
    wire eth_rxdv;

    reg [15:0] num;

    assign fs_eth_tx = (state == ETH_TX);
    assign fd_eth_rx = (state == ETH_RX);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs_eth_rx) next_state <= ETH_RX;
                else if(num >= GAP - 1'b1) next_state <= ETH_TX;
                else next_state <= WAIT;
            end

            ETH_RX: begin
                if(~fs_eth_rx) next_state <= DONE;
                else next_state <= ETH_RX;
            end

            ETH_TX: begin
                if(fd_eth_tx) next_state <= DONE;
                else next_state <= ETH_TX;
            end

            DONE: next_state <= WAIT;

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 16'h0000;
        else if(state == WAIT) num <= num + 1'b1;
        else num <= 16'h0000;
    end


    IBUFGDS
    ibufgds_clk(
        .I(clk_in_p),
        .IB(clk_in_n),
        .O(clk_in) 
    );

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk_in),
        .clk_75(clk)
    );

    eth
    eth_dut(
        .clk(),
        .rst(rst),

// CONTROL
        .fs_tx(fs_eth_tx),
        .fd_tx(fd_eth_tx),
        .fs_rx(fs_eth_rx),
        .fd_rx(fd_eth_rx),

// GPIO
        .e_mdc(e_mdc),
        .e_mdio(e_mdio),
        .e_rstn(e_rstn),

        .e_grxc(e_grxc),
        .e_gtxc(e_gtxc),
        .e_rxdv(e_rxdv),
        .e_txen(e_txen),
        .e_rxer(e_rxer),
        .e_txer(e_txer),

        .e_txd(e_txd),
        .e_rxd(e_rxd),

// RAM
        .eth_taddr(eth_taddr),
        .eth_txd(eth_txd),

        .eth_raddr(eth_raddr),
        .eth_rxd(eth_rxd),
        .eth_rxdv(eth_rxdv)
    );

    ram_8192_8
    ram_eth_tx_dut(
        .clka(),
        .addra(),
        .dina(),
        .wea(),

        .clkb(e_gtxc),
        .addrb(eth_taddr),
        .doutb(eth_txd)
    );

    ram_128_8
    ram_eth_tx_dut(
        .clka(e_grxc),
        .addra(eth_raddr),
        .dina(eth_rxd),
        .wea(eth_rxdv),

        .clkb(),
        .addrb(),
        .doutb()
    );


endmodule