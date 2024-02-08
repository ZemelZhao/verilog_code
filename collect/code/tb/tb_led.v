module tb_led(
    input clk_in_p,
    input clk_in_n,

    input rst_n,

    output fan_n,

    output [7:0] led_n
);

    reg [3:0] state, next_state;
    wire clk_slow, clk_norm, clk_fast;

    localparam IDLE = 4'b0001, WAIT = 4'b0010, WORK = 4'b0100, DONE = 4'b1000;

    wire rst;
    wire fan;

    reg [31:0] num;
    reg [7:0] led;

    localparam NUM = 32'd75_000_000;

    assign fan_n = ~fan;
    assign fan = 1'b1;

    assign led_n[0] = ~led[0];
    assign led_n[1] = ~led[1];
    assign led_n[2] = ~led[2];
    assign led_n[3] = ~led[3];
    assign led_n[4] = ~led[4];
    assign led_n[5] = ~led[5];
    assign led_n[6] = ~led[6];
    assign led_n[7] = ~led[7];

    always@(posedge clk_norm or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= WORK;
            WORK: begin
                if(num >= NUM) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: next_state <= WORK;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk_norm or posedge rst) begin
        if(rst) num <= 32'h0000;
        else if(state == IDLE) num <= 32'h0000;
        else if(state == WAIT) num <= 32'h0000;
        else if(state == WORK) num <= num + 1'b1;
        else if(state == DONE) num <= 32'h0000;
        else num <= 32'h0000;
    end

    always@(posedge clk_norm or posedge rst) begin
        if(rst) led <= 8'h00;
        else if(state == IDLE) led <= 8'h00;
        else if(state == WAIT) led <= 8'h01; 
        else if(state == DONE && led == 8'h01) led <= 8'h02;
        else if(state == DONE && led == 8'h02) led <= 8'h04;
        else if(state == DONE && led == 8'h04) led <= 8'h08;
        else if(state == DONE && led == 8'h08) led <= 8'h10;
        else if(state == DONE && led == 8'h10) led <= 8'h20;
        else if(state == DONE && led == 8'h20) led <= 8'h40;
        else if(state == DONE && led == 8'h40) led <= 8'h80;
        else if(state == DONE && led == 8'h80) led <= 8'h01;
        else if(state == DONE) led <= 8'h01;
        else led <= led;
    end 

    clk_wiz
    clk_wiz_dut(
        .clk_in1_p(clk_in_p),
        .clk_in1_n(clk_in_n),

        .clk_slow(clk_slow),
        .clk_norm(clk_norm),
        .clk_fast(clk_fast)
    );

    por
    por_dut(
        .clk(clk_slow),
        .rst_n(rst_n),
        .rst(rst)
    );


endmodule