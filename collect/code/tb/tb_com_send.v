module tb_com_send(
    input clk,
    input rst
);

    wire gmii_txc;

    wire fs_ram_tx, fd_ram_tx;
    wire ram_data_txen;
    wire [14:0] ram_data_txa;
    wire [7:0] ram_data_txd;

    reg [7:0] state, next_state;
    
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h04;

    assign gmii_txc = clk;
    assign fs_ram_tx = (state == WAIT);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fd_ram_tx) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: next_state <= DONE;
            DONE: next_state <= DONE;
            default: next_state <= IDLE;
        endcase
    end


    com_test
    com_test_dut(
        .clk(gmii_txc),
        .rst(rst),
        .fs(fs_ram_tx),
        .fd(fd_ram_tx),
        .ram_data_txa(ram_data_txa),
        .ram_data_txd(ram_data_txd),
        .ram_data_txen(ram_data_txen)
    );



endmodule