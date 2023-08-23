module sim();

    reg clk;
    reg rst_n;

    initial begin
        rst_n <= 1'b1;
        #12;
        rst_n <= 1'b0;
        #30;
        rst_n <= 1'b1;
    end

    always begin
        clk <= 1'b0;
        #5;
        clk <= 1'b1;
        #5;
    end




endmodule