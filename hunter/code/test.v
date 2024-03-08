module test(
    input clk_in,

    input [1:0] com_cc,
    input com_txf,
    input com_rxf
);

    wire clk_norm;

    (*MARK_DEBUG = "true"*)reg [1:0] pin_cc;
    (*MARK_DEBUG = "true"*)reg pin_txf, pin_rxf;

    always@(posedge clk_norm) begin
        pin_cc <= com_cc;
        pin_txf <= com_txf;
        pin_rxf <= com_rxf;
    end

    clk_wiz
    clk_wiz_dut(
        .clk_in(clk_in),
        .clk_norm(clk_norm)
    );

    





endmodule