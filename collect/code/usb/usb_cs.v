module usb_cs(
    input clk,
    input rst,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output reg [3:0] read_btype,
    input [11:0] data_idx,

    input [3:0] send_btype,

    output fs_tx,
    input fd_tx,
    input fs_rx,
    output fd_rx,

    output reg [3:0] tx_btype,

    input [3:0] rx_btype,
    output reg [11:0] rx_ram_init
);

    localparam TIMEOUT = 8'h80;
    localparam NUMOUT = 8'h10;

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    localparam ADC_RAM_ADDR_DATA0 = 12'h000, ADC_RAM_ADDR_DATA1 = 12'h240;
    localparam ADC_RAM_ADDR_DATA2 = 12'h480, ADC_RAM_ADDR_DATA3 = 12'h6C0;
    localparam ADC_RAM_ADDR_DATA4 = 12'h900, ADC_RAM_ADDR_DATA5 = 12'hB40;
    localparam ADC_RAM_ADDR_INIT = 12'hF00;

    (*MARK_DEBUG = "true"*)reg [7:0] state, next_state;
    reg [7:0] state_goto;

    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01;
    localparam SEND_PREP = 8'h20, SEND_DATA = 8'h21, SEND_DONE = 8'h22;
    localparam READ_PREP = 8'h30, READ_DATA = 8'h31, READ_DONE = 8'h32;
    localparam RANS_WAIT = 8'h40, RANS_TAKE = 8'h41, RANS_DONE = 8'h42;
    localparam WANS_PREP = 8'h50, WANS_DONE = 8'h51;

    reg [7:0] time_cnt, num_cnt;

    assign fd_send = (state == SEND_DONE);
    assign fs_read = (state == READ_DONE);
    assign fs_tx = (state == SEND_DATA) || (state == WANS_DONE);
    assign fd_rx = (state == RANS_DONE) || (state == READ_DATA);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_send) next_state <= SEND_PREP;
                else if(fs_rx) next_state <= READ_PREP;
                else next_state <= MAIN_WAIT;
            end

            SEND_PREP: next_state <= SEND_DATA;
            SEND_DATA: begin
                if(fd_tx) next_state <= RANS_WAIT;
                else next_state <= SEND_DATA;
            end
            RANS_WAIT: begin
                if(time_cnt >= TIMEOUT- 1'b1) next_state <= SEND_DONE; 
                else if(fs_rx) next_state <= RANS_TAKE;
                else next_state <= RANS_WAIT;
            end
            RANS_TAKE: next_state <= RANS_DONE;
            RANS_DONE: begin
                if(~fs_rx) next_state <= state_goto;
                else next_state <= RANS_DONE;
            end
            SEND_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= SEND_DONE;
            end

            READ_PREP: next_state <= READ_DATA;
            READ_DATA: begin
                if(~fs_rx) next_state <= WANS_PREP;
                else next_state <= READ_DATA;
            end
            WANS_PREP: next_state <= WANS_DONE;
            WANS_DONE: begin
                if(fd_tx) next_state <= READ_DONE;
                else next_state <= WANS_DONE;
            end
            READ_DONE: begin
                if(fd_read) next_state <= MAIN_WAIT;
                else next_state <= READ_DONE;
            end
            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) state_goto <= MAIN_IDLE;
        else if(state == MAIN_IDLE) state_goto <= MAIN_IDLE;
        else if(state == MAIN_WAIT) state_goto <= MAIN_IDLE;
        else if(state == RANS_TAKE && rx_btype == BAG_ACK) state_goto <= SEND_DONE;
        else if(state == RANS_TAKE && rx_btype == BAG_NAK && num_cnt >= NUMOUT - 1'b1) state_goto <= SEND_DONE;
        else if(state == RANS_TAKE && rx_btype == BAG_NAK) state_goto <= SEND_DATA;
        else state_goto <= state_goto;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) read_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) read_btype <= BAG_INIT;
        else if(state == WANS_PREP) read_btype <= rx_btype;
        else read_btype <= read_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) tx_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) tx_btype <= BAG_INIT;
        else if(state == MAIN_WAIT) tx_btype <= BAG_INIT;
        else if(state == SEND_PREP) tx_btype <= send_btype;
        else if(state == WANS_PREP && num_cnt >= NUMOUT - 1'b1) tx_btype <= BAG_ACK;
        else if(state == WANS_PREP && rx_btype == BAG_ERROR) tx_btype <= BAG_NAK;
        else if(state == WANS_PREP) tx_btype <= BAG_ACK;
        else tx_btype <= tx_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) time_cnt <= 8'h00;
        else if(state == MAIN_IDLE) time_cnt <= 8'h00;
        else if(state == MAIN_WAIT) time_cnt <= 8'h00;
        else if(state == RANS_WAIT) time_cnt <= time_cnt + 1'b1;
        else time_cnt <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num_cnt <= 8'h00;
        else if(state == MAIN_IDLE) num_cnt <= 8'h00;
        else if(state == MAIN_WAIT) num_cnt <= 8'h00;
        else if(state == RANS_TAKE) num_cnt <= num_cnt + 1'b1;
        else if(state == WANS_PREP) num_cnt <= num_cnt + 1'b1;
        else num_cnt <= num_cnt;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rx_ram_init <= ADC_RAM_ADDR_INIT;
        else if(state == MAIN_IDLE) rx_ram_init <= ADC_RAM_ADDR_INIT;
        else if(state == MAIN_WAIT) rx_ram_init <= ADC_RAM_ADDR_INIT;
        else if(state == READ_PREP && data_idx == 4'h0) rx_ram_init <= ADC_RAM_ADDR_DATA0;
        else if(state == READ_PREP && data_idx == 4'h1) rx_ram_init <= ADC_RAM_ADDR_DATA1;
        else if(state == READ_PREP && data_idx == 4'h2) rx_ram_init <= ADC_RAM_ADDR_DATA2;
        else if(state == READ_PREP && data_idx == 4'h3) rx_ram_init <= ADC_RAM_ADDR_DATA3;
        else if(state == READ_PREP && data_idx == 4'h4) rx_ram_init <= ADC_RAM_ADDR_DATA4;
        else if(state == READ_PREP && data_idx == 4'h5) rx_ram_init <= ADC_RAM_ADDR_DATA5;
        else rx_ram_init <= rx_ram_init;
    end


endmodule