set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

############################## CLOCK SECTION ##############################
create_clock -period 5.000 [get_ports clk_p]
set_property PACKAGE_PIN AE10 [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]

############################## RSTN SECTION ##############################
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN F26 [get_ports rst_n]

############################## RSTN SECTION ##############################
set_property IOSTANDARD LVCMOS33 [get_ports fan_n]
set_property PACKAGE_PIN E26 [get_ports fan_n]

#############SPI Configurate Setting##################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

############## clock define##################
create_clock -period 5.000 [get_ports clk_p]
set_property PACKAGE_PIN AE10 [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]

##############UTIL define##################
set_property PACKAGE_PIN AF21 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

set_property PACKAGE_PIN AB30 [get_ports fan_n]
set_property IOSTANDARD LVCMOS33 [get_ports fan_n]

##############ETH define##################
set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd0p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {usb_txd0p}]
set_property IOSTANDARD LVCMOS33 [get_ports {usb_rxf}]
set_property IOSTANDARD LVCMOS33 [get_ports {usb_txf}]

set_property PACKAGE_PIN K14 [get_nets {usb_rxd0p[0]}]
set_property PACKAGE_PIN L11 [get_nets {usb_rxd0p[1]}]
set_property PACKAGE_PIN L12 [get_nets {usb_rxd0p[2]}]
set_property PACKAGE_PIN L15 [get_nets {usb_rxd0p[3]}]

set_property PACKAGE_PIN C15 [get_nets {usb_txd0p}]

set_property PACKAGE_PIN B25 [get_ports {usb_rxf}]
set_property PACKAGE_PIN C26 [get_ports {usb_txf}]

set_property IOSTANDARD LVCMOS33 [get_ports {led_n}]
set_property PACKAGE_PIN G27 [get_ports {led_n}]


# ############################## LED SECTION ##############################

# set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
# set_property PACKAGE_PIN G27 [get_ports {led[0]}]
# set_property PACKAGE_PIN F27 [get_ports {led[1]}]
# set_property PACKAGE_PIN F28 [get_ports {led[2]}]
# set_property PACKAGE_PIN G28 [get_ports {led[3]}]
# set_property PACKAGE_PIN D28 [get_ports {led[4]}]
# set_property PACKAGE_PIN E28 [get_ports {led[5]}]
# set_property PACKAGE_PIN F30 [get_ports {led[6]}]
# set_property PACKAGE_PIN G29 [get_ports {led[7]}]

# ############################## USBC SECTION ##############################
# set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd0p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd1p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd2p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd3p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd4p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd5p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd6p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd7p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_txd0p}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_txd1p}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_txd2p}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_txd3p}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_txd4p}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_txd5p}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_txd6p}]
# set_property IOSTANDARD LVDS_25 [get_ports {usb_txd7p}]
# set_property IOSTANDARD LVCMOS33 [get_ports {usb_rxf[*]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {usb_txf[*]}]

# set_property PACKAGE_PIN K14 [get_ports usb_rxd0p[0]]
# set_property PACKAGE_PIN L11 [get_ports usb_rxd0p[1]]
# set_property PACKAGE_PIN L12 [get_ports usb_rxd0p[2]]
# set_property PACKAGE_PIN L15 [get_ports usb_rxd0p[3]]

# set_property PACKAGE_PIN H15 [get_ports usb_rxd1p[0]]
# set_property PACKAGE_PIN J11 [get_ports usb_rxd1p[1]]
# set_property PACKAGE_PIN L16 [get_ports usb_rxd1p[2]]
# set_property PACKAGE_PIN K13 [get_ports usb_rxd1p[3]]

# set_property PACKAGE_PIN J16 [get_ports usb_rxd2p[0]]
# set_property PACKAGE_PIN F11 [get_ports usb_rxd2p[1]]
# set_property PACKAGE_PIN G13 [get_ports usb_rxd2p[2]]
# set_property PACKAGE_PIN H11 [get_ports usb_rxd2p[3]]

# set_property PACKAGE_PIN D11 [get_ports usb_rxd3p[0]]
# set_property PACKAGE_PIN C12 [get_ports usb_rxd3p[1]]
# set_property PACKAGE_PIN E14 [get_ports usb_rxd3p[2]]
# set_property PACKAGE_PIN H14 [get_ports usb_rxd3p[3]]

# set_property PACKAGE_PIN C17 [get_ports usb_rxd4p[0]]
# set_property PACKAGE_PIN K18 [get_ports usb_rxd4p[1]]
# set_property PACKAGE_PIN E19 [get_ports usb_rxd4p[2]]
# set_property PACKAGE_PIN A16 [get_ports usb_rxd4p[3]]

# set_property PACKAGE_PIN B18 [get_ports usb_rxd5p[0]]
# set_property PACKAGE_PIN D21 [get_ports usb_rxd5p[1]]
# set_property PACKAGE_PIN A20 [get_ports usb_rxd5p[2]]
# set_property PACKAGE_PIN D17 [get_ports usb_rxd5p[3]]

# set_property PACKAGE_PIN C19 [get_ports usb_rxd6p[0]]
# set_property PACKAGE_PIN G17 [get_ports usb_rxd6p[1]]
# set_property PACKAGE_PIN B22 [get_ports usb_rxd6p[2]]
# set_property PACKAGE_PIN F20 [get_ports usb_rxd6p[3]]

# set_property PACKAGE_PIN C20 [get_ports usb_rxd7p[0]]
# set_property PACKAGE_PIN D22 [get_ports usb_rxd7p[1]]
# set_property PACKAGE_PIN F21 [get_ports usb_rxd7p[2]]
# set_property PACKAGE_PIN G22 [get_ports usb_rxd7p[3]]

# set_property PACKAGE_PIN C15 [get_ports usb_txd0p]
# set_property PACKAGE_PIN A11 [get_ports usb_txd1p]
# set_property PACKAGE_PIN B14 [get_ports usb_txd2p]
# set_property PACKAGE_PIN F15 [get_ports usb_txd3p]
# set_property PACKAGE_PIN G18 [get_ports usb_txd4p]
# set_property PACKAGE_PIN H20 [get_ports usb_txd5p]
# set_property PACKAGE_PIN H21 [get_ports usb_txd6p]
# set_property PACKAGE_PIN J17 [get_ports usb_txd7p]

# set_property PACKAGE_PIN B25 [get_ports {usb_rxf[0]}]
# set_property PACKAGE_PIN C25 [get_ports {usb_rxf[1]}]
# set_property PACKAGE_PIN A26 [get_ports {usb_rxf[2]}]
# set_property PACKAGE_PIN A25 [get_ports {usb_rxf[3]}]
# set_property PACKAGE_PIN C24 [get_ports {usb_rxf[4]}]
# set_property PACKAGE_PIN B24 [get_ports {usb_rxf[5]}]
# set_property PACKAGE_PIN C30 [get_ports {usb_rxf[6]}]
# set_property PACKAGE_PIN D29 [get_ports {usb_rxf[7]}]

# set_property PACKAGE_PIN C26 [get_ports {usb_txf[0]}]
# set_property PACKAGE_PIN D26 [get_ports {usb_txf[1]}]
# set_property PACKAGE_PIN C27 [get_ports {usb_txf[2]}]
# set_property PACKAGE_PIN D27 [get_ports {usb_txf[3]}]
# set_property PACKAGE_PIN A27 [get_ports {usb_txf[4]}]
# set_property PACKAGE_PIN B27 [get_ports {usb_txf[5]}]
# set_property PACKAGE_PIN E30 [get_ports {usb_txf[6]}]
# set_property PACKAGE_PIN E29 [get_ports {usb_txf[7]}]

