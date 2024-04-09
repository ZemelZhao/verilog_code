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
connect_debug_port u_ila_0/clk [get_nets [list crep_dut/clk_wiz_dut/inst/clk_norm]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[0]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[1]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[2]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[3]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[4]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[5]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[6]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[7]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[8]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[9]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[10]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[11]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[12]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[13]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[14]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/cnt[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[0]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[1]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[2]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[3]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[4]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[5]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[6]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[7]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[8]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[9]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[10]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[11]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[12]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[13]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[14]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[15]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[16]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[17]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[18]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[19]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[20]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[21]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[22]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[23]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[24]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[25]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[26]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[27]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[28]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[29]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[30]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/num[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[0]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[1]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[2]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[3]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[4]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[5]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[6]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[7]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[8]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[9]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[10]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[11]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[12]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[13]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[14]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/state[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 16 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[0]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[1]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[2]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[3]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[4]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[5]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[6]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[7]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[8]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[9]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[10]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[11]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[12]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[13]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[14]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/state[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[0]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[1]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[2]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[3]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[4]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[5]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[6]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[7]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[8]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[9]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[10]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[11]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[12]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[13]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[14]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[15]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[16]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[17]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[18]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[19]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[20]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[21]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[22]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[23]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[24]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[25]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[26]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[27]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[28]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[29]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[30]} {trgg_dut/trgg_out_inst[0].trgg_out_dut/num[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[0]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[1]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[2]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[3]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[4]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[5]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[6]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[7]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[8]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[9]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[10]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[11]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[12]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[13]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[14]} {trgg_dut/trgg_out_inst[1].trgg_out_dut/cnt[15]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_norm]
