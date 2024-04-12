
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
connect_debug_port u_ila_0/clk [get_nets [list crep_dut/clk_wiz_dut/inst/clk_fast]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {com_dut/com_cc_dut/lut[0]} {com_dut/com_cc_dut/lut[1]} {com_dut/com_cc_dut/lut[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {com_dut/com_cc_dut/state[0]} {com_dut/com_cc_dut/state[1]} {com_dut/com_cc_dut/state[2]} {com_dut/com_cc_dut/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {com_dut/com_rx_dut/state[0]} {com_dut/com_rx_dut/state[1]} {com_dut/com_rx_dut/state[2]} {com_dut/com_rx_dut/state[3]} {com_dut/com_rx_dut/state[4]} {com_dut/com_rx_dut/state[5]} {com_dut/com_rx_dut/state[6]} {com_dut/com_rx_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {com_dut/com_rxf_dut/state[0]} {com_dut/com_rxf_dut/state[1]} {com_dut/com_rxf_dut/state[2]} {com_dut/com_rxf_dut/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 7 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {com_dut/com_rxf_dut/tmp_rxd[0]} {com_dut/com_rxf_dut/tmp_rxd[1]} {com_dut/com_rxf_dut/tmp_rxd[2]} {com_dut/com_rxf_dut/tmp_rxd[3]} {com_dut/com_rxf_dut/tmp_rxd[4]} {com_dut/com_rxf_dut/tmp_rxd[5]} {com_dut/com_rxf_dut/tmp_rxd[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {com_dut/com_cs_dut/state[0]} {com_dut/com_cs_dut/state[1]} {com_dut/com_cs_dut/state[2]} {com_dut/com_cs_dut/state[3]} {com_dut/com_cs_dut/state[4]} {com_dut/com_cs_dut/state[5]} {com_dut/com_cs_dut/state[6]} {com_dut/com_cs_dut/state[7]} {com_dut/com_cs_dut/state[8]} {com_dut/com_cs_dut/state[9]} {com_dut/com_cs_dut/state[10]} {com_dut/com_cs_dut/state[11]} {com_dut/com_cs_dut/state[12]} {com_dut/com_cs_dut/state[13]} {com_dut/com_cs_dut/state[14]} {com_dut/com_cs_dut/state[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {com_dut/com_cs_dut/time_cnt[0]} {com_dut/com_cs_dut/time_cnt[1]} {com_dut/com_cs_dut/time_cnt[2]} {com_dut/com_cs_dut/time_cnt[3]} {com_dut/com_cs_dut/time_cnt[4]} {com_dut/com_cs_dut/time_cnt[5]} {com_dut/com_cs_dut/time_cnt[6]} {com_dut/com_cs_dut/time_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 4 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {com_dut/com_cs_dut/rx_btype[0]} {com_dut/com_cs_dut/rx_btype[1]} {com_dut/com_cs_dut/rx_btype[2]} {com_dut/com_cs_dut/rx_btype[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {com_dut/com_cs_dut/num_cnt[0]} {com_dut/com_cs_dut/num_cnt[1]} {com_dut/com_cs_dut/num_cnt[2]} {com_dut/com_cs_dut/num_cnt[3]} {com_dut/com_cs_dut/num_cnt[4]} {com_dut/com_cs_dut/num_cnt[5]} {com_dut/com_cs_dut/num_cnt[6]} {com_dut/com_cs_dut/num_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {com_dut/com_rxd[0]} {com_dut/com_rxd[1]} {com_dut/com_rxd[2]} {com_dut/com_rxd[3]} {com_dut/com_rxd[4]} {com_dut/com_rxd[5]} {com_dut/com_rxd[6]} {com_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {com_dut/com_txd[0]} {com_dut/com_txd[1]} {com_dut/com_txd[2]} {com_dut/com_txd[3]} {com_dut/com_txd[4]} {com_dut/com_txd[5]} {com_dut/com_txd[6]} {com_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 4 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {crep_dut/com_txd[0]} {crep_dut/com_txd[1]} {crep_dut/com_txd[2]} {crep_dut/com_txd[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {console_dut/state[0]} {console_dut/state[1]} {console_dut/state[2]} {console_dut/state[3]} {console_dut/state[4]} {console_dut/state[5]} {console_dut/state[6]} {console_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 2 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {crep_dut/com_rxd[0]} {crep_dut/com_rxd[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list com_dut/com_rxf_dut/din]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list com_dut/com_cs_dut/fd_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list com_dut/com_cs_dut/fd_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list com_dut/fire_rxd]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list com_dut/fire_txd]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list com_dut/com_cs_dut/fs_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list com_dut/com_cs_dut/fs_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list com_dut/com_cc_dut/pin_rxd]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list com_dut/com_cc_dut/usb_rxd]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_fast]
