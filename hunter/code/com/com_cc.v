module com_cc(
    input clk,
    input fire,

    input [3:0] usb_txd,
    output [3:0] pin_txd,

    input pin_rxd,
    output reg usb_rxd 
);

    assign pin_txd = usb_txd;

    reg [3:0] state, next_state;
    localparam IDLE = 4'h0, WAIT = 4'h1;
    localparam W0 = 4'h4, W1 = 4'h5, W2 = 4'h6;

    wire rst;

    reg [2:0] lut;
    assign rst = ~fire;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(pin_rxd) next_state <= W0;
                else next_state <= WAIT;
            end
            W0: next_state <= W1;
            W1: next_state <= W2;
            W2: next_state <= W0;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) lut <= 4'h0;
        else if(state == IDLE) lut <= 3'h0;
        else if(state == W0) lut[0] <= pin_rxd; 
        else if(state == W1) lut[1] <= pin_rxd; 
        else if(state == W2) lut[2] <= pin_rxd; 
        else lut <= 3'h0;
    end

    always@(posedge clk or posedge rst) begin
        if(rst) usb_rxd <= 1'b0;
        else if(state == IDLE) usb_rxd <= 1'b0;
        else if(state == W0 && lut == 3'h0) usb_rxd <= 1'b0; 
        else if(state == W0 && lut == 3'h1) usb_rxd <= 1'b0; 
        else if(state == W0 && lut == 3'h2) usb_rxd <= 1'b0; 
        else if(state == W0 && lut == 3'h3) usb_rxd <= 1'b1; 
        else if(state == W0 && lut == 3'h4) usb_rxd <= 1'b0; 
        else if(state == W0 && lut == 3'h5) usb_rxd <= 1'b1; 
        else if(state == W0 && lut == 3'h6) usb_rxd <= 1'b1; 
        else if(state == W0 && lut == 3'h7) usb_rxd <= 1'b1; 
        else usb_rxd <= usb_rxd;
    end


    // always@(posedge clk) begin
    //     pin_txd <= usb_txd;
    //     usb_rxd <= pin_rxd;
    // end




endmodule