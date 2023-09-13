set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

create_clock -period 20.000 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN M15 [get_ports rst_n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_01p]
# set_property PACKAGE_PIN T19 [get_ports pin_01p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_01n]
# set_property PACKAGE_PIN T20 [get_ports pin_01n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_02p]
# set_property PACKAGE_PIN U20 [get_ports pin_02p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_02n]
# set_property PACKAGE_PIN V20 [get_ports pin_02n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_03p]
# set_property PACKAGE_PIN W21 [get_ports pin_03p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_03n]
# set_property PACKAGE_PIN Y21 [get_ports pin_03n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_04p]
# set_property PACKAGE_PIN P17 [get_ports pin_04p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_04n]
# set_property PACKAGE_PIN R18 [get_ports pin_04n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_05p]
# set_property PACKAGE_PIN N15 [get_ports pin_05p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_05n]
# set_property PACKAGE_PIN R16 [get_ports pin_05n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_06p]
# set_property PACKAGE_PIN R17 [get_ports pin_06p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_06n]
# set_property PACKAGE_PIN T17 [get_ports pin_06n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_07p]
# set_property PACKAGE_PIN U17 [get_ports pin_07p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_07n]
# set_property PACKAGE_PIN U18 [get_ports pin_07n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_08p]
# set_property PACKAGE_PIN U19 [get_ports pin_08p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_08n]
# set_property PACKAGE_PIN V18 [get_ports pin_08n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_09p]
# set_property PACKAGE_PIN V19 [get_ports pin_09p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_09n]
# set_property PACKAGE_PIN V21 [get_ports pin_09n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_10p]
# set_property PACKAGE_PIN W22 [get_ports pin_10p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_10n]
# set_property PACKAGE_PIN V22 [get_ports pin_10n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_11p]
# set_property PACKAGE_PIN U22 [get_ports pin_11p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_11n]
# set_property PACKAGE_PIN T21 [get_ports pin_11n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_12p]
# set_property PACKAGE_PIN T22 [get_ports pin_12p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_12n]
# set_property PACKAGE_PIN P21 [get_ports pin_12n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_13p]
# set_property PACKAGE_PIN P22 [get_ports pin_13p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_13n]
# set_property PACKAGE_PIN N20 [get_ports pin_13n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_14p]
# set_property PACKAGE_PIN P20 [get_ports pin_14p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_14n]
# set_property PACKAGE_PIN AA22 [get_ports pin_14n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_15p]
# set_property PACKAGE_PIN AB21 [get_ports pin_15p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_15n]
# set_property PACKAGE_PIN Y22 [get_ports pin_15n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_16p]
# set_property PACKAGE_PIN Y20 [get_ports pin_16p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_16n]
# set_property PACKAGE_PIN AB20 [get_ports pin_16n]

# set_property IOSTANDARD LVCMOS33 [get_ports pin_17p]
# set_property PACKAGE_PIN W18 [get_ports pin_17p]
# set_property IOSTANDARD LVCMOS33 [get_ports pin_17n]
# set_property PACKAGE_PIN AA20 [get_ports pin_17n]

