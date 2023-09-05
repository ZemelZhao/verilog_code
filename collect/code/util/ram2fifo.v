module ram2fifo(
    input clk,
    input rst,

    input fs,
    output fd,

    input [11:0] ram_rxa_init,

    input [11:0] data_len,
    input [0:7] link,

    input [63:0] ram_rxd,
    output [95:0] ram_rxa,

    input fifo_full,
    output reg [7:0] fifo_txd,
    output reg fifo_txen
);

    localparam RAM_LATENCY = 8'h2;

    reg [7:0] state, next_state;

    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam INIT = 8'h04;
    localparam HD00 = 8'h08, HD01 = 8'h09, LK00 = 8'h0A, LK01 = 8'h0B;
    localparam PT00 = 8'h0C, PT01 = 8'h0D;

    localparam RC00 = 8'h10, RP00 = 8'h11, RR00 = 8'h12, RW00 = 8'h13;
    localparam RC01 = 8'h14, RP01 = 8'h15, RR01 = 8'h16, RW01 = 8'h17;
    localparam RC02 = 8'h18, RP02 = 8'h19, RR02 = 8'h1A, RW02 = 8'h1B;
    localparam RC03 = 8'h1C, RP03 = 8'h1D, RR03 = 8'h1E, RW03 = 8'h1F;

    localparam RC04 = 8'h30, RP04 = 8'h31, RR04 = 8'h32, RW04 = 8'h33;
    localparam RC05 = 8'h34, RP05 = 8'h35, RR05 = 8'h36, RW05 = 8'h37;
    localparam RC06 = 8'h38, RP06 = 8'h39, RR06 = 8'h3A, RW06 = 8'h3B;
    localparam RC07 = 8'h3C, RP07 = 8'h3D, RR07 = 8'h3E, RW07 = 8'h3F;

    reg [11:0] ram_rxa00, ram_rxa01, ram_rxa02, ram_rxa03;
    reg [11:0] ram_rxa04, ram_rxa05, ram_rxa06, ram_rxa07;
    wire [7:0] ram_rxd00, ram_rxd01, ram_rxd02, ram_rxd03;
    wire [7:0] ram_rxd04, ram_rxd05, ram_rxd06, ram_rxd07;
    reg [15:0] part;

    reg [11:0] dlen;
    reg [7:0] num;

    assign fd = (state == DONE);
    assign ram_rxa[95:48] = {ram_rxa00, ram_rxa01, ram_rxa02, ram_rxa03}; 
    assign ram_rxa[47:0] = {ram_rxa04, ram_rxa05, ram_rxa06, ram_rxa07}; 
    assign ram_rxd00 = ram_rxd[63:56];
    assign ram_rxd01 = ram_rxd[55:48];
    assign ram_rxd02 = ram_rxd[47:40];
    assign ram_rxd03 = ram_rxd[39:32];
    assign ram_rxd04 = ram_rxd[31:24];
    assign ram_rxd05 = ram_rxd[23:16];
    assign ram_rxd06 = ram_rxd[15:8];
    assign ram_rxd07 = ram_rxd[7:0];

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(~fifo_full) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(fs) next_state <= INIT;
                else next_state <= WORK;
            end
            INIT: next_state <= HD00;
            HD00: next_state <= HD01;
            HD01: next_state <= LK00;
            LK00: next_state <= LK01;
            LK01: next_state <= RC00;

            RC00: begin
                if(link[0]) next_state <= RP00;  
                else next_state <= RC01;
            end
            RP00: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RR00;
                else next_state <= RP00;
            end
            RR00: begin
                if(dlen >= data_len - 2'h1 - RAM_LATENCY) next_state <= RW00;
                else next_state <= RR00;
            end
            RW00: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RC01;
                else next_state <= RW00;
            end
            
            RC01: begin
                if(link[1]) next_state <= RP01;  
                else next_state <= RC02;
            end
            RP01: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RR01;
                else next_state <= RP01;
            end
            RR01: begin
                if(dlen >= data_len - 2'h1 - RAM_LATENCY) next_state <= RW01;
                else next_state <= RR01;
            end
            RW01: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RC02;
                else next_state <= RW01;
            end
            
            RC02: begin
                if(link[2]) next_state <= RP02;  
                else next_state <= RC03;
            end
            RP02: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RR02;
                else next_state <= RP02;
            end
            RR02: begin
                if(dlen >= data_len - 2'h1 - RAM_LATENCY) next_state <= RW02;
                else next_state <= RR02;
            end
            RW02: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RC03;
                else next_state <= RW02;
            end

            RC03: begin
                if(link[3]) next_state <= RP03;  
                else next_state <= RC04;
            end
            RP03: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RR03;
                else next_state <= RP03;
            end
            RR03: begin
                if(dlen >= data_len - 2'h1 - RAM_LATENCY) next_state <= RW03;
                else next_state <= RR03;
            end
            RW03: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RC04;
                else next_state <= RW03;
            end

            RC04: begin
                if(link[4]) next_state <= RP04;  
                else next_state <= RC05;
            end
            RP04: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RR04;
                else next_state <= RP04;
            end
            RR04: begin
                if(dlen >= data_len - 2'h1 - RAM_LATENCY) next_state <= RW04;
                else next_state <= RR04;
            end
            RW04: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RC05;
                else next_state <= RW04;
            end
            
            RC05: begin
                if(link[5]) next_state <= RP05;  
                else next_state <= RC06;
            end
            RP05: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RR05;
                else next_state <= RP05;
            end
            RR05: begin
                if(dlen >= data_len - 2'h1 - RAM_LATENCY) next_state <= RW05;
                else next_state <= RR05;
            end
            RW05: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RC06;
                else next_state <= RW05;
            end
            
            RC06: begin
                if(link[6]) next_state <= RP06;  
                else next_state <= RC07;
            end
            RP06: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RR06;
                else next_state <= RP06;
            end
            RR06: begin
                if(dlen >= data_len - 2'h1 - RAM_LATENCY) next_state <= RW06;
                else next_state <= RR06;
            end
            RW06: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RC07;
                else next_state <= RW06;
            end

            RC07: begin
                if(link[7]) next_state <= RP07;  
                else next_state <= PT00;
            end
            RP07: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= RR07;
                else next_state <= RP07;
            end
            RR07: begin
                if(dlen >= data_len - 2'h1 - RAM_LATENCY) next_state <= RW07;
                else next_state <= RR07;
            end
            RW07: begin
                if(num >= RAM_LATENCY - 1'b1) next_state <= PT00;
                else next_state <= RW07;
            end

            PT00: next_state <= PT01;
            PT01: next_state <= DONE;
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end

            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_rxa00 <= 12'h000;
        else if(state == INIT) ram_rxa00 <= ram_rxa_init;
        else if(state == RC00) ram_rxa00 <= ram_rxa_init;
        else if(state == RP00) ram_rxa00 <= ram_rxa00 + 1'b1;
        else if(state == RR00) ram_rxa00 <= ram_rxa00 + 1'b1;
        else ram_rxa00 <= ram_rxa00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_rxa01 <= 12'h000;
        else if(state == INIT) ram_rxa01 <= ram_rxa_init;
        else if(state == RC01) ram_rxa01 <= ram_rxa_init;
        else if(state == RP01) ram_rxa01 <= ram_rxa01 + 1'b1;
        else if(state == RR01) ram_rxa01 <= ram_rxa01 + 1'b1;
        else ram_rxa01 <= ram_rxa01;
    end

    always@(posedge clk or posedge rst) begin 
        if(rst) ram_rxa02 <= 12'h000;
        else if(state == INIT) ram_rxa02 <= ram_rxa_init;
        else if(state == RC02) ram_rxa02 <= ram_rxa_init;
        else if(state == RP02) ram_rxa02 <= ram_rxa02 + 1'b1;
        else if(state == RR02) ram_rxa02 <= ram_rxa02 + 1'b1;
        else ram_rxa02 <= ram_rxa02;
    end

    always@(posedge clk or posedge rst) begin 
        if(rst) ram_rxa03 <= 12'h000;
        else if(state == INIT) ram_rxa03 <= ram_rxa_init;
        else if(state == RC03) ram_rxa03 <= ram_rxa_init;
        else if(state == RP03) ram_rxa03 <= ram_rxa03 + 1'b1;
        else if(state == RR03) ram_rxa03 <= ram_rxa03 + 1'b1;
        else ram_rxa03 <= ram_rxa03;
    end

    always@(posedge clk or posedge rst) begin 
        if(rst) ram_rxa04 <= 12'h000;
        else if(state == INIT) ram_rxa04 <= ram_rxa_init;
        else if(state == RC04) ram_rxa04 <= ram_rxa_init;
        else if(state == RP04) ram_rxa04 <= ram_rxa04 + 1'b1;
        else if(state == RR04) ram_rxa04 <= ram_rxa04 + 1'b1;
        else ram_rxa04 <= ram_rxa04;
    end

    always@(posedge clk or posedge rst) begin 
        if(rst) ram_rxa05 <= 12'h000;
        else if(state == INIT) ram_rxa05 <= ram_rxa_init;
        else if(state == RC05) ram_rxa05 <= ram_rxa_init;
        else if(state == RP05) ram_rxa05 <= ram_rxa05 + 1'b1;
        else if(state == RR05) ram_rxa05 <= ram_rxa05 + 1'b1;
        else ram_rxa05 <= ram_rxa05;
    end

    always@(posedge clk or posedge rst) begin 
        if(rst) ram_rxa06 <= 12'h000;
        else if(state == INIT) ram_rxa06 <= ram_rxa_init;
        else if(state == RC06) ram_rxa06 <= ram_rxa_init;
        else if(state == RP06) ram_rxa06 <= ram_rxa06 + 1'b1;
        else if(state == RR06) ram_rxa06 <= ram_rxa06 + 1'b1;
        else ram_rxa06 <= ram_rxa06;
    end

    always@(posedge clk or posedge rst) begin 
        if(rst) ram_rxa07 <= 12'h000;
        else if(state == INIT) ram_rxa07 <= ram_rxa_init;
        else if(state == RC07) ram_rxa07 <= ram_rxa_init;
        else if(state == RP07) ram_rxa07 <= ram_rxa07 + 1'b1;
        else if(state == RR07) ram_rxa07 <= ram_rxa07 + 1'b1;
        else ram_rxa07 <= ram_rxa07;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= 12'h000;
        else if(state == IDLE) dlen <= 12'h000;
        else if(state == WAIT) dlen <= 12'h000;
        else if(state == RR00) dlen <= dlen + 1'b1;
        else if(state == RR01) dlen <= dlen + 1'b1;
        else if(state == RR02) dlen <= dlen + 1'b1;
        else if(state == RR03) dlen <= dlen + 1'b1;
        else if(state == RR04) dlen <= dlen + 1'b1;
        else if(state == RR05) dlen <= dlen + 1'b1;
        else if(state == RR06) dlen <= dlen + 1'b1;
        else if(state == RR07) dlen <= dlen + 1'b1;
        else dlen <= 12'h000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == RP00) num <= num + 1'b1;
        else if(state == RW00) num <= num + 1'b1;
        else if(state == RP01) num <= num + 1'b1;
        else if(state == RW01) num <= num + 1'b1;
        else if(state == RP02) num <= num + 1'b1;
        else if(state == RW02) num <= num + 1'b1;
        else if(state == RP03) num <= num + 1'b1;
        else if(state == RW03) num <= num + 1'b1;
        else if(state == RP04) num <= num + 1'b1;
        else if(state == RW04) num <= num + 1'b1;
        else if(state == RP05) num <= num + 1'b1;
        else if(state == RW05) num <= num + 1'b1;
        else if(state == RP06) num <= num + 1'b1;
        else if(state == RW06) num <= num + 1'b1;
        else if(state == RP07) num <= num + 1'b1;
        else if(state == RW07) num <= num + 1'b1;
        else num <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fifo_txd <= 8'h00;
        else if(state == IDLE) fifo_txd <= 8'h00;
        else if(state == WAIT) fifo_txd <= 8'h00;
        else if(state == INIT) fifo_txd <= 8'h00;
        else if(state == HD00) fifo_txd <= 8'h55;
        else if(state == HD01) fifo_txd <= 8'hAA;
        else if(state == LK00) fifo_txd <= 8'h00;
        else if(state == LK01) fifo_txd <= link;
        else if(state == RR00) fifo_txd <= ram_rxd00;
        else if(state == RW00) fifo_txd <= ram_rxd00;
        else if(state == RR01) fifo_txd <= ram_rxd01;
        else if(state == RW01) fifo_txd <= ram_rxd01;
        else if(state == RR02) fifo_txd <= ram_rxd02;
        else if(state == RW02) fifo_txd <= ram_rxd02;
        else if(state == RR03) fifo_txd <= ram_rxd03;
        else if(state == RW03) fifo_txd <= ram_rxd03;
        else if(state == RR04) fifo_txd <= ram_rxd04;
        else if(state == RW04) fifo_txd <= ram_rxd04;
        else if(state == RR05) fifo_txd <= ram_rxd05;
        else if(state == RW05) fifo_txd <= ram_rxd05;
        else if(state == RR06) fifo_txd <= ram_rxd06;
        else if(state == RW06) fifo_txd <= ram_rxd06;
        else if(state == RR07) fifo_txd <= ram_rxd07;
        else if(state == RW07) fifo_txd <= ram_rxd07;
        else if(state == PT00) fifo_txd <= part[15:8];
        else if(state == PT01) fifo_txd <= part[7:0];
        else fifo_txd <= fifo_txd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fifo_txen <= 1'b1;
        else if(state == IDLE) fifo_txen <= 1'b0;
        else if(state == WAIT) fifo_txen <= 1'b0;
        else if(state == HD00) fifo_txen <= 1'b1;
        else if(state == HD01) fifo_txen <= 1'b1;
        else if(state == LK00) fifo_txen <= 1'b1;
        else if(state == LK01) fifo_txen <= 1'b1;
        else if(state == RR00) fifo_txen <= 1'b1;
        else if(state == RW00) fifo_txen <= 1'b1;
        else if(state == RR01) fifo_txen <= 1'b1;
        else if(state == RW01) fifo_txen <= 1'b1;
        else if(state == RR02) fifo_txen <= 1'b1;
        else if(state == RW02) fifo_txen <= 1'b1;
        else if(state == RR03) fifo_txen <= 1'b1;
        else if(state == RW03) fifo_txen <= 1'b1;
        else if(state == RR04) fifo_txen <= 1'b1;
        else if(state == RW04) fifo_txen <= 1'b1;
        else if(state == RR05) fifo_txen <= 1'b1;
        else if(state == RW05) fifo_txen <= 1'b1;
        else if(state == RR06) fifo_txen <= 1'b1;
        else if(state == RW06) fifo_txen <= 1'b1;
        else if(state == RR07) fifo_txen <= 1'b1;
        else if(state == RW07) fifo_txen <= 1'b1;
        else if(state == PT00) fifo_txen <= 1'b1;
        else if(state == PT01) fifo_txen <= 1'b1;
        else fifo_txen <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) part <= 16'h0000;
        else if(state == IDLE) part <= 16'h0000;
        else if(state == WAIT) part <= 16'h0000;
        else if(state == LK01) part <= 16'h0000;
        else if(state == RR00) part <= part + ram_rxd00;
        else if(state == RW00) part <= part + ram_rxd00;
        else if(state == RR01) part <= part + ram_rxd01;
        else if(state == RW01) part <= part + ram_rxd01;
        else if(state == RR02) part <= part + ram_rxd02;
        else if(state == RW02) part <= part + ram_rxd02;
        else if(state == RR03) part <= part + ram_rxd03;
        else if(state == RW03) part <= part + ram_rxd03;
        else if(state == RR04) part <= part + ram_rxd04;
        else if(state == RW04) part <= part + ram_rxd04;
        else if(state == RR05) part <= part + ram_rxd05;
        else if(state == RW05) part <= part + ram_rxd05;
        else if(state == RR06) part <= part + ram_rxd06;
        else if(state == RW06) part <= part + ram_rxd06;
        else if(state == RR07) part <= part + ram_rxd07;
        else if(state == RW07) part <= part + ram_rxd07;
        else part <= part;
    end



    


endmodule