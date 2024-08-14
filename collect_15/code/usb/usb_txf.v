module usb_txf(
    input clk,
    input rst,

    input fs,

    output reg fire,
    input [7:0] din,
    output reg dout
);

    localparam SYNC_DATA = 8'h01;

    reg [7:0] state; 
    reg [7:0] next_state;
    localparam IDLE = 8'h00, WAIT = 8'h01, WORK = 8'h02, DONE = 8'h03;
    localparam W0 = 8'h04, W1 = 8'h05, W2 = 8'h06, W3 = 8'h07;
    localparam W4 = 8'h08, W5 = 8'h09, W6 = 8'h0A, W7 = 8'h0B;
    localparam G0 = 8'h14, G1 = 8'h15, G2 = 8'h16, G3 = 8'h17;
    localparam G4 = 8'h18, G5 = 8'h19, G6 = 8'h1A, G7 = 8'h1B;
    localparam D0 = 8'h24, D1 = 8'h25, D2 = 8'h26, D3 = 8'h27;
    localparam D4 = 8'h28, D5 = 8'h29, D6 = 8'h2A, D7 = 8'h2B;

    
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
            WORK: begin
                if(din == SYNC_DATA) next_state <= W1;
                else next_state <= WORK;
            end
            W0: next_state <= W1;
            W1: next_state <= W2;
            W2: next_state <= W3;
            W3: next_state <= W4;
            W4: next_state <= W5;
            W5: next_state <= W6;
            W6: next_state <= W7;
            W7: begin
                if(~fs) next_state <= G0;
                else next_state <= W0;
            end
            G0: next_state <= G1;
            G1: next_state <= G2;
            G2: next_state <= G3;
            G3: next_state <= G4;
            G4: next_state <= G5;
            G5: next_state <= G6;
            G6: next_state <= G7;
            G7: next_state <= D0;
            D0: next_state <= D1;
            D1: next_state <= D2;
            D2: next_state <= D3;
            D3: next_state <= D4;
            D4: next_state <= D5;
            D5: next_state <= D6;
            D6: next_state <= D7;
            D7: next_state <= DONE;
            DONE: next_state <= IDLE;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk) begin
        if(state == WORK) dout <= din[7];
        else if(state == W0) dout <= din[7];
        else if(state == W1) dout <= din[6];
        else if(state == W2) dout <= din[5];
        else if(state == W3) dout <= din[4];
        else if(state == W4) dout <= din[3];
        else if(state == W5) dout <= din[2];
        else if(state == W6) dout <= din[1];
        else if(state == W7) dout <= din[0];
        else if(state == G0) dout <= din[7];
        else if(state == G1) dout <= din[6];
        else if(state == G2) dout <= din[5];
        else if(state == G3) dout <= din[4];
        else if(state == G4) dout <= din[3];
        else if(state == G5) dout <= din[2];
        else if(state == G6) dout <= din[1];
        else if(state == G7) dout <= din[0];
        else dout <=  1'b0;
    end 

    always@(posedge clk) begin
        if(state == IDLE) fire <= 1'b0;
        else if(state == WAIT) fire <= 1'b0;
        else if(state == WORK) fire <= 1'b1;
        else if(state == W0) fire <= 1'b1;
        else if(state == W1) fire <= 1'b1;
        else if(state == W2) fire <= 1'b1;
        else if(state == W3) fire <= 1'b1;
        else if(state == W4) fire <= 1'b1;
        else if(state == W5) fire <= 1'b1;
        else if(state == W6) fire <= 1'b1;
        else if(state == W7) fire <= 1'b1;
        else if(state == G0) fire <= 1'b1;
        else if(state == G1) fire <= 1'b1;
        else if(state == G2) fire <= 1'b1;
        else if(state == G3) fire <= 1'b1;
        else if(state == G4) fire <= 1'b1;
        else if(state == G5) fire <= 1'b1;
        else if(state == G6) fire <= 1'b1;        
        else if(state == G7) fire <= 1'b1;
        else if(state == D0) fire <= 1'b1;
        else if(state == D1) fire <= 1'b1;
        else if(state == D2) fire <= 1'b1;
        else if(state == D3) fire <= 1'b1;
        else if(state == D4) fire <= 1'b1;
        else if(state == D5) fire <= 1'b1;
        else if(state == D6) fire <= 1'b1;
        else if(state == D7) fire <= 1'b1;
        else fire <= 1'b0;
    end 

endmodule