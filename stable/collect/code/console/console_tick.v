module console_tick(
    input clk,
    input fs_conf,

    input [3:0] fsamp,
    output tick
);

    localparam NUM_1S = 32'd75_000_000;

    localparam NUM_1KHZ = 32'd75_000, NUM_2KHZ = 32'd37_500;
    localparam NUM_4KHZ = 32'd18_750, NUM_8KHZ = 32'd9_375;
    localparam NUM_16KHZ0 = 32'd4_688, NUM_16KHZ1 = 32'd4_687;
    localparam NUM_INIT = 32'd75_000_000;

    localparam FS_INIT = 4'h0, FS_1KHZ = 4'h1, FS_2KHZ = 4'h2; 
    localparam FS_4KHZ = 4'h3, FS_8KHZ = 4'h4, FS_16KHZ = 4'h5;

    reg [5:0] state, next_state;
    localparam IDLE = 6'h01, WAIT = 6'h02, WORK = 6'h04, REST = 6'h08;
    localparam TAKE = 6'h10, DONE = 6'h20; 

    wire rst;
    reg [31:0] num_fs0, num_fs1;
    reg [31:0] num;

    assign rst = fs_conf;
    assign tick = (state == WORK) || (state == TAKE) || (num < {1'b0, num[31:1]});

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: next_state <= WORK;
            WORK: begin
                if(num >= num_fs0 - 2'h2) next_state <= REST;
                else next_state <= WORK;
            end
            REST: next_state <= TAKE;
            TAKE: begin
                if(num >= num_fs1 - 2'h2) next_state <= DONE;
                else next_state <= TAKE;
            end
            DONE: next_state <= WORK;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num_fs0 <= NUM_INIT;
        else if(state == WAIT && fsamp == FS_1KHZ) num_fs0 <= NUM_1KHZ;
        else if(state == WAIT && fsamp == FS_2KHZ) num_fs0 <= NUM_2KHZ;
        else if(state == WAIT && fsamp == FS_4KHZ) num_fs0 <= NUM_4KHZ;
        else if(state == WAIT && fsamp == FS_8KHZ) num_fs0 <= NUM_8KHZ;
        else if(state == WAIT && fsamp == FS_16KHZ) num_fs0 <= NUM_16KHZ0;
        else if(state == WAIT) num_fs0 <= NUM_INIT;
        else num_fs0 <= num_fs0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num_fs1 <= NUM_INIT;
        else if(state == REST && fsamp == FS_1KHZ) num_fs1 <= NUM_1KHZ;
        else if(state == REST && fsamp == FS_2KHZ) num_fs1 <= NUM_2KHZ;
        else if(state == REST && fsamp == FS_4KHZ) num_fs1 <= NUM_4KHZ;
        else if(state == REST && fsamp == FS_8KHZ) num_fs1 <= NUM_8KHZ;
        else if(state == REST && fsamp == FS_16KHZ) num_fs1 <= NUM_16KHZ1;
        else if(state == REST) num_fs1 <= NUM_INIT;
        else num_fs1 <= num_fs1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 32'h00;
        else if(state == WAIT) num <= 32'h00;
        else if(state == REST) num <= 32'h00;
        else if(state == DONE) num <= 32'h00;
        else if(state == WORK) num <= num + 1'b1;
        else if(state == TAKE) num <= num + 1'b1;
        else num <= 32'h00;
    end





endmodule