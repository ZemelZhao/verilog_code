module spi(
    input clk,
    input rst,

    input fs,
    output reg fd_spi,
    output reg fd_prd,

    input miso,
    output reg sclk,
    output reg mosi,
    output reg cs,

    input [15:0] chip_txd,
    output reg [31:0] chip_rxd
);

    reg [7:0] state, next_state;
    reg [15:0] chip_rxd0, chip_rxd1;
    reg [15:0] txd;

    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam TAKE = 8'h04, SPIPD = 8'h05;
    localparam SPI00 = 8'h10, SPI10 = 8'h11, SPI20 = 8'h12, SPI30 = 8'h13;
    localparam SPI01 = 8'h14, SPI11 = 8'h15, SPI21 = 8'h16, SPI31 = 8'h17;
    localparam SPI02 = 8'h18, SPI12 = 8'h19, SPI22 = 8'h1A, SPI32 = 8'h1B;
    localparam SPI03 = 8'h1C, SPI13 = 8'h1D, SPI23 = 8'h1E, SPI33 = 8'h1F;
    localparam SPI04 = 8'h20, SPI14 = 8'h21, SPI24 = 8'h22, SPI34 = 8'h23;
    localparam SPI05 = 8'h24, SPI15 = 8'h25, SPI25 = 8'h26, SPI35 = 8'h27;
    localparam SPI06 = 8'h28, SPI16 = 8'h29, SPI26 = 8'h2A, SPI36 = 8'h2B;
    localparam SPI07 = 8'h2C, SPI17 = 8'h2D, SPI27 = 8'h2E, SPI37 = 8'h2F;
    localparam SPI08 = 8'h30, SPI18 = 8'h31, SPI28 = 8'h32, SPI38 = 8'h33;
    localparam SPI09 = 8'h34, SPI19 = 8'h35, SPI29 = 8'h36, SPI39 = 8'h37;
    localparam SPI0A = 8'h38, SPI1A = 8'h39, SPI2A = 8'h3A, SPI3A = 8'h3B;
    localparam SPI0B = 8'h3C, SPI1B = 8'h3D, SPI2B = 8'h3E, SPI3B = 8'h3F;
    localparam SPI0C = 8'h40, SPI1C = 8'h41, SPI2C = 8'h42, SPI3C = 8'h43;
    localparam SPI0D = 8'h44, SPI1D = 8'h45, SPI2D = 8'h46, SPI3D = 8'h47;
    localparam SPI0E = 8'h48, SPI1E = 8'h49, SPI2E = 8'h4A, SPI3E = 8'h4B;
    localparam SPI0F = 8'h4C, SPI1F = 8'h4D, SPI2F = 8'h4E, SPI3F = 8'h4F;
    localparam LAST0 = 8'h50, LAST1 = 8'h51, LAST2 = 8'h52, LAST3 = 8'h53;
    localparam WAIT0 = 8'h60, WAIT1 = 8'h61, WAIT2 = 8'h62, WAIT3 = 8'h63;
    localparam WAIT4 = 8'h64, WAIT5 = 8'h65, WAIT6 = 8'h66, WAIT7 = 8'h67;
    localparam WAIT8 = 8'h68, WAIT9 = 8'h69; 

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: next_state <= TAKE;
            TAKE: next_state <= SPI00;
            SPI00: next_state <= SPI10;
            SPI10: next_state <= SPI20;
            SPI20: next_state <= SPI30;
            SPI30: next_state <= SPI01;
            SPI01: next_state <= SPI11;
            SPI11: next_state <= SPI21;
            SPI21: next_state <= SPI31;
            SPI31: next_state <= SPI02;
            SPI02: next_state <= SPI12;
            SPI12: next_state <= SPI22;
            SPI22: next_state <= SPI32;
            SPI32: next_state <= SPI03;
            SPI03: next_state <= SPI13;
            SPI13: next_state <= SPI23;
            SPI23: next_state <= SPI33;
            SPI33: next_state <= SPI04;
            SPI04: next_state <= SPI14;
            SPI14: next_state <= SPI24;
            SPI24: next_state <= SPI34;
            SPI34: next_state <= SPI05;
            SPI05: next_state <= SPI15;
            SPI15: next_state <= SPI25;
            SPI25: next_state <= SPI35;
            SPI35: next_state <= SPI06;
            SPI06: next_state <= SPI16;
            SPI16: next_state <= SPI26;
            SPI26: next_state <= SPI36;
            SPI36: next_state <= SPI07;
            SPI07: next_state <= SPI17;
            SPI17: next_state <= SPI27;
            SPI27: next_state <= SPI37;
            SPI37: next_state <= SPI08;
            SPI08: next_state <= SPI18;
            SPI18: next_state <= SPI28;
            SPI28: next_state <= SPI38;
            SPI38: next_state <= SPI09;
            SPI09: next_state <= SPI19;
            SPI19: next_state <= SPI29;
            SPI29: next_state <= SPI39;
            SPI39: next_state <= SPI0A;
            SPI0A: next_state <= SPI1A;
            SPI1A: next_state <= SPI2A;
            SPI2A: next_state <= SPI3A;
            SPI3A: next_state <= SPI0B;
            SPI0B: next_state <= SPI1B;
            SPI1B: next_state <= SPI2B;
            SPI2B: next_state <= SPI3B;
            SPI3B: next_state <= SPI0C;
            SPI0C: next_state <= SPI1C;
            SPI1C: next_state <= SPI2C;
            SPI2C: next_state <= SPI3C;
            SPI3C: next_state <= SPI0D;
            SPI0D: next_state <= SPI1D;
            SPI1D: next_state <= SPI2D;
            SPI2D: next_state <= SPI3D;
            SPI3D: next_state <= SPI0E;
            SPI0E: next_state <= SPI1E;
            SPI1E: next_state <= SPI2E;
            SPI2E: next_state <= SPI3E;
            SPI3E: next_state <= SPI0F;
            SPI0F: next_state <= SPI1F;
            SPI1F: next_state <= SPI2F;
            SPI2F: next_state <= SPI3F;
            SPI3F: next_state <= LAST0;
            LAST0: next_state <= LAST1;
            LAST1: next_state <= LAST2;
            LAST2: next_state <= LAST3;
            LAST3: next_state <= SPIPD;
            SPIPD: next_state <= WAIT0;
            WAIT0: next_state <= WAIT1;
            WAIT1: next_state <= WAIT2;
            WAIT2: next_state <= WAIT3;
            WAIT3: next_state <= WAIT4;
            WAIT4: next_state <= WAIT5;
            WAIT5: next_state <= WAIT6;
            WAIT6: next_state <= WAIT7;
            WAIT7: next_state <= WAIT8;
            WAIT8: next_state <= WAIT9;
            WAIT9: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin // cs
        if(rst) cs <= 1'b1;
        else if(state == IDLE) cs <= 1'b1;
        else if(state == SPIPD) cs <= 1'b1;
        else if(state == WORK) cs <= 1'b0;
        else cs <= cs;
    end

    always@(posedge clk or posedge rst) begin // mosi
        if(rst) mosi <= 1'b0;
        else if(state == IDLE) mosi <= 1'b0;
        else if(state == SPIPD) mosi <= 1'b0;
        else if(state == WORK) mosi <= 1'b0;
        else if(state == SPI00) mosi <= txd[15];
        else if(state == SPI01) mosi <= txd[14];
        else if(state == SPI02) mosi <= txd[13];
        else if(state == SPI03) mosi <= txd[12];
        else if(state == SPI04) mosi <= txd[11];
        else if(state == SPI05) mosi <= txd[10];
        else if(state == SPI06) mosi <= txd[9];
        else if(state == SPI07) mosi <= txd[8];
        else if(state == SPI08) mosi <= txd[7];
        else if(state == SPI09) mosi <= txd[6];
        else if(state == SPI0A) mosi <= txd[5];
        else if(state == SPI0B) mosi <= txd[4];
        else if(state == SPI0C) mosi <= txd[3];
        else if(state == SPI0D) mosi <= txd[2];
        else if(state == SPI0E) mosi <= txd[1];
        else if(state == SPI0F) mosi <= txd[0];
        else mosi <= mosi;
    end

    always@(posedge clk or posedge rst) begin // chip_rxd0
        if(rst) chip_rxd0 <= 16'h0000;
        else if(state == IDLE) chip_rxd0 <= 16'h0000;
        else if(state == WAIT) chip_rxd0 <= 16'h0000;
        else if(state == SPI30) chip_rxd0[15] <= miso;
        else if(state == SPI31) chip_rxd0[14] <= miso;
        else if(state == SPI32) chip_rxd0[13] <= miso;
        else if(state == SPI33) chip_rxd0[12] <= miso;
        else if(state == SPI34) chip_rxd0[11] <= miso;
        else if(state == SPI35) chip_rxd0[10] <= miso;
        else if(state == SPI36) chip_rxd0[9] <= miso;
        else if(state == SPI37) chip_rxd0[8] <= miso;
        else if(state == SPI38) chip_rxd0[7] <= miso;
        else if(state == SPI39) chip_rxd0[6] <= miso;
        else if(state == SPI3A) chip_rxd0[5] <= miso;
        else if(state == SPI3B) chip_rxd0[4] <= miso;
        else if(state == SPI3C) chip_rxd0[3] <= miso;
        else if(state == SPI3D) chip_rxd0[2] <= miso;
        else if(state == SPI3E) chip_rxd0[1] <= miso;
        else if(state == SPI3F) chip_rxd0[0] <= miso;
        else chip_rxd0 <= chip_rxd0;
    end
    
    always@(posedge clk or posedge rst) begin // chip_rxd1
        if(rst) chip_rxd1 <= 16'h0000;
        else if(state == IDLE) chip_rxd1 <= 16'h0000;
        else if(state == WAIT) chip_rxd1 <= 16'h0000;
        else if(state == SPI11) chip_rxd1[15] <= miso;
        else if(state == SPI12) chip_rxd1[14] <= miso;
        else if(state == SPI13) chip_rxd1[13] <= miso;
        else if(state == SPI14) chip_rxd1[12] <= miso;
        else if(state == SPI15) chip_rxd1[11] <= miso;
        else if(state == SPI16) chip_rxd1[10] <= miso;
        else if(state == SPI17) chip_rxd1[9] <= miso;
        else if(state == SPI18) chip_rxd1[8] <= miso;
        else if(state == SPI19) chip_rxd1[7] <= miso;
        else if(state == SPI1A) chip_rxd1[6] <= miso;
        else if(state == SPI1B) chip_rxd1[5] <= miso;
        else if(state == SPI1C) chip_rxd1[4] <= miso;
        else if(state == SPI1D) chip_rxd1[3] <= miso;
        else if(state == SPI1E) chip_rxd1[2] <= miso;
        else if(state == SPI1F) chip_rxd1[1] <= miso;
        else if(state == LAST1) chip_rxd1[0] <= miso;
        else chip_rxd1 <= chip_rxd1;
    end

    always@(posedge clk or posedge rst) begin // sclk
        if(rst) sclk <= 1'b0;
        else if(state == IDLE) sclk <= 1'b0;
        else if(state == WAIT) sclk <= 1'b0;
        else if(state == SPIPD) sclk <= 1'b0;
        else if(state == SPI10) sclk <= 1'b1;
        else if(state == SPI11) sclk <= 1'b1;
        else if(state == SPI12) sclk <= 1'b1;
        else if(state == SPI13) sclk <= 1'b1;
        else if(state == SPI14) sclk <= 1'b1;
        else if(state == SPI15) sclk <= 1'b1;
        else if(state == SPI16) sclk <= 1'b1;
        else if(state == SPI17) sclk <= 1'b1;
        else if(state == SPI18) sclk <= 1'b1;
        else if(state == SPI19) sclk <= 1'b1;
        else if(state == SPI1A) sclk <= 1'b1;
        else if(state == SPI1B) sclk <= 1'b1;
        else if(state == SPI1C) sclk <= 1'b1;
        else if(state == SPI1D) sclk <= 1'b1;
        else if(state == SPI1E) sclk <= 1'b1;
        else if(state == SPI1F) sclk <= 1'b1;
        else if(state == SPI30) sclk <= 1'b0;
        else if(state == SPI31) sclk <= 1'b0;
        else if(state == SPI32) sclk <= 1'b0;
        else if(state == SPI33) sclk <= 1'b0;
        else if(state == SPI34) sclk <= 1'b0;
        else if(state == SPI35) sclk <= 1'b0;
        else if(state == SPI36) sclk <= 1'b0;
        else if(state == SPI37) sclk <= 1'b0;
        else if(state == SPI38) sclk <= 1'b0;
        else if(state == SPI39) sclk <= 1'b0;
        else if(state == SPI3A) sclk <= 1'b0;
        else if(state == SPI3B) sclk <= 1'b0;
        else if(state == SPI3C) sclk <= 1'b0;
        else if(state == SPI3D) sclk <= 1'b0;
        else if(state == SPI3E) sclk <= 1'b0;
        else if(state == SPI3F) sclk <= 1'b0;
        else sclk <= sclk;
    end

    always@(posedge clk or posedge rst) begin // fd_spi
        if(rst) fd_spi <= 1'b0;
        else if(state == IDLE) fd_spi <= 1'b0;
        else if(state == WAIT) fd_spi <= 1'b0;
        else if(state == DONE) fd_spi <= 1'b0;
        else if(state == SPIPD) fd_spi <= 1'b1;
        else fd_spi <= fd_spi;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fd_prd <= 1'b0;
        else if(state == DONE) fd_prd <= 1'b1;
        else fd_prd <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) chip_rxd <= 32'h00000000;
        else if(state == IDLE) chip_rxd <= 32'h00000000;
        else if(state == LAST3) chip_rxd <= {chip_rxd0, chip_rxd1};
        else chip_rxd <= chip_rxd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txd <= 16'h0000;
        else if(state == IDLE) txd <= 16'h0000;
        else if(state == TAKE) txd <= chip_txd;
        else txd <= txd;
    end

endmodule