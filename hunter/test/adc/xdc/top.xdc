set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
####################################

create_clock -period 5.000 [get_ports clk_p]
set_property PACKAGE_PIN AE10 [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]

set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN AF21 [get_ports rst_n]

set_property IOSTANDARD LVCMOS33 [get_ports {miso[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mosi[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sclk[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cs[*]}]


set_property PACKAGE_PIN H17 [get_ports {mosi[0]}]
set_property PACKAGE_PIN E20 [get_ports {mosi[1]}]
set_property PACKAGE_PIN J17 [get_ports {mosi[2]}]
set_property PACKAGE_PIN F20 [get_ports {mosi[3]}]

set_property PACKAGE_PIN H22 [get_ports {miso[0]}]
set_property PACKAGE_PIN A22 [get_ports {miso[1]}]
set_property PACKAGE_PIN H21 [get_ports {miso[2]}]
set_property PACKAGE_PIN B22 [get_ports {miso[3]}]

set_property PACKAGE_PIN E21 [get_ports {cs[0]}]
set_property PACKAGE_PIN A21 [get_ports {cs[1]}]
set_property PACKAGE_PIN F21 [get_ports {cs[2]}]
set_property PACKAGE_PIN A20 [get_ports {cs[3]}]

set_property PACKAGE_PIN F22 [get_ports {sclk[0]}]
set_property PACKAGE_PIN D18 [get_ports {sclk[1]}]
set_property PACKAGE_PIN G22 [get_ports {sclk[2]}]
set_property PACKAGE_PIN D17 [get_ports {sclk[3]}]


