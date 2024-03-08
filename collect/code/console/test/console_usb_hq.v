module console_usb_hq(
    input clk,
    input rst,

    // CONTROL 
    input fs_adc_conf,
    output fd_adc_conf,
    input fs_adc_conv,
    output fd_adc_conv,

    output fs_send,
    input [0:7] fd_send,
    input [0:7] fs_read,
    output fd_read,

    // DATA
    output reg [3:0] send_btype,
    output reg [3:0] read_btype,

    input [15:0] com_cmd,
    input [0:255] cache_stat,
    input [0:7] adc_stat,
    output [95:0] adc_info

);

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    wire [0:7] cmd_fd_send, cmd_fs_read;
    reg ref_fs_send, ref_fd_read;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_DONE = 8'h02;
    localparam CONF_IDLE = 8'h10, CONF_WORK = 8'h11, CONF_WAIT = 8'h12, CONF_READ = 8'h13;
    localparam CONF_DONE = 8'h14;
    localparam CONV_IDLE = 8'h20, CONV_WORK = 8'h21, CONV_WAIT = 8'h22, CONV_READ = 8'h23;
    localparam CONV_DONE = 8'h24;

    reg [0:15] adc_type;
    reg [0:63] adc_temp;
    reg [15:0] adc_conf;

    reg ref_fs_read, ref_fd_send;

    assign adc_info = {adc_conf, adc_type, adc_temp};

    assign cmd_fd_send[0] = adc_stat[0] ?fd_send[0] :ref_fd_send;
    assign cmd_fd_send[1] = adc_stat[1] ?fd_send[1] :ref_fd_send;
    assign cmd_fd_send[2] = adc_stat[2] ?fd_send[2] :ref_fd_send;
    assign cmd_fd_send[3] = adc_stat[3] ?fd_send[3] :ref_fd_send;
    assign cmd_fd_send[4] = adc_stat[4] ?fd_send[4] :ref_fd_send;
    assign cmd_fd_send[5] = adc_stat[5] ?fd_send[5] :ref_fd_send;
    assign cmd_fd_send[6] = adc_stat[6] ?fd_send[6] :ref_fd_send;
    assign cmd_fd_send[7] = adc_stat[7] ?fd_send[7] :ref_fd_send;

    assign cmd_fs_read[0] = adc_stat[0] ?fs_read[0] :ref_fs_read;
    assign cmd_fs_read[1] = adc_stat[1] ?fs_read[1] :ref_fs_read;
    assign cmd_fs_read[2] = adc_stat[2] ?fs_read[2] :ref_fs_read;
    assign cmd_fs_read[3] = adc_stat[3] ?fs_read[3] :ref_fs_read;
    assign cmd_fs_read[4] = adc_stat[4] ?fs_read[4] :ref_fs_read;
    assign cmd_fs_read[5] = adc_stat[5] ?fs_read[5] :ref_fs_read;
    assign cmd_fs_read[6] = adc_stat[6] ?fs_read[6] :ref_fs_read;
    assign cmd_fs_read[7] = adc_stat[7] ?fs_read[7] :ref_fs_read;

    assign fd_adc_conf = (state == CONF_DONE);
    assign fd_adc_conv = (state == CONV_DONE);

    assign fs_send = (state == CONF_WORK) || (state == CONV_WORK);
    assign fd_read = (state == CONF_READ) || (state == CONV_READ);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_adc_conf) next_state <= CONF_IDLE;
                else if(fs_adc_conv) next_state <= CONV_IDLE;
                else next_state <= MAIN_WAIT;
            end
            MAIN_DONE: next_state <= MAIN_WAIT;

            CONF_IDLE: next_state <= CONV_WORK;
            CONF_WORK: begin
                if(cmd_fd_send == 8'hFF) next_state <= CONF_WAIT;
                else next_state <= CONF_WORK;
            end
            CONF_WAIT: begin
                if(cmd_fs_read == 8'hFF) next_state <= CONF_READ;
                else next_state <= CONF_WAIT;
            end
            CONF_READ: begin
                if(cmd_fs_read == 8'h00) next_state <= CONF_DONE;
                else next_state <= CONF_READ;
            end
            CONF_DONE: begin
                if(~fs_adc_conf) next_state <= MAIN_DONE;
                else next_state <= CONF_DONE;
            end

            CONV_IDLE: next_state <= CONV_WORK;
            CONV_WORK: begin
                if(cmd_fd_send == 8'hFF) next_state <= CONV_WAIT;
                else next_state <= CONV_WORK;
            end
            CONV_WAIT: begin
                if(cmd_fs_read == 8'hFF) next_state <= CONV_READ;
                else next_state <= CONV_WAIT;
            end
            CONV_READ: begin
                if(cmd_fs_read == 8'h00) next_state <= CONV_DONE;
                else next_state <= CONV_READ;
            end
            CONV_DONE: begin
                if(~fs_adc_conv) next_state <= MAIN_DONE;
                else next_state <= CONV_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ref_fd_send <= 1'b0;
        else if(adc_stat[0]) ref_fd_send <= fd_send[0];
        else if(adc_stat[1]) ref_fd_send <= fd_send[1];
        else if(adc_stat[2]) ref_fd_send <= fd_send[2];
        else if(adc_stat[3]) ref_fd_send <= fd_send[3];
        else if(adc_stat[4]) ref_fd_send <= fd_send[4];
        else if(adc_stat[5]) ref_fd_send <= fd_send[5];
        else if(adc_stat[6]) ref_fd_send <= fd_send[6];
        else if(adc_stat[7]) ref_fd_send <= fd_send[7];
        else ref_fd_send <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ref_fs_read <= 1'b0;
        else if(adc_stat[0]) ref_fs_read <= fs_read[0];
        else if(adc_stat[1]) ref_fs_read <= fs_read[1];
        else if(adc_stat[2]) ref_fs_read <= fs_read[2];
        else if(adc_stat[3]) ref_fs_read <= fs_read[3];
        else if(adc_stat[4]) ref_fs_read <= fs_read[4];
        else if(adc_stat[5]) ref_fs_read <= fs_read[5];
        else if(adc_stat[6]) ref_fs_read <= fs_read[6];
        else if(adc_stat[7]) ref_fs_read <= fs_read[7];
        else ref_fs_read <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) send_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) send_btype <= BAG_INIT;
        else if(state == CONF_IDLE) send_btype <= BAG_DPARAM;
        else if(state == CONV_IDLE) send_btype <= BAG_DIDX;
        else send_btype <= send_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) read_btype <= BAG_INIT;
        else if(state == MAIN_IDLE) read_btype <= BAG_INIT;
        else if(state == CONF_IDLE) read_btype <= BAG_DTEMP;
        else if(state == CONV_IDLE && read_btype == BAG_DTEMP) read_btype <= BAG_DATA0; 
        else if(state == CONV_IDLE && read_btype == BAG_DATA0) read_btype <= BAG_DATA1;
        else if(state == CONV_IDLE && read_btype == BAG_DATA1) read_btype <= BAG_DATA0;
        else read_btype <= read_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_conf <= 16'h0000;
        else if(state == MAIN_IDLE) adc_conf <= 16'h00;
        else if(state == CONF_DONE) adc_conf <= com_cmd;
        else adc_conf <= adc_conf;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_temp[0:7] <= 8'h00;
        else if(state == MAIN_IDLE) adc_temp[0:7] <= 8'h00;
        else if(state == CONF_DONE && adc_stat[0]) adc_temp[0:7] <= cache_stat[0:7];
        else if(state == CONF_DONE) adc_temp[0:7] <= 8'h00;
        else adc_temp[0:7] <= adc_temp[0:7];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_temp[8:15] <= 8'h00;
        else if(state == MAIN_IDLE) adc_temp[8:15] <= 8'h00;
        else if(state == CONF_DONE && adc_stat[1]) adc_temp[8:15] <= cache_stat[32:39];
        else if(state == CONF_DONE) adc_temp[8:15] <= 8'h00;
        else adc_temp[8:15] <= adc_temp[8:15];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_temp[16:23] <= 8'h00;
        else if(state == MAIN_IDLE) adc_temp[16:23] <= 8'h00;
        else if(state == CONF_DONE && adc_stat[2]) adc_temp[16:23] <= cache_stat[64:71];
        else if(state == CONF_DONE) adc_temp[16:23] <= 8'h00;
        else adc_temp[16:23] <= adc_temp[16:23];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_temp[24:31] <= 8'h00;
        else if(state == MAIN_IDLE) adc_temp[24:31] <= 8'h00;
        else if(state == CONF_DONE && adc_stat[3]) adc_temp[24:31] <= cache_stat[96:103];
        else if(state == CONF_DONE) adc_temp[24:31] <= 8'h00;
        else adc_temp[24:31] <= adc_temp[24:31];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_temp[32:39] <= 8'h00;
        else if(state == MAIN_IDLE) adc_temp[32:39] <= 8'h00;
        else if(state == CONF_DONE && adc_stat[4]) adc_temp[32:39] <= cache_stat[128:135];
        else if(state == CONF_DONE) adc_temp[32:39] <= 8'h00;
        else adc_temp[32:39] <= adc_temp[32:39];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_temp[40:47] <= 8'h00;
        else if(state == MAIN_IDLE) adc_temp[40:47] <= 8'h00;
        else if(state == CONF_DONE && adc_stat[5]) adc_temp[40:47] <= cache_stat[160:167];
        else if(state == CONF_DONE) adc_temp[40:47] <= 8'h00;
        else adc_temp[40:47] <= adc_temp[40:47];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_temp[48:55] <= 8'h00;
        else if(state == MAIN_IDLE) adc_temp[48:55] <= 8'h00;
        else if(state == CONF_DONE && adc_stat[6]) adc_temp[48:55] <= cache_stat[192:199];
        else if(state == CONF_DONE) adc_temp[48:55] <= 8'h00;
        else adc_temp[48:55] <= adc_temp[48:55];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_temp[56:63] <= 8'h00;
        else if(state == MAIN_IDLE) adc_temp[56:63] <= 8'h00;
        else if(state == CONF_DONE && adc_stat[7]) adc_temp[56:63] <= cache_stat[224:231];
        else if(state == CONF_DONE) adc_temp[56:63] <= 8'h00;
        else adc_temp[56:63] <= adc_temp[56:63];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_type[0:1] <= 2'b00;
        else if(state == MAIN_IDLE) adc_type[0:1] <= 2'b00;
        else if(state == CONF_DONE && adc_stat[0] && cache_stat[8:15] == 8'h55) adc_type[0:1] <= 2'b01;  
        else if(state == CONF_DONE && adc_stat[0] && cache_stat[8:15] == 8'hAA) adc_type[0:1] <= 2'b10;  
        else if(state == CONF_DONE && adc_stat[0] && cache_stat[8:15] == 8'hFF) adc_type[0:1] <= 2'b11;  
        else if(state == CONF_DONE) adc_type[0:1] = 2'b00;
        else adc_type[0:1] <= adc_type[0:1];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_type[2:3] <= 2'b00;
        else if(state == MAIN_IDLE) adc_type[2:3] <= 2'b00;
        else if(state == CONF_DONE && adc_stat[1] && cache_stat[40:47] == 8'h55) adc_type[2:3] <= 2'b01;  
        else if(state == CONF_DONE && adc_stat[1] && cache_stat[40:47] == 8'hAA) adc_type[2:3] <= 2'b10;  
        else if(state == CONF_DONE && adc_stat[1] && cache_stat[40:47] == 8'hFF) adc_type[2:3] <= 2'b11;  
        else if(state == CONF_DONE) adc_type[2:3] = 2'b00;
        else adc_type[2:3] <= adc_type[2:3];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_type[4:5] <= 2'b00;
        else if(state == MAIN_IDLE) adc_type[4:5] <= 2'b00;
        else if(state == CONF_DONE && adc_stat[2] && cache_stat[72:79] == 8'h55) adc_type[4:5] <= 2'b01;  
        else if(state == CONF_DONE && adc_stat[2] && cache_stat[72:79] == 8'hAA) adc_type[4:5] <= 2'b10;  
        else if(state == CONF_DONE && adc_stat[2] && cache_stat[72:79] == 8'hFF) adc_type[4:5] <= 2'b11;  
        else if(state == CONF_DONE) adc_type[4:5] = 2'b00;
        else adc_type[4:5] <= adc_type[4:5];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_type[6:7] <= 2'b00;
        else if(state == MAIN_IDLE) adc_type[6:7] <= 2'b00;
        else if(state == CONF_DONE && adc_stat[3] && cache_stat[104:111] == 8'h55) adc_type[6:7] <= 2'b01;  
        else if(state == CONF_DONE && adc_stat[3] && cache_stat[104:111] == 8'hAA) adc_type[6:7] <= 2'b10;  
        else if(state == CONF_DONE && adc_stat[3] && cache_stat[104:111] == 8'hFF) adc_type[6:7] <= 2'b11;  
        else if(state == CONF_DONE) adc_type[6:7] = 2'b00;
        else adc_type[6:7] <= adc_type[6:7];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_type[8:9] <= 2'b00;
        else if(state == MAIN_IDLE) adc_type[8:9] <= 2'b00;
        else if(state == CONF_DONE && adc_stat[4] && cache_stat[136:143] == 8'h55) adc_type[8:9] <= 2'b01;  
        else if(state == CONF_DONE && adc_stat[4] && cache_stat[136:143] == 8'hAA) adc_type[8:9] <= 2'b10;  
        else if(state == CONF_DONE && adc_stat[4] && cache_stat[136:143] == 8'hFF) adc_type[8:9] <= 2'b11;  
        else if(state == CONF_DONE) adc_type[8:9] = 2'b00;
        else adc_type[8:9] <= adc_type[8:9];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_type[10:11] <= 2'b00;
        else if(state == MAIN_IDLE) adc_type[10:11] <= 2'b00;
        else if(state == CONF_DONE && adc_stat[5] && cache_stat[168:175] == 8'h55) adc_type[10:11] <= 2'b01;  
        else if(state == CONF_DONE && adc_stat[5] && cache_stat[168:175] == 8'hAA) adc_type[10:11] <= 2'b10;  
        else if(state == CONF_DONE && adc_stat[5] && cache_stat[168:175] == 8'hFF) adc_type[10:11] <= 2'b11;  
        else if(state == CONF_DONE) adc_type[10:11] = 2'b00;
        else adc_type[10:11] <= adc_type[10:11];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_type[12:13] <= 2'b00;
        else if(state == MAIN_IDLE) adc_type[12:13] <= 2'b00;
        else if(state == CONF_DONE && adc_stat[6] && cache_stat[200:207] == 8'h55) adc_type[12:13] <= 2'b01;  
        else if(state == CONF_DONE && adc_stat[6] && cache_stat[200:207] == 8'hAA) adc_type[12:13] <= 2'b10;  
        else if(state == CONF_DONE && adc_stat[6] && cache_stat[200:207] == 8'hFF) adc_type[12:13] <= 2'b11;  
        else if(state == CONF_DONE) adc_type[12:13] = 2'b00;
        else adc_type[12:13] <= adc_type[12:13];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) adc_type[14:15] <= 2'b00;
        else if(state == MAIN_IDLE) adc_type[14:15] <= 2'b00;
        else if(state == CONF_DONE && adc_stat[7] && cache_stat[232:239] == 8'h55) adc_type[14:15] <= 2'b01;  
        else if(state == CONF_DONE && adc_stat[7] && cache_stat[232:239] == 8'hAA) adc_type[14:15] <= 2'b10;  
        else if(state == CONF_DONE && adc_stat[7] && cache_stat[232:239] == 8'hFF) adc_type[14:15] <= 2'b11;  
        else if(state == CONF_DONE) adc_type[14:15] = 2'b00;
        else adc_type[14:15] <= adc_type[14:15];
    end


endmodule