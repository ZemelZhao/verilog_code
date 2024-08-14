#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

############## Clock Define ##################
create_clock -period 5.000 [get_ports clk_in_p]
set_property PACKAGE_PIN AE10 [get_ports clk_in_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_in_p]

############## Util Define ##################

set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports fan_n]
set_property IOSTANDARD LVCMOS33 [get_ports led_stat_n[*]]
set_property IOSTANDARD LVCMOS33 [get_ports led_comm_n[*]]

set_property DRIVE 16 [get_ports fan_n]
set_property DRIVE 16 [get_ports led_stat_n]
set_property DRIVE 16 [get_ports led_comm_n]

set_property PACKAGE_PIN N26 [get_ports fan_n]
set_property PACKAGE_PIN N25 [get_ports rst_n]

set_property PACKAGE_PIN E23 [get_ports led_stat_n[0]]
set_property PACKAGE_PIN G24 [get_ports led_stat_n[1]]
set_property PACKAGE_PIN E25 [get_ports led_stat_n[2]]
set_property PACKAGE_PIN E24 [get_ports led_stat_n[3]]
set_property PACKAGE_PIN L28 [get_ports led_stat_n[4]]
set_property PACKAGE_PIN J26 [get_ports led_stat_n[5]]

set_property PACKAGE_PIN D23 [get_ports led_comm_n[0]]
set_property PACKAGE_PIN G23 [get_ports led_comm_n[1]]
set_property PACKAGE_PIN F25 [get_ports led_comm_n[2]]
set_property PACKAGE_PIN D24 [get_ports led_comm_n[3]]
set_property PACKAGE_PIN M28 [get_ports led_comm_n[4]]
set_property PACKAGE_PIN K26 [get_ports led_comm_n[5]]


