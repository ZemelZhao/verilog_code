create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list crep_dut/clk_wiz_dut/inst/clk_fast]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 20 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {console_dut/console_usb_dut/console_usb_core_dut/state[0]} {console_dut/console_usb_dut/console_usb_core_dut/state[1]} {console_dut/console_usb_dut/console_usb_core_dut/state[2]} {console_dut/console_usb_dut/console_usb_core_dut/state[3]} {console_dut/console_usb_dut/console_usb_core_dut/state[4]} {console_dut/console_usb_dut/console_usb_core_dut/state[5]} {console_dut/console_usb_dut/console_usb_core_dut/state[6]} {console_dut/console_usb_dut/console_usb_core_dut/state[7]} {console_dut/console_usb_dut/console_usb_core_dut/state[8]} {console_dut/console_usb_dut/console_usb_core_dut/state[9]} {console_dut/console_usb_dut/console_usb_core_dut/state[10]} {console_dut/console_usb_dut/console_usb_core_dut/state[11]} {console_dut/console_usb_dut/console_usb_core_dut/state[12]} {console_dut/console_usb_dut/console_usb_core_dut/state[13]} {console_dut/console_usb_dut/console_usb_core_dut/state[14]} {console_dut/console_usb_dut/console_usb_core_dut/state[15]} {console_dut/console_usb_dut/console_usb_core_dut/state[16]} {console_dut/console_usb_dut/console_usb_core_dut/state[17]} {console_dut/console_usb_dut/console_usb_core_dut/state[18]} {console_dut/console_usb_dut/console_usb_core_dut/state[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[0]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[1]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[2]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[3]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[4]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[5]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[6]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[7]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[8]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[9]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[10]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[11]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[12]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[13]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[14]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[15]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[16]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[17]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[18]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[19]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[20]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[21]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[22]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[23]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[24]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[25]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[26]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[27]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[28]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[29]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[30]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fail_num[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 12 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[0]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[1]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[2]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[3]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[4]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[5]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[6]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[7]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[8]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[9]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[10]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[0]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[1]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[2]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[3]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[4]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[5]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[6]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[7]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[8]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[9]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[10]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[11]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[12]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[13]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[14]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[15]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[16]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[17]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[18]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[19]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[20]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[21]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[22]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[23]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[24]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[25]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[26]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[27]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[28]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[29]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[30]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/time_num[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {usb_inst[0].usb_dut/usb_cs_dut/state[0]} {usb_inst[0].usb_dut/usb_cs_dut/state[1]} {usb_inst[0].usb_dut/usb_cs_dut/state[2]} {usb_inst[0].usb_dut/usb_cs_dut/state[3]} {usb_inst[0].usb_dut/usb_cs_dut/state[4]} {usb_inst[0].usb_dut/usb_cs_dut/state[5]} {usb_inst[0].usb_dut/usb_cs_dut/state[6]} {usb_inst[0].usb_dut/usb_cs_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 4 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {usb_inst[0].usb_dut/usb_rxf_dut/state[0]} {usb_inst[0].usb_dut/usb_rxf_dut/state[1]} {usb_inst[0].usb_dut/usb_rxf_dut/state[2]} {usb_inst[0].usb_dut/usb_rxf_dut/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {usb_inst[0].usb_dut/com_rxd[0]} {usb_inst[0].usb_dut/com_rxd[1]} {usb_inst[0].usb_dut/com_rxd[2]} {usb_inst[0].usb_dut/com_rxd[3]} {usb_inst[0].usb_dut/com_rxd[4]} {usb_inst[0].usb_dut/com_rxd[5]} {usb_inst[0].usb_dut/com_rxd[6]} {usb_inst[0].usb_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 4 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {usb_inst[0].usb_dut/usb_rxd[0]} {usb_inst[0].usb_dut/usb_rxd[1]} {usb_inst[0].usb_dut/usb_rxd[2]} {usb_inst[0].usb_dut/usb_rxd[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {usb_inst[0].usb_dut/com_txd[0]} {usb_inst[0].usb_dut/com_txd[1]} {usb_inst[0].usb_dut/com_txd[2]} {usb_inst[0].usb_dut/com_txd[3]} {usb_inst[0].usb_dut/com_txd[4]} {usb_inst[0].usb_dut/com_txd[5]} {usb_inst[0].usb_dut/com_txd[6]} {usb_inst[0].usb_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 5 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {usb_inst[0].usb_dut/usb_txf_dut/state[0]} {usb_inst[0].usb_dut/usb_txf_dut/state[1]} {usb_inst[0].usb_dut/usb_txf_dut/state[2]} {usb_inst[0].usb_dut/usb_txf_dut/state[3]} {usb_inst[0].usb_dut/usb_txf_dut/state[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {usb_inst[0].usb_dut/pin_read}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {usb_inst[0].usb_dut/pin_send}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {usb_inst[0].usb_dut/usb_txd}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_fast]
