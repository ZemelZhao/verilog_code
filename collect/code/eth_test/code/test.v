module test(
    input clk_in_p,
    input clk_in_n,

    input e_grxc,
    input e_rxdv,
    input [7:0] e_rxd,
    input e_rxer,

    output e_gtxc,
    output reg e_txen,
    output reg [7:0] e_txd,
    output e_txer,

    output e_rstn,
    output e_mdc,
    input e_mdio,

    output fan_n,
    output led_n
);

    wire clk_in;
    wire clk;
    wire rst;

    (*MARK_DEBUG = "true"*)reg [7:0] rxd;
    (*MARK_DEBUG = "true"*)reg rxdv;

    assign clk = e_gtxc;

    reg [15:0] num;
    reg rst;

    assign fan_n = 1'b0;
    assign led_n = 1'b0;

    assign e_gtxc = e_grxc;
    assign e_rstn = 1'b1;
    assign e_txer = 1'b0;
    assign e_mdc = 1'b0;

    // assign e_txd = 8'h00;
    // assign e_txen = 1'b0;

    assign rst = rxdv;

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 32'h00;
        else if(num == 32'd125_000_000) num <= 32'h00;
        else num <= num + 1'b1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) e_txd <= 8'h00;
        else if(num == 32'h01) e_txd <= 8'h55;
        else if(num == 32'h02) e_txd <= 8'h55;
        else if(num == 32'h03) e_txd <= 8'h55;
        else if(num == 32'h04) e_txd <= 8'h55;
        else if(num == 32'h05) e_txd <= 8'h55;
        else if(num == 32'h06) e_txd <= 8'h55;
        else if(num == 32'h07) e_txd <= 8'h55;
        else if(num == 32'h08) e_txd <= 8'hD5;
        else if(num == 32'h09) e_txd <= 8'hFF;
        else if(num == 32'h0A) e_txd <= 8'hFF;
        else if(num == 32'h0B) e_txd <= 8'hFF;
        else if(num == 32'h0C) e_txd <= 8'hFF;
        else if(num == 32'h0D) e_txd <= 8'hFF;
        else if(num == 32'h0E) e_txd <= 8'hFF;
        else if(num == 32'h0F) e_txd <= 8'h3C;
        else if(num == 32'h10) e_txd <= 8'hEC;
        else if(num == 32'h11) e_txd <= 8'hEF;
        else if(num == 32'h12) e_txd <= 8'hF5;
        else if(num == 32'h13) e_txd <= 8'h75;
        else if(num == 32'h14) e_txd <= 8'h63;
        else if(num == 32'h15) e_txd <= 8'h08;
        else if(num == 32'h16) e_txd <= 8'h06;
        else if(num == 32'h17) e_txd <= 8'h00;
        else if(num == 32'h18) e_txd <= 8'h01;
        else if(num == 32'h19) e_txd <= 8'h08;
        else if(num == 32'h1A) e_txd <= 8'h00;
        else if(num == 32'h1B) e_txd <= 8'h06;
        else if(num == 32'h1C) e_txd <= 8'h04;
        else if(num == 32'h1D) e_txd <= 8'h00;
        else if(num == 32'h1E) e_txd <= 8'h01;
        else if(num == 32'h1F) e_txd <= 8'h3C;
        else if(num == 32'h20) e_txd <= 8'hEC;
        else if(num == 32'h21) e_txd <= 8'hEF;
        else if(num == 32'h22) e_txd <= 8'hF5;
        else if(num == 32'h23) e_txd <= 8'h75;
        else if(num == 32'h24) e_txd <= 8'h63;
        else if(num == 32'h25) e_txd <= 8'hC0;
        else if(num == 32'h26) e_txd <= 8'hA8;
        else if(num == 32'h27) e_txd <= 8'h00;
        else if(num == 32'h28) e_txd <= 8'h03;
        else if(num == 32'h29) e_txd <= 8'h00;
        else if(num == 32'h2A) e_txd <= 8'h00;
        else if(num == 32'h2B) e_txd <= 8'h00;
        else if(num == 32'h2C) e_txd <= 8'h00;
        else if(num == 32'h2D) e_txd <= 8'h00;
        else if(num == 32'h2E) e_txd <= 8'h00;
        else if(num == 32'h2F) e_txd <= 8'hC0;
        else if(num == 32'h30) e_txd <= 8'hA8;
        else if(num == 32'h31) e_txd <= 8'h00;
        else if(num == 32'h32) e_txd <= 8'h02;
        else if(num == 32'h33) e_txd <= 8'h00;
        else if(num == 32'h34) e_txd <= 8'h00;
        else if(num == 32'h35) e_txd <= 8'h00;
        else if(num == 32'h36) e_txd <= 8'h00;
        else if(num == 32'h37) e_txd <= 8'h00;
        else if(num == 32'h38) e_txd <= 8'h00;
        else if(num == 32'h39) e_txd <= 8'h00;
        else if(num == 32'h3A) e_txd <= 8'h00;
        else if(num == 32'h3B) e_txd <= 8'h00;
        else if(num == 32'h3C) e_txd <= 8'h00;
        else if(num == 32'h3D) e_txd <= 8'h00;
        else if(num == 32'h3E) e_txd <= 8'h00;
        else if(num == 32'h3F) e_txd <= 8'h00;
        else if(num == 32'h40) e_txd <= 8'h00;
        else if(num == 32'h41) e_txd <= 8'h00;
        else if(num == 32'h42) e_txd <= 8'h00;
        else if(num == 32'h43) e_txd <= 8'h00;
        else if(num == 32'h44) e_txd <= 8'h00;
        else if(num == 32'h45) e_txd <= 8'h8A;
        else if(num == 32'h46) e_txd <= 8'h10;
        else if(num == 32'h47) e_txd <= 8'h97;
        else if(num == 32'h48) e_txd <= 8'h55;
        else e_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) e_txen <= 1'b1;
        else if(num == 32'h01) e_txen <= 1'b1;
        else if(num == 32'h49) e_txen <= 1'b0;
        else e_txen <= e_txen;
    end

    always@(negedge e_grxc) begin
        rxd <= e_rxd;
        rxdv <= e_rxdv;
    end

    always@(posedge e_gtxc) begin
    end



    IBUFGDS
    ibufgds_dut(
        .I(clk_in_p),
        .IB(clk_in_n),
        .O(clk_in)
    );





endmodule

