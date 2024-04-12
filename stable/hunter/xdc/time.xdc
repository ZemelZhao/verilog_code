create_clock -period 20.000 [get_ports clk_in]

set_clock_groups -name clk_in -asynchronous -group [get_clocks clk_in]

set_clock_groups -name clk_slow -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -name clk_norm -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT1]]
set_clock_groups -name clk_fast -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT2]]
set_clock_groups -name clk_ulta -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT3]]
set_clock_groups -name clk_chip -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT4]]


