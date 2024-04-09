module spi(
    input clk,
    input rst,

    input fs,
    output fd,

    input miso,
    output cs,
    output reg sclk,
    output reg mosi,

    input [15:0] txd,
    output reg [15:0] rxd 
); 

    localparam MODE_NUM = 8'd20, SEMI_NUM = 8'd09, SYNC_NUM = 8'h10; 

    reg [7:0] num;
    reg [15:0] data;

    reg [7:0] state, next_state;
    
    assign fd = (state == DONE);
    assign cs = 1'b0;

    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02;
    localparam LAST = 8'h04, DONE = 8'h08;
    localparam W0 = 8'h11, W1 = 8'h12, W2 = 8'h14, W3 = 8'h18;
    localparam W4 = 8'h21, W5 = 8'h22, W6 = 8'h24, W7 = 8'h28;
    localparam W8 = 8'h41, W9 = 8'h42, WA = 8'h44, WB = 8'h48;
    localparam WC = 8'h81, WD = 8'h82, WE = 8'h84, WF = 8'h88;
    
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
            WORK: begin
                if(num >= SYNC_NUM - 1'b1) next_state <= W0; 
                else next_state <= WORK;
            end
            LAST: begin
                if(num >= SYNC_NUM - 1'b1) next_state <= DONE;
                else next_state <= LAST;
            end
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end

            W0: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W1;
                else next_state <= W0;
            end
            W1: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W2;
                else next_state <= W1;
            end
            W2: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W3;
                else next_state <= W2;
            end
            W3: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W4;
                else next_state <= W3;
            end
            W4: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W5;
                else next_state <= W4;
            end
            W5: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W6;
                else next_state <= W5;
            end
            W6: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W7;
                else next_state <= W6;
            end
            W7: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W8;
                else next_state <= W7;
            end
            W8: begin
                if(num >= MODE_NUM - 1'b1) next_state <= W9;
                else next_state <= W8;
            end
            W9: begin
                if(num >= MODE_NUM - 1'b1) next_state <= WA;
                else next_state <= W9;
            end
            WA: begin
                if(num >= MODE_NUM - 1'b1) next_state <= WB;
                else next_state <= WA;
            end
            WB: begin
                if(num >= MODE_NUM - 1'b1) next_state <= WC;
                else next_state <= WB;
            end
            WC: begin
                if(num >= MODE_NUM - 1'b1) next_state <= WD;
                else next_state <= WC;
            end
            WD: begin
                if(num >= MODE_NUM - 1'b1) next_state <= WE;
                else next_state <= WD;
            end
            WE: begin
                if(num >= MODE_NUM - 1'b1) next_state <= WF;
                else next_state <= WE;
            end
            WF: begin
                if(num >= MODE_NUM - 1'b1) next_state <= LAST;
                else next_state <= WF;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) sclk <= 1'b0;
        else if(state == IDLE) sclk <= 1'b0;
        else if(state == WAIT) sclk <= 1'b0;
        else if(state == WORK) sclk <= 1'b0;
        else if(state == LAST) sclk <= 1'b0;
        else if(state == DONE) sclk <= 1'b0;
        else if(state == W0 && num == 8'h00) sclk <= 1'b1;
        else if(state == W1 && num == 8'h00) sclk <= 1'b1;
        else if(state == W2 && num == 8'h00) sclk <= 1'b1;
        else if(state == W3 && num == 8'h00) sclk <= 1'b1;
        else if(state == W4 && num == 8'h00) sclk <= 1'b1;
        else if(state == W5 && num == 8'h00) sclk <= 1'b1;
        else if(state == W6 && num == 8'h00) sclk <= 1'b1;
        else if(state == W7 && num == 8'h00) sclk <= 1'b1;
        else if(state == W8 && num == 8'h00) sclk <= 1'b1;
        else if(state == W9 && num == 8'h00) sclk <= 1'b1;
        else if(state == WA && num == 8'h00) sclk <= 1'b1;
        else if(state == WB && num == 8'h00) sclk <= 1'b1;
        else if(state == WC && num == 8'h00) sclk <= 1'b1;
        else if(state == WD && num == 8'h00) sclk <= 1'b1;
        else if(state == WE && num == 8'h00) sclk <= 1'b1;
        else if(state == WF && num == 8'h00) sclk <= 1'b1;
        else if(state == W0 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W1 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W2 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W3 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W4 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W5 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W6 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W7 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W8 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == W9 && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == WA && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == WB && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == WC && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == WD && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == WE && num == SEMI_NUM) sclk <= 1'b0;
        else if(state == WF && num == SEMI_NUM) sclk <= 1'b0;
        else sclk <= sclk;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) mosi <= 1'b0; 
        else if(state == W0) mosi <= txd[15];
        else if(state == W1) mosi <= txd[14];
        else if(state == W2) mosi <= txd[13];
        else if(state == W3) mosi <= txd[12];
        else if(state == W4) mosi <= txd[11];
        else if(state == W5) mosi <= txd[10];
        else if(state == W6) mosi <= txd[9];
        else if(state == W7) mosi <= txd[8];
        else if(state == W8) mosi <= txd[7];
        else if(state == W9) mosi <= txd[6];
        else if(state == WA) mosi <= txd[5];
        else if(state == WB) mosi <= txd[4];
        else if(state == WC) mosi <= txd[3];
        else if(state == WD) mosi <= txd[2];
        else if(state == WE) mosi <= txd[1];
        else if(state == WF) mosi <= txd[0];
        else mosi <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data <= 16'h0000;
        else if(state == IDLE) data <= 16'h0000;
        else if(state == W0 && num == SEMI_NUM + 1'b1) data[15] <= miso;
        else if(state == W1 && num == SEMI_NUM + 1'b1) data[14] <= miso;
        else if(state == W2 && num == SEMI_NUM + 1'b1) data[13] <= miso;
        else if(state == W3 && num == SEMI_NUM + 1'b1) data[12] <= miso;
        else if(state == W4 && num == SEMI_NUM + 1'b1) data[11] <= miso;
        else if(state == W5 && num == SEMI_NUM + 1'b1) data[10] <= miso;
        else if(state == W6 && num == SEMI_NUM + 1'b1) data[9] <= miso;
        else if(state == W7 && num == SEMI_NUM + 1'b1) data[8] <= miso;
        else if(state == W8 && num == SEMI_NUM + 1'b1) data[7] <= miso;
        else if(state == W9 && num == SEMI_NUM + 1'b1) data[6] <= miso;
        else if(state == WA && num == SEMI_NUM + 1'b1) data[5] <= miso;
        else if(state == WB && num == SEMI_NUM + 1'b1) data[4] <= miso;
        else if(state == WC && num == SEMI_NUM + 1'b1) data[3] <= miso;
        else if(state == WD && num == SEMI_NUM + 1'b1) data[2] <= miso;
        else if(state == WE && num == SEMI_NUM + 1'b1) data[1] <= miso;
        else if(state == WF && num == SEMI_NUM + 1'b1) data[0] <= miso;
        else data <= data;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rxd <= 16'h0000;
        else if(state == IDLE) rxd <= 16'h0000;
        else if(state == LAST) rxd <= data;
        else rxd <= rxd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state != next_state) num <= 8'h00;
        else num <= num + 1'b1;
    end 

endmodule