module console_cs(
    input clk,
    input rst,

    output fs_adc_conf_send,
    input fd_adc_conf_send,
    input fs_adc_conf_read,
    output fd_adc_conf_read,

    output fs_adc_conv_send,
    input fd_adc_conv_send,
    input fs_adc_conv_read,
    output fd_adc_conv_read,

    output fs_com_read_send,
    input fd_com_read_send,
    input fs_com_read_read,
    output fd_com_read_read,
    
    output fs_com_send_send,
    input fd_com_send_send,
    input fs_com_send_read,
    output fd_com_send_read,

    input fs_com_read,
    output fd_com_read,
    input [3:0] com_read_btype,
    output reg [3:0] com_send_btype,

    output reg fs_cd,
    input fs_cd,
    output fd_cd
);

    localparam BAG_INIT = 4'h0; 
    localparam BAG_LINK = 4'h1, BAG_CONF = 4'h5, BAG_WORK = 4'h9, BAG_STOP = 4'hD;
    localparam BAG_TYPE = 4'h1, BAG_DATA = 4'h5;

    reg [7:0] state, next_state;

    reg [0:3] device_stat[0:3];
    localparam ADC_CONF = 4'h0, ADC_CONV = 4'h1, COM_READ = 4'h2, COM_SEND = 4'h3;
    localparam UNSEND = 4'h0, UNDONE = 4'h1, FINISH = 4'h3;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(device_stat[COM_READ][UNSEND]) next_state <= READ_IDLE;
                else if(device_stat[COM_SEND][UNSEND]) next_state <= SEND_IDLE;
                else if(device_stat[ADC_CONF][UNSEND]) next_state <= CONF_IDLE;
                else if(device_stat[ADC_CONV][UNSEND]) next_state <= CONF_IDLE;
                else if(device_stat[COM_READ][FINISH]) next_state <= READ_WAIT;
                else if(device_stat[COM_SEND][FINISH]) next_state <= SEND_WAIT;
                else if(device_stat[ADC_CONF][FINISH]) next_state <= CONF_WAIT;
                else if(device_stat[ADC_CONV][FINISH]) next_state <= CONV_WAIT;
                else next_state <= MAIN_WAIT;
            end

            READ_IDLE: begin
                if(fd_com_read_send) next_state <= READ_WORK;
                else next_state <= READ_IDLE;
            end
            READ_WORK: next_state <= MAIN_WAIT;
            READ_WAIT: next_state <= READ_DONE;
            READ_DONE: begin
                if(~fs_com_read_read) next_state <= MAIN_WAIT; 
                else next_state <= READ_DONE;
            end

            SEND_IDLE: begin
                if(fd_com_send_send) next_state <= SEND_WORK;
                else next_state <= SEND_IDLE;
            end
            SEND_WORK: next_state <= MAIN_WAIT;
            SEND_WAIT: next_state <= SEND_DONE;
            SEND_DONE: begin
                if(~fs_com_send_read) next_state <= MAIN_WAIT; 
                else next_state <= SEND_DONE;
            end

            CONF_IDLE: begin
                if(fd_adc_conf_send) next_state <= CONF_WORK;
                else next_state <= CONF_IDLE;
            end
            CONF_WORK: next_state <= MAIN_WAIT;
            CONF_WAIT: next_state <= CONF_DONE;
            CONF_DONE: begin
                if(~fs_adc_conf_read) next_state <= MAIN_WAIT; 
                else next_state <= CONF_DONE;
            end

            CONV_IDLE: begin
                if(fd_adc_conv_send) next_state <= CONV_WORK;
                else next_state <= CONV_IDLE;
            end
            CONV_WORK: next_state <= MAIN_WAIT;
            CONV_WAIT: next_state <= CONV_DONE;
            CONV_DONE: begin
                if(~fs_adc_conv_read) next_state <= MAIN_WAIT; 
                else next_state <= CONV_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) begin
            device_stat[ADC_CONF] = 4'h0;
            device_stat[ADC_CONV] = 4'h0;
            device_stat[COM_READ] = 4'h0;
            device_stat[COM_SEND] = 4'h0;
        end
        else if(fs_com_read) device_stat[COM_READ][UNSEND] = 1'b1;
        else if(fs_adc_conf_read) begin
            device_stat[ADC_CONF][UNDONE] = 1'b0;
            device_stat[ADC_CONF][FINISH] = 1'b1;
        end
        else if(fs_adc_conv_read) begin
            device_stat[ADC_CONV][UNDONE] = 1'b0;
            device_stat[ADC_CONF][FINISH] = 1'b1;
        end
        else if(fs_com_send_read) begin
            device_stat[COM_SEND][UNDONE] = 1'b0;
            device_stat[COM_SEND][FINISH] = 1'b1;
        end
        else if(fs_com_read_read) begin
            device_stat[COM_READ][UNDONE] = 1'b0;
            device_stat[COM_READ][FINISH] = 1'b1;
        end
        else if(state == CONF_WORK) device_stat[ADC_CONF][UNDONE] = 1'b1;
        else if(state == CONV_WORK) device_stat[ADC_CONV][UNDONE] = 1'b1;
        else if(state == SEND_WORK) device_stat[COM_SEND][UNDONE] = 1'b1;
        else if(state == READ_WORK) device_stat[COM_READ][UNDONE] = 1'b1;
        else if(state == READ_WAIT && com_read_btype == BAG_LINK) device_stat[COM_SEND][UNSEND] = 1'b1;
        else if(state == READ_WAIT && com_read_btype == BAG_CONF) device_stat[ADC_CONF][UNSEND] = 1'b1;
        else if(fs_cd) device_stat[ADC_CONV][UNSEND] = 1'b1;
        else if(state == CONV_WAIT) device_stat[COM_SEND][UNSEND] = 1'b1;
        else if(state == CONF_WAIT) 
    end




    


endmodule