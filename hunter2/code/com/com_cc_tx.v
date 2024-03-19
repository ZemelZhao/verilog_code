module com_cc_tx(
    input clk,

    input fire_txd,
    output reg pin_send,

    input [3:0] usb_txd,
    output reg [3:0] pin_txd
);

    wire rst;

    reg pin_send_r0, pin_send_r1;
    reg [3:0] pin_txd_r0, pin_txd_r1;

    assign rst = ~fire_txd;

    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE; 
        else state <= next_state;
    end

    always@(*) begin
        case(state)
            IDLE: next_state <= W0;
            W0: next_state <= W1;
            W1: next_state <= W2;
            W2: next_state <= W3;
            W3: next_state <= W0;
            default: next_state <= IDLE;
        endcase
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pin_txd_r1[0] <= 1'b0;
        else if(state == IDLE) pin_txd_r1[0] <= 1'b0;
        else if(state == W0 && usb_txd[0] == 1'b1) pin_txd_r1[0] <= ~pin_txd_r1[0];
        else pin_txd_r1[0] <= pin_txd_r1[0];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pin_txd_r1[1] <= 1'b0;
        else if(state == IDLE) pin_txd_r1[1] <= 1'b0;
        else if(state == W0 && usb_txd[1] == 1'b1) pin_txd_r1[1] <= ~pin_txd_r1[1];
        else pin_txd_r1[1] <= pin_txd_r1[1];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pin_txd_r1[2] <= 1'b0;
        else if(state == IDLE) pin_txd_r1[0] <= 1'b0;
        else if(state == W0 && usb_txd[2] == 1'b1) pin_txd_r1[2] <= ~pin_txd_r1[2];
        else pin_txd_r1[2] <= pin_txd_r1[2];
    end

    always@(posedge clk or posedge rst) begin
        if(rst) pin_txd_r1[3] <= 1'b0;
        else if(state == IDLE) pin_txd_r1[3] <= 1'b0;
        else if(state == W0 && usb_txd[3] == 1'b1) pin_txd_r1[3] <= ~pin_txd_r1[3];
        else pin_txd_r1[3] <= pin_txd_r1[3];
    end

    always@(posedge clk or posedge rst) begin
        pin_txd_r0 <= pin_txd_r1;
        pin_txd <= pin_txd_r0;
    end

    always@(posedge clk or posedge rst) begin
        pin_send_r0 <= pin_send_r1;
        pin_send <= pin_send_r0;
    end

endmodule