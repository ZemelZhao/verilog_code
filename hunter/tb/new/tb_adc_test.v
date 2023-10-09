module tb_adc_test(
    input clk_25,
    input clk_50,
    input clk_100, 
    input clk_200,
    input rst
);

    wire clk;
    assign clk = clk_50;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01;
    localparam INIT = 8'h10, TYPE = 8'h11, CONF = 8'h12, CONV = 8'h13;
    localparam FIFO = 8'h14;

    wire fs_init, fd_init;
    wire fs_type, fd_type;
    wire fs_conf, fd_conf;
    wire fs_conv, fd_conv;
    wire fs_fifo, fd_fifo;

    wire [7:0] device_type;
    wire [15:0] device_temp;

    wire [7:0] fifo_adc_rxen;
    wire [63:0] fifo_adc_rxd;

    wire [11:0] ram_data_init, ram_data_txa;
    wire [7:0] ram_data_txd;

    assign ram_data_init = 12'h000;
    assign fs_init = (state == INIT);
    assign fs_type = (state == TYPE);
    assign fs_conf = (state == CONF);
    assign fs_conv = (state == CONV);
    assign fs_fifo = (state == FIFO);


    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= INIT;
            INIT: begin
                if(fd_init) next_state <= TYPE;
                else next_state <= INIT;
            end
            TYPE: begin
                if(fd_type) next_state <= CONF;
                else next_state <= TYPE;
            end
            CONF: begin
                if(fd_conf) next_state <= CONV;
                else next_state <= CONF;
            end
            CONV: begin
                if(fd_conv) next_state <= FIFO; 
                else next_state <= CONV;
            end
            FIFO: begin
                if(fd_fifo) next_state <= WAIT;
                else next_state <= FIFO;
            end
            
                
            default: next_state <= IDLE;
        endcase
    end



    adc2ram
    adc2ram_dut(
        .clk(clk_100),
        .rst(rst),

        .fs(fs_fifo),
        .fd(fd_fifo),

        .ram_txa_init(ram_data_init),

        .fifo_rxen(fifo_adc_rxen),
        .fifo_rxd(fifo_adc_rxd),

        .ram_txen(ram_data_txen),
        .ram_txd(ram_data_txd),
        .ram_txa(ram_data_txa)
    );





    adc_test
    adc_test_dut(
        .clk(clk_50),

        .fifo_txc(clk_100),
        .fifo_rxc(clk_100),

        .rst(rst),

        .fs_init(fs_init),
        .fd_init(fd_init),
        .fs_type(fs_type),
        .fd_type(fd_type),
        .fs_conf(fs_conf),
        .fd_conf(fd_conf),
        .fs_conv(fs_conv),
        .fd_conv(fd_conv),

        .device_type(device_type),
        .device_temp(device_temp),

        .fifo_rxen(fifo_adc_rxen),
        .fifo_rxd(fifo_adc_rxd)
    );



endmodule