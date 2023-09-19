module mac_tx(
    input clk,
    input rst,

    input [7:0] rxd,

    input fs,
    output fd,

    output fs_mode,

    output reg [15:0] mac_mode,
    output reg [47:0] src_mac_addr,
    output reg [47:0] det_mac_addr,
    output reg [7:0] mode_rxd

);

    reg state, next_state;



    always@(posedge clk or posedge rst) begin
        if(rst) state <= IDLE;
        else state <= next_state;
    end
    
    always@(*) begin
        case(state)
            IDLE: next_state <= WAIT;
            WAIT: begin
                if(fs) next_state <= DM00; 
                else next_state <= WAIT;
            end
            DM00: next_state <= DM01;
            DM01: next_state <= DM02;
            DM02: next_state <= DM03;
            DM03: next_state <= DM04;
            DM04: next_state <= DM05;
            DM05: next_state <= SM00;
            SM00: next_state <= SM01;
            SM01: next_state <= SM02;
            SM02: next_state <= SM03;
            SM03: next_state <= SM04;
            SM04: next_state <= SM05;
            SM05: next_state <= TP00;
            TP00: next_state <= TP01;
            TP01: next_state <= WORK;
            WORK: begin
                if(cnt >= dlen - 1'b1) next_state <= DONE;
                else next_state <= WORK;
            end
            DONE: begin
                if(~fs) next_state <= WAIT;  
                else next_state <= DONE;
            end
            default: next_state <= IDLE;
        endcase
    end



endmodule