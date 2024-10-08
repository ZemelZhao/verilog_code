module com_cc(
    input clk,
    input clk_fast,
    input fire,

    input [3:0] usb_txd,
    output [3:0] pin_txd,

    (*MARK_DEBUG = "true"*)input pin_rxd,
    output reg usb_rxd 
);

    assign pin_txd = usb_txd;
    // assign usb_rxd = pin_rxd;

    (*MARK_DEBUG = "true"*)reg [3:0] state; 
    reg [3:0] next_state;
    localparam IDLE = 4'h4, WAIT = 4'h5;
    localparam W0 = 4'h0, W1 = 4'h1, W2 = 4'h2, W3 = 4'h3;

    (*MARK_DEBUG = "true"*)reg rxd; 
    wire rst;

    (*MARK_DEBUG = "true"*)reg [2:0] lut;
    assign rst = ~fire;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state = WAIT;
            WAIT: begin
                if(pin_rxd) next_state = W0;
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
        if(rst) lut <= 4'h0;
        else if(state == IDLE) lut <= 3'h0;
        else if(state == W0) lut[0] <= pin_rxd; 
        else if(state == W1) lut[1] <= pin_rxd; 
        else if(state == W2) lut[2] <= pin_rxd; 
        else if(state == W3) lut <= 3'h0;
        else lut <= 3'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) rxd <= 1'b0;
        else if(state == IDLE) rxd <= 1'b0;
        else if(state == W3 && lut == 3'h0) rxd <= 1'b0; 
        else if(state == W3 && lut == 3'h1) rxd <= 1'b0; 
        else if(state == W3 && lut == 3'h2) rxd <= 1'b0; 
        else if(state == W3 && lut == 3'h3) rxd <= 1'b1; 
        else if(state == W3 && lut == 3'h4) rxd <= 1'b0; 
        else if(state == W3 && lut == 3'h5) rxd <= 1'b1; 
        else if(state == W3 && lut == 3'h6) rxd <= 1'b1; 
        else if(state == W3 && lut == 3'h7) rxd <= 1'b1; 
        else rxd <= rxd;
    end

    always@(posedge clk_fast or posedge rst) begin
        if(rst) usb_rxd <= 1'b0;
        else usb_rxd <= rxd;
    end



endmodule