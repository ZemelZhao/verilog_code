module data_make(
    input clk,
    input rst,

    input fs,
    output fd,

    input [3:0] btype,
    input [11:0] ram_addr_init,

    output reg [7:0] fifo_rxen,
    input [63:0] fifo_rxd,

    input [31:0] cache_cmd,
    input [31:0] cache_stat,

    output reg [11:0] ram_txa,
    output reg [7:0] ram_txd,
    output reg ram_txen
);

    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    localparam DATA_LEN = 8'h40, CHIP_NUM = 4'h8;

    localparam ADDR_CMD_DEVICE_IDX = 8'h1F, DLEN_CMD_DEVICE_IDX = 8'h04;
    localparam ADDR_CMD_DATA_IDX = 8'h1B, DLEN_CMD_DATA_IDX = 8'h04;
    localparam ADDR_INT_DEVICE_TEMP = 8'h1E, DLEN_INT_DEVICE_TEMP = 8'h08;
    localparam ADDR_INT_DEVICE_TYPE = 8'h0F, DLEN_INT_DEVICE_TYPE = 8'h08;
    localparam ADDR_INT_DEVICE_STAT = 8'h07, DLEN_INT_DEVICE_STAT = 8'h04;

    wire [DLEN_CMD_DEVICE_IDX - 1'b1 : 0] device_idx;
    wire [DLEN_CMD_DATA_IDX - 1'b1 : 0] data_idx;
    wire [DLEN_INT_DEVICE_TEMP - 1'b1 : 0] device_temp;
    wire [DLEN_INT_DEVICE_TYPE - 1'b1 : 0] device_type;
    wire [DLEN_INT_DEVICE_STAT - 1'b1 : 0] device_stat;

    assign device_idx = cache_cmd[ADDR_CMD_DEVICE_IDX -: DLEN_CMD_DEVICE_IDX];
    assign data_idx = cache_cmd[ADDR_CMD_DATA_IDX -: DLEN_CMD_DATA_IDX];
    assign device_temp = cache_stat[ADDR_INT_DEVICE_TEMP -: DLEN_INT_DEVICE_TEMP];
    assign device_type = cache_stat[ADDR_INT_DEVICE_TYPE -: DLEN_INT_DEVICE_TYPE];
    assign device_stat = cache_stat[ADDR_INT_DEVICE_STAT -: DLEN_INT_DEVICE_STAT];

    localparam HEAD_DTYPE = 4'h1, HEAD_DTEMP = 4'h9, HEAD_DATA = 4'h3;
    localparam HEAD_DLINK = 4'hD, DATA_DLINK = 12'h123;

    localparam DATA_ADDR_INIT = 12'hFE0;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_DONE = 8'h02;
    localparam DLINK_IDLE = 8'h10, DLINK_WORK = 8'h11;
    localparam DTYPE_IDLE = 8'h20, DTYPE_WORK = 8'h21;
    localparam DTEMP_IDLE = 8'h30, DTEMP_WORK = 8'h31;
    localparam DATA_IDLE = 8'h40, DATA_HEAD = 8'h41, DATA_WORK = 8'h42, DATA_REST = 8'h43;
    localparam DATA_GAP = 8'h44;

    reg [7:0] dlen;
    reg [3:0] cnum;
    reg [7:0] adc_rxd;
    reg [7:0] adc_rxen;

    assign fd = (state == MAIN_DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs && btype == BAG_DLINK) next_state <= DLINK_IDLE;
                else if(fs && btype == BAG_DTYPE) next_state <= DTYPE_IDLE;
                else if(fs && btype == BAG_DTEMP) next_state <= DTEMP_IDLE;
                else if(fs && btype == BAG_DATA0) next_state <= DATA_IDLE;
                else if(fs && btype == BAG_DATA1) next_state <= DATA_IDLE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_DONE: begin
                if(~fs) next_state <= MAIN_WAIT;
                else next_state <= MAIN_DONE;
            end

            DLINK_IDLE: next_state <= DLINK_WORK;
            DLINK_WORK: next_state <= MAIN_DONE;

            DTYPE_IDLE: next_state <= DTYPE_WORK;
            DTYPE_WORK: next_state <= MAIN_DONE;

            DTEMP_IDLE: next_state <= DTEMP_WORK;
            DTEMP_WORK: next_state <= MAIN_DONE;

            DATA_IDLE: next_state <= DATA_HEAD;
            DATA_HEAD: next_state <= DATA_GAP;
            DATA_GAP: next_state <= DATA_WORK;
            DATA_WORK: begin
                if(dlen >= DATA_LEN - 2'h2) next_state <= DATA_REST;
                else next_state <= DATA_WORK;
            end
            DATA_REST: begin
                if(cnum >= CHIP_NUM) next_state <= MAIN_DONE;
                else next_state <= DATA_GAP;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txa <= DATA_ADDR_INIT;
        else if(state == MAIN_IDLE) ram_txa <= DATA_ADDR_INIT;
        else if(state == MAIN_WAIT) ram_txa <= DATA_ADDR_INIT;
        else if(state == MAIN_DONE) ram_txa <= DATA_ADDR_INIT;

        else if(state == DLINK_IDLE) ram_txa <= ram_addr_init; 
        else if(state == DLINK_WORK) ram_txa <= ram_txa + 1'b1;

        else if(state == DTYPE_IDLE) ram_txa <= ram_addr_init;
        else if(state == DTYPE_WORK) ram_txa <= ram_txa + 1'b1;

        else if(state == DTEMP_IDLE) ram_txa <= ram_addr_init;
        else if(state == DTEMP_WORK) ram_txa <= ram_txa + 1'b1;

        else if(state == DATA_IDLE) ram_txa <= ram_addr_init;
        else if(state == DATA_HEAD) ram_txa <= ram_txa + 1'b1;
        else if(state == DATA_WORK) ram_txa <= ram_txa + 1'b1;
        else if(state == DATA_REST) ram_txa <= ram_txa + 1'b1;

        else ram_txa <= ram_txa;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txd <= 8'h00;
        else if(state == MAIN_IDLE) ram_txd <= 8'h00;
        else if(state == MAIN_WAIT) ram_txd <= 8'h00;
        else if(state == MAIN_DONE) ram_txd <= 8'h00;
        else if(state == DLINK_IDLE) ram_txd <= {HEAD_DLINK, DATA_DLINK[11:8]};
        else if(state == DLINK_WORK) ram_txd <= DATA_DLINK[7:0];
        else if(state == DTYPE_IDLE) ram_txd <= {HEAD_DTYPE, device_idx};
        else if(state == DTYPE_WORK) ram_txd <= device_type;
        else if(state == DTEMP_IDLE) ram_txd <= {HEAD_DTEMP, device_idx};
        else if(state == DTEMP_WORK) ram_txd <= device_temp;
        else if(state == DATA_IDLE) ram_txd <= {HEAD_DATA, device_idx};
        else if(state == DATA_HEAD) ram_txd <= {data_idx, device_stat};
        else if(state == DATA_WORK) ram_txd <= adc_rxd;
        else if(state == DATA_REST) ram_txd <= adc_rxd;
        else ram_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txen <= 1'b0;
        else if(state == MAIN_IDLE) ram_txen <= 1'b0;
        else if(state == MAIN_WAIT) ram_txen <= 1'b0;
        else if(state == DLINK_IDLE) ram_txen <= 1'b1;
        else if(state == DLINK_WORK) ram_txen <= 1'b1;
        else if(state == DTYPE_IDLE) ram_txen <= 1'b1;
        else if(state == DTYPE_WORK) ram_txen <= 1'b1;
        else if(state == DTEMP_IDLE) ram_txen <= 1'b1;
        else if(state == DTEMP_WORK) ram_txen <= 1'b1;
        else if(state == DATA_IDLE) ram_txen <= 1'b1;
        else if(state == DATA_HEAD) ram_txen <= 1'b1;
        else if(state == DATA_WORK) ram_txen <= 1'b1;
        else if(state == DATA_REST) ram_txen <= 1'b1;
        else ram_txen <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fifo_rxen <= 8'h00;
        else if(state == MAIN_IDLE) fifo_rxen <= 8'h00;
        else if(state == MAIN_WAIT) fifo_rxen <= 8'h00;
        else if(state == DATA_WORK) fifo_rxen <= adc_rxen; 
        else if(state == DATA_GAP) fifo_rxen <= adc_rxen;
        else fifo_rxen <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnum <= 4'h0;
        else if(state == MAIN_IDLE) cnum <= 4'h0;
        else if(state == MAIN_WAIT) cnum <= 4'h0;
        else if(state == MAIN_DONE) cnum <= 4'h0;
        else if(state == DATA_HEAD) cnum <= 4'h1;
        else if(state == DATA_REST) cnum <= cnum + 1'b1;
        else cnum <= cnum;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= 8'h00;
        else if(state == MAIN_IDLE) dlen <= 8'h00;
        else if(state == MAIN_WAIT) dlen <= 8'h00;
        else if(state == MAIN_DONE) dlen <= 8'h00;
        else if(state == DATA_WORK) dlen <= dlen + 1'b1;
        else dlen <= 8'h00;
    end

    always@(*) begin
        case(cnum) 
            4'h1: adc_rxd <= fifo_rxd[63:56];
            4'h2: adc_rxd <= fifo_rxd[55:48];
            4'h3: adc_rxd <= fifo_rxd[47:40];
            4'h4: adc_rxd <= fifo_rxd[39:32];
            4'h5: adc_rxd <= fifo_rxd[31:24];
            4'h6: adc_rxd <= fifo_rxd[23:16];
            4'h7: adc_rxd <= fifo_rxd[15:8];
            4'h8: adc_rxd <= fifo_rxd[7:0];
            default: adc_rxd <= 8'h00;
        endcase
    end

    always@(*) begin
        case(cnum)
            4'h1: adc_rxen <= 8'h80;
            4'h2: adc_rxen <= 8'h40;
            4'h3: adc_rxen <= 8'h20;
            4'h4: adc_rxen <= 8'h10;
            4'h5: adc_rxen <= 8'h08;
            4'h6: adc_rxen <= 8'h04;
            4'h7: adc_rxen <= 8'h02;
            4'h8: adc_rxen <= 8'h01;
            default: adc_rxen <= 8'h00;
        endcase
    end

endmodule