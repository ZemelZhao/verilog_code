
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
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports fan_n]
set_property IOSTANDARD LVCMOS33 [get_ports {led_n[*]}]

set_property DRIVE 16 [get_ports fan_n]
set_property DRIVE 16 [get_ports {led_n[*]}]

set_property PACKAGE_PIN F26 [get_ports rst_n]
set_property PACKAGE_PIN E26 [get_ports fan_n]

set_property PACKAGE_PIN G27 [get_ports {led_n[0]}]
set_property PACKAGE_PIN F27 [get_ports {led_n[1]}]
set_property PACKAGE_PIN F28 [get_ports {led_n[2]}]
set_property PACKAGE_PIN G28 [get_ports {led_n[3]}]
set_property PACKAGE_PIN D28 [get_ports {led_n[4]}]
set_property PACKAGE_PIN E28 [get_ports {led_n[5]}]
set_property PACKAGE_PIN F30 [get_ports {led_n[6]}]
set_property PACKAGE_PIN G29 [get_ports {led_n[7]}]

##############ETH define##################
create_clock -period 8.000 [get_ports e_grxc]

set_property IOSTANDARD LVCMOS33 [get_ports {e_rxd[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {e_txd[*]}]

set_property SLEW FAST [get_ports {e_txd[*]}]
set_property DRIVE 12 [get_ports {e_txd[*]}]

set_property IOSTANDARD LVCMOS33 [get_ports e_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports e_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports e_rstn]
set_property IOSTANDARD LVCMOS33 [get_ports e_grxc]
set_property IOSTANDARD LVCMOS33 [get_ports e_rxdv]
set_property IOSTANDARD LVCMOS33 [get_ports e_rxer]
set_property IOSTANDARD LVCMOS33 [get_ports e_gtxc]
set_property IOSTANDARD LVCMOS33 [get_ports e_txen]
set_property IOSTANDARD LVCMOS33 [get_ports e_txer]

set_property SLEW FAST [get_ports e_gtxc]
set_property SLEW FAST [get_ports e_txen]

set_property PACKAGE_PIN N22 [get_ports {e_rxd[6]}]
set_property PACKAGE_PIN L25 [get_ports {e_rxd[5]}]
set_property PACKAGE_PIN K25 [get_ports {e_rxd[4]}]
set_property PACKAGE_PIN N24 [get_ports {e_rxd[3]}]
set_property PACKAGE_PIN K23 [get_ports {e_rxd[2]}]
set_property PACKAGE_PIN K24 [get_ports {e_rxd[1]}]
set_property PACKAGE_PIN M22 [get_ports {e_rxd[0]}]
set_property PACKAGE_PIN N21 [get_ports {e_rxd[7]}]
set_property PACKAGE_PIN M23 [get_ports e_rxdv]

set_property PACKAGE_PIN M30 [get_ports {e_txd[7]}]
set_property PACKAGE_PIN P21 [get_ports {e_txd[6]}]
set_property PACKAGE_PIN P22 [get_ports {e_txd[5]}]
set_property PACKAGE_PIN K28 [get_ports {e_txd[4]}]
set_property PACKAGE_PIN L21 [get_ports {e_txd[3]}]
set_property PACKAGE_PIN K21 [get_ports {e_txd[2]}]
set_property PACKAGE_PIN N27 [get_ports {e_txd[1]}]
set_property PACKAGE_PIN M20 [get_ports {e_txd[0]}]

set_property PACKAGE_PIN N20 [get_ports e_mdc]
set_property PACKAGE_PIN N19 [get_ports e_mdio]
set_property PACKAGE_PIN M27 [get_ports e_rstn]
set_property PACKAGE_PIN P23 [get_ports e_grxc]
set_property PACKAGE_PIN K30 [get_ports e_rxer]
set_property PACKAGE_PIN J21 [get_ports e_gtxc]
set_property PACKAGE_PIN L20 [get_ports e_txen]
set_property PACKAGE_PIN M29 [get_ports e_txer]


##############ETH define##################
set_property IOSTANDARD LVDS_25 [get_ports {u_rxd_p[*]}]
set_property IOSTANDARD LVDS_25 [get_ports {u_txd_p[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {u_txen[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {u_rxdv[*]}]
set_property PULLUP true [get_ports {u_rxdv[*]}]

set_property SLEW FAST [get_ports {u_txen[*]}]
set_property DRIVE 16 [get_ports {u_txen[*]}]

set_property PACKAGE_PIN L15 [get_ports {u_rxd_p[0]}]
set_property PACKAGE_PIN L12 [get_ports {u_rxd_p[1]}]
set_property PACKAGE_PIN L11 [get_ports {u_rxd_p[2]}]
set_property PACKAGE_PIN K14 [get_ports {u_rxd_p[3]}]
set_property PACKAGE_PIN K13 [get_ports {u_rxd_p[4]}]
set_property PACKAGE_PIN L16 [get_ports {u_rxd_p[5]}]
set_property PACKAGE_PIN J11 [get_ports {u_rxd_p[6]}]
set_property PACKAGE_PIN H15 [get_ports {u_rxd_p[7]}]
set_property PACKAGE_PIN H11 [get_ports {u_rxd_p[8]}]
set_property PACKAGE_PIN G13 [get_ports {u_rxd_p[9]}]
set_property PACKAGE_PIN F11 [get_ports {u_rxd_p[10]}]
set_property PACKAGE_PIN J16 [get_ports {u_rxd_p[11]}]
set_property PACKAGE_PIN H14 [get_ports {u_rxd_p[12]}]
set_property PACKAGE_PIN E14 [get_ports {u_rxd_p[13]}]
set_property PACKAGE_PIN C12 [get_ports {u_rxd_p[14]}]
set_property PACKAGE_PIN D11 [get_ports {u_rxd_p[15]}]
set_property PACKAGE_PIN A16 [get_ports {u_rxd_p[16]}]
set_property PACKAGE_PIN E19 [get_ports {u_rxd_p[17]}]
set_property PACKAGE_PIN K18 [get_ports {u_rxd_p[18]}]
set_property PACKAGE_PIN C17 [get_ports {u_rxd_p[19]}]
set_property PACKAGE_PIN D17 [get_ports {u_rxd_p[20]}]
set_property PACKAGE_PIN A20 [get_ports {u_rxd_p[21]}]
set_property PACKAGE_PIN D21 [get_ports {u_rxd_p[22]}]
set_property PACKAGE_PIN B18 [get_ports {u_rxd_p[23]}]
set_property PACKAGE_PIN F20 [get_ports {u_rxd_p[24]}]
set_property PACKAGE_PIN B22 [get_ports {u_rxd_p[25]}]
set_property PACKAGE_PIN G17 [get_ports {u_rxd_p[26]}]
set_property PACKAGE_PIN C19 [get_ports {u_rxd_p[27]}]
set_property PACKAGE_PIN G22 [get_ports {u_rxd_p[28]}]
set_property PACKAGE_PIN F21 [get_ports {u_rxd_p[29]}]
set_property PACKAGE_PIN D22 [get_ports {u_rxd_p[30]}]
set_property PACKAGE_PIN C20 [get_ports {u_rxd_p[31]}]

set_property PACKAGE_PIN C15 [get_ports {u_txd_p[0]}]
set_property PACKAGE_PIN A11 [get_ports {u_txd_p[1]}]
set_property PACKAGE_PIN B14 [get_ports {u_txd_p[2]}]
set_property PACKAGE_PIN F15 [get_ports {u_txd_p[3]}]
set_property PACKAGE_PIN G18 [get_ports {u_txd_p[4]}]
set_property PACKAGE_PIN H20 [get_ports {u_txd_p[5]}]
set_property PACKAGE_PIN H21 [get_ports {u_txd_p[6]}]
set_property PACKAGE_PIN J17 [get_ports {u_txd_p[7]}]

set_property PACKAGE_PIN C26 [get_ports {u_txen[0]}]
set_property PACKAGE_PIN D26 [get_ports {u_txen[1]}]
set_property PACKAGE_PIN C27 [get_ports {u_txen[2]}]
set_property PACKAGE_PIN D27 [get_ports {u_txen[3]}]
set_property PACKAGE_PIN A27 [get_ports {u_txen[4]}]
set_property PACKAGE_PIN B27 [get_ports {u_txen[5]}]
set_property PACKAGE_PIN E30 [get_ports {u_txen[6]}]
set_property PACKAGE_PIN E29 [get_ports {u_txen[7]}]

