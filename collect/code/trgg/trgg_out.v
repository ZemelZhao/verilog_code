module trgg_out(
    input clk,
    input rst,

    input [3:0] mod,
    input [15:0] delay, 

    input fs,
    output fd,

    output reg pin
);

    // TRIGGER MODE
    // MOD HIGH DOWN HIGH
    // 000 0500 0500 
    // 001 0500 0500 0500
    // 010 1000 1000 
    // 011 1000 1000 1000
    // 100 0500 0500 1000
    // 101 0500 1000 0500
    // 110 1000 0500 1000
    // 111 2000 2000

    (*MARK_DEBUG = "true"*)reg [31:0] num;
    (*MARK_DEBUG = "true"*)reg [15:0] cnt;

    (*MARK_DEBUG = "true"*)reg [15:0] state; 
    reg [15:0] next_state;

    localparam IDLE = 16'h0001, WAIT = 16'h0002, WORK = 16'h0004, DONE = 16'h0008;
    localparam DLY0 = 16'h0010, DLY1 = 16'h0020, DLY2 = 16'h0040;
    localparam STG0 = 16'h0100, STG1 = 16'h0200, STG2 = 16'h0400, STG3 = 16'h0800;
    localparam STG4 = 16'h1000, STG5 = 16'h2000, STG6 = 16'h4000, STG7 = 16'h8000;

    localparam TIME_500MS = 32'd37_500_000, TIME_1MS = 32'd75_000;

    localparam HIGH = 1'b1, LOW = 1'b0;

    assign fd = (state == DONE);

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= WORK;
                else next_state <= WAIT;
            end
            WORK: next_state <= DLY0;

            DLY0: begin
                if(cnt == 16'h00) next_state <= STG0;
                else next_state <= DLY1;
            end
            DLY1: begin
                if(num == TIME_1MS - 2'h2) next_state <= DLY2;
                else next_state <= DLY1;
            end
            DLY2: next_state <= DLY0;

            STG0: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG1;
                else next_state <= STG0;
            end
            STG1: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG2;
                else next_state <= STG1;
            end
            STG2: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG3;
                else next_state <= STG2;
            end
            STG3: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG4;
                else next_state <= STG3;
            end
            STG4: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG5;
                else next_state <= STG4;
            end
            STG5: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG6;
                else next_state <= STG5;
            end
            STG6: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG7;
                else next_state <= STG6;
            end
            STG7: begin
                if(num == TIME_500MS - 1'b1) next_state <= DONE;
                else next_state <= STG7;
            end
            DONE: begin
                if(~fs) next_state <= WAIT;
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) cnt <= 16'h00;
        else if(state == WORK) cnt <= delay;
        else if(state == DLY2) cnt <= cnt - 1'b1;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pin <= LOW;
        else if(state == IDLE) pin <= LOW;
        else if(state == STG0) pin <= HIGH;

        else if(state == STG1 && mod == 4'h2) pin <= HIGH;
        else if(state == STG1 && mod == 4'h3) pin <= HIGH;
        else if(state == STG1 && mod == 4'h6) pin <= HIGH;
        else if(state == STG1 && mod == 4'h7) pin <= HIGH;

        else if(state == STG2 && mod == 4'h1) pin <= HIGH;
        else if(state == STG2 && mod == 4'h4) pin <= HIGH;
        else if(state == STG2 && mod == 4'h7) pin <= HIGH;

        else if(state == STG3 && mod == 4'h4) pin <= HIGH;
        else if(state == STG3 && mod == 4'h5) pin <= HIGH;
        else if(state == STG3 && mod == 4'h6) pin <= HIGH;
        else if(state == STG3 && mod == 4'h7) pin <= HIGH;

        else if(state == STG4 && mod == 4'h3) pin <= HIGH;
        else if(state == STG4 && mod == 4'h6) pin <= HIGH;

        else if(state == STG5 && mod == 4'h3) pin <= HIGH;
        
        else pin <= LOW;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) num <= 32'h00;
        else if(state == IDLE) num <= 32'h00;
        else if(state != next_state) num <= 32'h00;
        else if(state == DLY1) num <= num + 1'b1;
        else if(state == STG0) num <= num + 1'b1;
        else if(state == STG1) num <= num + 1'b1;
        else if(state == STG2) num <= num + 1'b1;
        else if(state == STG3) num <= num + 1'b1;
        else if(state == STG4) num <= num + 1'b1;
        else if(state == STG5) num <= num + 1'b1;
        else if(state == STG6) num <= num + 1'b1;
        else if(state == STG7) num <= num + 1'b1;
        else num <= 32'h00;
    end

endmodule