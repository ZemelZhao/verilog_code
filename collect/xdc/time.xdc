
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets crep_dut/e_gtxc_OBUF]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets e_grxc_IBUF]

set_clock_groups -name clk_ulta -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT3]]
set_clock_groups -name clk_fast -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT2]]
set_clock_groups -name clk_norm -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT1]]
set_clock_groups -name clk_slow -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKOUT0]]
set_clock_groups -name clk_out -asynchronous -group [get_clocks -of_objects [get_pins crep_dut/clk_wiz_dut/inst/mmcm_adv_inst/CLKFBOUT]]
set_clock_groups -name clk_eth -asynchronous -group [get_clocks e_grxc]
set_clock_groups -name clk_in -asynchronous -group [get_clocks clk_in_p]
