
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
connect_debug_port u_ila_0/clk [get_nets [list clk_wiz_dut/inst/clk_fast]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {adc_dut/intan_dutd/state[0]} {adc_dut/intan_dutd/state[1]} {adc_dut/intan_dutd/state[2]} {adc_dut/intan_dutd/state[3]} {adc_dut/intan_dutd/state[4]} {adc_dut/intan_dutd/state[5]} {adc_dut/intan_dutd/state[6]} {adc_dut/intan_dutd/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {adc_dut/intan_duta/state[0]} {adc_dut/intan_duta/state[1]} {adc_dut/intan_duta/state[2]} {adc_dut/intan_duta/state[3]} {adc_dut/intan_duta/state[4]} {adc_dut/intan_duta/state[5]} {adc_dut/intan_duta/state[6]} {adc_dut/intan_duta/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {adc_dut/intan_dutb/state[0]} {adc_dut/intan_dutb/state[1]} {adc_dut/intan_dutb/state[2]} {adc_dut/intan_dutb/state[3]} {adc_dut/intan_dutb/state[4]} {adc_dut/intan_dutb/state[5]} {adc_dut/intan_dutb/state[6]} {adc_dut/intan_dutb/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {adc_dut/intan_dutc/state[0]} {adc_dut/intan_dutc/state[1]} {adc_dut/intan_dutc/state[2]} {adc_dut/intan_dutc/state[3]} {adc_dut/intan_dutc/state[4]} {adc_dut/intan_dutc/state[5]} {adc_dut/intan_dutc/state[6]} {adc_dut/intan_dutc/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {com_dut/com_cs_dut/state[0]} {com_dut/com_cs_dut/state[1]} {com_dut/com_cs_dut/state[2]} {com_dut/com_cs_dut/state[3]} {com_dut/com_cs_dut/state[4]} {com_dut/com_cs_dut/state[5]} {com_dut/com_cs_dut/state[6]} {com_dut/com_cs_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 4 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {com_dut/usb_txd[0]} {com_dut/usb_txd[1]} {com_dut/usb_txd[2]} {com_dut/usb_txd[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {com_dut/com_rxd[0]} {com_dut/com_rxd[1]} {com_dut/com_rxd[2]} {com_dut/com_rxd[3]} {com_dut/com_rxd[4]} {com_dut/com_rxd[5]} {com_dut/com_rxd[6]} {com_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {com_dut/com_txd[0]} {com_dut/com_txd[1]} {com_dut/com_txd[2]} {com_dut/com_txd[3]} {com_dut/com_txd[4]} {com_dut/com_txd[5]} {com_dut/com_txd[6]} {com_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {console_dut/state[0]} {console_dut/state[1]} {console_dut/state[2]} {console_dut/state[3]} {console_dut/state[4]} {console_dut/state[5]} {console_dut/state[6]} {console_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 4 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {pin_cs[0]} {pin_cs[1]} {pin_cs[2]} {pin_cs[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 4 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {pin_miso[0]} {pin_miso[1]} {pin_miso[2]} {pin_miso[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 4 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {pin_mosi[0]} {pin_mosi[1]} {pin_mosi[2]} {pin_mosi[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 4 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {pin_sclk[0]} {pin_sclk[1]} {pin_sclk[2]} {pin_sclk[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list com_dut/usb_rxd]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_fast]
