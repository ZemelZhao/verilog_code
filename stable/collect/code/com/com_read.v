module com_read(
    input clk,
    input rst,

    (*MARK_DEBUG = "true"*)input fs_eth,
    (*MARK_DEBUG = "true"*)output fd_eth,

    (*MARK_DEBUG = "true"*)output fs,
    (*MARK_DEBUG = "true"*)input fd,
 
    output reg [7:0] rxa,
    input [7:0] rxd,

    input [15:0] password,

    output reg [3:0] btype,
    output reg [11:0] com_cmd,
    output reg [39:0] trgg_cmd
);

    parameter RAM_ADDR_INIT = 8'h0A;

    localparam STD_HEAD = 16'h55AA;

    localparam NUM_HEAD0 = 8'h00, NUM_HEAD1 = 8'h01;
    localparam NUM_DIDX0 = 8'h02, NUM_DIDX1 = 8'h03;
    localparam NUM_FUNC0 = 8'h04, NUM_FUNC1 = 8'h05;
    localparam NUM_RATE0 = 8'h06, NUM_RATE1 = 8'h07;
    localparam NUM_LFILT = 8'h08, NUM_HFILT = 8'h09;
    localparam NUM_TRGG0 = 8'h0A, NUM_TRGG1 = 8'h0B;
    localparam NUM_DLY00 = 8'h0C, NUM_DLY01 = 8'h0D;
    localparam NUM_DLY10 = 8'h0E, NUM_DLY11 = 8'h0F;
    localparam NUM_PART0 = 8'h10, NUM_PART1 = 8'h11;


    localparam DATA_LATENCY = 8'h02;
    localparam NUM = 8'h12;

    reg [5:0] state, next_state;

    localparam IDLE = 6'h01, WAIT = 6'h02, WORK = 6'h04;
    localparam TAKE = 6'h08, REST = 6'h10, DONE = 6'h20;

    localparam BTYPE_INIT = 4'h0;
    localparam BTYPE_CONF = 4'h01, BTYPE_READ = 4'h02, BTYPE_STOP = 4'h03;
    localparam BTYPE_RXD0 = 4'h04, BTYPE_RXD1 = 4'h05;
    localparam BAG_CONF = 16'h001E, BAG_READ = 16'h004C, BAG_STOP = 16'h0097;
    localparam BAG_RXD0 = 16'h002D, BAG_RXD1 = 16'h00D2;

    reg [7:0] num;
    reg [15:0] data[0:8];
    wire [15:0] sum;
    wire part, pass;
    assign sum = data[1]+data[2]+data[3]+data[4]+data[5]+data[6]+data[7]; 

    // assign part = (sum == data[NUM_PART0[7:1]]) && (data[NUM_HEAD0[7:1]] == STD_HEAD);
    // assign pass = data[NUM_DIDX0[7:1]] == password;

    assign part = 1'b1;
    assign pass = 1'b1;

    assign fd_eth = (state == REST);
    assign fs = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs_eth) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(num >= NUM + DATA_LATENCY) next_state <= TAKE;
                else next_state <= WORK;
            end
            TAKE: next_state <= REST;
            REST: begin
                if(~fs_eth) next_state <= DONE;
                else next_state <= REST;
            end
            DONE: begin
                if(fd) next_state <= IDLE;
                else next_state <= DONE;
            end
            
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rxa <= RAM_ADDR_INIT;
        else if(state == WORK && num == NUM_HEAD0) rxa <= RAM_ADDR_INIT + NUM_HEAD0;
        else if(state == WORK && num == NUM_HEAD1) rxa <= RAM_ADDR_INIT + NUM_HEAD1;
        else if(state == WORK && num == NUM_DIDX0) rxa <= RAM_ADDR_INIT + NUM_DIDX0;
        else if(state == WORK && num == NUM_DIDX1) rxa <= RAM_ADDR_INIT + NUM_DIDX1;
        else if(state == WORK && num == NUM_FUNC0) rxa <= RAM_ADDR_INIT + NUM_FUNC0;
        else if(state == WORK && num == NUM_FUNC1) rxa <= RAM_ADDR_INIT + NUM_FUNC1;
        else if(state == WORK && num == NUM_RATE0) rxa <= RAM_ADDR_INIT + NUM_RATE0;
        else if(state == WORK && num == NUM_RATE1) rxa <= RAM_ADDR_INIT + NUM_RATE1;
        else if(state == WORK && num == NUM_LFILT) rxa <= RAM_ADDR_INIT + NUM_LFILT;
        else if(state == WORK && num == NUM_HFILT) rxa <= RAM_ADDR_INIT + NUM_HFILT;
        else if(state == WORK && num == NUM_TRGG0) rxa <= RAM_ADDR_INIT + NUM_TRGG0;
        else if(state == WORK && num == NUM_TRGG1) rxa <= RAM_ADDR_INIT + NUM_TRGG1;
        else if(state == WORK && num == NUM_DLY00) rxa <= RAM_ADDR_INIT + NUM_DLY00;
        else if(state == WORK && num == NUM_DLY01) rxa <= RAM_ADDR_INIT + NUM_DLY01;
        else if(state == WORK && num == NUM_DLY10) rxa <= RAM_ADDR_INIT + NUM_DLY10;
        else if(state == WORK && num == NUM_DLY11) rxa <= RAM_ADDR_INIT + NUM_DLY11;
        else if(state == WORK && num == NUM_PART0) rxa <= RAM_ADDR_INIT + NUM_PART0;
        else if(state == WORK && num == NUM_PART1) rxa <= RAM_ADDR_INIT + NUM_PART1;
        else rxa <= RAM_ADDR_INIT;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) begin
            data[NUM_HEAD0[7:1]] <= 16'h00;
            data[NUM_DIDX0[7:1]] <= 16'h00;
            data[NUM_FUNC0[7:1]] <= 16'h00;
            data[NUM_RATE0[7:1]] <= 16'h00;
            data[NUM_LFILT[7:1]] <= 16'h00;
            data[NUM_TRGG0[7:1]] <= 16'h00;
            data[NUM_DLY00[7:1]] <= 16'h00;
            data[NUM_DLY10[7:1]] <= 16'h00;
            data[NUM_PART0[7:1]] <= 16'h00;
        end
        else if(state == WORK && num == NUM_HEAD0 + DATA_LATENCY + 1'b1) data[NUM_HEAD0[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_HEAD1 + DATA_LATENCY + 1'b1) data[NUM_HEAD1[7:1]][7:0] <= rxd;
        else if(state == WORK && num == NUM_DIDX0 + DATA_LATENCY + 1'b1) data[NUM_DIDX0[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_DIDX1 + DATA_LATENCY + 1'b1) data[NUM_DIDX1[7:1]][7:0] <= rxd;
        else if(state == WORK && num == NUM_FUNC0 + DATA_LATENCY + 1'b1) data[NUM_FUNC0[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_FUNC1 + DATA_LATENCY + 1'b1) data[NUM_FUNC1[7:1]][7:0] <= rxd;
        else if(state == WORK && num == NUM_RATE0 + DATA_LATENCY + 1'b1) data[NUM_RATE0[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_RATE1 + DATA_LATENCY + 1'b1) data[NUM_RATE1[7:1]][7:0] <= rxd;
        else if(state == WORK && num == NUM_LFILT + DATA_LATENCY + 1'b1) data[NUM_LFILT[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_HFILT + DATA_LATENCY + 1'b1) data[NUM_HFILT[7:1]][7:0] <= rxd;
        else if(state == WORK && num == NUM_TRGG0 + DATA_LATENCY + 1'b1) data[NUM_TRGG0[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_TRGG1 + DATA_LATENCY + 1'b1) data[NUM_TRGG1[7:1]][7:0] <= rxd;
        else if(state == WORK && num == NUM_DLY00 + DATA_LATENCY + 1'b1) data[NUM_DLY00[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_DLY01 + DATA_LATENCY + 1'b1) data[NUM_DLY01[7:1]][7:0] <= rxd;
        else if(state == WORK && num == NUM_DLY10 + DATA_LATENCY + 1'b1) data[NUM_DLY10[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_DLY11 + DATA_LATENCY + 1'b1) data[NUM_DLY11[7:1]][7:0] <= rxd;
        else if(state == WORK && num == NUM_PART0 + DATA_LATENCY + 1'b1) data[NUM_PART0[7:1]][15:8] <= rxd;
        else if(state == WORK && num == NUM_PART1 + DATA_LATENCY + 1'b1) data[NUM_PART1[7:1]][7:0] <= rxd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 8'h00;
        else if(state == WORK) num <= num + 1'b1;
        else num <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) btype <= BTYPE_INIT;
        else if(state == TAKE && part && pass && data[NUM_FUNC0[7:1]] == BAG_CONF) btype <= BTYPE_CONF;
        else if(state == TAKE && part && pass && data[NUM_FUNC0[7:1]] == BAG_READ) btype <= BTYPE_READ;
        else if(state == TAKE && part && pass && data[NUM_FUNC0[7:1]] == BAG_STOP) btype <= BTYPE_STOP;
        else if(state == TAKE && part && pass && data[NUM_FUNC0[7:1]] == BAG_RXD0) btype <= BTYPE_RXD0;
        else if(state == TAKE && part && pass && data[NUM_FUNC0[7:1]] == BAG_RXD1) btype <= BTYPE_RXD1;
        else btype <= btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_cmd <= 12'h000;
        else if(state == TAKE && part && data[NUM_FUNC0[7:1]] == BAG_CONF) begin
            com_cmd <= {data[NUM_RATE1[7:1]][3:0], data[NUM_LFILT[7:1]][11:8], data[NUM_HFILT[7:1]][3:0]};
        end
        else if(state == TAKE && part == 1'b0) com_cmd <= 12'h000;
        else com_cmd <= com_cmd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) trgg_cmd <= 40'h0000;
        else if(state == TAKE && part && data[NUM_FUNC0[7:1]] == BAG_CONF) begin
            trgg_cmd <= {data[NUM_TRGG0[7:1]][11:8], data[NUM_TRGG1[7:1]][3:0], data[NUM_DLY00[7:1]], data[NUM_DLY10[7:1]]};
        end
        else if(state == TAKE && part == 1'b0) trgg_cmd <= 40'h0000;
        else trgg_cmd <= trgg_cmd;
    end

endmodule