module console(
    input clk,
    input rst,

    output fs_adc_init,
    input fd_adc_init,
    output fs_adc_type,
    input fd_adc_type,
    output fs_adc_conf,
    input fd_adc_conf,

    output fs_adc_conv,
    input fd_adc_conv,
    output fs_adc_send,
    input fd_adc_send,

    output fs_com_send,
    input fd_com_send,
    input fs_com_read,
    output fd_com_read,

    input [3:0] read_btype,
    output reg [3:0] send_btype,
    input [3:0] read_btype,

    input [7:0] adc_type,
    input [15:0] adc_temp,
    input [7:0] adc_stat,
    output reg [3:0] adc_freq,

    output reg [7:0] com_type,
    output reg [7:0] com_temp,
    output reg [3:0] com_stat,
    output reg [3:0] com_didx,
    output reg [3:0] com_ddidx
);
    localparam BAG_INIT = 4'b0000;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DHEAD = 4'b1100, BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_TAKE = 8'h02;
    localparam LINK_IDLE = 8'h10, LINK_WORK = 8'h11, LINK_TAKE = 8'h12;
    localparam LINK_SEND = 8'h13, LINK_DONE = 8'h14;
    localparam TYPE_IDLE = 8'h20, TYPE_WORK = 8'h21, TYPE_TAKE = 8'h22;
    localparam TYPE_SEND = 8'h23, TYPE_DONE = 8'h24;
    localparam CONF_IDLE = 8'h30, CONF_WORK = 8'h31, CONF_TAKE = 8'h32;
    localparam CONF_SEND = 8'h33, CONF_DONE = 8'h34;
    localparam CONV_IDLE = 8'h40, CONV_WORK = 8'h41, CONV_TAKE = 8'h42;
    localparam CONV_SEND = 8'h43, CONV_DONE = 8'h44;
    
    assign fs_adc_init = (state == LINK_WORK);
    assign fs_adc_type = (state == TYPE_WORK);
    assign fs_adc_conf = (state == CONF_WORK);
    assign fs_adc_conv = (state == CONV_WORK);
    assign fs_adc_send = (state == CONV_SEND);

    assign fs_com_send = (state == LINK_SEND) || (state == TYPE_SEND) || (state == CONF_SEND) || (state == CONV_SEND);
    assign fd_com_read = (state == TYPE_IDLE) || (state == CONF_IDLE) || (state == CONV_IDLE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= LINK_IDLE;

            LINK_IDLE: next_state <= LINK_ADC;
            LINK_WORK: begin
                if(fd_adc_init) next_state <= LINK_TAKE;
                else next_state <= LINL_WORK;
            end
            LINK_TAKE: next_state <= LINK_SEND;
            LINK_SEND: begin
                if(fd_com_send) next_state <= LINK_DONE;
                else next_state <= LINK_SEND;
            end
            LINK_DONE: next_state <= MAIN_WAIT;

            MAIN_WAIT: begin
                if(fs_com_read) next_state <= MAIN_TAKE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_TAKE: begin
                if(read_btype == BAG_DIDX) next_state <= TYPE_IDLE;
                else if(read_btype == BAG_DPARAM) next_state <= CONF_IDLE;
                else if(read_btype == BAG_DDIDX) next_state <= CONV_IDLE;
                else next_state <= MAIN_TAKE;
            end

            TYPE_IDLE: begin
                if(~fs_com_read) next_state <= TYPE_WORK;
                else next_state <= TYPE_IDLE;
            end
            TYPE_WORK: begin
                if(fd_adc_type) next_state <= TYPE_TAKE;
                else next_state <= TYPE_DONE;
            end
            TYPE_TAKE: next_state <= TYPE_SEND;
            TYPE_SEND: begin
                if(fd_com_send) next_state <= next_state <= TYPE_DONE;
                else next_state <= TYPE_SEND;
            end
            TYPE_DONE: next_state <= MAIN_WAIT;

            CONF_IDLE: begin
                if(~fs_com_read) next_state <= CONF_WORK;
                else next_state <= CONF_IDLE;
            end
            CONF_WORK: begin
                if(fd_adc_conf) next_state <= CONF_TAKE;
                else next_state <= CONF_WORK;
            end
            CONF_TAKE: next_state <= CONF_SEND;
            CONF_SEND: begin
                if(fd_com_send) next_state <= CONF_DONE;
                else next_state <= CONF_SEND;
            end
            CONF_DONE: next_state <= MAIN_WAIT;

            CONV_IDLE: begin
                if(~fs_com_read) next_state <= CONV_WORK;
                else next_state <= CONV_IDLE;
            end
            CONV_WORK: begin
                if(fd_adc_conv) next_state <= CONV_TAKE;
                else next_state <= CONV_WORK;
            end
            CONV_TAKE: next_state <= CONV_SEND;
            CONV_SEND: begin
                if(fd_adc_send && fd_com_send) next_state <= CONV_DONE;
                else next_state <= CONV_DONE;
            end
            CONV_DONE: next_state <= MAIN_WAIT;

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) send_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) send_btype <= BAG_INIT;
        else if(State == MAIN_WAIT) send_btype <= BAG_INIT;
        else if(state == LINK_TAKE) send_btype <= BAG_DLINK;
        else if(state == TYPE_TAKE) send_btype <= BAG_DTYPE;
        else if(state == CONF_TAKE) send_btype <= BAG_DTEMP;
        else if(state == CONV_TAKE) send_btype <= BAG_DATA0;
        else send_btype <= send_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_freq <= 4'h0;
        else if(state == MAIN_IDLE) adc_freq <= 4'h0;
        else if(state == CONF_IDLE) adc_freq <= read_btype;
        else adc_freq <= adc_freq;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_type <= 8'h00;
        else if(state == MAIN_IDLE) com_type <= 8'h00;
        else if(state == TYPE_TAKE) com_type <= adc_type;
        else com_type <= com_type;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_temp <= 8'h00;
        else if(state == MAIN_IDLE) com_temp <= 8'h00;
        else if(state == CONF_TAKE) com_temp <= adc_temp[7:0];
        else com_temp <= com_temp;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_stat <= 4'h0;
        else if(state == MAIN_IDLE) com_stat <= 4'h0;
        else if(state == CONV_TAKE) com_stat <= adc_stat;
        else com_stat <= com_stat;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_didx <= 4'h0;
        else if(state == MAIN_IDLE) com_didx <= 4'h0;
        else if(state == TYPE_IDLE) com_didx <= read_btype;
        else com_didx <= com_didx;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_ddidx <= 8'h00;
        else if(state == MAIN_IDLE) com_ddidx <= 8'h00;
        else if(state == CONV_IDLE) com_ddidx <= read_btype;
        else com_ddidx <= com_ddidx;
    end


endmodule