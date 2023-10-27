create_clock -period 20.000 [get_ports clk_in]

set_false_path -from [get_clocks *norm*] -to [get_clocks *slow*]
set_false_path -from [get_clocks *slow*] -to [get_clocks *norm*]

set_max_delay -from [get_pins com_dut/com_cc_dut/rxd_reg/C] -to [get_pins com_dut/com_cc_dut/usb_rxd_reg/D] 2.500
