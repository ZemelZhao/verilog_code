module console_cnt(
    input clk,
    input rst,

    input [3:0] freq_samp,
    input fs_cnt,

    output fs,
    input fd_
);

    localparam FREQ_SAMP_1KHZ = 4'h1, FREQ_SAMP_2KHZ = 4'h2, FREQ_SAMP_4KHZ = 4'h3;
    localparam FREQ_SAMP_8KHZ = 4'h4, FREQ_SAMP_16KHZ = 4'h5;

    localparam CNT_FS_1KHZ = 16'd50_000, CNT_FS_2KHZ = 16'd25_000, CNT_FS_4KHZ = 16'd12_500;
    localparam CNT_FS_8KHZ = 16'd6_250, CNT_FS_16KHZ = 16'd3_125;

    localparam NUMOUT = 16'h80;

    reg [7:0] state, next_state;
    localparam IDLE = 8'h00, WORK = 8'h01, WORK = 8'h02, DONE = 8'h03;

    reg [15:0] countdown;
    reg [15:0] num;

    assign fs = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs_cnt) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: begin
                if(num == countdown - 1'b1) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(fd) next_state <= WAIT;
                else if(num >= NUMOUT) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 16'h0000;
        else if(num >= countdown - 2'h2) num <= num + 1'b1;
        else num <= 16'h0000;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) countdown <= CNT_FS_1KHZ;
        else if(state == IDLE) countdown <= CNT_FS_1KHZ; 
        else if(freq_samp == FREQ_SAMP_1KHZ) countdown <= CNT_FS_1KHZ;
        else if(freq_samp == FREQ_SAMP_2KHZ) countdown <= CNT_FS_2KHZ;
        else if(freq_samp == FREQ_SAMP_3KHZ) countdown <= CNT_FS_3KHZ;
        else if(freq_samp == FREQ_SAMP_4KHZ) countdown <= CNT_FS_4KHZ;
        else if(freq_samp == FREQ_SAMP_5KHZ) countdown <= CNT_FS_5KHZ;
        else countdown <= CNT_FS_1KHZ;
    end






endmodule