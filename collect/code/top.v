module top(
    input clk_p,
    input clk_n,
    input rst_n
);

    wire clk, rst;
    assign rst = ~rst_n;

    IBUFDS #(
        .DIFF_TERM("TRUE"),      // Differential Termination
        .IBUF_LOW_PWR("TRUE"),   // Low power="TRUE", Highest performance="FALSE" 
        .IOSTANDARD("DEFAULT")   // Specify the input I/O standard
    ) u_ibuf_sys_clk (
        .O(clk),             // Buffer output
        .I(clk_p),           // Diff_p buffer input (connect directly to top-level port)
        .IB(clk_n)           // Diff_n buffer input (connect directly to top-level port)
    ); 



    tb_udp_tx
    tb_udp_tx_dut(
        .clk(clk),
        .rst(rst)
    );




endmodule