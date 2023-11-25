module console_hq(
    input clk,
    input rst,

    input fs_com_read,
    output reg fd_com_read,
    output reg fs_com_send,
    input fd_com_send,

    output reg fs_adc_conf,
    input fd_adc_conf,
    output reg fs_adc_conv,
    input fd_adc_conv,

    input fs_adc_tick,
    output fd_adc_tick,

    input [3:0] com_read_btype,
    output reg [3:0] com_send_btype,

    output reg [3:0] data_idx,
    output reg work
);

    localparam IDLE = 4'b0001, WORK = 4'b0010, WAIT = 4'b0100, EROR = 4'b1000;
    localparam COM_INIT = 4'h0;
    localparam COM_CONF = 4'h1, COM_READ = 4'h4, COM_STOP = 4'h9;
    localparam COM_DATA = 4'h5, COM_STAT = 4'hA;

    reg [7:0] state, next_state;
    reg [7:0] state_goto;
    localparam MAIN_IDLE = 8'h00, MAIN_WAIT = 8'h01, MAIN_DOOR = 8'h02;
    localparam TICK_IDLE = 8'h10, TICK_WAIT = 8'h11, TICK_WOTK = 8'h12, TICK_DONE = 8'h13;
    localparam READ_IDLE = 8'h40, READ_WAIT = 8'h41, READ_WORK = 8'h42, READ_DONE = 8'h43;
    localparam SEND_IDLE = 8'h50, SEND_WAIT = 8'h51, SEND_WORK = 8'h52, SEND_DONE = 8'h53;
    localparam CONF_IDLE = 8'h80, CONF_WAIT = 8'h81, CONF_WORK = 8'h82, CONF_DONE = 8'h83;
    localparam CONV_IDLE = 8'h90, CONV_WAIT = 8'h91, CONV_WORK = 8'h92, CONV_DONE = 8'h93;

    assign fd_adc_tick = (state == TICK_DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= MAIN_IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            MAIN_IDLE: next_state <= MAIN_WAIT;
            MAIN_WAIT: begin
                if(fs_com_read) next_state <= READ_IDLE;
                else if(fs_adc_tick) next_state <= TICK_IDLE;
                else if(fd_com_send) next_state <= SEND_DONE;
                else if(fd_adc_conf) next_state <= CONF_DONE;
                else if(fd_adc_conv) next_state <= CONV_DONE;
            end
            MAIN_DOOR: next_state <= state_goto;

            READ_IDLE: next_state <= READ_WAIT;
            READ_WAIT: next_state <= READ_WORK;
            READ_WORK: next_state <= READ_DONE;
            READ_DONE: begin
                if(~fs_com_read) next_state <= MAIN_DOOR;
                else next_state <= READ_DONE;
            end
            
            TICK_IDLE: next_state <= TICK_WAIT;
            TICK_WAIT: next_state <= TICK_WORK;
            TICK_WORK: next_state <= TICK_DONE;
            TICK_DONE: begin
                if(~fs_adc_tick) next_state <= MAIN_DOOR;
                else next_state <= TICK_DONE;
            end

            SEND_IDLE: next_state <= SEND_WAIT;
            SEND_WAIT: next_state <= SEND_WORK;
            SEND_WORK: next_state <= MAIN_WAIT;
            SEND_DONE: begin
                if(~fd_com_send) next_state <= MAIN_DOOR;
                else next_state <= SEND_DONE;
            end

            CONF_IDLE: next_state <= CONF_WAIT;
            CONF_WAIT: next_state <= CONF_WORK;
            CONF_WORK: next_state <= MAIN_WAIT;
            CONF_DONE: begin
                if(~fd_adc_conf) next_state <= MAIN_DOOR;
                else next_state <= CONF_DONE;
            end

            CONV_IDLE: next_state <= CONV_WAIT;
            CONV_WAIT: next_state <= CONV_WORK;
            CONV_WORK: next_state <= MAIN_WAIT;
            CONV_DONE: begin
                if(~fd_adc_conv) next_state <= MAIN_DOOR;
                else next_state <= CONV_DONE;
            end

            default: next_state <= MAIN_IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) state_goto <= MAIN_IDLE;
        else if(state == READ_WORK && com_read_btype == COM_CONF) state_goto <= CONF_IDLE; 
        else if(state == READ_WORK && com_read_btype == COM_READ) state_goto <= MAIN_WAIT; 
        else if(state == READ_WORK && com_read_btype == COM_STOP) state_goto <= MAIN_WAIT; 
        else if(state == TICK_WORK) state_goto <= CONV_IDLE;
        else if(state == CONF_WORK) state_goto <= SEND_IDLE;
        else if(state == CONV_WORK) state_goto <= SEND_IDLE;
        else if(state == SEND_WORK) state_goto <= MAIN_WAIT;
        else state_goto <= state_goto;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fd_com_read <= 1'b0;
        else if(state == READ_DONE) fd_com_read <= 1'b1;
        else fd_com_read <= 1'b0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_com_send <= 1'b0;
        else if(state == SEND_WORK) fs_com_send <= 1'b1;
        else if(state == SEND_DONE) fs_com_send <= 1'b0; 
        else fs_com_send <= fs_com_send;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_adc_conf <= 1'b0;
        else if(state == CONF_WORK) fs_adc_conf <= 1'b1;
        else if(state == CONF_DONE) fs_adc_conf <= 1'b0;
        else fs_adc_conf <= fs_adc_conf;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) fs_adc_conv <= 1'b0;
        else if(state == CONV_WORK) fs_adc_conv <= 1'b1;
        else if(state == CONV_DONE) fs_adc_conv <= 1'b0;
        else fs_adc_conv <= fs_adc_conv;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) com_send_btype <= COM_INIT;
        else if(state == CONF_DONE) com_send_btype <= COM_STAT; 
        else if(state == CONV_DONE) com_send_btype <= COM_DATA;
        else com_send_btype <= com_send_btype;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) data_idx <= 4'hF;
        else if(state == MAIN_IDLE) data_idx <= 4'hF;
        else if(state == CONF_IDLE) data_idx <= 4'hF;
        else if(state == CONV_IDLE && data_idx == 4'hF) data_idx <= 4'h0; 
        else if(state == CONV_IDLE && data_idx == 4'h0) data_idx <= 4'h1; 
        else if(state == CONV_IDLE && data_idx == 4'h1) data_idx <= 4'h2; 
        else if(state == CONV_IDLE && data_idx == 4'h2) data_idx <= 4'h3; 
        else if(state == CONV_IDLE && data_idx == 4'h3) data_idx <= 4'h4; 
        else if(state == CONV_IDLE && data_idx == 4'h4) data_idx <= 4'h5; 
        else if(state == CONV_IDLE && data_idx == 4'h5) data_idx <= 4'h0; 
        else data_idx <= data_idx;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) work <= 1'b0;
        else if(state == MAIN_IDLE) work <= 1'b0;
        else if(state == READ_WORK && com_read_btype == COM_CONF) work <= 1'b0;
        else if(state == READ_WORK && com_read_btype == COM_READ) work <= 1'b1;
        else if(state == READ_WORK && com_read_btype == COM_STOP) work <= 1'b0;
        else work <= work;
    end



endmodule