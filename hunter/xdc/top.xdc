set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

create_clock -period 20.000 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN P15 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN P17 [get_ports rst_n]

set_property IOSTANDARD LVDS_25 [get_ports {com_txd_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {com_rxd_p[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports com_txf]
set_property IOSTANDARD LVCMOS33 [get_ports com_rxf]

set_property PACKAGE_PIN M17 [get_ports com_txd_p[0]]
set_property PACKAGE_PIN M15 [get_ports com_txd_p[1]]
set_property PACKAGE_PIN K18 [get_ports com_txd_p[2]]
set_property PACKAGE_PIN L16 [get_ports com_txd_p[3]]

set_property PACKAGE_PIN L18 [get_ports com_rxd_p[0]]
set_property PACKAGE_PIN H19 [get_ports com_rxd_p[1]]

set_property PACKAGE_PIN T19 [get_ports com_txf]
set_property PACKAGE_PIN T20 [get_ports com_rxf]

