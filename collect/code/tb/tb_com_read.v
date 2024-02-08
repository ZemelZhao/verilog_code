module tb_com_read(
    input clk,
    input rst
);

    wire fs, fd;
    wire [15:0] password;
    wire [7:0] rxa, rxd; 
    reg [7:0] txa, txd;
    wire txen;
    wire [3:0] btype;
    wire [11:0] com_cmd;
    wire [39:0] trgg_cmd;

    reg [3:0] state, next_state;
    localparam IDLE = 4'h1, WAIT = 4'h2, WORK = 4'h4, DONE = 4'h8;

    wire [7:0] func, rate, lfilt, hfilt, trgg0, trgg1;
    wire [15:0] dly0, dly1, part;
    reg [7:0] num;

    assign func = 8'h02;
    assign rate = 8'h03;
    assign lfilt = 8'h08;
    assign hfilt = 8'h09;
    assign trgg0 = 8'h05;
    assign trgg1 = 8'h06;
    assign dly0 = 16'h1234;
    assign dly1 = 16'h5678;
    assign part = 16'h55AA + func + rate + {lfilt, hfilt} + {trgg0, trgg1} + dly0 + dly1;

    assign password = 16'h55AA;
    assign txen = (state == WAIT);
    assign fs = (state == WORK);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(num >= 8'd18) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(fd) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: next_state <= IDLE;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) txa <= 8'h0A;
        else if(state == WAIT) txa <= 8'h0A + num;
        else txa <= 8'h0A;
    end 

    always@(posedge clk or posedge rst) begin
        if(rst) txd <= 8'h00;
        else if(state == WAIT && num == 8'h00) txd <= 8'h55;
        else if(state == WAIT && num == 8'h01) txd <= 8'hAA;
        else if(state == WAIT && num == 8'h02) txd <= 8'h55;
        else if(state == WAIT && num == 8'h03) txd <= 8'hAA;
        else if(state == WAIT && num == 8'h04) txd <= 8'h00;
        else if(state == WAIT && num == 8'h05) txd <= func;
        else if(state == WAIT && num == 8'h06) txd <= 8'h00;
        else if(state == WAIT && num == 8'h07) txd <= rate;
        else if(state == WAIT && num == 8'h08) txd <= lfilt;
        else if(state == WAIT && num == 8'h09) txd <= hfilt;
        else if(state == WAIT && num == 8'h0A) txd <= trgg0;
        else if(state == WAIT && num == 8'h0B) txd <= trgg1;
        else if(state == WAIT && num == 8'h0C) txd <= dly0[15:8];
        else if(state == WAIT && num == 8'h0D) txd <= dly0[7:0];
        else if(state == WAIT && num == 8'h0E) txd <= dly1[15:8];
        else if(state == WAIT && num == 8'h0F) txd <= dly1[7:0];
        else if(state == WAIT && num == 8'h10) txd <= part[15:8];
        else if(state == WAIT && num == 8'h11) txd <= part[7:0];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state ==  WAIT) num <= num + 1'b1;
        else num <= 8'h00;
    end


    

    com_read
    com_read_dut(
        .clk(clk),
        .rst(rst),
        .fs(fs),
        .fd(fd),
        .password(password),
        .rxa(rxa),
        .rxd(rxd),
        .btype(btype),
        .com_cmd(com_cmd),
        .trgg_cmd(trgg_cmd)
    );

    ram_cmd
    ram_cmd_dut(
        .clka(clk),
        .wea(txen),
        .addra(txa),
        .dina(txd),
        .clkb(clk),
        .addrb(rxa),
        .doutb(rxd)
    );




endmodule