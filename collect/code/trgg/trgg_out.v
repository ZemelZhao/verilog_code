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

    reg [31:0] num;
    reg [15:0] cnt;

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
                else next_state <= STG0;
            end
            STG2: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG3;
                else next_state <= STG0;
            end
            STG3: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG4;
                else next_state <= STG0;
            end
            STG4: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG5;
                else next_state <= STG0;
            end
            STG5: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG6;
                else next_state <= STG0;
            end
            STG6: begin
                if(num == TIME_500MS - 1'b1) next_state <= STG7;
                else next_state <= STG0;
            end
            STG7: begin
                if(num == TIME_500MS - 1'b1) next_state <= DONE;
                else next_state <= STG0;
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