module com_rxf(
    input clk,
    input rst,

    input fire,
    input din,
    output reg [7:0] dout
);

    // PREMABLE CODE 5A 5A 5A 5A 01
    localparam PID_SYNC = 8'h01;
    localparam PID_PREM = 8'h5A;

    (*MARK_DEBUG = "true"*)reg [31:0] state, next_state;
    localparam IDLE = 32'h0000_0001, WAIT = 32'h0000_0002, WORK = 32'h0000_0004, DONE = 32'h0000_0008;
    localparam SYNC = 32'h0000_0010;
    localparam SYNC0 = 32'h0000_0100, SYNC1 = 32'h0000_0200, SYNC2 = 32'h0000_0400, SYNC3 = 32'h0000_0800;
    localparam SYNC4 = 32'h0000_1000, SYNC5 = 32'h0000_2000, SYNC6 = 32'h0000_4000, SYNC7 = 32'h0000_8000;
    localparam SYNC8 = 32'h0001_0000, SYNC9 = 32'h0002_0000, SYNCA = 32'h0004_0000, SYNCB = 32'h0008_0000;
    localparam SYNCC = 32'h0010_0000, SYNCD = 32'h0020_0000, SYNCE = 32'h0040_0000, SYNCF = 32'h0080_0000;
    localparam READ0 = 32'h0100_0000, READ1 = 32'h0200_0000, READ2 = 32'h0400_0000, READ3 = 32'h0800_0000;
    localparam READ4 = 32'h1000_0000, READ5 = 32'h2000_0000, READ6 = 32'h4000_0000, READ7 = 32'h8000_0000;


    reg [7:0] pos_rxd0, pos_rxd1, pos_rxd2, pos_rxd3;
    reg [7:0] pos_rxd4, pos_rxd5, pos_rxd6, pos_rxd7;
    reg [7:0] neg_rxd0, neg_rxd1, neg_rxd2, neg_rxd3;
    reg [7:0] neg_rxd4, neg_rxd5, neg_rxd6, neg_rxd7;

    reg [15:0] sync;
    reg [7:0] data;
    reg [3:0] num;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fire) next_state <= SYNC;
                else next_state <= WAIT;
            end
            SYNC: begin
                if(pos_rxd0 == PID_PREM) next_state <= SYNC0;
                else if(pos_rxd1 == PID_PREM) next_state <= SYNC1;
                else if(pos_rxd2 == PID_PREM) next_state <= SYNC2;
                else if(pos_rxd3 == PID_PREM) next_state <= SYNC3;
                else if(pos_rxd4 == PID_PREM) next_state <= SYNC4;
                else if(pos_rxd5 == PID_PREM) next_state <= SYNC5;
                else if(pos_rxd6 == PID_PREM) next_state <= SYNC6;
                else if(pos_rxd7 == PID_PREM) next_state <= SYNC7;
                else if(neg_rxd0 == PID_PREM) next_state <= SYNC8;
                else if(neg_rxd1 == PID_PREM) next_state <= SYNC9;
                else if(neg_rxd2 == PID_PREM) next_state <= SYNCA;
                else if(neg_rxd3 == PID_PREM) next_state <= SYNCB;
                else if(neg_rxd4 == PID_PREM) next_state <= SYNCC;
                else if(neg_rxd5 == PID_PREM) next_state <= SYNCD;
                else if(neg_rxd6 == PID_PREM) next_state <= SYNCE;
                else if(neg_rxd7 == PID_PREM) next_state <= SYNCF;
                else next_state <= SYNC;
            end
            SYNC0: begin
                if(pos_rxd0 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC1: begin
                if(pos_rxd1 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC2: begin
                if(pos_rxd2 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC3: begin
                if(pos_rxd3 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC4: begin
                if(pos_rxd4 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC5: begin
                if(pos_rxd5 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC6: begin
                if(pos_rxd6 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC7: begin
                if(pos_rxd7 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC8: begin
                if(neg_rxd0 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNC9: begin
                if(neg_rxd1 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNCA: begin
                if(neg_rxd2 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNCB: begin
                if(neg_rxd3 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNCC: begin
                if(neg_rxd4 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNCD: begin
                if(neg_rxd5 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNCE: begin
                if(neg_rxd6 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end
            SYNCF: begin
                if(neg_rxd7 == PID_PREM) next_state <= WORK;
                else next_state <= SYNC;
            end

            WORK: begin
                if(data == PID_SYNC) next_state <= READ0;
                else next_state <= WORK;
            end 
            READ0: next_state <= READ1;
            READ1: next_state <= READ2;
            READ2: next_state <= READ3;
            READ3: next_state <= READ4;
            READ4: next_state <= READ5;
            READ5: next_state <= READ6;
            READ6: next_state <= READ7;
            READ7: begin
                if(~fire) next_state <= DONE;
                else next_state <= READ0;
            end
            DONE: next_state <= WAIT;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) sync <= 16'h0000;
        else if(state == WAIT) sync <= 16'h0000;
        else if(state == SYNC) sync <= 16'h0000;
        else if(state == DONE) sync <= 16'h0000;
        else if(state == SYNC0) sync <= 16'h0001;
        else if(state == SYNC1) sync <= 16'h0002;
        else if(state == SYNC2) sync <= 16'h0004;
        else if(state == SYNC3) sync <= 16'h0008;
        else if(state == SYNC4) sync <= 16'h0010;
        else if(state == SYNC5) sync <= 16'h0020;
        else if(state == SYNC6) sync <= 16'h0040;
        else if(state == SYNC7) sync <= 16'h0080;
        else if(state == SYNC8) sync <= 16'h0100;
        else if(state == SYNC9) sync <= 16'h0200;
        else if(state == SYNCA) sync <= 16'h0400;
        else if(state == SYNCB) sync <= 16'h0800;
        else if(state == SYNCC) sync <= 16'h1000;
        else if(state == SYNCD) sync <= 16'h2000;
        else if(state == SYNCE) sync <= 16'h4000;
        else if(state == SYNCF) sync <= 16'h8000;
        else sync <= sync;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data <= 8'h00;
        else if(sync == 16'h0000) data <= 8'h00;
        else if(sync == 16'h0001) data <= pos_rxd0;
        else if(sync == 16'h0002) data <= pos_rxd1;
        else if(sync == 16'h0004) data <= pos_rxd2;
        else if(sync == 16'h0008) data <= pos_rxd3;
        else if(sync == 16'h0010) data <= pos_rxd4;
        else if(sync == 16'h0020) data <= pos_rxd5;
        else if(sync == 16'h0040) data <= pos_rxd6;
        else if(sync == 16'h0080) data <= pos_rxd7;
        else if(sync == 16'h0100) data <= neg_rxd0;
        else if(sync == 16'h0200) data <= neg_rxd1;
        else if(sync == 16'h0400) data <= neg_rxd2;
        else if(sync == 16'h0800) data <= neg_rxd3;
        else if(sync == 16'h1000) data <= neg_rxd4;
        else if(sync == 16'h2000) data <= neg_rxd5;
        else if(sync == 16'h4000) data <= neg_rxd6;
        else if(sync == 16'h8000) data <= neg_rxd7;
        else data <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dout <= 8'h00;
        else if(state == IDLE) dout <= 8'h00;
        else if(state == WAIT) dout <= 8'h00;
        else if(state == DONE) dout <= 8'h00;
        else if(state == READ0) dout <= data;
        else dout <= dout;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 4'h0;
        else if(state == IDLE) num <= 4'h0;
        else if(num == 4'h7) num <= 4'h0;
        else num <= num + 1'b1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd0 <= 8'h00;
        else if(state == IDLE) pos_rxd0 <= 8'h00;
        else if(state == WAIT) pos_rxd0 <= 8'h00;
        else if(num == 4'h0) pos_rxd0 <= {din, pos_rxd0[6:0]};
        else if(num == 4'h1) pos_rxd0 <= {pos_rxd0[7], din, pos_rxd0[5:0]};
        else if(num == 4'h2) pos_rxd0 <= {pos_rxd0[7:6], din, pos_rxd0[4:0]};
        else if(num == 4'h3) pos_rxd0 <= {pos_rxd0[7:5], din, pos_rxd0[3:0]};
        else if(num == 4'h4) pos_rxd0 <= {pos_rxd0[7:4], din, pos_rxd0[2:0]};
        else if(num == 4'h5) pos_rxd0 <= {pos_rxd0[7:3], din, pos_rxd0[1:0]};
        else if(num == 4'h6) pos_rxd0 <= {pos_rxd0[7:2], din, pos_rxd0[0]};
        else if(num == 4'h7) pos_rxd0 <= {pos_rxd0[7:1], din};
        else pos_rxd0 <= pos_rxd0;
    end
    
    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd1 <= 8'h00;
        else if(state == IDLE) pos_rxd1 <= 8'h00;
        else if(state == WAIT) pos_rxd1 <= 8'h00;
        else if(num == 4'h0) pos_rxd1 <= {pos_rxd1[7:1], din};
        else if(num == 4'h1) pos_rxd1 <= {din, pos_rxd1[6:0]};
        else if(num == 4'h2) pos_rxd1 <= {pos_rxd1[7], din, pos_rxd1[5:0]};
        else if(num == 4'h3) pos_rxd1 <= {pos_rxd1[7:6], din, pos_rxd1[4:0]};
        else if(num == 4'h4) pos_rxd1 <= {pos_rxd1[7:5], din, pos_rxd1[3:0]};
        else if(num == 4'h5) pos_rxd1 <= {pos_rxd1[7:4], din, pos_rxd1[2:0]};
        else if(num == 4'h6) pos_rxd1 <= {pos_rxd1[7:3], din, pos_rxd1[1:0]};
        else if(num == 4'h7) pos_rxd1 <= {pos_rxd1[7:2], din, pos_rxd1[0]};
        else pos_rxd1 <= pos_rxd1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd2 <= 8'h00;
        else if(state == IDLE) pos_rxd2 <= 8'h00;
        else if(state == WAIT) pos_rxd2 <= 8'h00;
        else if(num == 4'h0) pos_rxd2 <= {pos_rxd2[7:2], din, pos_rxd2[0]};
        else if(num == 4'h1) pos_rxd2 <= {pos_rxd2[7:1], din};
        else if(num == 4'h2) pos_rxd2 <= {din, pos_rxd2[6:0]};
        else if(num == 4'h3) pos_rxd2 <= {pos_rxd2[7], din, pos_rxd2[5:0]};
        else if(num == 4'h4) pos_rxd2 <= {pos_rxd2[7:6], din, pos_rxd2[4:0]};
        else if(num == 4'h5) pos_rxd2 <= {pos_rxd2[7:5], din, pos_rxd2[3:0]};
        else if(num == 4'h6) pos_rxd2 <= {pos_rxd2[7:4], din, pos_rxd2[2:0]};
        else if(num == 4'h7) pos_rxd2 <= {pos_rxd2[7:3], din, pos_rxd2[1:0]};
        else pos_rxd2 <= pos_rxd2;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd3 <= 8'h00;
        else if(state == IDLE) pos_rxd3 <= 8'h00;
        else if(state == WAIT) pos_rxd3 <= 8'h00;
        else if(num == 4'h0) pos_rxd3 <= {pos_rxd3[7:3], din, pos_rxd3[1:0]};
        else if(num == 4'h1) pos_rxd3 <= {pos_rxd3[7:2], din, pos_rxd3[0]};
        else if(num == 4'h2) pos_rxd3 <= {pos_rxd3[7:1], din};
        else if(num == 4'h3) pos_rxd3 <= {din, pos_rxd3[6:0]};
        else if(num == 4'h4) pos_rxd3 <= {pos_rxd3[7], din, pos_rxd3[5:0]};
        else if(num == 4'h5) pos_rxd3 <= {pos_rxd3[7:6], din, pos_rxd3[4:0]};
        else if(num == 4'h6) pos_rxd3 <= {pos_rxd3[7:5], din, pos_rxd3[3:0]};
        else if(num == 4'h7) pos_rxd3 <= {pos_rxd3[7:4], din, pos_rxd3[2:0]};
        else pos_rxd3 <= pos_rxd3;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd4 <= 8'h00;
        else if(state == IDLE) pos_rxd4 <= 8'h00;
        else if(state == WAIT) pos_rxd4 <= 8'h00;
        else if(num == 4'h0) pos_rxd4 <= {pos_rxd4[7:4], din, pos_rxd4[2:0]};
        else if(num == 4'h1) pos_rxd4 <= {pos_rxd4[7:3], din, pos_rxd4[1:0]};
        else if(num == 4'h2) pos_rxd4 <= {pos_rxd4[7:2], din, pos_rxd4[0]};
        else if(num == 4'h3) pos_rxd4 <= {pos_rxd4[7:1], din};
        else if(num == 4'h4) pos_rxd4 <= {din, pos_rxd4[6:0]};
        else if(num == 4'h5) pos_rxd4 <= {pos_rxd4[7], din, pos_rxd4[5:0]};
        else if(num == 4'h6) pos_rxd4 <= {pos_rxd4[7:6], din, pos_rxd4[4:0]};
        else if(num == 4'h7) pos_rxd4 <= {pos_rxd4[7:5], din, pos_rxd4[3:0]};
        else pos_rxd4 <= pos_rxd4;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd5 <= 8'h00;
        else if(state == IDLE) pos_rxd5 <= 8'h00;
        else if(state == WAIT) pos_rxd5 <= 8'h00;
        else if(num == 4'h0) pos_rxd5 <= {pos_rxd5[7:5], din, pos_rxd5[3:0]};
        else if(num == 4'h1) pos_rxd5 <= {pos_rxd5[7:4], din, pos_rxd5[2:0]};
        else if(num == 4'h2) pos_rxd5 <= {pos_rxd5[7:3], din, pos_rxd5[1:0]};
        else if(num == 4'h3) pos_rxd5 <= {pos_rxd5[7:2], din, pos_rxd5[0]};
        else if(num == 4'h4) pos_rxd5 <= {pos_rxd5[7:1], din};
        else if(num == 4'h5) pos_rxd5 <= {din, pos_rxd5[6:0]};
        else if(num == 4'h6) pos_rxd5 <= {pos_rxd5[7], din, pos_rxd5[5:0]};
        else if(num == 4'h7) pos_rxd5 <= {pos_rxd5[7:6], din, pos_rxd5[4:0]};
        else pos_rxd5 <= pos_rxd5;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd6 <= 8'h00;
        else if(state == IDLE) pos_rxd6 <= 8'h00;
        else if(state == WAIT) pos_rxd6 <= 8'h00;
        else if(num == 4'h0) pos_rxd6 <= {pos_rxd6[7:6], din, pos_rxd6[4:0]};
        else if(num == 4'h1) pos_rxd6 <= {pos_rxd6[7:5], din, pos_rxd6[3:0]};
        else if(num == 4'h2) pos_rxd6 <= {pos_rxd6[7:4], din, pos_rxd6[2:0]};
        else if(num == 4'h3) pos_rxd6 <= {pos_rxd6[7:3], din, pos_rxd6[1:0]};
        else if(num == 4'h4) pos_rxd6 <= {pos_rxd6[7:2], din, pos_rxd6[0]};
        else if(num == 4'h5) pos_rxd6 <= {pos_rxd6[7:1], din};
        else if(num == 4'h6) pos_rxd6 <= {din, pos_rxd6[6:0]};
        else if(num == 4'h7) pos_rxd6 <= {pos_rxd6[7], din, pos_rxd6[5:0]};
        else pos_rxd6 <= pos_rxd6;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pos_rxd7 <= 8'h00;
        else if(state == IDLE) pos_rxd7 <= 8'h00;
        else if(state == WAIT) pos_rxd7 <= 8'h00;
        else if(num == 4'h0) pos_rxd7 <= {pos_rxd7[7], din, pos_rxd7[5:0]};
        else if(num == 4'h1) pos_rxd7 <= {pos_rxd7[7:6], din, pos_rxd7[4:0]};
        else if(num == 4'h2) pos_rxd7 <= {pos_rxd7[7:5], din, pos_rxd7[3:0]};
        else if(num == 4'h3) pos_rxd7 <= {pos_rxd7[7:4], din, pos_rxd7[2:0]};
        else if(num == 4'h4) pos_rxd7 <= {pos_rxd7[7:3], din, pos_rxd7[1:0]};
        else if(num == 4'h5) pos_rxd7 <= {pos_rxd7[7:2], din, pos_rxd7[0]};
        else if(num == 4'h6) pos_rxd7 <= {pos_rxd7[7:1], din};
        else if(num == 4'h7) pos_rxd7 <= {din, pos_rxd7[6:0]};
        else pos_rxd7 <= pos_rxd7;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd0 <= 8'h00;
        else if(state == IDLE) neg_rxd0 <= 8'h00;
        else if(state == WAIT) neg_rxd0 <= 8'h00;
        else if(num == 4'h0) neg_rxd0 <= {din, neg_rxd0[6:0]};
        else if(num == 4'h1) neg_rxd0 <= {neg_rxd0[7], din, neg_rxd0[5:0]};
        else if(num == 4'h2) neg_rxd0 <= {neg_rxd0[7:6], din, neg_rxd0[4:0]};
        else if(num == 4'h3) neg_rxd0 <= {neg_rxd0[7:5], din, neg_rxd0[3:0]};
        else if(num == 4'h4) neg_rxd0 <= {neg_rxd0[7:4], din, neg_rxd0[2:0]};
        else if(num == 4'h5) neg_rxd0 <= {neg_rxd0[7:3], din, neg_rxd0[1:0]};
        else if(num == 4'h6) neg_rxd0 <= {neg_rxd0[7:2], din, neg_rxd0[0]};
        else if(num == 4'h7) neg_rxd0 <= {neg_rxd0[7:1], din};
        else neg_rxd0 <= neg_rxd0;
    end
    
    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd1 <= 8'h00;
        else if(state == IDLE) neg_rxd1 <= 8'h00;
        else if(state == WAIT) neg_rxd1 <= 8'h00;
        else if(num == 4'h0) neg_rxd1 <= {neg_rxd1[7:1], din};
        else if(num == 4'h1) neg_rxd1 <= {din, neg_rxd1[6:0]};
        else if(num == 4'h2) neg_rxd1 <= {neg_rxd1[7], din, neg_rxd1[5:0]};
        else if(num == 4'h3) neg_rxd1 <= {neg_rxd1[7:6], din, neg_rxd1[4:0]};
        else if(num == 4'h4) neg_rxd1 <= {neg_rxd1[7:5], din, neg_rxd1[3:0]};
        else if(num == 4'h5) neg_rxd1 <= {neg_rxd1[7:4], din, neg_rxd1[2:0]};
        else if(num == 4'h6) neg_rxd1 <= {neg_rxd1[7:3], din, neg_rxd1[1:0]};
        else if(num == 4'h7) neg_rxd1 <= {neg_rxd1[7:2], din, neg_rxd1[0]};
        else neg_rxd1 <= neg_rxd1;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd2 <= 8'h00;
        else if(state == IDLE) neg_rxd2 <= 8'h00;
        else if(state == WAIT) neg_rxd2 <= 8'h00;
        else if(num == 4'h0) neg_rxd2 <= {neg_rxd2[7:2], din, neg_rxd2[0]};
        else if(num == 4'h1) neg_rxd2 <= {neg_rxd2[7:1], din};
        else if(num == 4'h2) neg_rxd2 <= {din, neg_rxd2[6:0]};
        else if(num == 4'h3) neg_rxd2 <= {neg_rxd2[7], din, neg_rxd2[5:0]};
        else if(num == 4'h4) neg_rxd2 <= {neg_rxd2[7:6], din, neg_rxd2[4:0]};
        else if(num == 4'h5) neg_rxd2 <= {neg_rxd2[7:5], din, neg_rxd2[3:0]};
        else if(num == 4'h6) neg_rxd2 <= {neg_rxd2[7:4], din, neg_rxd2[2:0]};
        else if(num == 4'h7) neg_rxd2 <= {neg_rxd2[7:3], din, neg_rxd2[1:0]};
        else neg_rxd2 <= neg_rxd2;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd3 <= 8'h00;
        else if(state == IDLE) neg_rxd3 <= 8'h00;
        else if(state == WAIT) neg_rxd3 <= 8'h00;
        else if(num == 4'h0) neg_rxd3 <= {neg_rxd3[7:3], din, neg_rxd3[1:0]};
        else if(num == 4'h1) neg_rxd3 <= {neg_rxd3[7:2], din, neg_rxd3[0]};
        else if(num == 4'h2) neg_rxd3 <= {neg_rxd3[7:1], din};
        else if(num == 4'h3) neg_rxd3 <= {din, neg_rxd3[6:0]};
        else if(num == 4'h4) neg_rxd3 <= {neg_rxd3[7], din, neg_rxd3[5:0]};
        else if(num == 4'h5) neg_rxd3 <= {neg_rxd3[7:6], din, neg_rxd3[4:0]};
        else if(num == 4'h6) neg_rxd3 <= {neg_rxd3[7:5], din, neg_rxd3[3:0]};
        else if(num == 4'h7) neg_rxd3 <= {neg_rxd3[7:4], din, neg_rxd3[2:0]};
        else neg_rxd3 <= neg_rxd3;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd4 <= 8'h00;
        else if(state == IDLE) neg_rxd4 <= 8'h00;
        else if(state == WAIT) neg_rxd4 <= 8'h00;
        else if(num == 4'h0) neg_rxd4 <= {neg_rxd4[7:4], din, neg_rxd4[2:0]};
        else if(num == 4'h1) neg_rxd4 <= {neg_rxd4[7:3], din, neg_rxd4[1:0]};
        else if(num == 4'h2) neg_rxd4 <= {neg_rxd4[7:2], din, neg_rxd4[0]};
        else if(num == 4'h3) neg_rxd4 <= {neg_rxd4[7:1], din};
        else if(num == 4'h4) neg_rxd4 <= {din, neg_rxd4[6:0]};
        else if(num == 4'h5) neg_rxd4 <= {neg_rxd4[7], din, neg_rxd4[5:0]};
        else if(num == 4'h6) neg_rxd4 <= {neg_rxd4[7:6], din, neg_rxd4[4:0]};
        else if(num == 4'h7) neg_rxd4 <= {neg_rxd4[7:5], din, neg_rxd4[3:0]};
        else neg_rxd4 <= neg_rxd4;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd5 <= 8'h00;
        else if(state == IDLE) neg_rxd5 <= 8'h00;
        else if(state == WAIT) neg_rxd5 <= 8'h00;
        else if(num == 4'h0) neg_rxd5 <= {neg_rxd5[7:5], din, neg_rxd5[3:0]};
        else if(num == 4'h1) neg_rxd5 <= {neg_rxd5[7:4], din, neg_rxd5[2:0]};
        else if(num == 4'h2) neg_rxd5 <= {neg_rxd5[7:3], din, neg_rxd5[1:0]};
        else if(num == 4'h3) neg_rxd5 <= {neg_rxd5[7:2], din, neg_rxd5[0]};
        else if(num == 4'h4) neg_rxd5 <= {neg_rxd5[7:1], din};
        else if(num == 4'h5) neg_rxd5 <= {din, neg_rxd5[6:0]};
        else if(num == 4'h6) neg_rxd5 <= {neg_rxd5[7], din, neg_rxd5[5:0]};
        else if(num == 4'h7) neg_rxd5 <= {neg_rxd5[7:6], din, neg_rxd5[4:0]};
        else neg_rxd5 <= neg_rxd5;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd6 <= 8'h00;
        else if(state == IDLE) neg_rxd6 <= 8'h00;
        else if(state == WAIT) neg_rxd6 <= 8'h00;
        else if(num == 4'h0) neg_rxd6 <= {neg_rxd6[7:6], din, neg_rxd6[4:0]};
        else if(num == 4'h1) neg_rxd6 <= {neg_rxd6[7:5], din, neg_rxd6[3:0]};
        else if(num == 4'h2) neg_rxd6 <= {neg_rxd6[7:4], din, neg_rxd6[2:0]};
        else if(num == 4'h3) neg_rxd6 <= {neg_rxd6[7:3], din, neg_rxd6[1:0]};
        else if(num == 4'h4) neg_rxd6 <= {neg_rxd6[7:2], din, neg_rxd6[0]};
        else if(num == 4'h5) neg_rxd6 <= {neg_rxd6[7:1], din};
        else if(num == 4'h6) neg_rxd6 <= {din, neg_rxd6[6:0]};
        else if(num == 4'h7) neg_rxd6 <= {neg_rxd6[7], din, neg_rxd6[5:0]};
        else neg_rxd6 <= neg_rxd6;
    end

    always@(negedge clk or posedge rst) begin
        if(rst) neg_rxd7 <= 8'h00;
        else if(state == IDLE) neg_rxd7 <= 8'h00;
        else if(state == WAIT) neg_rxd7 <= 8'h00;
        else if(num == 4'h0) neg_rxd7 <= {neg_rxd7[7], din, neg_rxd7[5:0]};
        else if(num == 4'h1) neg_rxd7 <= {neg_rxd7[7:6], din, neg_rxd7[4:0]};
        else if(num == 4'h2) neg_rxd7 <= {neg_rxd7[7:5], din, neg_rxd7[3:0]};
        else if(num == 4'h3) neg_rxd7 <= {neg_rxd7[7:4], din, neg_rxd7[2:0]};
        else if(num == 4'h4) neg_rxd7 <= {neg_rxd7[7:3], din, neg_rxd7[1:0]};
        else if(num == 4'h5) neg_rxd7 <= {neg_rxd7[7:2], din, neg_rxd7[0]};
        else if(num == 4'h6) neg_rxd7 <= {neg_rxd7[7:1], din};
        else if(num == 4'h7) neg_rxd7 <= {din, neg_rxd7[6:0]};
        else neg_rxd7 <= neg_rxd7;
    end

endmodule