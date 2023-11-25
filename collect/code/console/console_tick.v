module console_tick(
    input clk,
    input work,

    input [3:0] freq_samp,

    output fs,
    input fd
);

    localparam IDLE = 4'b0001, WORK = 4'b0010, WAIT = 4'b0100, EROR = 4'b1000;

    localparam FSAMP_1KHZ = 4'h1, FSAMP_2KHZ = 4'h2, FSAMP_4KHZ = 4'h3;
    localparam FSAMP_8KHZ = 4'h4, FSAMP_16KHZ = 4'h5;

    localparam TICK_1KHZ = 16'd50_000, TICK_2KHZ = 16'd25_000, TICK_4KHZ = 16'd12_500;
    localparam TICK_8KHZ = 16'd6_250, TICK_16KHZ = 16'd3_125;

    localparam NUMOUT = 16'h80;

    reg [3:0] state, next_state;
    localparam IDLE = 4'h1, WORK = 4'h2, WAIT = 4'h4, DONE = 4'h8;

    reg [15:0] countdown;
    reg [15:0] num;

    wire rst;

    assign fs = (state == DONE);
    assign rst = ~work;

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
        if(rst) countdown <= TICK_1KHZ;
        else if(state == IDLE) countdown <= TICK_1KHZ; 
        else if(freq_samp == FSAMP_1KHZ) countdown <= TICK_1KHZ;
        else if(freq_samp == FSAMP_2KHZ) countdown <= TICK_2KHZ;
        else if(freq_samp == FSAMP_4KHZ) countdown <= TICK_4KHZ;
        else if(freq_samp == FSAMP_8KHZ) countdown <= TICK_8KHZ;
        else if(freq_samp == FSAMP_16KHZ) countdown <= TICK_16KHZ;
        else countdown <= TICK_1KHZ;
    end

endmodule