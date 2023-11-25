module console_usb_hq(
    input clk,
    input rst,

    input fs_adc_conf,
    output fd_adc_conf,

    input fs_adc_conv,
    output fd_adc_conv,

    input [0:255] cache_stat,

    output fs_send,
    input [0:7] cache_fd_send,
    output reg [3:0] send_btype,
    input [0:7] cache_fs_read,
    output fd_read,
    output reg [3:0] read_btype,

    input [15:0] device_cmd, // {freq_samp, filt_up, filt_low, 4'h0};
    output reg [15:0] conf_cmd,

    output [95:0] device_info, // {device_conf(16), device_type(16), device_temp(64)}

    input [0:7] device_stat
);

    localparam BAG_INIT = 4'b0000;
    localparam BAG_ACK = 4'b0001, BAG_NAK = 4'b0010, BAG_STL = 4'b0011;
    localparam BAG_DIDX = 4'b0101, BAG_DPARAM = 4'b0110, BAG_DDIDX = 4'b0111;
    localparam BAG_DLINK = 4'b1000, BAG_DTYPE = 4'b1001, BAG_DTEMP = 4'b1010;
    localparam BAG_DATA0 = 4'b1101, BAG_DATA1 = 4'b1110;
    localparam BAG_ERROR = 4'b1111;

    wire [0:7] cmd_fd_send, cmd_fs_read;
    reg ref_fd_send, ref_fs_read;

    reg [7:0] state, next_state;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_DONE = 8'h02;
    localparam CONF_IDLE = 8'h10, CONF_WORK = 8'h11, CONF_WAIT = 8'h12, CONF_READ = 8'h13;
    localparam CONF_DONE = 8'h14;
    localparam CONV_IDLE = 8'h20, CONV_WORK = 8'h21, CONV_WAIT = 8'h22, CONV_READ = 8'h23;
    localparam CONV_DONE = 8'h24;

    reg [15:0] device_conf; 
    reg [0:15] device_type;
    reg [0:63] device_temp;

    assign device_info = {device_conf, device_type, device_temp};

    assign cmd_fd_send[0] = device_stat[0] ?cache_fd_send[0] :ref_fd_send;
    assign cmd_fd_send[1] = device_stat[1] ?cache_fd_send[1] :ref_fd_send;
    assign cmd_fd_send[2] = device_stat[2] ?cache_fd_send[2] :ref_fd_send;
    assign cmd_fd_send[3] = device_stat[3] ?cache_fd_send[3] :ref_fd_send;
    assign cmd_fd_send[4] = device_stat[4] ?cache_fd_send[4] :ref_fd_send;
    assign cmd_fd_send[5] = device_stat[5] ?cache_fd_send[5] :ref_fd_send;
    assign cmd_fd_send[6] = device_stat[6] ?cache_fd_send[6] :ref_fd_send;
    assign cmd_fd_send[7] = device_stat[7] ?cache_fd_send[7] :ref_fd_send;

    assign cmd_fs_read[0] = device_stat[0] ?cache_fs_read[0] :ref_fs_read;
    assign cmd_fs_read[1] = device_stat[1] ?cache_fs_read[1] :ref_fs_read;
    assign cmd_fs_read[2] = device_stat[2] ?cache_fs_read[2] :ref_fs_read;
    assign cmd_fs_read[3] = device_stat[3] ?cache_fs_read[3] :ref_fs_read;
    assign cmd_fs_read[4] = device_stat[4] ?cache_fs_read[4] :ref_fs_read;
    assign cmd_fs_read[5] = device_stat[5] ?cache_fs_read[5] :ref_fs_read;
    assign cmd_fs_read[6] = device_stat[6] ?cache_fs_read[6] :ref_fs_read;
    assign cmd_fs_read[7] = device_stat[7] ?cache_fs_read[7] :ref_fs_read;

    assign fd_adc_conf = (state == CONF_DONE);
    assign fd_adc_conv = (state == CONV_DONE);

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
        else if(device_stat[0]) ref_fd_send <= cache_fd_send[0];
        else if(device_stat[1]) ref_fd_send <= cache_fd_send[1];
        else if(device_stat[2]) ref_fd_send <= cache_fd_send[2];
        else if(device_stat[3]) ref_fd_send <= cache_fd_send[3];
        else if(device_stat[4]) ref_fd_send <= cache_fd_send[4];
        else if(device_stat[5]) ref_fd_send <= cache_fd_send[5];
        else if(device_stat[6]) ref_fd_send <= cache_fd_send[6];
        else if(device_stat[7]) ref_fd_send <= cache_fd_send[7];
        else ref_fd_send <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) ref_fd_send <= 1'b0;
        else if(device_stat[0]) ref_fs_read <= cache_fs_read[0];
        else if(device_stat[1]) ref_fs_read <= cache_fs_read[1];
        else if(device_stat[2]) ref_fs_read <= cache_fs_read[2];
        else if(device_stat[3]) ref_fs_read <= cache_fs_read[3];
        else if(device_stat[4]) ref_fs_read <= cache_fs_read[4];
        else if(device_stat[5]) ref_fs_read <= cache_fs_read[5];
        else if(device_stat[6]) ref_fs_read <= cache_fs_read[6];
        else if(device_stat[7]) ref_fs_read <= cache_fs_read[7];
        else ref_fd_send <= 1'b0;
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
        if(rst) conf_cmd <= 16'h0000;
        else if(state == MAIN_IDLE) conf_cmd <= 16'h0000;
        else if(state == CONF_IDLE) conf_cmd <= device_cmd;
        else conf_cmd <= conf_cmd;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_conf <= 16'h0000;
        else if(state == MAIN_IDLE) device_conf <= 16'h00;
        else if(state == CONF_DONE) device_conf <= device_cmd;
        else device_conf <= device_conf;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp[0:7] <= 8'h00;
        else if(state == MAIN_IDLE) device_temp[0:7] <= 8'h00;
        else if(state == CONF_DONE && device_stat[0]) device_temp[0:7] <= cache_stat[0:7];
        else if(state == CONF_DONE) device_temp[0:7] <= 8'h00;
        else device_temp[0:7] <= device_temp[0:7];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp[8:15] <= 8'h00;
        else if(state == MAIN_IDLE) device_temp[8:15] <= 8'h00;
        else if(state == CONF_DONE && device_stat[1]) device_temp[8:15] <= cache_stat[32:39];
        else if(state == CONF_DONE) device_temp[8:15] <= 8'h00;
        else device_temp[8:15] <= device_temp[8:15];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp[16:23] <= 8'h00;
        else if(state == MAIN_IDLE) device_temp[16:23] <= 8'h00;
        else if(state == CONF_DONE && device_stat[2]) device_temp[16:23] <= cache_stat[64:71];
        else if(state == CONF_DONE) device_temp[16:23] <= 8'h00;
        else device_temp[16:23] <= device_temp[16:23];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp[24:31] <= 8'h00;
        else if(state == MAIN_IDLE) device_temp[24:31] <= 8'h00;
        else if(state == CONF_DONE && device_stat[3]) device_temp[24:31] <= cache_stat[96:103];
        else if(state == CONF_DONE) device_temp[24:31] <= 8'h00;
        else device_temp[24:31] <= device_temp[24:31];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp[32:39] <= 8'h00;
        else if(state == MAIN_IDLE) device_temp[32:39] <= 8'h00;
        else if(state == CONF_DONE && device_stat[4]) device_temp[32:39] <= cache_stat[128:135];
        else if(state == CONF_DONE) device_temp[32:39] <= 8'h00;
        else device_temp[32:39] <= device_temp[32:39];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp[40:47] <= 8'h00;
        else if(state == MAIN_IDLE) device_temp[0:7] <= 8'h00;
        else if(state == CONF_DONE && device_stat[5]) device_temp[40:47] <= cache_stat[160:167];
        else if(state == CONF_DONE) device_temp[40:47] <= 8'h00;
        else device_temp[40:47] <= device_temp[40:47];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp[48:55] <= 8'h00;
        else if(state == MAIN_IDLE) device_temp[48:55] <= 8'h00;
        else if(state == CONF_DONE && device_stat[6]) device_temp[48:55] <= cache_stat[192:199];
        else if(state == CONF_DONE) device_temp[48:55] <= 8'h00;
        else device_temp[48:55] <= device_temp[48:55];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_temp[56:63] <= 8'h00;
        else if(state == MAIN_IDLE) device_temp[56:63] <= 8'h00;
        else if(state == CONF_DONE && device_stat[7]) device_temp[56:63] <= cache_stat[224:231];
        else if(state == CONF_DONE) device_temp[56:63] <= 8'h00;
        else device_temp[56:63] <= device_temp[56:63];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type[0:1] <= 2'b00;
        else if(state == MAIN_IDLE) device_type[0:1] <= 2'b00;
        else if(state == CONF_DONE && device_stat[0] && cache_stat[8:15] == 8'h55) device_type[0:1] <= 2'b01;  
        else if(state == CONF_DONE && device_stat[0] && cache_stat[8:15] == 8'hAA) device_type[0:1] <= 2'b10;  
        else if(state == CONF_DONE && device_stat[0] && cache_stat[8:15] == 8'hFF) device_type[0:1] <= 2'b11;  
        else if(state == CONF_DONE) device_type[0:1] = 2'b00;
        else device_type[0:1] <= device_type[0:1];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type[2:3] <= 2'b00;
        else if(state == MAIN_IDLE) device_type[2:3] <= 2'b00;
        else if(state == CONF_DONE && device_stat[1] && cache_stat[40:47] == 8'h55) device_type[2:3] <= 2'b01;  
        else if(state == CONF_DONE && device_stat[1] && cache_stat[40:47] == 8'hAA) device_type[2:3] <= 2'b10;  
        else if(state == CONF_DONE && device_stat[1] && cache_stat[40:47] == 8'hFF) device_type[2:3] <= 2'b11;  
        else if(state == CONF_DONE) device_type[2:3] = 2'b00;
        else device_type[2:3] <= device_type[2:3];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type[4:5] <= 2'b00;
        else if(state == MAIN_IDLE) device_type[4:5] <= 2'b00;
        else if(state == CONF_DONE && device_stat[2] && cache_stat[72:79] == 8'h55) device_type[4:5] <= 2'b01;  
        else if(state == CONF_DONE && device_stat[2] && cache_stat[72:79] == 8'hAA) device_type[4:5] <= 2'b10;  
        else if(state == CONF_DONE && device_stat[2] && cache_stat[72:79] == 8'hFF) device_type[4:5] <= 2'b11;  
        else if(state == CONF_DONE) device_type[4:5] = 2'b00;
        else device_type[4:5] <= device_type[4:5];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type[6:7] <= 2'b00;
        else if(state == MAIN_IDLE) device_type[6:7] <= 2'b00;
        else if(state == CONF_DONE && device_stat[3] && cache_stat[104:111] == 8'h55) device_type[6:7] <= 2'b01;  
        else if(state == CONF_DONE && device_stat[3] && cache_stat[104:111] == 8'hAA) device_type[6:7] <= 2'b10;  
        else if(state == CONF_DONE && device_stat[3] && cache_stat[104:111] == 8'hFF) device_type[6:7] <= 2'b11;  
        else if(state == CONF_DONE) device_type[6:7] = 2'b00;
        else device_type[6:7] <= device_type[6:7];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type[8:9] <= 2'b00;
        else if(state == MAIN_IDLE) device_type[8:9] <= 2'b00;
        else if(state == CONF_DONE && device_stat[4] && cache_stat[136:143] == 8'h55) device_type[8:9] <= 2'b01;  
        else if(state == CONF_DONE && device_stat[4] && cache_stat[136:143] == 8'hAA) device_type[8:9] <= 2'b10;  
        else if(state == CONF_DONE && device_stat[4] && cache_stat[136:143] == 8'hFF) device_type[8:9] <= 2'b11;  
        else if(state == CONF_DONE) device_type[8:9] = 2'b00;
        else device_type[8:9] <= device_type[8:9];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type[10:11] <= 2'b00;
        else if(state == MAIN_IDLE) device_type[10:11] <= 2'b00;
        else if(state == CONF_DONE && device_stat[5] && cache_stat[168:175] == 8'h55) device_type[10:11] <= 2'b01;  
        else if(state == CONF_DONE && device_stat[5] && cache_stat[168:175] == 8'hAA) device_type[10:11] <= 2'b10;  
        else if(state == CONF_DONE && device_stat[5] && cache_stat[168:175] == 8'hFF) device_type[10:11] <= 2'b11;  
        else if(state == CONF_DONE) device_type[10:11] = 2'b00;
        else device_type[10:11] <= device_type[10:11];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type[12:13] <= 2'b00;
        else if(state == MAIN_IDLE) device_type[12:13] <= 2'b00;
        else if(state == CONF_DONE && device_stat[6] && cache_stat[200:207] == 8'h55) device_type[12:13] <= 2'b01;  
        else if(state == CONF_DONE && device_stat[6] && cache_stat[200:207] == 8'hAA) device_type[12:13] <= 2'b10;  
        else if(state == CONF_DONE && device_stat[6] && cache_stat[200:207] == 8'hFF) device_type[12:13] <= 2'b11;  
        else if(state == CONF_DONE) device_type[12:13] = 2'b00;
        else device_type[12:13] <= device_type[12:13];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) device_type[14:15] <= 2'b00;
        else if(state == MAIN_IDLE) device_type[14:15] <= 2'b00;
        else if(state == CONF_DONE && device_stat[7] && cache_stat[232:239] == 8'h55) device_type[14:15] <= 2'b01;  
        else if(state == CONF_DONE && device_stat[7] && cache_stat[232:239] == 8'hAA) device_type[14:15] <= 2'b10;  
        else if(state == CONF_DONE && device_stat[7] && cache_stat[232:239] == 8'hFF) device_type[14:15] <= 2'b11;  
        else if(state == CONF_DONE) device_type[14:15] = 2'b00;
        else device_type[14:15] <= device_type[14:15];
    end




endmodule