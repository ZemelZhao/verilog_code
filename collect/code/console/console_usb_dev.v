module console_usb_dev(
    input clk,
    input rst,

    input fs_send,
    output fd_send,
    output fs_read,
    input fd_read,

    output fs_usb_send,
    input fd_usb_send,
    (*MARK_DEBUG = "true"*)input ff_usb_send,
    input fs_usb_read,
    output fd_usb_read,

    input [3:0] send_btype,
    input [3:0] read_btype,
    output reg [3:0] send_usb_btype,
    input [3:0] read_usb_btype,

    input [3:0] device_idx,
    input [3:0] data_idx,
    input [11:0] com_cmd,
    output reg [31:0] usb_cmd,

    input [31:0] usb_stat,
    output [9:0] dev_stat
);

    (*MARK_DEBUG = "true"*)reg [9:0] state; 
    reg [9:0] next_state;
    localparam MAIN_IDLE = 10'h000;
    localparam MAIN_WAIT = 10'h001, MAIN_TAKE = 10'h002, MAIN_WORK = 10'h004, MAIN_DOOR = 10'h008;
    localparam LINK_IDLE = 10'h011, LINK_TAKE = 10'h012, DIDX_WAIT = 10'h014, DIDX_WORK = 10'h018;
    localparam TYPE_IDLE = 10'h021, TYPE_TAKE = 10'h022, TYPE_DONE = 10'h024;
    localparam TEMP_IDLE = 10'h041, TEMP_TAKE = 10'h042, TEMP_DONE = 10'h044;
    localparam DATA_IDLE = 10'h081, DATA_TAKE = 10'h082, DATA_DONE = 10'h084;
    localparam CONF_IDLE = 10'h101, CONF_WAIT = 10'h102, CONF_WORK = 10'h104, CONF_DONE = 10'h108;
    localparam CONV_IDLE = 10'h201, CONV_WAIT = 10'h202, CONV_WORK = 10'h204, CONV_DONE = 10'h208;
    localparam IDLE_IDLE = 10'h301, IDLE_WAIT = 10'h302, IDLE_WORK = 10'h304, IDLE_DONE = 10'h308;

    localparam BAG_INIT = 4'b0000;
    localparam BAG_LINK = 4'b0100;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110, BAG_DATA = 4'b0101;

    localparam BAG_DCONF = 4'b0001, BAG_DCONV = 4'b1001, BAG_CLINK = 4'b1011;

    wire [7:0] usb_temp, usb_type;
    wire [3:0] usb_link, usb_idx, usb_didx;
    localparam DEV_STAT = 4'hF;

    reg [7:0] dev_temp;
    reg [1:0] dev_type;
    reg dev_link;
    wire cri_stat;

    wire fd_com_send;
    wire fs_com_read;

    assign cri_stat = (usb_idx == device_idx);

    assign fd_com_send = (state == CONF_DONE) || (state == CONV_DONE) || (state == IDLE_DONE);
    assign fs_com_read = (state == TYPE_DONE) || (state == TEMP_DONE) || (state == DATA_DONE);
    assign fs_usb_send = (state == DIDX_WORK) || (state == CONF_WORK) || (state == CONV_WORK) || (state == IDLE_WORK); 
    assign fd_usb_read = (state == MAIN_TAKE);

    assign usb_temp = usb_stat[31:24];
    assign usb_type = usb_stat[23:16];
    assign usb_link = usb_stat[15:12];
    assign usb_idx = usb_stat[11:8];
    assign usb_didx = usb_stat[7:4];

    assign fd_send = dev_link ?fd_com_send :1'b1;
    assign fs_read = dev_link ?fs_com_read :~fd_read;

    assign dev_stat[9:8] = dev_link ?dev_type :2'b00;
    assign dev_stat[7:0] = dev_temp;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_usb_read) next_state <= MAIN_TAKE;
                else if(fs_send) next_state <= MAIN_DOOR;
                else next_state <= MAIN_WAIT;
            end

            MAIN_TAKE: begin
                if(~fs_usb_read) next_state <= MAIN_WORK;
                else next_state <= MAIN_TAKE;
            end
            MAIN_WORK: begin
                if(read_usb_btype == BAG_DLINK) next_state <= LINK_IDLE;
                else if(read_usb_btype == BAG_DTYPE) next_state <= TYPE_IDLE;
                else if(read_usb_btype == BAG_DTEMP) next_state <= TEMP_IDLE;
                else if(read_usb_btype == BAG_DATA0) next_state <= DATA_IDLE;
                else if(read_usb_btype == BAG_DATA1) next_state <= DATA_IDLE;
                else next_state <= MAIN_WAIT;
            end

            MAIN_DOOR: begin
                if(send_btype == BAG_DCONF) next_state <=  CONF_IDLE;
                else if(send_btype == BAG_DCONV) next_state <= CONV_IDLE; 
                else if(send_btype == BAG_CLINK) next_state <= IDLE_IDLE;
                else next_state <= MAIN_WAIT;
            end

            IDLE_IDLE: next_state <= IDLE_WAIT;
            IDLE_WAIT: next_state <= IDLE_WORK;
            IDLE_WORK: begin
                if(fd_usb_send) next_state <= IDLE_DONE;
                else next_state <= IDLE_WORK;
            end
            IDLE_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= IDLE_DONE;
            end

            LINK_IDLE: next_state <= LINK_TAKE;
            LINK_TAKE: next_state <= DIDX_WAIT;
            DIDX_WAIT: next_state <= DIDX_WORK;
            DIDX_WORK: begin
                if(fd_usb_send) next_state <= MAIN_WAIT;
                else next_state <= DIDX_WORK;
            end

            TYPE_IDLE: next_state <= TYPE_TAKE;
            TYPE_TAKE: next_state <= MAIN_WAIT;
            TYPE_DONE: begin
                if(fd_read) next_state <= MAIN_WAIT;
                else next_state <= TYPE_DONE;
            end

            TEMP_IDLE: next_state <= TEMP_TAKE;
            TEMP_TAKE: next_state <= TEMP_DONE;
            TEMP_DONE: begin
                if(fd_read) next_state <= MAIN_WAIT;
                else next_state <= TEMP_DONE;
            end

            DATA_IDLE: next_state <= DATA_TAKE;
            DATA_TAKE: next_state <= DATA_DONE;
            DATA_DONE: begin
                if(fd_read) next_state <= MAIN_WAIT;
                else next_state <= DATA_DONE;
            end

            CONF_IDLE: next_state <= CONF_WAIT;
            CONF_WAIT: next_state <= CONF_WORK;
            CONF_WORK: begin
                if(fd_usb_send) next_state <= CONF_DONE;
                else next_state <= CONF_WORK;
            end
            CONF_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= CONF_DONE;
            end

            CONV_IDLE: next_state <= CONV_WAIT;
            CONV_WAIT: next_state <= CONV_WORK;
            CONV_WORK: begin
                if(fd_usb_send) next_state <= CONV_DONE;
                else next_state <= CONV_WORK;
            end
            CONV_DONE: begin
                if(~fs_send) next_state <= MAIN_WAIT;
                else next_state <= CONV_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) usb_cmd <= 32'h00;
        else if(state == LINK_IDLE) usb_cmd <= {device_idx, 28'h0000};
        else if(state == MAIN_DOOR) usb_cmd <= {device_idx, data_idx, com_cmd, 12'h000};
        else usb_cmd <= usb_cmd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dev_temp <= 8'h00;
        else if(state == TEMP_TAKE) dev_temp <= usb_stat[31:24];
        else dev_temp <= dev_temp;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dev_type <= 2'b00;
        else if(state == TYPE_TAKE && usb_type == 8'hC0) dev_type <= 2'b01;
        else if(state == TYPE_TAKE && usb_type == 8'hF0) dev_type <= 2'b10;
        else if(state == TYPE_TAKE && usb_type == 8'hFF) dev_type <= 2'b11;
        else dev_type <= dev_type;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) dev_link <= 1'b0;
        else if(state == MAIN_IDLE) dev_link <= 1'b0;
        else if(state == LINK_TAKE) dev_link <= 1'b1;
        else if(state == TEMP_TAKE && read_btype != BAG_DTEMP) dev_link <= 1'b0;
        else if(state == DATA_TAKE && read_btype != BAG_DATA && cri_stat) dev_link <= 1'b0;
        else if(state == DATA_TAKE && dev_type == 2'b01 && usb_link != 4'h8) dev_link <= 1'b0;
        else if(state == DATA_TAKE && dev_type == 2'b10 && usb_link != 4'hC) dev_link <= 1'b0;
        else if(state == DATA_TAKE && dev_type == 2'b11 && usb_link != 4'hF) dev_link <= 1'b0;
        else if(ff_usb_send) dev_link <= 1'b0;
        else dev_link <= dev_link;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) send_usb_btype <= BAG_INIT;
        else if(state == DIDX_WAIT) send_usb_btype <= BAG_DIDX;
        else if(state == CONF_WAIT) send_usb_btype <= BAG_DPARAM;
        else if(state == CONV_WAIT) send_usb_btype <= BAG_DDIDX;
        else if(state == IDLE_WAIT) send_usb_btype <= BAG_LINK;
        else send_usb_btype <= send_usb_btype;
    end

endmodule