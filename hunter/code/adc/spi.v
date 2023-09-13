module spi(
    input clk,
    input rst,

    input fs,
    output reg fd_spi,
    output fd_prd,

    input miso,
    output reg sclk,
    output reg mosi,
    output reg cs,

    input [15:0] chip_txd,
    output reg [15:0] chip_rxda,
    output reg [15:0] chip_rxdb
);

    reg [7:0] state, next_state;
    reg [15:0] chip_rxd0, chip_rxd1;

    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam SPIPD = 8'h04;
    localparam MOSI0 = 8'h10, SCLK0 = 8'h11, REST0 = 8'h12, MISO0 = 8'h13;
    localparam MOSI1 = 8'h14, SCLK1 = 8'h15, REST1 = 8'h16, MISO1 = 8'h17;
    localparam MOSI2 = 8'h18, SCLK2 = 8'h19, REST2 = 8'h1A, MISO2 = 8'h1B;
    localparam MOSI3 = 8'h1C, SCLK3 = 8'h1D, REST3 = 8'h1E, MISO3 = 8'h1F;
    localparam MOSI4 = 8'h20, SCLK4 = 8'h21, REST4 = 8'h22, MISO4 = 8'h23;
    localparam MOSI5 = 8'h24, SCLK5 = 8'h25, REST5 = 8'h26, MISO5 = 8'h27;
    localparam MOSI6 = 8'h28, SCLK6 = 8'h29, REST6 = 8'h2A, MISO6 = 8'h2B;
    localparam MOSI7 = 8'h2C, SCLK7 = 8'h2D, REST7 = 8'h2E, MISO7 = 8'h2F;
    localparam MOSI8 = 8'h30, SCLK8 = 8'h31, REST8 = 8'h32, MISO8 = 8'h33;
    localparam MOSI9 = 8'h34, SCLK9 = 8'h35, REST9 = 8'h36, MISO9 = 8'h37;
    localparam MOSIA = 8'h38, SCLKA = 8'h39, RESTA = 8'h3A, MISOA = 8'h3B;
    localparam MOSIB = 8'h3C, SCLKB = 8'h3D, RESTB = 8'h3E, MISOB = 8'h3F;
    localparam MOSIC = 8'h40, SCLKC = 8'h41, RESTC = 8'h42, MISOC = 8'h43;
    localparam MOSID = 8'h44, SCLKD = 8'h45, RESTD = 8'h46, MISOD = 8'h47;
    localparam MOSIE = 8'h48, SCLKE = 8'h49, RESTE = 8'h4A, MISOE = 8'h4B;
    localparam MOSIF = 8'h4C, SCLKF = 8'h4D, RESTF = 8'h4E, MISOF = 8'h4F;
    localparam LAST0 = 8'h50, LAST1 = 8'h51, LAST2 = 8'h52;
    localparam WAIT0 = 8'h60, WAIT1 = 8'h61, WAIT2 = 8'h62, WAIT3 = 4'h63;
    localparam WAIT4 = 8'h64, WAIT5 = 8'h65, WAIT6 = 8'h66, WAIT7 = 4'h67;
    localparam WAIT8 = 8'h68, WAIT9 = 8'h69; 

    assign fd_prd = (state == DONE);

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
            WORK: next_state <= MOSI0;
            MOSI0: next_state <= SCLK0;
            SCLK0: next_state <= REST0;
            REST0: next_state <= MISO0;
            MISO0: next_state <= MOSI1;
            MOSI1: next_state <= SCLK1;
            SCLK1: next_state <= REST1;
            REST1: next_state <= MISO1;
            MISO1: next_state <= MOSI2;
            MOSI2: next_state <= SCLK2;
            SCLK2: next_state <= REST2;
            REST2: next_state <= MISO2;
            MISO2: next_state <= MOSI3;
            MOSI3: next_state <= SCLK3;
            SCLK3: next_state <= REST3;
            REST3: next_state <= MISO3;
            MISO3: next_state <= MOSI4;
            MOSI4: next_state <= SCLK4;
            SCLK4: next_state <= REST4;
            REST4: next_state <= MISO4;
            MISO4: next_state <= MOSI5;
            MOSI5: next_state <= SCLK5;
            SCLK5: next_state <= REST5;
            REST5: next_state <= MISO5;
            MISO5: next_state <= MOSI6;
            MOSI6: next_state <= SCLK6;
            SCLK6: next_state <= REST6;
            REST6: next_state <= MISO6;
            MISO6: next_state <= MOSI7;
            MOSI7: next_state <= SCLK7;
            SCLK7: next_state <= REST7;
            REST7: next_state <= MISO7;
            MISO7: next_state <= MOSI8;
            MOSI8: next_state <= SCLK8;
            SCLK8: next_state <= REST8;
            REST8: next_state <= MISO8;
            MISO8: next_state <= MOSI9;
            MOSI9: next_state <= SCLK9;
            SCLK9: next_state <= REST9;
            REST9: next_state <= MISO9;
            MISO9: next_state <= MOSIA;
            MOSIA: next_state <= SCLKA;
            SCLKA: next_state <= RESTA;
            RESTA: next_state <= MISOA;
            MISOA: next_state <= MOSIB;
            MOSIB: next_state <= SCLKB;
            SCLKB: next_state <= RESTB;
            RESTB: next_state <= MISOB;
            MISOB: next_state <= MOSIC;
            MOSIC: next_state <= SCLKC;
            SCLKC: next_state <= RESTC;
            RESTC: next_state <= MISOC;
            MISOC: next_state <= MOSID;
            MOSID: next_state <= SCLKD;
            SCLKD: next_state <= RESTD;
            RESTD: next_state <= MISOD;
            MISOD: next_state <= MOSIE;
            MOSIE: next_state <= SCLKE;
            SCLKE: next_state <= RESTE;
            RESTE: next_state <= MISOE;
            MISOE: next_state <= MOSIF;
            MOSIF: next_state <= SCLKF;
            SCLKF: next_state <= RESTF;
            RESTF: next_state <= MISOF;
            MISOF: next_state <= LAST0;
            LAST0: next_state <= LAST1;
            LAST1: next_state <= LAST2;
            LAST2: next_state <= SPIPD;
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
        else if(state == MOSI0) mosi <= chip_txd[15];
        else if(state == MOSI1) mosi <= chip_txd[14];
        else if(state == MOSI2) mosi <= chip_txd[13];
        else if(state == MOSI3) mosi <= chip_txd[12];
        else if(state == MOSI4) mosi <= chip_txd[11];
        else if(state == MOSI5) mosi <= chip_txd[10];
        else if(state == MOSI6) mosi <= chip_txd[9];
        else if(state == MOSI7) mosi <= chip_txd[8];
        else if(state == MOSI8) mosi <= chip_txd[7];
        else if(state == MOSI9) mosi <= chip_txd[6];
        else if(state == MOSIA) mosi <= chip_txd[5];
        else if(state == MOSIB) mosi <= chip_txd[4];
        else if(state == MOSIC) mosi <= chip_txd[3];
        else if(state == MOSID) mosi <= chip_txd[2];
        else if(state == MOSIE) mosi <= chip_txd[1];
        else if(state == MOSIF) mosi <= chip_txd[0];
        else mosi <= mosi;
    end

    always@(posedge clk or posedge rst) begin // chip_rxd0
        if(rst) chip_rxd0 <= 16'h0000;
        else if(state == IDLE) chip_rxd0 <= 16'h0000;
        else if(state == WAIT) chip_rxd0 <= 16'h0000;
        else if(state == MISO0) chip_rxd0[15] <= miso;
        else if(state == MISO1) chip_rxd0[14] <= miso;
        else if(state == MISO2) chip_rxd0[13] <= miso;
        else if(state == MISO3) chip_rxd0[12] <= miso;
        else if(state == MISO4) chip_rxd0[11] <= miso;
        else if(state == MISO5) chip_rxd0[10] <= miso;
        else if(state == MISO6) chip_rxd0[9] <= miso;
        else if(state == MISO7) chip_rxd0[8] <= miso;
        else if(state == MISO8) chip_rxd0[7] <= miso;
        else if(state == MISO9) chip_rxd0[6] <= miso;
        else if(state == MISOA) chip_rxd0[5] <= miso;
        else if(state == MISOB) chip_rxd0[4] <= miso;
        else if(state == MISOC) chip_rxd0[3] <= miso;
        else if(state == MISOD) chip_rxd0[2] <= miso;
        else if(state == MISOE) chip_rxd0[1] <= miso;
        else if(state == MISOF) chip_rxd0[0] <= miso;
        else chip_rxd0 <= chip_rxd0;
    end
    
    always@(posedge clk or posedge rst) begin // chip_rxd1
        if(rst) chip_rxd1 <= 16'h0000;
        else if(state == IDLE) chip_rxd1 <= 16'h0000;
        else if(state == WAIT) chip_rxd1 <= 16'h0000;
        else if(state == SCLK1) chip_rxd1[15] <= miso;
        else if(state == SCLK2) chip_rxd1[14] <= miso;
        else if(state == SCLK3) chip_rxd1[13] <= miso;
        else if(state == SCLK4) chip_rxd1[12] <= miso;
        else if(state == SCLK5) chip_rxd1[11] <= miso;
        else if(state == SCLK6) chip_rxd1[10] <= miso;
        else if(state == SCLK7) chip_rxd1[9] <= miso;
        else if(state == SCLK8) chip_rxd1[8] <= miso;
        else if(state == SCLK9) chip_rxd1[7] <= miso;
        else if(state == SCLKA) chip_rxd1[6] <= miso;
        else if(state == SCLKB) chip_rxd1[5] <= miso;
        else if(state == SCLKC) chip_rxd1[4] <= miso;
        else if(state == SCLKD) chip_rxd1[3] <= miso;
        else if(state == SCLKE) chip_rxd1[2] <= miso;
        else if(state == SCLKF) chip_rxd1[1] <= miso;
        else if(state == LAST1) chip_rxd1[0] <= miso;
        else chip_rxd1 <= chip_rxd1;
    end

    always@(posedge clk or posedge rst) begin // sclk
        if(rst) sclk <= 1'b0;
        else if(state == IDLE) sclk <= 1'b0;
        else if(state == WAIT) sclk <= 1'b0;
        else if(state == SPIPD) sclk <= 1'b0;
        else if(state == SCLK0) sclk <= 1'b1;
        else if(state == SCLK1) sclk <= 1'b1;
        else if(state == SCLK2) sclk <= 1'b1;
        else if(state == SCLK3) sclk <= 1'b1;
        else if(state == SCLK4) sclk <= 1'b1;
        else if(state == SCLK5) sclk <= 1'b1;
        else if(state == SCLK6) sclk <= 1'b1;
        else if(state == SCLK7) sclk <= 1'b1;
        else if(state == SCLK8) sclk <= 1'b1;
        else if(state == SCLK9) sclk <= 1'b1;
        else if(state == SCLKA) sclk <= 1'b1;
        else if(state == SCLKB) sclk <= 1'b1;
        else if(state == SCLKC) sclk <= 1'b1;
        else if(state == SCLKD) sclk <= 1'b1;
        else if(state == SCLKE) sclk <= 1'b1;
        else if(state == SCLKF) sclk <= 1'b1;
        else if(state == MISO0) sclk <= 1'b0;
        else if(state == MISO1) sclk <= 1'b0;
        else if(state == MISO2) sclk <= 1'b0;
        else if(state == MISO3) sclk <= 1'b0;
        else if(state == MISO4) sclk <= 1'b0;
        else if(state == MISO5) sclk <= 1'b0;
        else if(state == MISO6) sclk <= 1'b0;
        else if(state == MISO7) sclk <= 1'b0;
        else if(state == MISO8) sclk <= 1'b0;
        else if(state == MISO9) sclk <= 1'b0;
        else if(state == MISOA) sclk <= 1'b0;
        else if(state == MISOB) sclk <= 1'b0;
        else if(state == MISOC) sclk <= 1'b0;
        else if(state == MISOD) sclk <= 1'b0;
        else if(state == MISOE) sclk <= 1'b0;
        else if(state == MISOF) sclk <= 1'b0;
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
        if(rst) chip_rxda <= 16'h0000;
        else if(state == IDLE) chip_rxda <= 16'h0000;
        else if(state == LAST2) chip_rxda <= chip_rxd0;
        else chip_rxda <= chip_rxda;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) chip_rxdb <= 16'h0000;
        else if(state == IDLE) chip_rxdb <= 16'h0000;
        else if(state == LAST2) chip_rxdb <= chip_rxd1;
        else chip_rxdb <= chip_rxdb;
    end

endmodule