#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

############## clock define##################
create_clock -period 5.000 [get_ports clk_in_p]
set_property PACKAGE_PIN AE10 [get_ports clk_in_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_in_p]

create_clock -period 8.000 [get_ports sfp_clk_p]
set_property PACKAGE_PIN J8 [get_ports sfp_clk_p]


##############UTIL define##################
set_property PACKAGE_PIN M23 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

set_property PACKAGE_PIN E26 [get_ports fan_n]
set_property IOSTANDARD LVCMOS33 [get_ports fan_n]

##############ETH define##################
set_property LOC GTXE2_CHANNEL_X0Y8 [get_cells gtx_exdes_dut/gtx_support_i/gtx_init_i/inst/gtx_i/gt0_gtx_i/gtxe2_i]

