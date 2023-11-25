module data_make(
    input clk,
    input rst,

    input fs,
    output fd,

    input [3:0] btype,
    input [3:0] data_idx,

    input [95:0] cache_info,

    output reg [11:0] cache_ram_rxa,
    input [63:0] cache_ram_rxd,

    output reg [15:0] ram_txa,
    output reg [7:0] ram_txd,
    output reg ram_txen
);

    localparam DATA_LATENCY = 4'h2;
    localparam DEVICE_NUM = 4'h8;

    localparam ADC_RAM_ADDR_DATA0 = 12'h000, ADC_RAM_ADDR_DATA1 = 12'h240;
    localparam ADC_RAM_ADDR_DATA2 = 12'h480, ADC_RAM_ADDR_DATA3 = 12'h6C0;
    localparam ADC_RAM_ADDR_DATA4 = 12'h900, ADC_RAM_ADDR_DATA5 = 12'hB40;
    localparam ADC_RAM_ADDR_INIT = 12'hF00;
    
    localparam COM_RAM_ADDR_DATA0 = 16'h0000, COM_RAM_ADDR_DATA1 = 16'h2400;
    localparam COM_RAM_ADDR_DATA2 = 16'h4800, COM_RAM_ADDR_DATA3 = 16'h6C00;
    localparam COM_RAM_ADDR_DATA4 = 16'h9000, COM_RAM_ADDR_DATA5 = 16'hB400;
    localparam COM_RAM_ADDR_STAT = 16'h2300, COM_RAM_ADDR_INIT = 16'hF000;

    localparam BAG_STAT = 4'h1, BAG_DATA = 4'h5;

    localparam SLEN = 12'h0E, HLEN = 12'h04, DLEN = 12'h200;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_DONE = 8'h02;
    localparam STAT_IDLE = 8'h10, STAT_WAIT = 8'h11, STAT_WORK = 8'h12;
    localparam DATA_IDLE = 8'h20, DATA_WAIT = 8'h22, DATA_WORK = 8'h23;
    localparam DATA_HEAD = 8'h24, DATA_GAP = 8'h25, DATA_REST = 8'h26;
    localparam DATA_JUDGE = 8'h27;

    reg [15:0] ram_addr_init;
    reg [11:0] cache_ram_addr_init;
    reg [11:0] dlen;
    reg [3:0] dnum, lnum;
    wire [0:7] device_stat;

    assign device_stat[0] = ~(cache_info[79:78] == 2'b00);
    assign device_stat[1] = ~(cache_info[77:76] == 2'b00);
    assign device_stat[2] = ~(cache_info[75:74] == 2'b00);
    assign device_stat[3] = ~(cache_info[73:72] == 2'b00);
    assign device_stat[4] = ~(cache_info[71:70] == 2'b00);
    assign device_stat[5] = ~(cache_info[69:68] == 2'b00);
    assign device_stat[6] = ~(cache_info[67:66] == 2'b00);
    assign device_stat[7] = ~(cache_info[65:64] == 2'b00);

    assign fd = (state == MAIN_DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs && btype == BAG_STAT) next_state <= STAT_IDLE;
                else if(fs && btype == BAG_DATA) next_state <= DATA_IDLE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_DONE: begin
                if(~fs) next_state <= MAIN_WAIT;
                else next_state <= MAIN_DONE;
            end

            STAT_IDLE: next_state <= STAT_WAIT;
            STAT_WAIT: next_state <= STAT_WORK;
            STAT_WORK: begin
                if(dlen >= SLEN - 1'b1) next_state <= MAIN_DONE;
                else next_state <= STAT_WORK;
            end

            DATA_IDLE: next_state <= DATA_WAIT;
            DATA_WAIT: next_state <= DATA_HEAD;
            DATA_HEAD: begin
                if(dlen >= HLEN - 1'b1) next_state <= DATA_REST;
                else next_state <= DATA_HEAD;
            end
            DATA_GAP: begin
                if(lnum >= DATA_LATENCY - 1'b1) next_state <= DATA_WORK;
                else next_state <= DATA_GAP;
            end
            DATA_WORK: begin
                if(dlen >= DLEN - 1'b1) next_state <= DATA_REST;
                else next_state <= DATA_WORK;
            end
            DATA_REST: next_state <= DATA_JUDGE;
            DATA_JUDGE: begin
                if(dnum >= DEVICE_NUM - 1'b1) next_state <= MAIN_DONE;
                else if(device_stat[dnum]) next_state <= DATA_GAP;
                else next_state <= DATA_REST;
            end
            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txa <= COM_RAM_ADDR_INIT;
        else if(state == MAIN_IDLE) ram_txa <= COM_RAM_ADDR_INIT;
        else if(state == MAIN_WAIT) ram_txa <= ram_addr_init;
        else if(state == MAIN_DONE) ram_txa <= ram_addr_init;

        else if(state == STAT_WAIT) ram_txa <= ram_addr_init;
        else if(state == STAT_WORK && dlen == 12'h000) ram_txa <= ram_txa;
        else if(state == STAT_WORK) ram_txa <= ram_txa + 1'b1;

        else if(state == DATA_WAIT) ram_txa <= ram_addr_init;
        else if(state == DATA_HEAD && dlen == 12'h000) ram_txa <= ram_txa;
        else if(state == DATA_HEAD) ram_txa <= ram_txa + 1'b1;
        else if(state == DATA_WORK) ram_txa <= ram_txa + 1'b1;

        else ram_txa <= ram_txa;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_addr_init <= COM_RAM_ADDR_INIT;
        else if(state == MAIN_IDLE) ram_addr_init <= COM_RAM_ADDR_INIT;
        else if(state == MAIN_WAIT) ram_addr_init <= COM_RAM_ADDR_INIT;
        else if(state == MAIN_DONE) ram_addr_init <= COM_RAM_ADDR_INIT;

        else if(state == STAT_IDLE) ram_addr_init <= COM_RAM_ADDR_STAT;
        else if(state == DATA_IDLE && data_idx == 4'h0) ram_addr_init <= COM_RAM_ADDR_DATA0;
        else if(state == DATA_IDLE && data_idx == 4'h1) ram_addr_init <= COM_RAM_ADDR_DATA1;
        else if(state == DATA_IDLE && data_idx == 4'h2) ram_addr_init <= COM_RAM_ADDR_DATA2;
        else if(state == DATA_IDLE && data_idx == 4'h3) ram_addr_init <= COM_RAM_ADDR_DATA3;
        else if(state == DATA_IDLE && data_idx == 4'h4) ram_addr_init <= COM_RAM_ADDR_DATA4;
        else if(state == DATA_IDLE && data_idx == 4'h5) ram_addr_init <= COM_RAM_ADDR_DATA5;

        else ram_addr_init <= ram_addr_init;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cache_ram_rxa <= ADC_RAM_ADDR_INIT;
        else if(state == MAIN_IDLE) cache_ram_rxa <= ADC_RAM_ADDR_INIT;
        else if(state == MAIN_WAIT) cache_ram_rxa <= cache_ram_addr_init;
        else if(state == MAIN_DONE) cache_ram_rxa <= cache_ram_addr_init;

        else if(state == DATA_WAIT) cache_ram_rxa <= cache_ram_addr_init;
        else if(state == DATA_GAP) cache_ram_rxa <= cache_ram_rxa + 1'b1;
        else if(state == DATA_WORK) cache_ram_rxa <= cache_ram_rxa + 1'b1;
        else if(state == DATA_REST) cache_ram_rxa <= cache_ram_addr_init;

        else cache_ram_rxa <= cache_ram_rxa;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cache_ram_addr_init <= ADC_RAM_ADDR_INIT; 
        else if(state == MAIN_IDLE) cache_ram_addr_init <= ADC_RAM_ADDR_INIT;
        else if(state == MAIN_WAIT) cache_ram_addr_init <= ADC_RAM_ADDR_INIT;
        else if(state == MAIN_DONE) cache_ram_addr_init <= ADC_RAM_ADDR_INIT;

        else if(state == DATA_IDLE && data_idx == 4'h0) cache_ram_addr_init <= ADC_RAM_ADDR_DATA0;
        else if(state == DATA_IDLE && data_idx == 4'h1) cache_ram_addr_init <= ADC_RAM_ADDR_DATA1;
        else if(state == DATA_IDLE && data_idx == 4'h2) cache_ram_addr_init <= ADC_RAM_ADDR_DATA2;
        else if(state == DATA_IDLE && data_idx == 4'h3) cache_ram_addr_init <= ADC_RAM_ADDR_DATA3;
        else if(state == DATA_IDLE && data_idx == 4'h4) cache_ram_addr_init <= ADC_RAM_ADDR_DATA4;
        else if(state == DATA_IDLE && data_idx == 4'h5) cache_ram_addr_init <= ADC_RAM_ADDR_DATA5;
        
        else cache_ram_addr_init <= cache_ram_addr_init;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txd <= 8'h00;
        else if(state == MAIN_IDLE) ram_txd <= 8'h00;
        else if(state == MAIN_WAIT) ram_txd <= 8'h00;
        else if(state == MAIN_DONE) ram_txd <= 8'h00;
        else if(state == STAT_WORK && dlen == 12'h00) ram_txd <= 8'h66;
        else if(state == STAT_WORK && dlen == 12'h01) ram_txd <= 8'hBB;
        else if(state == STAT_WORK && dlen == 12'h02) ram_txd <= cache_info[95:88];
        else if(state == STAT_WORK && dlen == 12'h03) ram_txd <= cache_info[87:80];
        else if(state == STAT_WORK && dlen == 12'h04) ram_txd <= cache_info[79:72];
        else if(state == STAT_WORK && dlen == 12'h05) ram_txd <= cache_info[71:64];
        else if(state == STAT_WORK && dlen == 12'h06) ram_txd <= cache_info[63:56];
        else if(state == STAT_WORK && dlen == 12'h07) ram_txd <= cache_info[55:48];
        else if(state == STAT_WORK && dlen == 12'h08) ram_txd <= cache_info[47:40];
        else if(state == STAT_WORK && dlen == 12'h09) ram_txd <= cache_info[39:32];
        else if(state == STAT_WORK && dlen == 12'h0A) ram_txd <= cache_info[31:24];
        else if(state == STAT_WORK && dlen == 12'h0B) ram_txd <= cache_info[23:16];
        else if(state == STAT_WORK && dlen == 12'h0C) ram_txd <= cache_info[15:8];
        else if(state == STAT_WORK && dlen == 12'h0D) ram_txd <= cache_info[7:0];
        else if(state == DATA_HEAD && dlen == 12'h00) ram_txd <= 8'h55;
        else if(state == DATA_HEAD && dlen == 12'h01) ram_txd <= 8'hAA;
        else if(state == DATA_HEAD && dlen == 12'h02) ram_txd <= device_stat;
        else if(state == DATA_HEAD && dlen == 12'h03) ram_txd <= {4'h0, data_idx};
        else if(state == DATA_WORK && dnum == 4'h0) ram_txd <= cache_ram_rxd[63:56]; 
        else if(state == DATA_WORK && dnum == 4'h1) ram_txd <= cache_ram_rxd[55:48]; 
        else if(state == DATA_WORK && dnum == 4'h2) ram_txd <= cache_ram_rxd[47:40]; 
        else if(state == DATA_WORK && dnum == 4'h3) ram_txd <= cache_ram_rxd[39:32]; 
        else if(state == DATA_WORK && dnum == 4'h4) ram_txd <= cache_ram_rxd[31:24]; 
        else if(state == DATA_WORK && dnum == 4'h5) ram_txd <= cache_ram_rxd[23:16]; 
        else if(state == DATA_WORK && dnum == 4'h6) ram_txd <= cache_ram_rxd[15:8]; 
        else if(state == DATA_WORK && dnum == 4'h7) ram_txd <= cache_ram_rxd[7:0]; 
        else ram_txd <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_txen <= 1'b0;
        else if(state == MAIN_IDLE) ram_txen <= 1'b0;
        else if(state == MAIN_WAIT) ram_txen <= 1'b0;
        else if(state == MAIN_DONE) ram_txen <= 1'b0;
        else if(state == STAT_WORK) ram_txen <= 1'b1;
        else if(state == DATA_HEAD) ram_txen <= 1'b1;
        else if(state == DATA_WORK) ram_txen <= 1'b1;
        else ram_txen <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dlen <= 12'h00;
        else if(state == MAIN_IDLE) dlen <= 12'h00;
        else if(state == MAIN_WAIT) dlen <= 12'h00;
        else if(state == MAIN_DONE) dlen <= 12'h00;
        else if(state == STAT_WORK) dlen <= dlen + 1'b1;
        else if(state == DATA_HEAD) dlen <= dlen + 1'b1;
        else if(state == DATA_WORK) dlen <= dlen + 1'b1;
        else dlen <= 12'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) lnum <= 4'h0;
        else if(state == MAIN_IDLE) lnum <= 4'h0;
        else if(state == MAIN_WAIT) lnum <= 4'h0;
        else if(state == DATA_GAP) lnum <= lnum + 1'b1;
        else lnum <= 4'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dnum <= 4'hF;
        else if(state == MAIN_IDLE) dnum <= 4'hF;
        else if(state == MAIN_WAIT) dnum <= 4'hF;
        else if(state == MAIN_DONE) dnum <= 4'hF;
        else if(state == DATA_REST) dnum <= dnum + 1'b1;
        else dnum <= dnum;
    end


endmodule