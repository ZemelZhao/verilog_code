module sim();

    reg clk_25, clk_50, clk_100, clk_200, clk_400;

    reg rst;

    initial begin
        rst <= 1'b0;
        #24;
        rst <= 1'b1;
        #60;
        rst <= 1'b0;
    end

    always begin
        clk_25 <= 1'b0;
        #80;
        clk_25 <= 1'b1;
        #80;
    end

    always begin
        clk_50 <= 1'b0;
        #40;
        clk_50 <= 1'b1;
        #40;
    end

    always begin
        clk_100 <= 1'b0;
        #20;
        clk_100 <= 1'b1;
        #20;
    end

    always begin
        clk_200 <= 1'b0;
        #10;
        clk_200 <= 1'b1;
        #10;
    end

    always begin
        clk_400 <= 1'b0;
        #5;
        clk_400 <= 1'b1;
        #5;
    end

    tb_com
    tb_com_dut(
        .clk_25(clk_25),
        .clk_50(clk_50),
        .clk_100(clk_100),
        .clk_200(clk_200),
        .clk_400(clk_400),
        .rst(rst)
    );


    // tb_ram2fifo
    // tb_ram2fifo(
    //     .clk(clk_200),
    //     .rst(rst)
    // );




endmodule