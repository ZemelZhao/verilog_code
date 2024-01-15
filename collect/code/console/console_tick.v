module console_tick(
    input clk,
    input work,

    input [3:0] freq_samp,

    output fs,
    input fd
);

    localparam FSAMP_1KHZ = 4'h1, FSAMP_2KHZ = 4'h2, FSAMP_4KHZ = 4'h3;
    localparam FSAMP_8KHZ = 4'h4, FSAMP_16KHZ = 4'h5;

    localparam TICK_1KHZ = 24'd75_000, TICK_2KHZ = 24'd37_500, TICK_4KHZ = 24'd18_750;
    localparam TICK_8KHZ = 24'd9_375, TICK_16KHZ = 24'd4_687;

    localparam NUMOUT = 16'h80;

    reg [3:0] state, next_state;
    localparam IDLE = 4'h1, WORK = 4'h2, WAIT = 4'h4, DONE = 4'h8;

    reg [23:0] countdown;
    reg [23:0] num;

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
            WAIT: next_state <= WORK;
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
        if(rst) num <= 24'h00;
        else if(num <= countdown - 2'h2) num <= num + 1'b1;
        else num <= 24'h00;
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