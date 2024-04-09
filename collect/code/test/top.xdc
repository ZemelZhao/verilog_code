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

set_property IOSTANDARD LVCMOS33 [get_ports fan_n]
set_property PACKAGE_PIN E26 [get_ports fan_n]

set_property IOSTANDARD LVCMOS33 [get_ports {trgg_out[*]}]
set_property PACKAGE_PIN J29 [get_ports {trgg_out[0]}]
set_property PACKAGE_PIN J27 [get_ports {trgg_out[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {trgg_miso[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {trgg_mosi[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {trgg_cs[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {trgg_sclk[*]}]

set_property PACKAGE_PIN H25 [get_ports {trgg_sclk[0]}]
set_property PACKAGE_PIN E23 [get_ports {trgg_sclk[1]}]
set_property PACKAGE_PIN H24 [get_ports {trgg_cs[0]}]
set_property PACKAGE_PIN D23 [get_ports {trgg_cs[1]}]
set_property PACKAGE_PIN A23 [get_ports {trgg_mosi[0]}]
set_property PACKAGE_PIN G24 [get_ports {trgg_mosi[1]}]
set_property PACKAGE_PIN B23 [get_ports {trgg_miso[0]}]
set_property PACKAGE_PIN G23 [get_ports {trgg_miso[1]}]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_wiz/inst/clk_norm]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[0]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[1]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[2]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[3]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[4]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[5]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[6]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[7]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[8]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[9]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[10]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[11]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[12]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[13]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[14]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/spi_dut/data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[0]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[1]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[2]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[3]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[4]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[5]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[6]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[7]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[8]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[9]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[10]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[11]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[12]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[13]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[14]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/spi_dut/data[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/state[0]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/state[1]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/state[2]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/state[3]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/state[4]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/state[5]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/state[6]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/state[0]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/state[1]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/state[2]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/state[3]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/state[4]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/state[5]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/state[6]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[0]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[1]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[2]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[3]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[4]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[5]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[6]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[7]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[8]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[9]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[10]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[11]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[12]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[13]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[14]} {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/rxd[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[0]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[1]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[2]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[3]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[4]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[5]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[6]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[7]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[8]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[9]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[10]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[11]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[12]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[13]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[14]} {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/rxd[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 16 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {trgg_rxd1[0]} {trgg_rxd1[1]} {trgg_rxd1[2]} {trgg_rxd1[3]} {trgg_rxd1[4]} {trgg_rxd1[5]} {trgg_rxd1[6]} {trgg_rxd1[7]} {trgg_rxd1[8]} {trgg_rxd1[9]} {trgg_rxd1[10]} {trgg_rxd1[11]} {trgg_rxd1[12]} {trgg_rxd1[13]} {trgg_rxd1[14]} {trgg_rxd1[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 16 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {trgg_rxd0[0]} {trgg_rxd0[1]} {trgg_rxd0[2]} {trgg_rxd0[3]} {trgg_rxd0[4]} {trgg_rxd0[5]} {trgg_rxd0[6]} {trgg_rxd0[7]} {trgg_rxd0[8]} {trgg_rxd0[9]} {trgg_rxd0[10]} {trgg_rxd0[11]} {trgg_rxd0[12]} {trgg_rxd0[13]} {trgg_rxd0[14]} {trgg_rxd0[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/cs}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/cs}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/miso}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/miso}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/mosi}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/mosi}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[0].ads_dut/sclk}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {trgg_dut/trgg_in_dut/ads_inst[1].ads_dut/sclk}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
