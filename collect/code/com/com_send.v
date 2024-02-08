module com_send(
    input clk,
    input rst,

    output fs_eth,
    input fd_eth,

    input fs,
    output fd,

    input [3:0] btype,
    input [3:0] didx,
    input [11:0] dlen,

    output reg [14:0] ram_data_rxa_init,
    output reg [12:0] data_len 
);

    reg [4:0] state, next_state;

    localparam IDLE = 5'h01, WAIT = 5'h02, TAKE = 5'h04;
    localparam WORK = 5'h08, DONE = 5'h10;

    localparam RAM_DATA_RXA_INIT = 15'h0000, RAM_DATA_RXA_INFO = 15'h0100;
    localparam RAM_DATA_RXA_DAT0 = 15'h1000, RAM_DATA_RXA_DAT1 = 15'h2200;
    localparam RAM_DATA_RXA_DAT2 = 15'h3400, RAM_DATA_RXA_DAT3 = 15'h4600;
    localparam RAM_DATA_RXA_DAT4 = 15'h5800, RAM_DATA_RXA_DAT5 = 15'h6A00;

    localparam DATA_LEN_INFO = 12'h000E, DATA_LEN_INIT = 12'h0000;
    localparam DATA_LEN_PART = 12'h0024;
    
    localparam BTYPE_INFO = 4'h1;
    localparam BTYPE_DATA = 4'hE;

    assign fs_eth = (state == WORK);
    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= TAKE;
                else next_state <= WAIT;
            end
            TAKE: next_state <= WORK;
            WORK: begin
                if(fd_eth) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(~fs) next_state <= IDLE;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_len <= DATA_LEN_INIT;
        else if(state == TAKE && btype == BTYPE_INFO) data_len <= DATA_LEN_INFO;
        else if(state == TAKE && btype == BTYPE_DATA) data_len <= dlen + DATA_LEN_PART;
        else if(state == TAKE) data_len <= DATA_LEN_INIT;
        else if(state == DONE) data_len <= DATA_LEN_INIT;
        else data_len <= data_len;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ram_data_rxa_init <= RAM_DATA_RXA_INIT;
        else if(state == TAKE && btype == BTYPE_INFO) ram_data_rxa_init <= RAM_DATA_RXA_INFO;
        else if(state == TAKE && btype == BTYPE_DATA && didx == 4'h0) ram_data_rxa_init <= RAM_DATA_RXA_DAT0;
        else if(state == TAKE && btype == BTYPE_DATA && didx == 4'h1) ram_data_rxa_init <= RAM_DATA_RXA_DAT1;
        else if(state == TAKE && btype == BTYPE_DATA && didx == 4'h2) ram_data_rxa_init <= RAM_DATA_RXA_DAT2;
        else if(state == TAKE && btype == BTYPE_DATA && didx == 4'h3) ram_data_rxa_init <= RAM_DATA_RXA_DAT3;
        else if(state == TAKE && btype == BTYPE_DATA && didx == 4'h4) ram_data_rxa_init <= RAM_DATA_RXA_DAT4;
        else if(state == TAKE && btype == BTYPE_DATA && didx == 4'h5) ram_data_rxa_init <= RAM_DATA_RXA_DAT5;
        else if(state == TAKE) ram_data_rxa_init <= RAM_DATA_RXA_INIT;
        else if(state == DONE) ram_data_rxa_init <= RAM_DATA_RXA_INIT;
        else ram_data_rxa_init <= ram_data_rxa_init;
    end











endmodule