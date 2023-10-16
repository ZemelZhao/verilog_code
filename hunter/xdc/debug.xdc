set_property MARK_DEBUG false [get_nets console_dut/next_state_inferred_i_19_n_0]

connect_debug_port u_ila_0/probe0 [get_nets [list {console_dut/state_0[0]} {console_dut/state_0[1]} {console_dut/state_0[2]} {console_dut/state_0[3]} {console_dut/state_0[4]} {console_dut/state_0[5]} {console_dut/state_0[6]} {console_dut/state_0[7]}]]

connect_debug_port u_ila_0/probe0 [get_nets [list {console_dut/state[0]} {console_dut/state[1]} {console_dut/state[2]} {console_dut/state[3]} {console_dut/state[4]} {console_dut/state[5]} {console_dut/state[6]} {console_dut/state[7]}]]



create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_wiz_dut/inst/clk_200]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 24 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {console_dut/state_0[0]} {console_dut/state_0[1]} {console_dut/state_0[2]} {console_dut/state_0[3]} {console_dut/state_0[4]} {console_dut/state_0[5]} {console_dut/state_0[6]} {console_dut/state_0[7]} {console_dut/state_0[8]} {console_dut/state_0[9]} {console_dut/state_0[10]} {console_dut/state_0[11]} {console_dut/state_0[12]} {console_dut/state_0[13]} {console_dut/state_0[14]} {console_dut/state_0[15]} {console_dut/state_0[16]} {console_dut/state_0[17]} {console_dut/state_0[18]} {console_dut/state_0[19]} {console_dut/state_0[20]} {console_dut/state_0[21]} {console_dut/state_0[22]} {console_dut/state_0[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {pin_txd[0]} {pin_txd[1]} {pin_txd[2]} {pin_txd[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list fire_read]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list fire_send]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list pin_rxd]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_200]
