`timescale 1 ns/1 ns
module smi_config#(
    parameter REF_CLK = 50,         //reference clock frequency(MHz)
    parameter MDC_CLK = 500         //mdc clock(KHz)
)
(
    input                       clk         ,
    input                       rst_n       ,
    output                      mdc         ,     //mdc interface
    inout                       mdio        ,     //mdio interface
    output reg  [1:0]           speed = 'd3 ,    //ethernet speed 00:10M 01:100M 10:1000M 11:no 
    output reg                  link  = 'd0      //ethernet link signal
);

reg  [4:0]         phy_addr     = 'd1    ;   //phy address 5'b0001
reg  [4:0]         reg_addr     = 'd0    ;   //phy register address
reg                write_req    = 'd0    ;   //write smi request
reg  [15:0]        write_data   = 'd0    ;   //write smi data
reg                read_req     = 'd0    ;   //read smi request
wire [15:0]        read_data             ;   //read smi data
wire               data_valid            ;   //read smi data valid
wire               done                  ;	 //write or read finished 
reg[31:0]          timer0        = 'd0   ;	 //wait counter 
reg[15:0]          timer1        = 'd1   ; 
  

reg [2:0]    state   = 'd0;
reg  flag_speed      = 'd0;
 
reg[2:0]    done_b    = 'd0;
reg[15:0]   read_data_b     = 'd0;
//always @(posedge clk or negedge rst_n)  begin
always @(posedge clk)  begin
    done_b[2:1]                   <= done_b[1:0];
    if(done) begin
        timer1                          <= 'd0;
        read_data_b                     <= read_data;
    end
    else begin
        if(timer1   < (REF_CLK*'d1000)) begin
            timer1                      <= timer1 + 'd1;    
            done_b[0]                   <= 'd0;
        end
        else begin
            done_b[0]                   <= 'd1;
        end
    end
    if (~rst_n) begin
        state                           <= 'd0;
        timer0                          <= 'd0;
        read_req                        <= 'd0;
        write_req                       <= 'd0;
        link                            <= 'd0;
        speed                           <= 'd0;
        flag_speed                      <= 'd0;
    end
    else begin
        case(state)
            'd0:begin
                flag_speed              <= 'd0;
                timer0                  <= timer0 + 'd1;
                if(timer0 == (REF_CLK*'d1000000))
//                if(timer0 == (REF_CLK*'d1000))
                    state               <= 'd1;
            end 
            'd1:begin
                timer0                  <= 'd0;
                reg_addr                <= 'd31;//write page
//                write_data              <= flag_speed ? 16'ha43 :16'd0 ;//page 0
                write_data              <= 6'd0 ;//page 0
                write_req               <= 'd1;
                state                   <= 'd2;
            end
            'd2:begin
                write_req               <= 'd0;
                if(done_b[2:1] == 2'b01)
                    state               <= 'd3;
            end
            'd3:begin
                reg_addr                <= flag_speed ? 5'h11 :5'd1 ;//read page 0xa43_reg_addr_0x1A  or read page 0_reg_addr_1 
                read_req                <= 'd1 ;// 
                state                   <= 'd4;
            end
            'd4:begin
                read_req                <= 'd0;
                if(done_b[2:1] == 2'b01) begin
                    if(flag_speed) begin
                        speed           <= read_data_b[15:14];
                        state           <= 'd0;
                    end
                    else begin
                        if (~read_data_b[2])begin             //read register data  to check if ethernet link  0: unlink  1: link
                            link        <= 'd0;
                            state       <= 'd0;     
                        end
                        else begin
                            link        <= 'd1;
                            flag_speed  <= 'd1;
                            state       <= 'd1;
                        end
                    end
                end
            end
        endcase
    end
  end 

smi_read_write 
      #(
        .REF_CLK(REF_CLK),
        .MDC_CLK(MDC_CLK)
	   )
	   smi_inst
       (
        .clk              (clk         ),
        .rst_n            (rst_n       ),
        .mdc              (mdc         ),
        .mdio             (mdio        ),         
        .phy_addr         (phy_addr    ),
        .reg_addr         (reg_addr    ),		 
        .write_req        (write_req   ),
        .write_data       (write_data  ),
        .read_req         (read_req    ),
        .read_data        (read_data   ),
        .data_valid       (data_valid  ),
        .done             (done        )
       );

 
endmodule
