module intan(
    input clk,
    input spi_clk,

    input fifo_txc,
    input fifo_rxc,

    input rst,

    input fs_init,
    input fs_type,
    input fs_conf,
    input fs_conv,

    output fd_init,
    output fd_type,
    output fd_conf,
    output fd_conv,

    input [2:0] fs, 
    output reg [1:0] type,
    output reg [15:0] chip_temp,

    input [3:0] filt_up,
    input [3:0] filt_low,

    input spi_miso,
    output spi_mosi,
    output spi_sclk,
    output spi_cs,

    input [1:0] fifo_rxen,
    output [15:0] fifo_rxd
);

    localparam DATA_REG59_A = 8'h35, DATA_REG59_B = 8'h3A;
    localparam DATA_REG63_RHD2116 = 8'h01, DATA_REG63_RHD2132 = 8'h02, DATA_REG63_RHD2164 = 8'h04;
    localparam DATA_REG40 = 8'h49, DATA_REG41 = 8'h4E, DATA_REG42 = 8'h54, DATA_REG43 = 8'h41;
    localparam DATA_REG44 = 8'h4E;

    localparam HEAD_CONV = 2'b00, HEAD_CMD = 2'b01, HEAD_TX = 2'b10, HEAD_RX = 2'b11;
    localparam TAIL_CONV = 8'h00;
    localparam RHEAD_TX = 8'hFF, RHEAD_RX = 8'h00;

    localparam CHIP_INIT = 16'h0000, CHIP_CALIBRATE = 16'h5500, CHIP_CLEAR = 16'h6A00;
    localparam CHIP_GAP = {HEAD_RX, REG40, 8'h00};
    localparam CHIP_RXD_INIT = 16'h0000;

    localparam WAIT_FOR_0US = 16'h0000, WAIT_FOR_100US = 16'd5_000; 
    localparam WAIT_FOR_200US = 16'd10_000, WAIT_FOR_250US = 16'd12_500;

    localparam FS_1KHZ = 3'h1, FS_2KHZ = 3'h2, FS_4KHZ = 3'h3; 
    localparam FS_8KHZ = 3'h4, FS_16KHZ = 3'h5;

    localparam FILTUP_20K = 4'h1, FILTUP_15K = 4'h2, FILTUP_10K = 4'h3, FILTUP_7K5 = 4'h4;
    localparam FILTUP_5K0 = 4'h5, FILTUP_3K0 = 4'h6, FILTUP_2K5 = 4'h7, FILTUP_2K0 = 4'h8;
    localparam FILTUP_1K5 = 4'h9, FILTUP_1K0 = 4'hA, FILTUP_750 = 4'hB, FILTUP_500 = 4'hC;
    localparam FILTUP_300 = 4'hD, FILTUP_200 = 4'hE, FILTUP_100 = 4'hF;

    localparam FILTLOW_100 = 4'h1, FILTLOW_020 = 4'h2, FILTLOW_015 = 4'h3, FILTLOW_010 = 4'h4;
    localparam FILTLOW_7D5 = 4'h5, FILTLOW_5D0 = 4'h6, FILTLOW_3D0 = 4'h7, FILTLOW_2D5 = 4'h8;
    localparam FILTLOW_2D0 = 4'h9, FILTLOW_1D0 = 4'hA, FILTLOW_D75 = 4'hB, FILTLOW_D50 = 4'hC;
    localparam FILTLOW_D30 = 4'hD, FILTLOW_D25 = 4'hE, FILTLOW_D10 = 4'hF;

    localparam DATA_REG00_NORMAL = 8'hDE, DATA_REG00_RESET = 8'hFE; 
    localparam DATA_REG01_12KHZ = 8'h20, DATA_REG01_4KHZ = 8'h10, DATA_REG01_8KHZ = 8'h08, DATA_REG01_16KHZ = 8'h03;
    localparam DATA_REG02_12KHZ = 8'h28, DATA_REG02_4KHZ = 8'h28, DATA_REG02_8KHZ = 8'h1A, DATA_REG02_16KHZ = 8'h07;
    localparam DATA_REG03_NORMAL = 8'h00; 
    localparam DATA_REG03_TEMP_EN = 8'h04, DATA_REG03_TEMP_00 = 8'h0C, DATA_REG03_TEMP_01 = 8'h1C, DATA_REG03_TEMP_10 = 8'h14;
    localparam DATA_REG04 = 8'hDD, DATA_REG05 = 8'h00, DATA_REG06 = 8'h00, DATA_REG07 = 8'h00;
    localparam DATA_REG08 = 8'h00, DATA_REG09 = 8'h00, DATA_REG10 = 8'h00, DATA_REG11 = 8'h00;
    localparam DATA_REG12 = 8'h00, DATA_REG13 = 8'h00, DATA_REG14 = 8'hFF, DATA_REG15 = 8'hFF;
    localparam DATA_REG16 = 8'hFF, DATA_REG17 = 8'hFF, DATA_REG18 = 8'hFF, DATA_REG19 = 8'hFF;
    localparam DATA_REG20 = 8'hFF, DATA_REG21 = 8'hFF;

    localparam RH1_DAC1_20K = 6'h08, RH1_DAC1_15K = 6'h0B, RH1_DAC1_10K = 6'h11, RH1_DAC1_7K5 = 6'h16; 
    localparam RH1_DAC1_5K0 = 6'h21, RH1_DAC1_3K0 = 6'h03, RH1_DAC1_2K5 = 6'h0D, RH1_DAC1_2K0 = 6'h1B;
    localparam RH1_DAC1_1K5 = 6'h01, RH1_DAC1_1K0 = 6'h2E, RH1_DAC1_750 = 6'h29, RH1_DAC1_500 = 6'h1E;
    localparam RH1_DAC1_300 = 6'h06, RH1_DAC1_200 = 6'h18, RH1_DAC1_100 = 6'h26;

    localparam RH1_DAC2_20K = 5'h00, RH1_DAC2_15K = 5'h00, RH1_DAC2_10K = 5'h00, RH1_DAC2_7K5 = 5'h00; 
    localparam RH1_DAC2_5K0 = 5'h00, RH1_DAC2_3K0 = 5'h01, RH1_DAC2_2K5 = 5'h01, RH1_DAC2_2K0 = 5'h01;
    localparam RH1_DAC2_1K5 = 5'h02, RH1_DAC2_1K0 = 5'h02, RH1_DAC2_750 = 5'h03, RH1_DAC2_500 = 5'h05;
    localparam RH1_DAC2_300 = 5'h09, RH1_DAC2_200 = 5'h0D, RH1_DAC2_100 = 5'h1A;

    localparam RH2_DAC1_20K = 6'h04, RH2_DAC1_15K = 6'h08, RH2_DAC1_10K = 6'h10, RH2_DAC1_7K5 = 6'h17; 
    localparam RH2_DAC1_5K0 = 6'h25, RH2_DAC1_3K0 = 6'h0D, RH2_DAC1_2K5 = 6'h19, RH2_DAC1_2K0 = 6'h2C;
    localparam RH2_DAC1_1K5 = 6'h17, RH2_DAC1_1K0 = 6'h1E, RH2_DAC1_750 = 6'h24, RH2_DAC1_500 = 6'h2B;
    localparam RH2_DAC1_300 = 6'h02, RH2_DAC1_200 = 6'h07, RH2_DAC1_100 = 6'h05;

    localparam RH2_DAC2_20K = 5'h00, RH2_DAC2_15K = 5'h00, RH2_DAC2_10K = 5'h00, RH2_DAC2_7K5 = 5'h00; 
    localparam RH2_DAC2_5K0 = 5'h00, RH2_DAC2_3K0 = 5'h01, RH2_DAC2_2K5 = 5'h01, RH2_DAC2_2K0 = 5'h01;
    localparam RH2_DAC2_1K5 = 5'h02, RH2_DAC2_1K0 = 5'h03, RH2_DAC2_750 = 5'h04, RH2_DAC2_500 = 5'h06;
    localparam RH2_DAC2_300 = 5'h0B, RH2_DAC2_200 = 5'h10, RH2_DAC2_100 = 5'h1F;

    localparam RL_DAC1_100 = 7'h19, RL_DAC1_020 = 7'h36, RL_DAC1_015 = 7'h3E, RL_DAC1_010 = 7'h05;
    localparam RL_DAC1_7D5 = 7'h12, RL_DAC1_5D0 = 7'h28, RL_DAC1_3D0 = 7'h14, RL_DAC1_2D5 = 7'h2A;
    localparam RL_DAC1_2D0 = 7'h08, RL_DAC1_1D0 = 7'h2C, RL_DAC1_D75 = 7'h31, RL_DAC1_D50 = 7'h23;
    localparam RL_DAC1_D30 = 7'h01, RL_DAC1_D25 = 7'h38, RL_DAC1_D10 = 7'h10;

    localparam RL_DAC2_100 = 7'h00, RL_DAC2_020 = 7'h00, RL_DAC2_015 = 7'h00, RL_DAC2_010 = 7'h01;
    localparam RL_DAC2_7D5 = 7'h01, RL_DAC2_5D0 = 7'h01, RL_DAC2_3D0 = 7'h02, RL_DAC2_2D5 = 7'h02;
    localparam RL_DAC2_2D0 = 7'h03, RL_DAC2_1D0 = 7'h06, RL_DAC2_D75 = 7'h09, RL_DAC2_D50 = 7'h11;
    localparam RL_DAC2_D30 = 7'h28, RL_DAC2_D25 = 7'h36, RL_DAC2_D10 = 7'h7C;

    localparam CH00 = 6'h00, CH01 = 6'h01, CH02 = 6'h02, CH03 = 6'h03;
    localparam CH04 = 6'h04, CH05 = 6'h05, CH06 = 6'h06, CH07 = 6'h07;
    localparam CH08 = 6'h08, CH09 = 6'h09, CH10 = 6'h0A, CH11 = 6'h0B;
    localparam CH12 = 6'h0C, CH13 = 6'h0D, CH14 = 6'h0E, CH15 = 6'h0F;
    localparam CH16 = 6'h10, CH17 = 6'h11, CH18 = 6'h12, CH19 = 6'h13;
    localparam CH20 = 6'h14, CH21 = 6'h15, CH22 = 6'h16, CH23 = 6'h17;
    localparam CH24 = 6'h18, CH25 = 6'h19, CH26 = 6'h1A, CH27 = 6'h1B;
    localparam CH28 = 6'h1C, CH29 = 6'h1D, CH30 = 6'h1E, CH31 = 6'h1F;
    localparam CH49 = 6'h31;

    localparam REG00 = 6'h00, REG01 = 6'h01, REG02 = 6'h02, REG03 = 6'h03;
    localparam REG04 = 6'h04, REG05 = 6'h05, REG06 = 6'h06, REG07 = 6'h07;
    localparam REG08 = 6'h08, REG09 = 6'h09, REG10 = 6'h0A, REG11 = 6'h0B;
    localparam REG12 = 6'h0C, REG13 = 6'h0D, REG14 = 6'h0E, REG15 = 6'h0F;
    localparam REG16 = 6'h10, REG17 = 6'h11, REG18 = 6'h12, REG19 = 6'h13;
    localparam REG20 = 6'h14, REG21 = 6'h15; 
    localparam REG40 = 6'h28, REG41 = 6'h29, REG42 = 6'h2A, REG43 = 6'h2B;
    localparam REG44 = 6'h2C;
    localparam REG59 = 6'h3B; 
    localparam REG60 = 6'h3C, REG61 = 6'h3D, REG62 = 6'h3E, REG63 = 6'h3F;

    (*MARK_DEBUG = "true"*)reg [7:0] state, next_state;
    (*MARK_DEBUG = "true"*)reg [7:0] state_goto, state_back;

    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_FAIL = 8'h02;

    localparam IDLE_WAIT = 8'h04, IDLE_TRAN = 8'h05, IDLE_DONE = 8'h06;
    localparam WRAM_WAIT = 8'h08, WRAM_WORK = 8'h09, WRAM_TRAN = 8'h0A, WRAM_DONE = 8'h0B;
    localparam RREG_WAIT = 8'h0C, RREG_WORK = 8'h0D, RREG_TRAN = 8'h0E, RREG_DONE = 8'h0F;
    localparam RREG_FAIL = 8'h10;
    localparam TREG_WAIT = 8'h14, TREG_WORK = 8'h15, TREG_TRAN = 8'h16, TREG_DONE = 8'h17;
    localparam REST_WAIT = 8'h18, REST_WORK = 8'h19, REST_DONE = 8'h1A;
    localparam RTMP_WAIT = 8'h1C, RTMP_WORK = 8'h1D, RTMP_TRAN = 8'h1E, RTMP_DONE = 8'h1F;

    localparam INIT_IDLE = 8'h20, INIT_DONE = 8'h21, INIT_RXD0 = 8'h22, INIT_RXD1 = 8'h23;

    localparam TYPE_IDLE = 8'h24, TYPE_DONE = 8'h25, TYPE_RXD0 = 8'h26, TYPE_RXD1 = 8'h27;
    localparam TYPE_RXD2 = 8'h28, TYPE_RXD3 = 8'h29;

    localparam CONF_IDLE = 8'h2C, CONF_DONE = 8'h2D, CONF_RXD0 = 8'h2E, CONF_RXD1 = 8'h2F;

    localparam TEMP_IDLE = 8'h30, TEMP_DONE = 8'h31, TEMP_RXD0 = 8'h32, TEMP_RXD1 = 8'h33;
    localparam TEMP_RXD2 = 8'h34, TEMP_RXD3 = 8'h35;

    localparam CALI_IDLE = 8'h38, CALI_DONE = 8'h39;

    localparam CONV_IDLE = 8'h3C, CONV_DONE = 8'h3D, CONV_RXD0 = 8'h3E, CONV_RXD1 = 8'h3F;

    localparam INIT_REG40 = 8'h40, INIT_REG41 = 8'h41, INIT_REG42 = 8'h42, INIT_REG43 = 8'h43;
    localparam INIT_REG44 = 8'h44; 

    localparam TYPE_REG59 = 8'h50, TYPE_REG60 = 8'h51, TYPE_REG61 = 8'h52, TYPE_REG62 = 8'h53;
    localparam TYPE_REG63 = 8'h54;

    localparam CONF_REG00 = 8'h80, CONF_REG01 = 8'h81, CONF_REG02 = 8'h82, CONF_REG03 = 8'h83;
    localparam CONF_REG04 = 8'h84, CONF_REG05 = 8'h85, CONF_REG06 = 8'h86, CONF_REG07 = 8'h87;
    localparam CONF_REG08 = 8'h88, CONF_REG09 = 8'h89, CONF_REG10 = 8'h8A, CONF_REG11 = 8'h8B;
    localparam CONF_REG12 = 8'h8C, CONF_REG13 = 8'h8D, CONF_REG14 = 8'h8E, CONF_REG15 = 8'h8F;
    localparam CONF_REG16 = 8'h90, CONF_REG17 = 8'h91, CONF_REG18 = 8'h92, CONF_REG19 = 8'h93;
    localparam CONF_REG20 = 8'h94, CONF_REG21 = 8'h95; 

    localparam TEMP_WREG0 = 8'hA0, TEMP_REST0 = 8'hA1, TEMP_WREG1 = 8'hA2, TEMP_REST1 = 8'hA3;
    localparam TEMP_WREG2 = 8'hA4, TEMP_REST2 = 8'hA5, TEMP_WREG3 = 8'hA6, TEMP_REST3 = 8'hA7;
    localparam TEMP_RRESA = 8'hA8, TEMP_RRESB = 8'hA9, TEMP_RESET = 8'hAA;

    localparam CALI_WORK = 8'hB0, CALI_RXD0 = 8'hB1, CALI_RXD1 = 8'hB2, CALI_RXD2 = 8'hB3;
    localparam CALI_RXD3 = 8'hB4, CALI_RXD4 = 8'hB5, CALI_RXD5 = 8'hB6, CALI_RXD6 = 8'hB7;
    localparam CALI_RXD7 = 8'hB8, CALI_RXD8 = 8'hB9, CALI_RXD9 = 8'hBA; 

    localparam CONV_CH00 = 8'hC0, CONV_CH01 = 8'hC1, CONV_CH02 = 8'hC2, CONV_CH03 = 8'hC3;
    localparam CONV_CH04 = 8'hC4, CONV_CH05 = 8'hC5, CONV_CH06 = 8'hC6, CONV_CH07 = 8'hC7;
    localparam CONV_CH08 = 8'hC8, CONV_CH09 = 8'hC9, CONV_CH10 = 8'hCA, CONV_CH11 = 8'hCB;
    localparam CONV_CH12 = 8'hCC, CONV_CH13 = 8'hCD, CONV_CH14 = 8'hCE, CONV_CH15 = 8'hCF;
    localparam CONV_CH16 = 8'hD0, CONV_CH17 = 8'hD1, CONV_CH18 = 8'hD2, CONV_CH19 = 8'hD3;
    localparam CONV_CH20 = 8'hD4, CONV_CH21 = 8'hD5, CONV_CH22 = 8'hD6, CONV_CH23 = 8'hD7;
    localparam CONV_CH24 = 8'hD8, CONV_CH25 = 8'hD9, CONV_CH26 = 8'hDA, CONV_CH27 = 8'hDB;
    localparam CONV_CH28 = 8'hDC, CONV_CH29 = 8'hDD, CONV_CH30 = 8'hDE, CONV_CH31 = 8'hDF;

    (*MARK_DEBUG = "true"*)reg [15:0] chip_txd;
    (*MARK_DEBUG = "true"*)wire [15:0] chip_rxda, chip_rxdb;

    reg [7:0] data_reg01, data_reg02;

    reg [15:0] chip_rxda_res, chip_rxda_res_d0, chip_rxda_res_d1;
    reg [15:0] chip_rxdb_res, chip_rxdb_res_d0, chip_rxdb_res_d1;

    reg [15:0] num, num_wait;

    reg [15:0] temp_measure;

    reg [7:0] data_reg08, data_reg09, data_reg10, data_reg11;
    reg [7:0] data_reg12, data_reg13;

    wire fs_spi, fd_spi, fd_prd;
    wire fs_fifo, fd_fifo;
    wire [15:0] fifo_txd;
    wire [1:0] fifo_txen, fifo_full;

    assign fs_spi = (state >= IDLE_WAIT) && (state <= RTMP_DONE);
    assign fs_fifo = (state == WRAM_WORK);
    assign fd_init = (state == INIT_DONE);
    assign fd_type = (state == TYPE_DONE);
    assign fd_conf = (state == CALI_DONE);
    assign fd_conv = (state == CONV_DONE);

    always@(posedge clk or posedge rst) begin // state
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end

    always@(*) begin // next_state
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_init) next_state <= INIT_IDLE;
                else if(fs_type) next_state <= TYPE_IDLE;
                else if(fs_conf) next_state <= CONF_IDLE;
                else if(fs_conv) next_state <= CONV_IDLE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_FAIL: next_state <= MAIN_FAIL;

            IDLE_WAIT: begin
                if(fd_spi) next_state <= IDLE_TRAN;
                else next_state <= IDLE_WAIT;
            end
            IDLE_TRAN: next_state <= IDLE_DONE;
            IDLE_DONE: begin
                if(fd_prd) next_state <= state_goto;
                else next_state <= IDLE_DONE;
            end

            WRAM_WAIT: begin
                if(fd_spi) next_state <= WRAM_WORK;
                else next_state <= WRAM_WAIT;
            end
            WRAM_WORK: begin
                if(fd_fifo) next_state <= WRAM_TRAN;
                else next_state <= WRAM_WORK;
            end
            WRAM_TRAN: next_state <= WRAM_DONE;
            WRAM_DONE: begin
                if(fd_prd) next_state <= state_goto;
                else next_state <= WRAM_DONE;
            end

            RREG_WAIT: begin
                if(fd_spi) next_state <= RREG_WORK;
                else next_state <= RREG_WAIT;
            end
            RREG_WORK: begin
                if((chip_rxda == chip_rxda_res_d1) && (chip_rxdb == chip_rxdb_res_d1)) next_state <= RREG_TRAN; 
                else next_state <= RREG_FAIL;
            end
            RREG_TRAN: next_state <= RREG_DONE;
            RREG_DONE: begin
                if(fd_prd) next_state <= state_goto;
                else next_state <= RREG_DONE;
            end
            RREG_FAIL: begin
                if(fd_prd) next_state <= state_back;
                else next_state <= RREG_FAIL;
            end

            TREG_WAIT: begin
                if(fd_spi) next_state <= TREG_WORK;
                else next_state <= TREG_WAIT;
            end
            TREG_WORK: next_state <= TREG_TRAN;
            TREG_TRAN: next_state <= TREG_DONE;
            TREG_DONE: begin
                if(fd_prd) next_state <= state_goto;
                else next_state <= TREG_DONE;
            end

            REST_WAIT: next_state <= REST_WORK;
            REST_WORK: begin
                if(num >= num_wait) next_state <= REST_DONE;
                else next_state <= REST_WORK;
            end
            REST_DONE: next_state <= state_goto;

            RTMP_WAIT: begin
                if(fd_spi) next_state <= RTMP_WORK;
                else next_state <= RTMP_WAIT;
            end
            RTMP_WORK: next_state <= RTMP_TRAN;
            RTMP_TRAN: next_state <= RTMP_DONE;
            RTMP_DONE: begin
                if(fd_prd) next_state <= state_goto;
                else next_state <= RTMP_DONE;
            end

            INIT_IDLE: next_state <= INIT_REG40;
            INIT_REG40: next_state <= IDLE_WAIT;
            INIT_REG41: next_state <= IDLE_WAIT;
            INIT_REG42: next_state <= RREG_WAIT;
            INIT_REG43: next_state <= RREG_WAIT;
            INIT_REG44: next_state <= RREG_WAIT;
            INIT_RXD0: next_state <= RREG_WAIT;
            INIT_RXD1: next_state <= RREG_WAIT;
            INIT_DONE: begin
                if(~fs_init) next_state <= MAIN_WAIT;
                else next_state <= INIT_DONE;
            end

            TYPE_IDLE: next_state <= TYPE_REG63;
            TYPE_REG63: next_state <= IDLE_WAIT;
            TYPE_RXD0: next_state <= IDLE_WAIT;
            TYPE_RXD1: next_state <= TREG_WAIT;
            TYPE_REG59: next_state <= IDLE_WAIT;
            TYPE_RXD2: next_state <= IDLE_WAIT;
            TYPE_RXD3: next_state <= RREG_WAIT;
            TYPE_DONE: begin
                if(~fs_type) next_state <= MAIN_WAIT;
                else next_state <= TYPE_DONE;
            end

            CONF_IDLE: next_state <= CONF_REG00;
            CONF_REG00: next_state <= IDLE_WAIT;
            CONF_REG01: next_state <= IDLE_WAIT;
            CONF_REG02: next_state <= RREG_WAIT;
            CONF_REG03: next_state <= RREG_WAIT;
            CONF_REG04: next_state <= RREG_WAIT;
            CONF_REG05: next_state <= RREG_WAIT;
            CONF_REG06: next_state <= RREG_WAIT;
            CONF_REG07: next_state <= RREG_WAIT;
            CONF_REG08: next_state <= RREG_WAIT;
            CONF_REG09: next_state <= RREG_WAIT;
            CONF_REG10: next_state <= RREG_WAIT;
            CONF_REG11: next_state <= RREG_WAIT;
            CONF_REG12: next_state <= RREG_WAIT;
            CONF_REG13: next_state <= RREG_WAIT;
            CONF_REG14: next_state <= RREG_WAIT;
            CONF_REG15: next_state <= RREG_WAIT;
            CONF_REG16: next_state <= RREG_WAIT;
            CONF_REG17: next_state <= RREG_WAIT;
            CONF_REG18: next_state <= RREG_WAIT;
            CONF_REG19: next_state <= RREG_WAIT;
            CONF_REG20: next_state <= RREG_WAIT;
            CONF_REG21: next_state <= RREG_WAIT;
            CONF_RXD0: next_state <= RREG_WAIT;
            CONF_RXD1: next_state <= RREG_WAIT;
            CONF_DONE: next_state <= TEMP_IDLE;

            TEMP_IDLE: next_state <= TEMP_WREG0;
            TEMP_WREG0: next_state <= IDLE_WAIT;
            TEMP_REST0: next_state <= REST_WAIT;
            TEMP_WREG1: next_state <= IDLE_WAIT;
            TEMP_REST1: next_state <= REST_WAIT;
            TEMP_WREG2: next_state <= IDLE_WAIT;
            TEMP_REST2: next_state <= REST_WAIT;
            TEMP_RRESA: next_state <= IDLE_WAIT;
            TEMP_RXD0: next_state <= IDLE_WAIT;
            TEMP_RXD1: next_state <= RTMP_WAIT;
            TEMP_WREG3: next_state <= IDLE_WAIT;
            TEMP_REST3: next_state <= REST_WAIT;
            TEMP_RRESB: next_state <= IDLE_WAIT;
            TEMP_RESET: next_state <= IDLE_WAIT;
            TEMP_RXD2: next_state <= RTMP_WAIT;
            TEMP_RXD3: next_state <= RREG_WAIT;
            TEMP_DONE: next_state <= CALI_IDLE;

            CALI_IDLE: next_state <= CALI_WORK;
            CALI_WORK: next_state <= IDLE_WAIT;
            CALI_RXD0: next_state <= IDLE_WAIT;
            CALI_RXD1: next_state <= IDLE_WAIT;
            CALI_RXD2: next_state <= IDLE_WAIT;
            CALI_RXD3: next_state <= IDLE_WAIT;
            CALI_RXD4: next_state <= IDLE_WAIT;
            CALI_RXD5: next_state <= IDLE_WAIT;
            CALI_RXD6: next_state <= IDLE_WAIT;
            CALI_RXD7: next_state <= IDLE_WAIT;
            CALI_RXD8: next_state <= IDLE_WAIT;
            CALI_RXD9: next_state <= IDLE_WAIT;
            CALI_DONE: begin
                if(~fs_conf) next_state <= MAIN_WAIT;
                else next_state <= CALI_DONE;
            end
        
            CONV_IDLE: next_state <= CONV_CH00;
            CONV_CH00: next_state <= IDLE_WAIT;
            CONV_CH01: next_state <= IDLE_WAIT;
            CONV_CH02: next_state <= WRAM_WAIT;
            CONV_CH03: next_state <= WRAM_WAIT;
            CONV_CH04: next_state <= WRAM_WAIT;
            CONV_CH05: next_state <= WRAM_WAIT;
            CONV_CH06: next_state <= WRAM_WAIT;
            CONV_CH07: next_state <= WRAM_WAIT;
            CONV_CH08: next_state <= WRAM_WAIT;
            CONV_CH09: next_state <= WRAM_WAIT;
            CONV_CH10: next_state <= WRAM_WAIT;
            CONV_CH11: next_state <= WRAM_WAIT;
            CONV_CH12: next_state <= WRAM_WAIT;
            CONV_CH13: next_state <= WRAM_WAIT;
            CONV_CH14: next_state <= WRAM_WAIT;
            CONV_CH15: next_state <= WRAM_WAIT;
            CONV_CH16: next_state <= WRAM_WAIT;
            CONV_CH17: next_state <= WRAM_WAIT;
            CONV_CH18: next_state <= WRAM_WAIT;
            CONV_CH19: next_state <= WRAM_WAIT;
            CONV_CH20: next_state <= WRAM_WAIT;
            CONV_CH21: next_state <= WRAM_WAIT;
            CONV_CH22: next_state <= WRAM_WAIT;
            CONV_CH23: next_state <= WRAM_WAIT;
            CONV_CH24: next_state <= WRAM_WAIT;
            CONV_CH25: next_state <= WRAM_WAIT;
            CONV_CH26: next_state <= WRAM_WAIT;
            CONV_CH27: next_state <= WRAM_WAIT;
            CONV_CH28: next_state <= WRAM_WAIT;
            CONV_CH29: next_state <= WRAM_WAIT;
            CONV_CH30: next_state <= WRAM_WAIT;
            CONV_CH31: next_state <= WRAM_WAIT;
            CONV_RXD0: next_state <= WRAM_WAIT;
            CONV_RXD1: next_state <= WRAM_WAIT;
            CONV_DONE: begin
                if(~fs_conv) next_state <= MAIN_WAIT;
                else next_state <= CONV_DONE;
            end
            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin // state_goto
        if(rst) state_goto <= MAIN_IDLE;
        else if(state == MAIN_IDLE) state_goto <= MAIN_IDLE;
        else if(state == MAIN_WAIT) state_goto <= MAIN_IDLE;
        else if(state == INIT_RXD0) state_goto <= INIT_RXD1;
        else if(state == INIT_RXD1) state_goto <= INIT_DONE;
        else if(state == TYPE_RXD0) state_goto <= TYPE_RXD1;
        else if(state == TYPE_RXD1) state_goto <= TYPE_REG59;
        else if(state == TYPE_RXD2) state_goto <= TYPE_RXD3;
        else if(state == TYPE_RXD3) state_goto <= TYPE_DONE;
        else if(state == CONF_RXD0) state_goto <= CONF_RXD1;
        else if(state == CONF_RXD1) state_goto <= CONF_DONE;
        else if(state == TEMP_RXD0) state_goto <= TEMP_RXD1;
        else if(state == TEMP_RXD1) state_goto <= TEMP_WREG3;
        else if(state == TEMP_RXD2) state_goto <= TEMP_RXD3;
        else if(state == TEMP_RXD3) state_goto <= TEMP_DONE;
        else if(state == CALI_RXD0) state_goto <= CALI_RXD1;
        else if(state == CALI_RXD1) state_goto <= CALI_RXD2;
        else if(state == CALI_RXD2) state_goto <= CALI_RXD3;
        else if(state == CALI_RXD3) state_goto <= CALI_RXD4;
        else if(state == CALI_RXD4) state_goto <= CALI_RXD5;
        else if(state == CALI_RXD5) state_goto <= CALI_RXD6;
        else if(state == CALI_RXD6) state_goto <= CALI_RXD7;
        else if(state == CALI_RXD7) state_goto <= CALI_RXD8;
        else if(state == CALI_RXD8) state_goto <= CALI_RXD9;
        else if(state == CALI_RXD9) state_goto <= CALI_DONE;
        else if(state == CONV_RXD0) state_goto <= CONV_RXD1;
        else if(state == CONV_RXD1) state_goto <= CONV_DONE;

        else if(state == INIT_REG40) state_goto <= INIT_REG41;
        else if(state == INIT_REG41) state_goto <= INIT_REG42;
        else if(state == INIT_REG42) state_goto <= INIT_REG43;
        else if(state == INIT_REG43) state_goto <= INIT_REG44;
        else if(state == INIT_REG44) state_goto <= INIT_RXD0;

        else if(state == TYPE_REG63) state_goto <= TYPE_RXD0;
        else if(state == TYPE_REG59) state_goto <= TYPE_RXD2;

        else if(state == CONF_REG00) state_goto <= CONF_REG01;
        else if(state == CONF_REG01) state_goto <= CONF_REG02;
        else if(state == CONF_REG02) state_goto <= CONF_REG03;
        else if(state == CONF_REG03) state_goto <= CONF_REG04;
        else if(state == CONF_REG04) state_goto <= CONF_REG05;
        else if(state == CONF_REG05) state_goto <= CONF_REG06;
        else if(state == CONF_REG06) state_goto <= CONF_REG07;
        else if(state == CONF_REG07) state_goto <= CONF_REG08;
        else if(state == CONF_REG08) state_goto <= CONF_REG09;
        else if(state == CONF_REG09) state_goto <= CONF_REG10;
        else if(state == CONF_REG10) state_goto <= CONF_REG11;
        else if(state == CONF_REG11) state_goto <= CONF_REG12;
        else if(state == CONF_REG12) state_goto <= CONF_REG13;
        else if(state == CONF_REG13) state_goto <= CONF_REG14;
        else if(state == CONF_REG14) state_goto <= CONF_REG15;
        else if(state == CONF_REG15) state_goto <= CONF_REG16;
        else if(state == CONF_REG16) state_goto <= CONF_REG17;
        else if(state == CONF_REG17) state_goto <= CONF_REG18;
        else if(state == CONF_REG18) state_goto <= CONF_REG19;
        else if(state == CONF_REG19) state_goto <= CONF_REG20;
        else if(state == CONF_REG20) state_goto <= CONF_REG21;
        else if(state == CONF_REG21) state_goto <= CONF_RXD0;

        else if(state == TEMP_WREG0) state_goto <= TEMP_REST0;
        else if(state == TEMP_REST0) state_goto <= TEMP_WREG1;
        else if(state == TEMP_WREG1) state_goto <= TEMP_REST1;
        else if(state == TEMP_REST1) state_goto <= TEMP_WREG2;
        else if(state == TEMP_WREG2) state_goto <= TEMP_REST2;
        else if(state == TEMP_REST2) state_goto <= TEMP_RRESA;
        else if(state == TEMP_RRESA) state_goto <= TEMP_RXD0;
        else if(state == TEMP_WREG3) state_goto <= TEMP_REST3;
        else if(state == TEMP_REST3) state_goto <= TEMP_RRESB;
        else if(state == TEMP_RRESB) state_goto <= TEMP_RESET;
        else if(state == TEMP_RESET) state_goto <= TEMP_RXD2;

        else if(state == CONV_CH00) state_goto <= CONV_CH01;
        else if(state == CONV_CH01) state_goto <= CONV_CH02;
        else if(state == CONV_CH02) state_goto <= CONV_CH03;
        else if(state == CONV_CH03) state_goto <= CONV_CH04;
        else if(state == CONV_CH04) state_goto <= CONV_CH05;
        else if(state == CONV_CH05) state_goto <= CONV_CH06;
        else if(state == CONV_CH06) state_goto <= CONV_CH07;
        else if(state == CONV_CH07) state_goto <= CONV_CH08;
        else if(state == CONV_CH08) state_goto <= CONV_CH09;
        else if(state == CONV_CH09) state_goto <= CONV_CH10;
        else if(state == CONV_CH10) state_goto <= CONV_CH11;
        else if(state == CONV_CH11) state_goto <= CONV_CH12;
        else if(state == CONV_CH12) state_goto <= CONV_CH13;
        else if(state == CONV_CH13) state_goto <= CONV_CH14;
        else if(state == CONV_CH14) state_goto <= CONV_CH15;
        else if(state == CONV_CH15) state_goto <= CONV_CH16;
        else if(state == CONV_CH16) state_goto <= CONV_CH17;
        else if(state == CONV_CH17) state_goto <= CONV_CH18;
        else if(state == CONV_CH18) state_goto <= CONV_CH19;
        else if(state == CONV_CH19) state_goto <= CONV_CH20;
        else if(state == CONV_CH20) state_goto <= CONV_CH21;
        else if(state == CONV_CH21) state_goto <= CONV_CH22;
        else if(state == CONV_CH22) state_goto <= CONV_CH23;
        else if(state == CONV_CH23) state_goto <= CONV_CH24;
        else if(state == CONV_CH24) state_goto <= CONV_CH25;
        else if(state == CONV_CH25) state_goto <= CONV_CH26;
        else if(state == CONV_CH26) state_goto <= CONV_CH27;
        else if(state == CONV_CH27) state_goto <= CONV_CH28;
        else if(state == CONV_CH28) state_goto <= CONV_CH29;
        else if(state == CONV_CH29) state_goto <= CONV_CH30;
        else if(state == CONV_CH30) state_goto <= CONV_CH31;
        else if(state == CONV_CH31) state_goto <= CONV_RXD0;
        else state_goto <= state_goto;
    end

    always@(posedge clk or posedge rst) begin // state_back
        if(rst) state_back <= MAIN_IDLE;
        else if(state == MAIN_IDLE) state_back <= MAIN_IDLE;
        else if(state == MAIN_WAIT) state_back <= MAIN_IDLE;
        else state_back <= MAIN_FAIL;
    end

    always@(posedge clk or posedge rst) begin // chip_txd
        if(rst) chip_txd <= CHIP_INIT;
        else if(state == MAIN_IDLE) chip_txd <= CHIP_INIT;
        else if(state == MAIN_WAIT) chip_txd <= CHIP_INIT;
        else if(state == INIT_RXD0) chip_txd <= CHIP_GAP;
        else if(state == INIT_RXD1) chip_txd <= CHIP_GAP;
        else if(state == TYPE_RXD0) chip_txd <= CHIP_GAP;
        else if(state == TYPE_RXD1) chip_txd <= CHIP_GAP;
        else if(state == TYPE_RXD2) chip_txd <= CHIP_GAP;
        else if(state == TYPE_RXD3) chip_txd <= CHIP_GAP;
        else if(state == CONF_RXD0) chip_txd <= CHIP_GAP;
        else if(state == CONF_RXD1) chip_txd <= CHIP_GAP;
        else if(state == TEMP_RXD0) chip_txd <= CHIP_GAP;
        else if(state == TEMP_RXD1) chip_txd <= CHIP_GAP;
        else if(state == TEMP_RXD2) chip_txd <= CHIP_GAP;
        else if(state == TEMP_RXD3) chip_txd <= CHIP_GAP;
        else if(state == CALI_RXD0) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD1) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD2) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD3) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD4) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD5) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD6) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD7) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD8) chip_txd <= CHIP_INIT;
        else if(state == CALI_RXD9) chip_txd <= CHIP_INIT;
        else if(state == CONV_RXD0) chip_txd <= CHIP_INIT;
        else if(state == CONV_RXD1) chip_txd <= CHIP_INIT;

        else if(state == INIT_REG40) chip_txd <= {HEAD_RX, REG40, 8'h00};
        else if(state == INIT_REG41) chip_txd <= {HEAD_RX, REG41, 8'h00};
        else if(state == INIT_REG42) chip_txd <= {HEAD_RX, REG42, 8'h00};
        else if(state == INIT_REG43) chip_txd <= {HEAD_RX, REG43, 8'h00};
        else if(state == INIT_REG44) chip_txd <= {HEAD_RX, REG44, 8'h00};
       
        else if(state == TYPE_REG59) chip_txd <= {HEAD_RX, REG59, 8'h00};
        else if(state == TYPE_REG60) chip_txd <= {HEAD_RX, REG60, 8'h00};
        else if(state == TYPE_REG61) chip_txd <= {HEAD_RX, REG61, 8'h00};
        else if(state == TYPE_REG62) chip_txd <= {HEAD_RX, REG62, 8'h00};
        else if(state == TYPE_REG63) chip_txd <= {HEAD_RX, REG63, 8'h00};

        else if(state == CONF_REG00) chip_txd <= {HEAD_TX, REG00, DATA_REG00_NORMAL};
        else if(state == CONF_REG01) chip_txd <= {HEAD_TX, REG01, data_reg01};
        else if(state == CONF_REG02) chip_txd <= {HEAD_TX, REG02, data_reg02};
        else if(state == CONF_REG03) chip_txd <= {HEAD_TX, REG03, DATA_REG03_NORMAL};
        else if(state == CONF_REG04) chip_txd <= {HEAD_TX, REG04, DATA_REG04};
        else if(state == CONF_REG05) chip_txd <= {HEAD_TX, REG05, DATA_REG05};
        else if(state == CONF_REG06) chip_txd <= {HEAD_TX, REG06, DATA_REG06};
        else if(state == CONF_REG07) chip_txd <= {HEAD_TX, REG07, DATA_REG07};
        else if(state == CONF_REG08) chip_txd <= {HEAD_TX, REG08, data_reg08};
        else if(state == CONF_REG09) chip_txd <= {HEAD_TX, REG09, data_reg09};
        else if(state == CONF_REG10) chip_txd <= {HEAD_TX, REG10, data_reg10};
        else if(state == CONF_REG11) chip_txd <= {HEAD_TX, REG11, data_reg11};
        else if(state == CONF_REG12) chip_txd <= {HEAD_TX, REG12, data_reg12};
        else if(state == CONF_REG13) chip_txd <= {HEAD_TX, REG13, data_reg13};
        else if(state == CONF_REG14) chip_txd <= {HEAD_TX, REG14, DATA_REG14};
        else if(state == CONF_REG15) chip_txd <= {HEAD_TX, REG15, DATA_REG15};
        else if(state == CONF_REG16) chip_txd <= {HEAD_TX, REG16, DATA_REG16};
        else if(state == CONF_REG17) chip_txd <= {HEAD_TX, REG17, DATA_REG17};
        else if(state == CONF_REG18) chip_txd <= {HEAD_TX, REG18, DATA_REG18};
        else if(state == CONF_REG19) chip_txd <= {HEAD_TX, REG19, DATA_REG19};
        else if(state == CONF_REG20) chip_txd <= {HEAD_TX, REG20, DATA_REG20};
        else if(state == CONF_REG21) chip_txd <= {HEAD_TX, REG21, DATA_REG21};

        else if(state == TEMP_WREG0) chip_txd <= {HEAD_TX, REG03, DATA_REG03_TEMP_EN};
        else if(state == TEMP_WREG1) chip_txd <= {HEAD_TX, REG03, DATA_REG03_TEMP_00};
        else if(state == TEMP_WREG2) chip_txd <= {HEAD_TX, REG03, DATA_REG03_TEMP_01};
        else if(state == TEMP_WREG3) chip_txd <= {HEAD_TX, REG03, DATA_REG03_TEMP_10};
        else if(state == TEMP_RRESA) chip_txd <= {HEAD_CONV, CH49, TAIL_CONV};
        else if(state == TEMP_RRESB) chip_txd <= {HEAD_CONV, CH49, TAIL_CONV};
        else if(state == TEMP_RESET) chip_txd <= {HEAD_TX, REG03, DATA_REG03_NORMAL};

        else if(state == CALI_WORK) chip_txd <= CHIP_CALIBRATE;

        else if(state == CONV_CH00) chip_txd <= {HEAD_CONV, CH00, TAIL_CONV};
        else if(state == CONV_CH01) chip_txd <= {HEAD_CONV, CH01, TAIL_CONV};
        else if(state == CONV_CH02) chip_txd <= {HEAD_CONV, CH02, TAIL_CONV};
        else if(state == CONV_CH03) chip_txd <= {HEAD_CONV, CH03, TAIL_CONV};
        else if(state == CONV_CH04) chip_txd <= {HEAD_CONV, CH04, TAIL_CONV};
        else if(state == CONV_CH05) chip_txd <= {HEAD_CONV, CH05, TAIL_CONV};
        else if(state == CONV_CH06) chip_txd <= {HEAD_CONV, CH06, TAIL_CONV};
        else if(state == CONV_CH07) chip_txd <= {HEAD_CONV, CH07, TAIL_CONV};
        else if(state == CONV_CH08) chip_txd <= {HEAD_CONV, CH08, TAIL_CONV};
        else if(state == CONV_CH09) chip_txd <= {HEAD_CONV, CH09, TAIL_CONV};
        else if(state == CONV_CH10) chip_txd <= {HEAD_CONV, CH10, TAIL_CONV};
        else if(state == CONV_CH11) chip_txd <= {HEAD_CONV, CH11, TAIL_CONV};
        else if(state == CONV_CH12) chip_txd <= {HEAD_CONV, CH12, TAIL_CONV};
        else if(state == CONV_CH13) chip_txd <= {HEAD_CONV, CH13, TAIL_CONV};
        else if(state == CONV_CH14) chip_txd <= {HEAD_CONV, CH14, TAIL_CONV};
        else if(state == CONV_CH15) chip_txd <= {HEAD_CONV, CH15, TAIL_CONV};
        else if(state == CONV_CH16) chip_txd <= {HEAD_CONV, CH16, TAIL_CONV};
        else if(state == CONV_CH17) chip_txd <= {HEAD_CONV, CH17, TAIL_CONV};
        else if(state == CONV_CH18) chip_txd <= {HEAD_CONV, CH18, TAIL_CONV};
        else if(state == CONV_CH19) chip_txd <= {HEAD_CONV, CH19, TAIL_CONV};
        else if(state == CONV_CH20) chip_txd <= {HEAD_CONV, CH20, TAIL_CONV};
        else if(state == CONV_CH21) chip_txd <= {HEAD_CONV, CH21, TAIL_CONV};
        else if(state == CONV_CH22) chip_txd <= {HEAD_CONV, CH22, TAIL_CONV};
        else if(state == CONV_CH23) chip_txd <= {HEAD_CONV, CH23, TAIL_CONV};
        else if(state == CONV_CH24) chip_txd <= {HEAD_CONV, CH24, TAIL_CONV};
        else if(state == CONV_CH25) chip_txd <= {HEAD_CONV, CH25, TAIL_CONV};
        else if(state == CONV_CH26) chip_txd <= {HEAD_CONV, CH26, TAIL_CONV};
        else if(state == CONV_CH22) chip_txd <= {HEAD_CONV, CH27, TAIL_CONV};
        else if(state == CONV_CH28) chip_txd <= {HEAD_CONV, CH28, TAIL_CONV};
        else if(state == CONV_CH29) chip_txd <= {HEAD_CONV, CH29, TAIL_CONV};
        else if(state == CONV_CH30) chip_txd <= {HEAD_CONV, CH30, TAIL_CONV};
        else if(state == CONV_CH31) chip_txd <= {HEAD_CONV, CH31, TAIL_CONV};
        else chip_txd <= chip_txd;
    end

    always@(posedge clk or posedge rst) begin // chip_rxda_res
        if(rst) chip_rxda_res <= CHIP_RXD_INIT;
        else if(state == MAIN_IDLE) chip_rxda_res <= CHIP_RXD_INIT;
        else if(state == MAIN_WAIT) chip_rxda_res <= CHIP_RXD_INIT;
        else if(state == INIT_REG40) chip_rxda_res <= {RHEAD_RX, DATA_REG40};
        else if(state == INIT_REG41) chip_rxda_res <= {RHEAD_RX, DATA_REG41};
        else if(state == INIT_REG42) chip_rxda_res <= {RHEAD_RX, DATA_REG42};
        else if(state == INIT_REG43) chip_rxda_res <= {RHEAD_RX, DATA_REG43};
        else if(state == INIT_REG44) chip_rxda_res <= {RHEAD_RX, DATA_REG44};
        else if(state == TYPE_REG59) chip_rxda_res <= {RHEAD_RX, DATA_REG59_A};
        else if(state == CONF_REG00) chip_rxda_res <= {RHEAD_RX, DATA_REG00_NORMAL};
        else if(state == CONF_REG01) chip_rxda_res <= {RHEAD_RX, data_reg01};
        else if(state == CONF_REG02) chip_rxda_res <= {RHEAD_RX, data_reg02};
        else if(state == CONF_REG03) chip_rxda_res <= {RHEAD_RX, DATA_REG03_NORMAL};
        else if(state == CONF_REG04) chip_rxda_res <= {RHEAD_RX, DATA_REG04};
        else if(state == CONF_REG05) chip_rxda_res <= {RHEAD_RX, DATA_REG05};
        else if(state == CONF_REG06) chip_rxda_res <= {RHEAD_RX, DATA_REG06};
        else if(state == CONF_REG07) chip_rxda_res <= {RHEAD_RX, DATA_REG07};
        else if(state == CONF_REG08) chip_rxda_res <= {RHEAD_RX, DATA_REG08};
        else if(state == CONF_REG09) chip_rxda_res <= {RHEAD_RX, DATA_REG09};
        else if(state == CONF_REG10) chip_rxda_res <= {RHEAD_RX, DATA_REG10};
        else if(state == CONF_REG11) chip_rxda_res <= {RHEAD_RX, DATA_REG11};
        else if(state == CONF_REG12) chip_rxda_res <= {RHEAD_RX, DATA_REG12};
        else if(state == CONF_REG13) chip_rxda_res <= {RHEAD_RX, DATA_REG13};
        else if(state == CONF_REG14) chip_rxda_res <= {RHEAD_RX, DATA_REG14};
        else if(state == CONF_REG15) chip_rxda_res <= {RHEAD_RX, DATA_REG15};
        else if(state == CONF_REG16) chip_rxda_res <= {RHEAD_RX, DATA_REG16};
        else if(state == CONF_REG17) chip_rxda_res <= {RHEAD_RX, DATA_REG17};
        else if(state == CONF_REG18) chip_rxda_res <= {RHEAD_RX, DATA_REG18};
        else if(state == CONF_REG19) chip_rxda_res <= {RHEAD_RX, DATA_REG19};
        else if(state == CONF_REG20) chip_rxda_res <= {RHEAD_RX, DATA_REG20};
        else if(state == CONF_REG21) chip_rxda_res <= {RHEAD_RX, DATA_REG21};
        else if(state == TEMP_RESET) chip_rxda_res <= {RHEAD_RX, DATA_REG03_NORMAL};
        else chip_rxda_res <= chip_rxda_res;
    end

    always@(posedge clk or posedge rst) begin // chip_rxdb_res
        if(rst) chip_rxdb_res <= CHIP_RXD_INIT;
        else if(state == MAIN_IDLE) chip_rxdb_res <= CHIP_RXD_INIT;
        else if(state == MAIN_WAIT) chip_rxdb_res <= CHIP_RXD_INIT;
        else if(state == INIT_REG40) chip_rxdb_res <= {RHEAD_RX, DATA_REG40};
        else if(state == INIT_REG41) chip_rxdb_res <= {RHEAD_RX, DATA_REG41};
        else if(state == INIT_REG42) chip_rxdb_res <= {RHEAD_RX, DATA_REG42};
        else if(state == INIT_REG43) chip_rxdb_res <= {RHEAD_RX, DATA_REG43};
        else if(state == INIT_REG44) chip_rxdb_res <= {RHEAD_RX, DATA_REG44};
        else if(state == TYPE_REG59) chip_rxdb_res <= {RHEAD_RX, DATA_REG59_B};
        else if(state == CONF_REG00) chip_rxdb_res <= {RHEAD_RX, DATA_REG00_NORMAL};
        else if(state == CONF_REG01) chip_rxdb_res <= {RHEAD_RX, data_reg01};
        else if(state == CONF_REG02) chip_rxdb_res <= {RHEAD_RX, data_reg02};
        else if(state == CONF_REG03) chip_rxdb_res <= {RHEAD_RX, DATA_REG03_NORMAL};
        else if(state == CONF_REG04) chip_rxdb_res <= {RHEAD_RX, DATA_REG04};
        else if(state == CONF_REG05) chip_rxdb_res <= {RHEAD_RX, DATA_REG05};
        else if(state == CONF_REG06) chip_rxdb_res <= {RHEAD_RX, DATA_REG06};
        else if(state == CONF_REG07) chip_rxdb_res <= {RHEAD_RX, DATA_REG07};
        else if(state == CONF_REG08) chip_rxdb_res <= {RHEAD_RX, data_reg08};
        else if(state == CONF_REG09) chip_rxdb_res <= {RHEAD_RX, data_reg09};
        else if(state == CONF_REG10) chip_rxdb_res <= {RHEAD_RX, data_reg10};
        else if(state == CONF_REG11) chip_rxdb_res <= {RHEAD_RX, data_reg11};
        else if(state == CONF_REG12) chip_rxdb_res <= {RHEAD_RX, data_reg12};
        else if(state == CONF_REG13) chip_rxdb_res <= {RHEAD_RX, data_reg13};
        else if(state == CONF_REG14) chip_rxdb_res <= {RHEAD_RX, DATA_REG14};
        else if(state == CONF_REG15) chip_rxdb_res <= {RHEAD_RX, DATA_REG15};
        else if(state == CONF_REG16) chip_rxdb_res <= {RHEAD_RX, DATA_REG16};
        else if(state == CONF_REG17) chip_rxdb_res <= {RHEAD_RX, DATA_REG17};
        else if(state == CONF_REG18) chip_rxdb_res <= {RHEAD_RX, DATA_REG18};
        else if(state == CONF_REG19) chip_rxdb_res <= {RHEAD_RX, DATA_REG19};
        else if(state == CONF_REG20) chip_rxdb_res <= {RHEAD_RX, DATA_REG20};
        else if(state == CONF_REG21) chip_rxdb_res <= {RHEAD_RX, DATA_REG21};
        else if(state == TEMP_RESET) chip_rxdb_res <= {RHEAD_RX, DATA_REG03_NORMAL};
        else chip_rxdb_res <= chip_rxdb_res;
    end

    always@(posedge clk or posedge rst) begin // chip_rxda_res_d0
        if(rst) chip_rxda_res_d0 <= CHIP_RXD_INIT;
        else if(state == MAIN_IDLE) chip_rxda_res_d0 <= CHIP_RXD_INIT;
        else if(state == MAIN_WAIT) chip_rxda_res_d0 <= CHIP_RXD_INIT;
        else if(state == IDLE_TRAN) chip_rxda_res_d0 <= chip_rxda_res;
        else if(state == WRAM_TRAN) chip_rxda_res_d0 <= chip_rxda_res;
        else if(state == RREG_TRAN) chip_rxda_res_d0 <= chip_rxda_res;
        else if(state == TREG_TRAN) chip_rxda_res_d0 <= chip_rxda_res;
        else if(state == RTMP_TRAN) chip_rxda_res_d0 <= chip_rxda_res;
        else chip_rxda_res_d0 <= chip_rxda_res_d0;
    end

    always@(posedge clk or posedge rst) begin // chip_rxdb_res_d0
        if(rst) chip_rxdb_res_d0 <= CHIP_RXD_INIT;
        else if(state == MAIN_IDLE) chip_rxdb_res_d0 <= CHIP_RXD_INIT;
        else if(state == MAIN_WAIT) chip_rxdb_res_d0 <= CHIP_RXD_INIT;
        else if(state == IDLE_TRAN) chip_rxdb_res_d0 <= chip_rxdb_res;
        else if(state == WRAM_TRAN) chip_rxdb_res_d0 <= chip_rxdb_res;
        else if(state == RREG_TRAN) chip_rxdb_res_d0 <= chip_rxdb_res;
        else if(state == TREG_TRAN) chip_rxdb_res_d0 <= chip_rxdb_res;
        else if(state == RTMP_TRAN) chip_rxdb_res_d0 <= chip_rxdb_res;
        else chip_rxdb_res_d0 <= chip_rxdb_res_d0;
    end

    always@(posedge clk or posedge rst) begin // chip_rxda_res_d1
        if(rst) chip_rxda_res_d1 <= CHIP_RXD_INIT;
        else if(state == MAIN_IDLE) chip_rxda_res_d1 <= CHIP_RXD_INIT;
        else if(state == MAIN_WAIT) chip_rxda_res_d1 <= CHIP_RXD_INIT;
        else if(state == IDLE_TRAN) chip_rxda_res_d1 <= chip_rxda_res_d0;
        else if(state == WRAM_TRAN) chip_rxda_res_d1 <= chip_rxda_res_d0;
        else if(state == RREG_TRAN) chip_rxda_res_d1 <= chip_rxda_res_d0;
        else if(state == TREG_TRAN) chip_rxda_res_d1 <= chip_rxda_res_d0;
        else if(state == RTMP_TRAN) chip_rxda_res_d1 <= chip_rxda_res_d0;
        else chip_rxda_res_d1 <= chip_rxda_res_d1;
    end

    always@(posedge clk or posedge rst) begin // chip_rxdb_res_d1
        if(rst) chip_rxdb_res_d1 <= CHIP_RXD_INIT;
        else if(state == MAIN_IDLE) chip_rxdb_res_d1 <= CHIP_RXD_INIT;
        else if(state == MAIN_WAIT) chip_rxdb_res_d1 <= CHIP_RXD_INIT;
        else if(state == IDLE_TRAN) chip_rxdb_res_d1 <= chip_rxdb_res_d0;
        else if(state == WRAM_TRAN) chip_rxdb_res_d1 <= chip_rxdb_res_d0;
        else if(state == RREG_TRAN) chip_rxdb_res_d1 <= chip_rxdb_res_d0;
        else if(state == TREG_TRAN) chip_rxdb_res_d1 <= chip_rxdb_res_d0;
        else if(state == RTMP_TRAN) chip_rxdb_res_d1 <= chip_rxdb_res_d0;
        else chip_rxdb_res_d1 <= chip_rxdb_res_d1;
    end

    always@(posedge clk or posedge rst) begin // type
        if(rst) type <= 2'b00;
        else if((state == TREG_WORK) && (chip_rxda == {RHEAD_RX, DATA_REG63_RHD2116})) type <= 2'b01;
        else if((state == TREG_WORK) && (chip_rxda == {RHEAD_RX, DATA_REG63_RHD2132})) type <= 2'b10;
        else if((state == TREG_WORK) && (chip_rxda == {RHEAD_RX, DATA_REG63_RHD2164})) type <= 2'b11;
        else type <= type;
    end

    always@(posedge clk or posedge rst) begin // data_reg01
        if(rst) data_reg01 <= 8'h00;
        else if(state == MAIN_IDLE) data_reg01  <=  8'h00;
        else if((state == CONF_REG01) && (fs == FS_1KHZ)) data_reg01 <= DATA_REG01_12KHZ;
        else if((state == CONF_REG01) && (fs == FS_2KHZ)) data_reg01 <= DATA_REG01_12KHZ;
        else if((state == CONF_REG01) && (fs == FS_4KHZ)) data_reg01 <= DATA_REG01_4KHZ;
        else if((state == CONF_REG01) && (fs == FS_8KHZ)) data_reg01 <= DATA_REG01_8KHZ;
        else if((state == CONF_REG01) && (fs == FS_16KHZ)) data_reg01 <= DATA_REG01_16KHZ;
        else data_reg01 <= data_reg01;
    end 

    always@(posedge clk or posedge rst) begin // data_reg02
        if(rst) data_reg02 <= 8'h00;
        else if(state == MAIN_IDLE) data_reg02  <=  8'h00;
        else if((state == CONF_REG02) && (fs == FS_1KHZ)) data_reg02 <= DATA_REG02_12KHZ;
        else if((state == CONF_REG02) && (fs == FS_2KHZ)) data_reg02 <= DATA_REG02_12KHZ;
        else if((state == CONF_REG02) && (fs == FS_4KHZ)) data_reg02 <= DATA_REG02_4KHZ;
        else if((state == CONF_REG02) && (fs == FS_8KHZ)) data_reg02 <= DATA_REG02_8KHZ;
        else if((state == CONF_REG02) && (fs == FS_16KHZ)) data_reg02 <= DATA_REG02_16KHZ;
        else data_reg02 <= data_reg02;
    end 

    always@(posedge clk or posedge rst) begin // num_wait
        if(rst) num_wait <= WAIT_FOR_0US;
        else if(state == MAIN_IDLE) num_wait <= WAIT_FOR_0US;
        else if(state == MAIN_WAIT) num_wait <=  WAIT_FOR_0US;
        else if(state == TEMP_REST0) num_wait <= WAIT_FOR_200US;
        else if(state == TEMP_REST1) num_wait <= WAIT_FOR_100US;
        else if(state == TEMP_REST2) num_wait <= WAIT_FOR_100US;
        else if(state == TEMP_REST3) num_wait <= WAIT_FOR_100US;
        else num_wait <= num_wait;
    end

    always@(posedge clk or posedge rst) begin // num
        if(rst) num <= 16'h0000;
        else if(state == MAIN_IDLE) num <= 16'h0000;
        else if(state == MAIN_WAIT) num <= 16'h0000;
        else if(state == REST_WAIT) num <= 16'h0000;
        else if(state == REST_WORK) num <= num + 1'b1;
        else num <= 16'h0000;
    end

    always@(posedge clk or posedge rst) begin // temp_measure
        if(rst) temp_measure <= 16'h00000;
        else if(state == MAIN_IDLE) temp_measure <= 16'h0000;
        else if(state == MAIN_WAIT) temp_measure <= 16'h0000;
        else if(state == TEMP_RRESA) temp_measure <= 16'h0000;
        else if(state == RTMP_WORK) temp_measure <= chip_rxda - temp_measure;
        else temp_measure <= temp_measure;
    end

    always@(posedge clk or posedge rst) begin // chip_temp
        if(rst) chip_temp <= 16'h0000;
        else if(state == MAIN_IDLE) chip_temp <= 16'h0000;
        else if(state == TEMP_DONE) chip_temp <= temp_measure;
        else chip_temp <= chip_temp;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_reg08 <= {2'h0, RH1_DAC1_20K};
        else if(state == CONF_IDLE && filt_up == FILTUP_20K) data_reg08 <= {2'h0, RH1_DAC1_20K};
        else if(state == CONF_IDLE && filt_up == FILTUP_15K) data_reg08 <= {2'h0, RH1_DAC1_15K};
        else if(state == CONF_IDLE && filt_up == FILTUP_10K) data_reg08 <= {2'h0, RH1_DAC1_10K};
        else if(state == CONF_IDLE && filt_up == FILTUP_7K5) data_reg08 <= {2'h0, RH1_DAC1_7K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_5K0) data_reg08 <= {2'h0, RH1_DAC1_5K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_3K0) data_reg08 <= {2'h0, RH1_DAC1_3K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_2K5) data_reg08 <= {2'h0, RH1_DAC1_2K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_2K0) data_reg08 <= {2'h0, RH1_DAC1_2K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_1K5) data_reg08 <= {2'h0, RH1_DAC1_1K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_1K0) data_reg08 <= {2'h0, RH1_DAC1_1K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_750) data_reg08 <= {2'h0, RH1_DAC1_750};
        else if(state == CONF_IDLE && filt_up == FILTUP_500) data_reg08 <= {2'h0, RH1_DAC1_500};
        else if(state == CONF_IDLE && filt_up == FILTUP_300) data_reg08 <= {2'h0, RH1_DAC1_300};
        else if(state == CONF_IDLE && filt_up == FILTUP_200) data_reg08 <= {2'h0, RH1_DAC1_200};
        else if(state == CONF_IDLE && filt_up == FILTUP_100) data_reg08 <= {2'h0, RH1_DAC1_100};
        else if(state == CONF_IDLE) data_reg08 <= {2'h0, RH1_DAC1_20K};
        else data_reg08 <= data_reg08;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_reg09 <= {3'h0, RH1_DAC2_20K};
        else if(state == CONF_IDLE && filt_up == FILTUP_20K) data_reg09 <= {3'h0, RH1_DAC2_20K};
        else if(state == CONF_IDLE && filt_up == FILTUP_15K) data_reg09 <= {3'h0, RH1_DAC2_15K};
        else if(state == CONF_IDLE && filt_up == FILTUP_10K) data_reg09 <= {3'h0, RH1_DAC2_10K};
        else if(state == CONF_IDLE && filt_up == FILTUP_7K5) data_reg09 <= {3'h0, RH1_DAC2_7K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_5K0) data_reg09 <= {3'h0, RH1_DAC2_5K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_3K0) data_reg09 <= {3'h0, RH1_DAC2_3K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_2K5) data_reg09 <= {3'h0, RH1_DAC2_2K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_2K0) data_reg09 <= {3'h0, RH1_DAC2_2K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_1K5) data_reg09 <= {3'h0, RH1_DAC2_1K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_1K0) data_reg09 <= {3'h0, RH1_DAC2_1K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_750) data_reg09 <= {3'h0, RH1_DAC2_750};
        else if(state == CONF_IDLE && filt_up == FILTUP_500) data_reg09 <= {3'h0, RH1_DAC2_500};
        else if(state == CONF_IDLE && filt_up == FILTUP_300) data_reg09 <= {3'h0, RH1_DAC2_300};
        else if(state == CONF_IDLE && filt_up == FILTUP_200) data_reg09 <= {3'h0, RH1_DAC2_200};
        else if(state == CONF_IDLE && filt_up == FILTUP_100) data_reg09 <= {3'h0, RH1_DAC2_100};
        else if(state == CONF_IDLE) data_reg09 <= {3'h0, RH1_DAC2_20K};
        else data_reg09 <= data_reg09;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_reg10 <= {2'h0, RH2_DAC1_20K};
        else if(state == CONF_IDLE && filt_up == FILTUP_20K) data_reg10 <= {2'h0, RH2_DAC1_20K};
        else if(state == CONF_IDLE && filt_up == FILTUP_15K) data_reg10 <= {2'h0, RH2_DAC1_15K};
        else if(state == CONF_IDLE && filt_up == FILTUP_10K) data_reg10 <= {2'h0, RH2_DAC1_10K};
        else if(state == CONF_IDLE && filt_up == FILTUP_7K5) data_reg10 <= {2'h0, RH2_DAC1_7K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_5K0) data_reg10 <= {2'h0, RH2_DAC1_5K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_3K0) data_reg10 <= {2'h0, RH2_DAC1_3K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_2K5) data_reg10 <= {2'h0, RH2_DAC1_2K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_2K0) data_reg10 <= {2'h0, RH2_DAC1_2K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_1K5) data_reg10 <= {2'h0, RH2_DAC1_1K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_1K0) data_reg10 <= {2'h0, RH2_DAC1_1K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_750) data_reg10 <= {2'h0, RH2_DAC1_750};
        else if(state == CONF_IDLE && filt_up == FILTUP_500) data_reg10 <= {2'h0, RH2_DAC1_500};
        else if(state == CONF_IDLE && filt_up == FILTUP_300) data_reg10 <= {2'h0, RH2_DAC1_300};
        else if(state == CONF_IDLE && filt_up == FILTUP_200) data_reg10 <= {2'h0, RH2_DAC1_200};
        else if(state == CONF_IDLE && filt_up == FILTUP_100) data_reg10 <= {2'h0, RH2_DAC1_100};
        else if(state == CONF_IDLE) data_reg10 <= {2'h0, RH2_DAC1_20K};
        else data_reg10 <= data_reg10;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_reg11 <= {3'h0, RH2_DAC2_20K};
        else if(state == CONF_IDLE && filt_up == FILTUP_20K) data_reg11 <= {3'h0, RH2_DAC2_20K};
        else if(state == CONF_IDLE && filt_up == FILTUP_15K) data_reg11 <= {3'h0, RH2_DAC2_15K};
        else if(state == CONF_IDLE && filt_up == FILTUP_10K) data_reg11 <= {3'h0, RH2_DAC2_10K};
        else if(state == CONF_IDLE && filt_up == FILTUP_7K5) data_reg11 <= {3'h0, RH2_DAC2_7K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_5K0) data_reg11 <= {3'h0, RH2_DAC2_5K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_3K0) data_reg11 <= {3'h0, RH2_DAC2_3K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_2K5) data_reg11 <= {3'h0, RH2_DAC2_2K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_2K0) data_reg11 <= {3'h0, RH2_DAC2_2K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_1K5) data_reg11 <= {3'h0, RH2_DAC2_1K5};
        else if(state == CONF_IDLE && filt_up == FILTUP_1K0) data_reg11 <= {3'h0, RH2_DAC2_1K0};
        else if(state == CONF_IDLE && filt_up == FILTUP_750) data_reg11 <= {3'h0, RH2_DAC2_750};
        else if(state == CONF_IDLE && filt_up == FILTUP_500) data_reg11 <= {3'h0, RH2_DAC2_500};
        else if(state == CONF_IDLE && filt_up == FILTUP_300) data_reg11 <= {3'h0, RH2_DAC2_300};
        else if(state == CONF_IDLE && filt_up == FILTUP_200) data_reg11 <= {3'h0, RH2_DAC2_200};
        else if(state == CONF_IDLE && filt_up == FILTUP_100) data_reg11 <= {3'h0, RH2_DAC2_100};
        else if(state == CONF_IDLE) data_reg11 <= {3'h0, RH2_DAC2_20K};
        else data_reg11 <= data_reg11;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_reg12 <= {1'b0, RL_DAC1_D10};
        else if(state == CONF_IDLE && filt_low == FILTLOW_100) data_reg12 <= {1'b0, RL_DAC1_100};
        else if(state == CONF_IDLE && filt_low == FILTLOW_020) data_reg12 <= {1'b0, RL_DAC1_020};
        else if(state == CONF_IDLE && filt_low == FILTLOW_015) data_reg12 <= {1'b0, RL_DAC1_015};
        else if(state == CONF_IDLE && filt_low == FILTLOW_010) data_reg12 <= {1'b0, RL_DAC1_010};
        else if(state == CONF_IDLE && filt_low == FILTLOW_7D5) data_reg12 <= {1'b0, RL_DAC1_7D5};
        else if(state == CONF_IDLE && filt_low == FILTLOW_5D0) data_reg12 <= {1'b0, RL_DAC1_5D0};
        else if(state == CONF_IDLE && filt_low == FILTLOW_3D0) data_reg12 <= {1'b0, RL_DAC1_3D0};
        else if(state == CONF_IDLE && filt_low == FILTLOW_2D5) data_reg12 <= {1'b0, RL_DAC1_2D5};
        else if(state == CONF_IDLE && filt_low == FILTLOW_2D0) data_reg12 <= {1'b0, RL_DAC1_2D0};
        else if(state == CONF_IDLE && filt_low == FILTLOW_1D0) data_reg12 <= {1'b0, RL_DAC1_1D0};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D75) data_reg12 <= {1'b0, RL_DAC1_D75};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D50) data_reg12 <= {1'b0, RL_DAC1_D50};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D30) data_reg12 <= {1'b0, RL_DAC1_D30};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D25) data_reg12 <= {1'b0, RL_DAC1_D25};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D10) data_reg12 <= {1'b0, RL_DAC1_D10};
        else if(state == CONF_IDLE) data_reg12 <= {1'b0, RL_DAC1_D10};
        else data_reg12 <= data_reg12;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_reg13 <= {1'b0, RL_DAC2_D10};
        else if(state == CONF_IDLE && filt_low == FILTLOW_100) data_reg13 <= {1'b0, RL_DAC2_100};
        else if(state == CONF_IDLE && filt_low == FILTLOW_020) data_reg13 <= {1'b0, RL_DAC2_020};
        else if(state == CONF_IDLE && filt_low == FILTLOW_015) data_reg13 <= {1'b0, RL_DAC2_015};
        else if(state == CONF_IDLE && filt_low == FILTLOW_010) data_reg13 <= {1'b0, RL_DAC2_010};
        else if(state == CONF_IDLE && filt_low == FILTLOW_7D5) data_reg13 <= {1'b0, RL_DAC2_7D5};
        else if(state == CONF_IDLE && filt_low == FILTLOW_5D0) data_reg13 <= {1'b0, RL_DAC2_5D0};
        else if(state == CONF_IDLE && filt_low == FILTLOW_3D0) data_reg13 <= {1'b0, RL_DAC2_3D0};
        else if(state == CONF_IDLE && filt_low == FILTLOW_2D5) data_reg13 <= {1'b0, RL_DAC2_2D5};
        else if(state == CONF_IDLE && filt_low == FILTLOW_2D0) data_reg13 <= {1'b0, RL_DAC2_2D0};
        else if(state == CONF_IDLE && filt_low == FILTLOW_1D0) data_reg13 <= {1'b0, RL_DAC2_1D0};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D75) data_reg13 <= {1'b0, RL_DAC2_D75};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D50) data_reg13 <= {1'b0, RL_DAC2_D50};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D30) data_reg13 <= {1'b0, RL_DAC2_D30};
        else if(state == CONF_IDLE && filt_low == FILTLOW_D25) data_reg13 <= {1'b0, RL_DAC2_D25};
        else if(state == CONF_IDLE && filt_low == RL_DAC2_D10) data_reg13 <= {1'b0, RL_DAC2_D10};
        else if(state == CONF_IDLE) data_reg13 <= {1'b0, RL_DAC2_D10};
        else data_reg13 <= data_reg13;
    end
 
 
    spi
    spi_dut(
        .clk(spi_clk),
        .rst(rst),

        .fs(fs_spi),
        .fd_spi(fd_spi),
        .fd_prd(fd_prd),

        .miso(spi_miso),
        .sclk(spi_sclk),
        .mosi(spi_mosi),
        .cs(spi_cs),

        .chip_txd(chip_txd),
        .chip_rxda(chip_rxda),
        .chip_rxdb(chip_rxdb)
    );

    spi2fifo
    spi2fifo_dut(
        .fifo_txc(fifo_txc),
        .rst(rst),

        .fs(fs_fifo),
        .fd(fd_fifo),

        .chip_rxda(chip_rxda),
        .chip_rxdb(chip_rxdb),

        .fifo_full(fifo_full),
        .fifo_txen(fifo_txen),
        .fifo_txd(fifo_txd)
    );

    fifo_intan
    fifo_intan_duta(
        .wr_clk(fifo_txc),
        .din(fifo_txd[15:8]),
        .wr_en(fifo_txen[1]),
        .full(fifo_full[1]),

        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[15:8]),
        .rd_en(fifo_rxen[1])
    );

    fifo_intan
    fifo_intan_dutb(
        .wr_clk(fifo_txc),
        .din(fifo_txd[7:0]),
        .wr_en(fifo_txen[0]),
        .full(fifo_full[0]),

        .rd_clk(fifo_rxc),
        .dout(fifo_rxd[7:0]),
        .rd_en(fifo_rxen[0])
    );



endmodule