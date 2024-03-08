module sim();
    reg clk, rst;

    always begin
        clk <= 1'b0;
        #5;
        clk <= 1'b1;
        #5;
    end

    initial begin
        rst <= 1'b0;
        #12;
        rst <= 1'b1;
        #33;
        rst <= 1'b0;
    end

    tb_data_make
    tb_data_make_dut(
        .clk(clk),
        .rst(rst)
    );



endmodule