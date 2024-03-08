module console_usb_sub(
    input clk,
    input rst,

    input fs_send_dlv,
    output fd_send_dlv,
    output fs_read_rly,
    input fd_read_rly,
    input [3:0] dlv_send_btype,
    output reg [3:0] rly_read_btype,

    output fs_send,
    input fd_send,
    output reg [3:0] send_btype,

    input fs_read,
    output fd_read,
    input [3:0] read_btype,

    input [3:0] device_idx,
    input [3:0] data_idx,
    input [15:0] device_cmd,
    output reg [31:0] cache_cmd,

    input [31:0] cache_stat,
    output reg [15:0] device_stat
);

    localparam ADC_RAM_ADDR_DATA0 = 12'h000, ADC_RAM_ADDR_DATA1 = 12'h240;
    localparam ADC_RAM_ADDR_DATA2 = 12'h480, ADC_RAM_ADDR_DATA3 = 12'h6C0;
    localparam ADC_RAM_ADDR_DATA4 = 12'h900, ADC_RAM_ADDR_DATA5 = 12'hB40;

    localparam BAG_INIT = 4'b0000;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_WORK = 8'h02, MAIN_DOOR = 8'h03;
    localparam LINK_IDLE = 8'h10, LINK_TAKE = 8'h11;
    localparam TYPE_WAIT = 8'h20, TYPE_WORK = 8'h21;
    localparam TYPE_IDLE = 8'h30, TYPE_TAKE = 8'h31;
    localparam TEMP_IDLE = 8'h40, TEMP_TAKE = 8'h41, TEMP_DONE = 8'h42;
    localparam DATA0_IDLE = 8'h50, DATA_TAKE = 8'h51, DATA_DONE = 8'h52, DATA1_IDLE = 8'h53;
    localparam CONF_IDLE = 8'h60, CONF_WAIT = 8'h61, CONF_WORK = 8'h62, CONF_DONE = 8'h63;
    localparam CONV_IDLE = 8'h70, CONV_WAIT = 8'h71, CONV_WORK = 8'h72, CONV_DONE = 8'h73;

    wire [7:0] device_type;
    wire [7:0] device_temp;
    wire [3:0] device_stat;

    assign device_temp = cache_stat[31:24];
    assign device_type = cache_stat[23:16];
    assign deivce_stat = cache_stat[15:12];

    reg [7:0] num;

    assign fs_send = (state == TYPE_WORK) || (state == CONF_WORK) || (state == CONV_WORK); 
    assign fd_send_dlv = (state == CONF_DONE) || (state == CONV_DONE);
    assign fs_read_rly = (state == TEMP_DONE) || (state == DATA_DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_read) next_state <= MAIN_TAKE;
                else if(fs_send_dlv) next_state <= MAIN_DOOR;
                else next_state <= MAIN_WAIT;
            end
            MAIN_TAKE: begin
                if(~fs_read) next_state <= MAIN_WORK;
                else next_state <= MAIN_TAKE;
            end
            MAIN_WORK: begin
                if(read_btype == BAG_DLINK) next_state <= LINK_IDLE;
                else if(read_btype == BAG_DTYPE) next_state <= TYPE_IDLE;
                else if(read_btype == BAG_DTEMP) next_state <= TEMP_IDLE;
                else if(read_btype == BAG_DATA0) next_state <= DATA_IDLE;
                else if(read_btype == BAG_DATA1) next_state <= DATA_IDLE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_DOOR: begin
                if(dlv_send_btype == BAG_DPARAM) next_state <= CONF_IDLE;
                else if(dlv_send_btype == BAG_DDIDX) next_state <= CONV_IDLE;
                else next_state <= CONV_DONE;
            end

            LINK_IDLE: next_state <= LINK_TAKE;
            LINK_TAKE: next_state <= TYPE_WAIT;
            TYPE_WAIT: begin
                if(num >= CNUM - 1'b1) next_state <= TYPE_WORK;
                else next_state <= TYPE_WAIT;
            end
            TYPE_WORK: begin
                if(fd_send) next_state <= MAIN_WAIT;
                else next_state <= TYPE_WORK;
            end

            TYPE_IDLE: next_state <= TYPE_TAKE;
            TYPE_TAKE: next_state <= MAIN_WAIT;

            TEMP_IDLE: next_state <= TEMP_TAKE;
            TEMP_TAKE: next_state <= TEMP_DONE;
            TEMP_DONE: begin
                if(fd_read_rly) next_state <= MAIN_WAIT;
                else next_state <= TEMP_DONE;
            end

            DATA0_IDLE: next_state <= DATA_TAKE;
            DATA1_IDLE: next_state <= DATA_TAKE;
            DATA_TAKE: next_state <= DATA_DONE;
            DATA_DONE: begin
                if(fd_read_rly) next_state <= MAIN_WAIT;
                else next_state <= DATA_DONE;
            end

            CONF_IDLE: next_state <= CONF_WAIT;
            CONF_WAIT: next_state <= CONF_WORK;
            CONF_WORK: begin
                if(fd_send) next_state <= CONF_DONE;
                else next_state <= CONF_WORK;
            end
            CONF_DONE: begin
                if(~fs_send_dlv) next_state <= MAIN_WAIT;
                else next_state <= CONF_DONE;
            end

            CONV_IDLE: next_state <= CONV_WAIT;
            CONV_WAIT: next_state <= CONV_WORK;
            CONV_WORK: begin
                if(fd_send) next_state <= CONV_DONE;
                else next_state <= CONV_WORK;
            end
            CONV_DONE: begin
                if(~fs_send_dlv) next_state <= MAIN_WAIT;
                else next_state <= CONV_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rly_read_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) rly_read_btype <= BAG_INIT;
        else if(state == MAIN_WAIT) rly_read_btype <= BAG_INIT;
        else if(state == TEMP_TAKE) rly_read_btype <= BAG_DTEMP;
        else if(state == DATA0_IDLE) rly_read_btype <= BAG_DATA0;
        else if(state == DATA1_IDLE) rly_read_btype <= BAG_DATA1;
        else rly_read_btype <= rly_read_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) send_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) send_btype <= BAG_INIT;
        else if(state == MAIN_WAIT) send_btype <= BAG_INIT;
        else if(state == LINK_TAKE) send_btype <= BAG_DTYPE; 
        else if(state == CONF_WAIT) send_btype <= BAG_DPARAM;
        else if(state == CONV_WAIT) send_btype <= BAG_DDIDX;
        else send_btype <= send_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cache_cmd <= 32'h00;
        else if(state == MAIN_IDLE) cache_cmd <= 32'h00;
        else if(state == LINK_TAKE) cache_cmd[31:28] <= device_idx; 
        else if(state == CONF_WAIT) cache_cmd[23:8] <= device_cmd;
        else if(state == CONV_WAIT) cache_cmd[27:24] <= data_idx;
        else cache_cmd <= cache_cmd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_stat <= 16'h00;
        else if(state == MAIN_IDLE) device_stat <= 16'h00;
        else if(state == TYPE_TAKE && device_type == 8'hFF) device_stat[13:12] == 2'h3;
        else if(state == TYPE_TAKE && device_type == 8'hF0) device_stat[13:12] == 2'h2;
        else if(state == TYPE_TAKE && device_type == 8'hC0) device_stat[13:12] == 2'h1;
        else if(state == LINK_TAKE) device_stat[15] <= 1'b1; 
        else if(state == DATA0_IDLE) deivce_stat[14] <= 1'b0;
        else if(state == DATA1_IDLE) deivce_stat[14] <= 1'b1;
        else if(state == DATA_TAKE && device_type == 8'hFF && device_stat == 4'hF) device_stat[15] <= 1'b1; 
        else if(state == DATA_TAKE && device_type == 8'hF0 && device_stat == 4'hC) device_stat[15] <= 1'b1; 
        else if(state == DATA_TAKE && device_type == 8'hC0 && device_stat == 4'h8) device_stat[15] <= 1'b1; 
        else if(state == DATA_TAKE) device_stat[15] <= 1'b0;
        else if(state == DATA_TAKE) device_stat[11:8] <= cache_stat[7:4];
        else if(state == TEMP_TAKE) device_stat[7:0] <= device_temp;
    end



endmodule