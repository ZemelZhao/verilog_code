module sim();

    reg clk_25, clk_50, clk_100, clk_200;

    reg rst;

    initial begin
        rst <= 1'b0;
        #12;
        rst <= 1'b1;
        #30;
        rst <= 1'b0;
    end

    always begin
        clk_25 <= 1'b0;
        #40;
        clk_25 <= 1'b1;
        #40;
    end

    always begin
        clk_50 <= 1'b0;
        #20;
        clk_50 <= 1'b1;
        #20;
    end

    always begin
        clk_100 <= 1'b0;
        #10;
        clk_100 <= 1'b1;
        #10;
    end

    always begin
        clk_200 <= 1'b0;
        #5;
        clk_200 <= 1'b1;
        #5;
    end

    tb_crc32
    tb_crc32_dut(
        // .clk_25(clk_25),
        .clk(clk_50),
        // .clk_100(clk_100),
        // .clk_200(clk_200),
        .rst(rst)
    );


    // tb_ram2fifo
    // tb_ram2fifo(
    //     .clk(clk_200),
    //     .rst(rst)
    // );




endmodule