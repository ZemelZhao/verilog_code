module tb_com_clk(
    input clk,
    input rst,

    (*MARK_DEBUG = "true"*)input [3:0] pm_rxd,
    (*MARK_DEBUG = "true"*)input ps_rxd,
    (*MARK_DEBUG = "true"*)output [3:0] ps_txd,
    (*MARK_DEBUG = "true"*)output pm_txd,

    (*MARK_DEBUG = "true"*)input pm_recv,
    (*MARK_DEBUG = "true"*)input ps_recv,

    (*MARK_DEBUG = "true"*)output pm_send,
    (*MARK_DEBUG = "true"*)output ps_send
);

    (*MARK_DEBUG = "true"*)reg [7:0] state; 
    reg [7:0] next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, DONE = 8'h02; 
    localparam WK00 = 8'h10, WK01 = 8'h11, WK02 = 8'h12, WK03 = 8'h13;
    localparam WK04 = 8'h14, WK05 = 8'h15, WK06 = 8'h16, WK07 = 8'h17;
    localparam WK08 = 8'h18, WK09 = 8'h19, WK0A = 8'h1A, WK0B = 8'h1B;
    localparam WK0C = 8'h1C, WK0D = 8'h1D, WK0E = 8'h1E, WK0F = 8'h1F;

    localparam WT00 = 8'h20, WT01 = 8'h21, WT02 = 8'h22, WT03 = 8'h23;
    localparam WT04 = 8'h24, WT05 = 8'h25, WT06 = 8'h26, WT07 = 8'h27;
    localparam WT08 = 8'h28, WT09 = 8'h29, WT0A = 8'h2A, WT0B = 8'h2B;
    localparam WT0C = 8'h2C, WT0D = 8'h2D, WT0E = 8'h2E, WT0F = 8'h2F;


    wire clk_25, clk_50, clk_100, clk_200;
    wire wclk;

    reg [7:0] num; 
    reg [7:0] cnt; 

    (*MARK_DEBUG = "true"*)wire res;

    assign wclk = clk_25;
    assign ps_txd = num[3:0];
    assign pm_txd = 1'b0;
    assign pm_send = 1'b0;
    assign ps_send = 1'b0;
    assign res = ^pm_rxd ^ ps_rxd ^ pm_recv ^ ps_recv;


    always@(posedge wclk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= WT00;
            WT00: next_state <= WK00;
            WK00: begin
                if(num > 4'hF) next_state <= WT01;
                else next_state <= WK00;
            end
            WT01: next_state <= WK01;
            WK01: begin
                if(num > 4'hF) next_state <= WT02;
                else next_state <= WK01;
            end
            WT02: next_state <= WK02;
            WK02: begin
                if(num > 4'hF) next_state <= WT03;
                else next_state <= WK02;
            end
            WT03: next_state <= WK03;
            WK03: begin
                if(num > 4'hF) next_state <= WT04;
                else next_state <= WK03;
            end
            WT04: next_state <= WK04;
            WK04: begin
                if(num > 4'hF) next_state <= WT05;
                else next_state <= WK04;
            end
            WT05: next_state <= WK05;
            WK05: begin
                if(num > 4'hF) next_state <= WT06;
                else next_state <= WK05;
            end
            WT06: next_state <= WK06;
            WK06: begin
                if(num > 4'hF) next_state <= WT07;
                else next_state <= WK06;
            end
            WT07: next_state <= WK07;
            WK07: begin
                if(num > 4'hF) next_state <= WT08;
                else next_state <= WK07;
            end
            WT08: next_state <= WK08;
            WK08: begin
                if(num > 4'hF) next_state <= WT09;
                else next_state <= WK08;
            end
            WT09: next_state <= WK09;
            WK09: begin
                if(num > 4'hF) next_state <= WT0A;
                else next_state <= WK09;
            end
            WT0A: next_state <= WK0A;
            WK0A: begin
                if(num > 4'hF) next_state <= WT0B;
                else next_state <= WK0A;
            end
            WT0B: next_state <= WK0B;
            WK0B: begin
                if(num > 4'hF) next_state <= WT0C;
                else next_state <= WK0B;
            end
            WT0C: next_state <= WK0C;
            WK0C: begin
                if(num > 4'hF) next_state <= WT0D;
                else next_state <= WK0C;
            end
            WT0D: next_state <= WK0D;
            WK0D: begin
                if(num > 4'hF) next_state <= WT0E;
                else next_state <= WK0D;
            end
            WT0E: next_state <= WK0E;
            WK0E: begin
                if(num > 4'hF) next_state <= WT0F;
                else next_state <= WK0E;
            end
            WT0F: next_state <= WK0F;
            WK0F: begin
                if(num > 4'hF) next_state <= DONE;
                else next_state <= WK0F;
            end
            DONE: begin
                if(res) next_state <= IDLE;
                else next_state <= WAIT;
            end
            
            default: next_state <= IDLE;
        endcase
    end


    always@(posedge wclk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == IDLE) num <= 8'h00;
        else if(state == WAIT) num <= 8'h00;

        else if(state == WT00) num <= 8'h00;
        else if(state == WT01) num <= 8'h00;
        else if(state == WT02) num <= 8'h00;
        else if(state == WT03) num <= 8'h00;
        else if(state == WT04) num <= 8'h00;
        else if(state == WT05) num <= 8'h00;
        else if(state == WT06) num <= 8'h00;
        else if(state == WT07) num <= 8'h00;
        else if(state == WT08) num <= 8'h00;
        else if(state == WT09) num <= 8'h00;
        else if(state == WT0A) num <= 8'h00;
        else if(state == WT0B) num <= 8'h00;
        else if(state == WT0C) num <= 8'h00;
        else if(state == WT0D) num <= 8'h00;
        else if(state == WT0E) num <= 8'h00;
        else if(state == WT0F) num <= 8'h00;

        else if(state == WK00 && cnt >= 8'h00) num <= num + 1'b1;
        else if(state == WK01 && cnt >= 8'h01) num <= num + 1'b1;
        else if(state == WK02 && cnt >= 8'h02) num <= num + 1'b1;
        else if(state == WK03 && cnt >= 8'h03) num <= num + 1'b1;
        else if(state == WK04 && cnt >= 8'h04) num <= num + 1'b1;
        else if(state == WK05 && cnt >= 8'h05) num <= num + 1'b1;
        else if(state == WK06 && cnt >= 8'h06) num <= num + 1'b1;
        else if(state == WK07 && cnt >= 8'h07) num <= num + 1'b1;
        else if(state == WK08 && cnt >= 8'h08) num <= num + 1'b1;
        else if(state == WK09 && cnt >= 8'h09) num <= num + 1'b1;
        else if(state == WK0A && cnt >= 8'h0A) num <= num + 1'b1;
        else if(state == WK0B && cnt >= 8'h0B) num <= num + 1'b1;
        else if(state == WK0C && cnt >= 8'h0C) num <= num + 1'b1;
        else if(state == WK0D && cnt >= 8'h0D) num <= num + 1'b1;
        else if(state == WK0E && cnt >= 8'h0E) num <= num + 1'b1;
        else if(state == WK0F && cnt >= 8'h0F) num <= num + 1'b1;
        else num <= num;

    end

    always@(posedge wclk or posedge rst) begin
        if(rst) cnt <= 8'h00;
        else if(state == IDLE) cnt <= 8'h00;
        else if(state == WAIT) cnt <= 8'h00;

        else if(state == WT00) cnt <= 8'h00;
        else if(state == WT01) cnt <= 8'h00;
        else if(state == WT02) cnt <= 8'h00;
        else if(state == WT03) cnt <= 8'h00;
        else if(state == WT04) cnt <= 8'h00;
        else if(state == WT05) cnt <= 8'h00;
        else if(state == WT06) cnt <= 8'h00;
        else if(state == WT07) cnt <= 8'h00;
        else if(state == WT08) cnt <= 8'h00;
        else if(state == WT09) cnt <= 8'h00;
        else if(state == WT0A) cnt <= 8'h00;
        else if(state == WT0B) cnt <= 8'h00;
        else if(state == WT0C) cnt <= 8'h00;
        else if(state == WT0D) cnt <= 8'h00;
        else if(state == WT0E) cnt <= 8'h00;
        else if(state == WT0F) cnt <= 8'h00;

        else if(state == WK00 && cnt >= 8'h00) cnt <= 8'h00;
        else if(state == WK01 && cnt >= 8'h01) cnt <= 8'h00;
        else if(state == WK02 && cnt >= 8'h02) cnt <= 8'h00;
        else if(state == WK03 && cnt >= 8'h03) cnt <= 8'h00;
        else if(state == WK04 && cnt >= 8'h04) cnt <= 8'h00;
        else if(state == WK05 && cnt >= 8'h05) cnt <= 8'h00;
        else if(state == WK06 && cnt >= 8'h06) cnt <= 8'h00;
        else if(state == WK07 && cnt >= 8'h07) cnt <= 8'h00;
        else if(state == WK08 && cnt >= 8'h08) cnt <= 8'h00;
        else if(state == WK09 && cnt >= 8'h09) cnt <= 8'h00;
        else if(state == WK0A && cnt >= 8'h0A) cnt <= 8'h00;
        else if(state == WK0B && cnt >= 8'h0B) cnt <= 8'h00;
        else if(state == WK0C && cnt >= 8'h0C) cnt <= 8'h00;
        else if(state == WK0D && cnt >= 8'h0D) cnt <= 8'h00;
        else if(state == WK0E && cnt >= 8'h0E) cnt <= 8'h00;
        else if(state == WK0F && cnt >= 8'h0F) cnt <= 8'h00;

        else cnt <= cnt + 1'b1;

    end


    mmcm
    mmcm_dut(
        .clk_in(clk),
        .clk_out1(clk_25),
        .clk_out2(clk_50),
        .clk_out3(clk_100),
        .clk_out4(clk_200)
    );




endmodule