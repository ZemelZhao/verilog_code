create_clock -period 20.000 [get_ports clk_in]

set_false_path -from [get_clocks *norm*] -to [get_clocks *slow*]
set_false_path -from [get_clocks *slow*] -to [get_clocks *norm*]
