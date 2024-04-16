module console_core(
    input clk,
    input rst,

    output fs_conf,
    input fd_conf,
    output fs_conv,
    input fd_conv,

    output fs_send,
    input fd_send,
    input fs_read,
    output fd_read,

    output reg fs_trgg,
    input fd_trgg,

    input tick,
    output reg [3:0] data_idx,

    input [1:0] com_state
);

    localparam COM_STATE_IDLE = 2'b00, COM_STATE_CONF = 2'b01;
    localparam COM_STATE_READ = 2'b10, COM_STATE_SAME = 2'b11;

    localparam DATA_IDX_INIT = 4'h0, DATA_IDX_NUM = 4'h6;

    reg [11:0] state; 
    reg [11:0] next_state;
    localparam MAIN_IDLE = 12'h001, MAIN_WAIT = 12'h002, MAIN_DONE = 12'h004;
    localparam CONF_IDLE = 12'h008, CONF_WAIT = 12'h010, CONF_WORK = 12'h020, CONF_DONE = 12'h040;
    localparam CONV_IDLE = 12'h080, CONV_WAIT = 12'h100, CONV_WORK = 12'h200, CONV_TAKE = 12'h400;
    localparam CONV_DONE = 12'h800;

    reg [1:0] tick_b;


    assign fs_conf = (state == CONF_WORK);
    assign fs_conv = (state == CONV_TAKE);
    assign fs_send = (state == CONV_TAKE);
    assign fd_read = (state == CONF_WAIT) || (state == CONV_WAIT) || (state == MAIN_DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_read && com_state == COM_STATE_IDLE) next_state <= MAIN_DONE;
                else if(fs_read && com_state == COM_STATE_CONF) next_state <= CONF_IDLE; 
                else if(fs_read && com_state == COM_STATE_READ) next_state <= CONV_IDLE;
                else if(fs_read && com_state == COM_STATE_SAME) next_state <= MAIN_DONE;
                else if(fs_read) next_state <= MAIN_DONE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_DONE: begin
                if(~fs_read) next_state <= MAIN_WAIT;
                else next_state <= MAIN_DONE;
            end

            CONF_IDLE: next_state <= CONF_WAIT;
            CONF_WAIT: begin
                if(~fs_read) next_state <= CONF_WORK;
                else next_state <= CONF_WAIT;
            end
            CONF_WORK: begin
                if(fd_conf) next_state <= CONF_DONE;
                else next_state <= CONF_WORK;
            end
            CONF_DONE: next_state <= MAIN_WAIT;

            CONV_IDLE: next_state <= CONV_WAIT;
            CONV_WAIT: begin
                if(~fs_read) next_state <= CONV_WORK;
                else next_state <= CONV_WAIT;
            end
            CONV_WORK: begin
                if(tick_b == 2'b01) next_state <= CONV_TAKE;
                else if(fs_read) next_state <= MAIN_WAIT;
                else next_state <= CONV_WORK;
            end
            CONV_TAKE: begin
                if(fd_conv && fd_send) next_state <= CONV_DONE;
                else next_state <= CONV_TAKE;
            end
            CONV_DONE: begin
                if(com_state == COM_STATE_IDLE) next_state <= MAIN_WAIT;
                else if(com_state == COM_STATE_CONF) next_state <= MAIN_WAIT;
                else if(com_state == COM_STATE_READ) next_state <= CONV_WORK;
                else if(com_state == COM_STATE_SAME) next_state <= CONV_WORK;
                else next_state <= MAIN_WAIT;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) tick_b <= 2'b00;
        else tick_b <= {tick_b[0], tick};
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_trgg <= 1'b0;
        else if(state == CONV_IDLE) fs_trgg <= 1'b1;
        else if(fd_trgg) fs_trgg <= 1'b0;
        else fs_trgg <= fs_trgg;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_idx <= DATA_IDX_INIT;
        else if(state == MAIN_IDLE) data_idx <= DATA_IDX_INIT;
        else if(state == CONV_IDLE) data_idx <= DATA_IDX_INIT;
        else if(state == CONV_DONE && data_idx == DATA_IDX_NUM - 1'b1) data_idx <= DATA_IDX_INIT;
        else if(state == CONV_DONE) data_idx <= data_idx + 1'b1;
        else data_idx <= data_idx;
    end

endmodule