module usb_cc(
    input clk,
    input clk_fast,
    input fire,

    input usb_txd,
    output pin_txd,

    input [3:0] pin_rxd,
    output reg [3:0] usb_rxd
);

    assign pin_txd = usb_txd;

    // Here is a very interesting bug here.
    // state would change into 0x00 sometimes when state is a 6-bit regsiter.

    reg [3:0] state; 
    reg [3:0] next_state;
    localparam IDLE = 4'h4, WAIT = 4'h5;
    localparam W0 = 4'h0, W1 = 4'h1, W2 = 4'h2, W3 = 4'h3;

    reg [2:0] lut0, lut1, lut2, lut3;
    reg [3:0] rxd;
    wire rst;

    assign rst = ~fire;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state = WAIT;
            WAIT: begin
                if(&pin_rxd) next_state = W0;
                else next_state = WAIT;
            end
            W0: next_state = W1;
            W1: next_state = W2;
            W2: next_state = W3;
            W3: next_state = W0;
            default: next_state = IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) lut0 <= 3'h0;
        else if(state == IDLE) lut0 <= 3'h0;
        else if(state == W0) lut0[0] <= pin_rxd[0];
        else if(state == W1) lut0[1] <= pin_rxd[0];
        else if(state == W2) lut0[2] <= pin_rxd[0];
        else if(state == W3) lut0 <= 3'h0;
        else lut0 <= 3'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) lut1 <= 3'h0;
        else if(state == IDLE) lut1 <= 3'h0;
        else if(state == W0) lut1[0] <= pin_rxd[1];
        else if(state == W1) lut1[1] <= pin_rxd[1];
        else if(state == W2) lut1[2] <= pin_rxd[1];
        else if(state == W3) lut1 <= 3'h0;
        else lut1 <= 3'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) lut2 <= 3'h0;
        else if(state == IDLE) lut2 <= 3'h0;
        else if(state == W0) lut2[0] <= pin_rxd[2];
        else if(state == W1) lut2[1] <= pin_rxd[2];
        else if(state == W2) lut2[2] <= pin_rxd[2];
        else if(state == W3) lut2 <= 3'h0;
        else lut2 <= 3'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) lut3 <= 3'h0;
        else if(state == IDLE) lut3 <= 3'h0;
        else if(state == W0) lut3[0] <= pin_rxd[3];
        else if(state == W1) lut3[1] <= pin_rxd[3];
        else if(state == W2) lut3[2] <= pin_rxd[3];
        else if(state == W3) lut3 <= 3'h0;
        else lut3 <= 3'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rxd[0] <= 1'b0;
        else if(state == IDLE) rxd[0] <= 1'b0;
        else if(state == W3 && lut0 == 3'h0) rxd[0] <= 1'b0; 
        else if(state == W3 && lut0 == 3'h1) rxd[0] <= 1'b0; 
        else if(state == W3 && lut0 == 3'h2) rxd[0] <= 1'b0; 
        else if(state == W3 && lut0 == 3'h3) rxd[0] <= 1'b1; 
        else if(state == W3 && lut0 == 3'h4) rxd[0] <= 1'b0; 
        else if(state == W3 && lut0 == 3'h5) rxd[0] <= 1'b1; 
        else if(state == W3 && lut0 == 3'h6) rxd[0] <= 1'b1; 
        else if(state == W3 && lut0 == 3'h7) rxd[0] <= 1'b1; 
        else rxd[0] <= rxd[0];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rxd[1] <= 1'b0;
        else if(state == IDLE) rxd[1] <= 1'b0;
        else if(state == W3 && lut1 == 3'h0) rxd[1] <= 1'b0; 
        else if(state == W3 && lut1 == 3'h1) rxd[1] <= 1'b0; 
        else if(state == W3 && lut1 == 3'h2) rxd[1] <= 1'b0; 
        else if(state == W3 && lut1 == 3'h3) rxd[1] <= 1'b1; 
        else if(state == W3 && lut1 == 3'h4) rxd[1] <= 1'b0; 
        else if(state == W3 && lut1 == 3'h5) rxd[1] <= 1'b1; 
        else if(state == W3 && lut1 == 3'h6) rxd[1] <= 1'b1; 
        else if(state == W3 && lut1 == 3'h7) rxd[1] <= 1'b1; 
        else rxd[1] <= rxd[1];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rxd[2] <= 1'b0;
        else if(state == IDLE) rxd[2] <= 1'b0;
        else if(state == W3 && lut2 == 3'h0) rxd[2] <= 1'b0; 
        else if(state == W3 && lut2 == 3'h1) rxd[2] <= 1'b0; 
        else if(state == W3 && lut2 == 3'h2) rxd[2] <= 1'b0; 
        else if(state == W3 && lut2 == 3'h3) rxd[2] <= 1'b1; 
        else if(state == W3 && lut2 == 3'h4) rxd[2] <= 1'b0; 
        else if(state == W3 && lut2 == 3'h5) rxd[2] <= 1'b1; 
        else if(state == W3 && lut2 == 3'h6) rxd[2] <= 1'b1; 
        else if(state == W3 && lut2 == 3'h7) rxd[2] <= 1'b1; 
        else rxd[2] <= rxd[2];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rxd[3] <= 1'b0;
        else if(state == IDLE) rxd[3] <= 1'b0;
        else if(state == W3 && lut3 == 3'h0) rxd[3] <= 1'b0; 
        else if(state == W3 && lut3 == 3'h1) rxd[3] <= 1'b0; 
        else if(state == W3 && lut3 == 3'h2) rxd[3] <= 1'b0; 
        else if(state == W3 && lut3 == 3'h3) rxd[3] <= 1'b1; 
        else if(state == W3 && lut3 == 3'h4) rxd[3] <= 1'b0; 
        else if(state == W3 && lut3 == 3'h5) rxd[3] <= 1'b1; 
        else if(state == W3 && lut3 == 3'h6) rxd[3] <= 1'b1; 
        else if(state == W3 && lut3 == 3'h7) rxd[3] <= 1'b1; 
        else rxd[3] <= rxd[3];
    end

    always@(posedge clk_fast or posedge rst) begin
        if(rst) usb_rxd <= 4'h0;
        else usb_rxd <= rxd;
    end

endmodule