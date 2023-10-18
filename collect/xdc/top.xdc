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

##############UTIL define##################
# set_property PACKAGE_PIN F26 [get_ports rst_n]
set_property PACKAGE_PIN M23 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

set_property PACKAGE_PIN E26 [get_ports fan_n]
set_property IOSTANDARD LVCMOS33 [get_ports fan_n]

set_property PACKAGE_PIN G27 [get_ports led_n]
set_property IOSTANDARD LVCMOS33 [get_ports led_n]


##############ETH define##################
# create_clock -period 8.000 [get_ports e_grxc]

# set_property IOSTANDARD LVCMOS33 [get_ports {e_rxd[*]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {e_txd[*]}]
# set_property SLEW FAST [get_ports {e_txd[*]}]

# set_property IOSTANDARD LVCMOS33 [get_ports e_mdc]
# set_property IOSTANDARD LVCMOS33 [get_ports e_mdio]
# set_property IOSTANDARD LVCMOS33 [get_ports e_rstn]
# set_property IOSTANDARD LVCMOS33 [get_ports e_grxc]
# set_property IOSTANDARD LVCMOS33 [get_ports e_rxdv]
# set_property IOSTANDARD LVCMOS33 [get_ports e_rxer]
# set_property IOSTANDARD LVCMOS33 [get_ports e_gtxc]
# set_property IOSTANDARD LVCMOS33 [get_ports e_txen]
# set_property IOSTANDARD LVCMOS33 [get_ports e_txer]

# set_property SLEW FAST [get_ports e_gtxc]
# set_property SLEW FAST [get_ports e_txen]

# set_property PACKAGE_PIN N21 [get_ports {e_rxd[7]}]
# set_property PACKAGE_PIN N22 [get_ports {e_rxd[6]}]
# set_property PACKAGE_PIN L25 [get_ports {e_rxd[5]}]
# set_property PACKAGE_PIN K25 [get_ports {e_rxd[4]}]
# set_property PACKAGE_PIN N24 [get_ports {e_rxd[3]}]
# set_property PACKAGE_PIN K23 [get_ports {e_rxd[2]}]
# set_property PACKAGE_PIN K24 [get_ports {e_rxd[1]}]
# set_property PACKAGE_PIN M22 [get_ports {e_rxd[0]}]

# set_property PACKAGE_PIN M30 [get_ports {e_txd[7]}]
# set_property PACKAGE_PIN P21 [get_ports {e_txd[6]}]
# set_property PACKAGE_PIN P22 [get_ports {e_txd[5]}]
# set_property PACKAGE_PIN K28 [get_ports {e_txd[4]}]
# set_property PACKAGE_PIN L21 [get_ports {e_txd[3]}]
# set_property PACKAGE_PIN K21 [get_ports {e_txd[2]}]
# set_property PACKAGE_PIN N27 [get_ports {e_txd[1]}]
# set_property PACKAGE_PIN M20 [get_ports {e_txd[0]}]

# set_property PACKAGE_PIN N20 [get_ports e_mdc]
# set_property PACKAGE_PIN N19 [get_ports e_mdio]
# set_property PACKAGE_PIN M27 [get_ports e_rstn]
# set_property PACKAGE_PIN P23 [get_ports e_grxc]
# set_property PACKAGE_PIN M23 [get_ports e_rxdv]
# set_property PACKAGE_PIN K30 [get_ports e_rxer]
# set_property PACKAGE_PIN J21 [get_ports e_gtxc]
# set_property PACKAGE_PIN L20 [get_ports e_txen]
# set_property PACKAGE_PIN M29 [get_ports e_txer]


# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets e_grxc_IBUF_BUFG]
# set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets e_grxc_IBUF]

##############ETH define##################
set_property IOSTANDARD LVDS_25 [get_ports {usb_rxd_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports usb_txd_p]
set_property IOSTANDARD LVCMOS33 [get_ports usb_rxf]
set_property IOSTANDARD LVCMOS33 [get_ports usb_txf]

set_property PACKAGE_PIN K14 [get_ports {usb_rxd_p[0]}]
set_property PACKAGE_PIN L11 [get_ports {usb_rxd_p[1]}]
set_property PACKAGE_PIN L12 [get_ports {usb_rxd_p[2]}]
set_property PACKAGE_PIN L15 [get_ports {usb_rxd_p[3]}]
set_property PACKAGE_PIN C15 [get_ports usb_txd_p]
set_property PACKAGE_PIN B25 [get_ports usb_rxf]
set_property PACKAGE_PIN C26 [get_ports usb_txf]

# set_property IOSTANDARD LVDS_25 [get_ports {usb1_rxd_p[*]}]
# set_property IOSTANDARD LVDS_25 [get_ports usb1_txd_p]
# set_property IOSTANDARD LVCMOS33 [get_ports usb1_rxf]
# set_property IOSTANDARD LVCMOS33 [get_ports usb1_txf]

# set_property PACKAGE_PIN L16 [get_ports {usb1_rxd_p[0]}]
# set_property PACKAGE_PIN K13 [get_ports {usb1_rxd_p[1]}]
# set_property PACKAGE_PIN H15 [get_ports {usb1_rxd_p[2]}]
# set_property PACKAGE_PIN J11 [get_ports {usb1_rxd_p[3]}]

# set_property PACKAGE_PIN A11 [get_ports usb1_txd_p]
# set_property PACKAGE_PIN C25 [get_ports usb1_rxf]
# set_property PACKAGE_PIN D26 [get_ports usb1_txf]