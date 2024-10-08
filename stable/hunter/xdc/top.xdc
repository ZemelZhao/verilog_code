set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

## CRE Section
create_clock -period 20.000 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]
set_property PACKAGE_PIN P15 [get_ports clk_in]

set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN P17 [get_ports rst_n]

## COM Section
set_property IOSTANDARD LVDS_25 [get_ports {com_txd_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {com_rxd_p[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports com_txf]
set_property IOSTANDARD LVCMOS33 [get_ports com_rxf]
set_property IOSTANDARD LVCMOS33 [get_ports {com_cc[*]}]

set_property PACKAGE_PIN M17 [get_ports {com_txd_p[0]}]
set_property PACKAGE_PIN M15 [get_ports {com_txd_p[1]}]
set_property PACKAGE_PIN K18 [get_ports {com_txd_p[2]}]
set_property PACKAGE_PIN L16 [get_ports {com_txd_p[3]}]

set_property PACKAGE_PIN L18 [get_ports {com_rxd_p[0]}]
set_property PACKAGE_PIN H19 [get_ports {com_rxd_p[1]}]

set_property PACKAGE_PIN T19 [get_ports com_txf]
set_property PACKAGE_PIN T20 [get_ports com_rxf]

set_property DRIVE 16 [get_ports com_txf]
set_property SLEW FAST [get_ports com_txf]
set_property PULLUP true [get_ports com_txf]
set_property PULLUP true [get_ports com_rxf]


set_property PACKAGE_PIN R19 [get_ports {com_cc[0]}]
set_property PACKAGE_PIN R20 [get_ports {com_cc[1]}]

## ADC Section
set_property IOSTANDARD LVCMOS33 [get_ports {adc_miso[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_mosi[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_sclk[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {adc_cs[*]}]

set_property PACKAGE_PIN E11 [get_ports {adc_miso[0]}]
set_property PACKAGE_PIN D13 [get_ports {adc_miso[1]}]
set_property PACKAGE_PIN D16 [get_ports {adc_miso[2]}]
set_property PACKAGE_PIN D18 [get_ports {adc_miso[3]}]

set_property PACKAGE_PIN F13 [get_ports {adc_mosi[0]}]
set_property PACKAGE_PIN A11 [get_ports {adc_mosi[1]}]
set_property PACKAGE_PIN E15 [get_ports {adc_mosi[2]}]
set_property PACKAGE_PIN C19 [get_ports {adc_mosi[3]}]

set_property PACKAGE_PIN G10 [get_ports {adc_sclk[0]}]
set_property PACKAGE_PIN G14 [get_ports {adc_sclk[1]}]
set_property PACKAGE_PIN B15 [get_ports {adc_sclk[2]}]
set_property PACKAGE_PIN A16 [get_ports {adc_sclk[3]}]

set_property PACKAGE_PIN G11 [get_ports {adc_cs[0]}]
set_property PACKAGE_PIN F12 [get_ports {adc_cs[1]}]
set_property PACKAGE_PIN C15 [get_ports {adc_cs[2]}]
set_property PACKAGE_PIN B14 [get_ports {adc_cs[3]}]



