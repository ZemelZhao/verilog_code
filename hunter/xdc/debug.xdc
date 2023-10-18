create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_wiz_dut/inst/clk_300]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 24 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {console_dut/state[0]} {console_dut/state[1]} {console_dut/state[2]} {console_dut/state[3]} {console_dut/state[4]} {console_dut/state[5]} {console_dut/state[6]} {console_dut/state[7]} {console_dut/state[8]} {console_dut/state[9]} {console_dut/state[10]} {console_dut/state[11]} {console_dut/state[12]} {console_dut/state[13]} {console_dut/state[14]} {console_dut/state[15]} {console_dut/state[16]} {console_dut/state[17]} {console_dut/state[18]} {console_dut/state[19]} {console_dut/state[20]} {console_dut/state[21]} {console_dut/state[22]} {console_dut/state[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {pin_txd[0]} {pin_txd[1]} {pin_txd[2]} {pin_txd[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {adc_test_dut/state[0]} {adc_test_dut/state[1]} {adc_test_dut/state[2]} {adc_test_dut/state[3]} {adc_test_dut/state[4]} {adc_test_dut/state[5]} {adc_test_dut/state[6]} {adc_test_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {com_dut/com_cc_dut/state[0]} {com_dut/com_cc_dut/state[1]} {com_dut/com_cc_dut/state[2]} {com_dut/com_cc_dut/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 3 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {com_dut/com_cc_dut/lut[0]} {com_dut/com_cc_dut/lut[1]} {com_dut/com_cc_dut/lut[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 7 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {com_dut/com_rxf_dut/tmp_rxd[0]} {com_dut/com_rxf_dut/tmp_rxd[1]} {com_dut/com_rxf_dut/tmp_rxd[2]} {com_dut/com_rxf_dut/tmp_rxd[3]} {com_dut/com_rxf_dut/tmp_rxd[4]} {com_dut/com_rxf_dut/tmp_rxd[5]} {com_dut/com_rxf_dut/tmp_rxd[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {com_dut/com_rxf_dut/state[0]} {com_dut/com_rxf_dut/state[1]} {com_dut/com_rxf_dut/state[2]} {com_dut/com_rxf_dut/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {com_dut/com_cs_dut/state[0]} {com_dut/com_cs_dut/state[1]} {com_dut/com_cs_dut/state[2]} {com_dut/com_cs_dut/state[3]} {com_dut/com_cs_dut/state[4]} {com_dut/com_cs_dut/state[5]} {com_dut/com_cs_dut/state[6]} {com_dut/com_cs_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {com_dut/com_txd[0]} {com_dut/com_txd[1]} {com_dut/com_txd[2]} {com_dut/com_txd[3]} {com_dut/com_txd[4]} {com_dut/com_txd[5]} {com_dut/com_txd[6]} {com_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {com_dut/com_rxd[0]} {com_dut/com_rxd[1]} {com_dut/com_rxd[2]} {com_dut/com_rxd[3]} {com_dut/com_rxd[4]} {com_dut/com_rxd[5]} {com_dut/com_rxd[6]} {com_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list com_dut/com_rxf_dut/din]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list fire_read]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list fire_send]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list pin_rxd]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_300]
