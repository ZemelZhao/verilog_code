

connect_debug_port u_ila_0/probe3 [get_nets [list {console_dut/state[0]} {console_dut/state[1]} {console_dut/state[2]} {console_dut/state[3]} {console_dut/state[4]} {console_dut/state[5]} {console_dut/state[6]} {console_dut/state[7]}]]

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
connect_debug_port u_ila_0/clk [get_nets [list crep_dut/clk_wiz_dut/inst/clk_fast]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {com_dut/com_rxd[0]} {com_dut/com_rxd[1]} {com_dut/com_rxd[2]} {com_dut/com_rxd[3]} {com_dut/com_rxd[4]} {com_dut/com_rxd[5]} {com_dut/com_rxd[6]} {com_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {com_dut/com_txd[0]} {com_dut/com_txd[1]} {com_dut/com_txd[2]} {com_dut/com_txd[3]} {com_dut/com_txd[4]} {com_dut/com_txd[5]} {com_dut/com_txd[6]} {com_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {crep_dut/com_rxd[0]} {crep_dut/com_rxd[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {crep_dut/com_txd[0]} {crep_dut/com_txd[1]} {crep_dut/com_txd[2]} {crep_dut/com_txd[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {com_dut/com_cs_dut/fail_num[0]} {com_dut/com_cs_dut/fail_num[1]} {com_dut/com_cs_dut/fail_num[2]} {com_dut/com_cs_dut/fail_num[3]} {com_dut/com_cs_dut/fail_num[4]} {com_dut/com_cs_dut/fail_num[5]} {com_dut/com_cs_dut/fail_num[6]} {com_dut/com_cs_dut/fail_num[7]} {com_dut/com_cs_dut/fail_num[8]} {com_dut/com_cs_dut/fail_num[9]} {com_dut/com_cs_dut/fail_num[10]} {com_dut/com_cs_dut/fail_num[11]} {com_dut/com_cs_dut/fail_num[12]} {com_dut/com_cs_dut/fail_num[13]} {com_dut/com_cs_dut/fail_num[14]} {com_dut/com_cs_dut/fail_num[15]} {com_dut/com_cs_dut/fail_num[16]} {com_dut/com_cs_dut/fail_num[17]} {com_dut/com_cs_dut/fail_num[18]} {com_dut/com_cs_dut/fail_num[19]} {com_dut/com_cs_dut/fail_num[20]} {com_dut/com_cs_dut/fail_num[21]} {com_dut/com_cs_dut/fail_num[22]} {com_dut/com_cs_dut/fail_num[23]} {com_dut/com_cs_dut/fail_num[24]} {com_dut/com_cs_dut/fail_num[25]} {com_dut/com_cs_dut/fail_num[26]} {com_dut/com_cs_dut/fail_num[27]} {com_dut/com_cs_dut/fail_num[28]} {com_dut/com_cs_dut/fail_num[29]} {com_dut/com_cs_dut/fail_num[30]} {com_dut/com_cs_dut/fail_num[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {com_dut/com_cs_dut/state[0]} {com_dut/com_cs_dut/state[1]} {com_dut/com_cs_dut/state[2]} {com_dut/com_cs_dut/state[3]} {com_dut/com_cs_dut/state[4]} {com_dut/com_cs_dut/state[5]} {com_dut/com_cs_dut/state[6]} {com_dut/com_cs_dut/state[7]} {com_dut/com_cs_dut/state[8]} {com_dut/com_cs_dut/state[9]} {com_dut/com_cs_dut/state[10]} {com_dut/com_cs_dut/state[11]} {com_dut/com_cs_dut/state[12]} {com_dut/com_cs_dut/state[13]} {com_dut/com_cs_dut/state[14]} {com_dut/com_cs_dut/state[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 64 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {com_dut/com_cs_dut/time_num[0]} {com_dut/com_cs_dut/time_num[1]} {com_dut/com_cs_dut/time_num[2]} {com_dut/com_cs_dut/time_num[3]} {com_dut/com_cs_dut/time_num[4]} {com_dut/com_cs_dut/time_num[5]} {com_dut/com_cs_dut/time_num[6]} {com_dut/com_cs_dut/time_num[7]} {com_dut/com_cs_dut/time_num[8]} {com_dut/com_cs_dut/time_num[9]} {com_dut/com_cs_dut/time_num[10]} {com_dut/com_cs_dut/time_num[11]} {com_dut/com_cs_dut/time_num[12]} {com_dut/com_cs_dut/time_num[13]} {com_dut/com_cs_dut/time_num[14]} {com_dut/com_cs_dut/time_num[15]} {com_dut/com_cs_dut/time_num[16]} {com_dut/com_cs_dut/time_num[17]} {com_dut/com_cs_dut/time_num[18]} {com_dut/com_cs_dut/time_num[19]} {com_dut/com_cs_dut/time_num[20]} {com_dut/com_cs_dut/time_num[21]} {com_dut/com_cs_dut/time_num[22]} {com_dut/com_cs_dut/time_num[23]} {com_dut/com_cs_dut/time_num[24]} {com_dut/com_cs_dut/time_num[25]} {com_dut/com_cs_dut/time_num[26]} {com_dut/com_cs_dut/time_num[27]} {com_dut/com_cs_dut/time_num[28]} {com_dut/com_cs_dut/time_num[29]} {com_dut/com_cs_dut/time_num[30]} {com_dut/com_cs_dut/time_num[31]} {com_dut/com_cs_dut/time_num[32]} {com_dut/com_cs_dut/time_num[33]} {com_dut/com_cs_dut/time_num[34]} {com_dut/com_cs_dut/time_num[35]} {com_dut/com_cs_dut/time_num[36]} {com_dut/com_cs_dut/time_num[37]} {com_dut/com_cs_dut/time_num[38]} {com_dut/com_cs_dut/time_num[39]} {com_dut/com_cs_dut/time_num[40]} {com_dut/com_cs_dut/time_num[41]} {com_dut/com_cs_dut/time_num[42]} {com_dut/com_cs_dut/time_num[43]} {com_dut/com_cs_dut/time_num[44]} {com_dut/com_cs_dut/time_num[45]} {com_dut/com_cs_dut/time_num[46]} {com_dut/com_cs_dut/time_num[47]} {com_dut/com_cs_dut/time_num[48]} {com_dut/com_cs_dut/time_num[49]} {com_dut/com_cs_dut/time_num[50]} {com_dut/com_cs_dut/time_num[51]} {com_dut/com_cs_dut/time_num[52]} {com_dut/com_cs_dut/time_num[53]} {com_dut/com_cs_dut/time_num[54]} {com_dut/com_cs_dut/time_num[55]} {com_dut/com_cs_dut/time_num[56]} {com_dut/com_cs_dut/time_num[57]} {com_dut/com_cs_dut/time_num[58]} {com_dut/com_cs_dut/time_num[59]} {com_dut/com_cs_dut/time_num[60]} {com_dut/com_cs_dut/time_num[61]} {com_dut/com_cs_dut/time_num[62]} {com_dut/com_cs_dut/time_num[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {com_dut/com_cs_dut/num_cnt[0]} {com_dut/com_cs_dut/num_cnt[1]} {com_dut/com_cs_dut/num_cnt[2]} {com_dut/com_cs_dut/num_cnt[3]} {com_dut/com_cs_dut/num_cnt[4]} {com_dut/com_cs_dut/num_cnt[5]} {com_dut/com_cs_dut/num_cnt[6]} {com_dut/com_cs_dut/num_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list crep_dut/fire_read]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list crep_dut/fire_send]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_fast]
