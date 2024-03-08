module com_cs(
    input clk,
    input rst,

    input fs_send,
    output fd_send,
    output fd_txer,
    output fs_read,
    input fd_read,

    output reg [3:0] read_btype,

    input [3:0] send_btype,
    input [11:0] send_dlen,
    input [11:0] ram_addr_init,

    output fs_tx,
    input fd_tx,
    input fs_rx,
    output fd_rx,

    output reg [3:0] tx_btype,
    output reg [11:0] tx_ram_init,
    output reg [11:0] tx_ram_rlen,

    input [3:0] rx_btype
);

    localparam TIMEOUT = 8'h80;
    localparam NUMOUT = 8'h03;

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    localparam DEBUG_NUM = 8'h80;

    reg [15:0] state, next_state;
    reg [15:0] state_goto;

    localparam MAIN_IDLE = 16'h0101, MAIN_WAIT = 16'h0102;
    localparam SEND_PREP = 16'h0201, SEND_DATA = 16'h0202, SEND_DONE = 16'h0204, SEND_FAIL = 16'h0208;
    localparam READ_PREP = 16'h0401, READ_DATA = 16'h0402, READ_DONE = 16'h0404;
    localparam RANS_WAIT = 16'h0801, RANS_TOUT = 16'h0802, RANS_TAKE = 16'h0804, RANS_DONE = 16'h0808;
    localparam WANS_PREP = 16'h1001, WANS_DONE = 16'h1002;

    reg [7:0] time_cnt; 
    (*MARK_DEBUG = "true"*)reg [7:0] num_cnt;

    assign fd_send = (state == SEND_DONE) || (state == SEND_FAIL);
    assign fd_txer = (state == SEND_FAIL);
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
                if(time_cnt >= TIMEOUT- 1'b1) next_state <= RANS_TOUT; 
                else if(fs_rx) next_state <= RANS_TAKE;
                else next_state <= RANS_WAIT;
            end
            RANS_TOUT: begin
                if(num_cnt >= NUMOUT - 1'b1) next_state <= SEND_FAIL;
                else next_state <= SEND_DATA;
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
            SEND_FAIL: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= SEND_FAIL;
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
                else if(time_cnt >= TIMEOUT - 1'b1) next_state <= MAIN_WAIT;
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
        else if(state == RANS_TAKE && rx_btype == BAG_NAK && num_cnt >= NUMOUT - 1'b1) state_goto <= SEND_FAIL;
        else if(state == RANS_TAKE && rx_btype == BAG_NAK) state_goto <= SEND_DATA;
        else if(state == RANS_TAKE) state_goto <= SEND_DONE;
        else state_goto <= state_goto;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) read_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) read_btype <= BAG_INIT;
        else if(state == MAIN_WAIT) read_btype <= BAG_INIT;
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
        if(rst) tx_ram_init <= 12'h000;
        else if(state == MAIN_IDLE) tx_ram_init <= 12'h000;
        else if(state == MAIN_WAIT) tx_ram_init <= 12'h000;
        else if(state == SEND_PREP) tx_ram_init <= ram_addr_init;
        else tx_ram_init <= tx_ram_init;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) tx_ram_rlen <= 12'h000;
        else if(state == MAIN_IDLE) tx_ram_rlen <= 12'h000;
        else if(state == MAIN_WAIT) tx_ram_rlen <= 12'h000;
        else if(state == SEND_PREP) tx_ram_rlen <= send_dlen;
        else tx_ram_rlen <= tx_ram_rlen;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) time_cnt <= 8'h00;
        else if(state == MAIN_IDLE) time_cnt <= 8'h00;
        else if(state == MAIN_WAIT) time_cnt <= 8'h00;
        else if(state == RANS_WAIT) time_cnt <= time_cnt + 1'b1;
        else if(state == READ_DONE) time_cnt <= time_cnt + 1'b1;
        else time_cnt <= 8'h00;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num_cnt <= 8'h00;
        else if(state == MAIN_IDLE) num_cnt <= 8'h00;
        else if(state == MAIN_WAIT) num_cnt <= 8'h00;
        else if(state == RANS_TOUT) num_cnt <= num_cnt + 1'b1;
        else if(state == RANS_TAKE) num_cnt <= num_cnt + 1'b1;
        else if(state == WANS_PREP) num_cnt <= num_cnt + 1'b1;
        else num_cnt <= num_cnt;
    end


endmodule