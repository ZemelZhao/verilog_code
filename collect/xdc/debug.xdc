

connect_debug_port u_ila_0/probe5 [get_nets [list usb1_rxf]]
connect_debug_port u_ila_0/probe7 [get_nets [list usb1_txf]]

connect_debug_port u_ila_0/clk [get_nets [list clk_in_BUFG]]
connect_debug_port u_ila_0/probe0 [get_nets [list {usb0_rxd[0]} {usb0_rxd[1]} {usb0_rxd[2]} {usb0_rxd[3]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {usb1_rxd[0]} {usb1_rxd[1]} {usb1_rxd[2]} {usb1_rxd[3]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list usb0_rxf_OBUF]]
connect_debug_port u_ila_0/probe3 [get_nets [list usb0_txd]]
connect_debug_port u_ila_0/probe5 [get_nets [list usb1_txd]]
connect_debug_port u_ila_0/probe6 [get_nets [list usb_rxf]]
connect_debug_port u_ila_0/probe7 [get_nets [list usb_txf]]
connect_debug_port dbg_hub/clk [get_nets clk_in_BUFG]







connect_debug_port u_ila_0/clk [get_nets [list clk_wiz_dut/inst/clk_200]]
connect_debug_port u_ila_0/probe0 [get_nets [list {test_collect_dut/usb_dut/usb_cs_dut/state[0]} {test_collect_dut/usb_dut/usb_cs_dut/state[1]} {test_collect_dut/usb_dut/usb_cs_dut/state[2]} {test_collect_dut/usb_dut/usb_cs_dut/state[3]} {test_collect_dut/usb_dut/usb_cs_dut/state[4]} {test_collect_dut/usb_dut/usb_cs_dut/state[5]} {test_collect_dut/usb_dut/usb_cs_dut/state[6]} {test_collect_dut/usb_dut/usb_cs_dut/state[7]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {test_collect_dut/usb_dut/com_rxd[0]} {test_collect_dut/usb_dut/com_rxd[1]} {test_collect_dut/usb_dut/com_rxd[2]} {test_collect_dut/usb_dut/com_rxd[3]} {test_collect_dut/usb_dut/com_rxd[4]} {test_collect_dut/usb_dut/com_rxd[5]} {test_collect_dut/usb_dut/com_rxd[6]} {test_collect_dut/usb_dut/com_rxd[7]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {test_collect_dut/pin_rxd[0]} {test_collect_dut/pin_rxd[1]} {test_collect_dut/pin_rxd[2]} {test_collect_dut/pin_rxd[3]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {test_collect_dut/state[0]} {test_collect_dut/state[1]} {test_collect_dut/state[2]} {test_collect_dut/state[3]} {test_collect_dut/state[4]} {test_collect_dut/state[5]} {test_collect_dut/state[6]} {test_collect_dut/state[7]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {test_collect_dut/usb_dut/com_txd[0]} {test_collect_dut/usb_dut/com_txd[1]} {test_collect_dut/usb_dut/com_txd[2]} {test_collect_dut/usb_dut/com_txd[3]} {test_collect_dut/usb_dut/com_txd[4]} {test_collect_dut/usb_dut/com_txd[5]} {test_collect_dut/usb_dut/com_txd[6]} {test_collect_dut/usb_dut/com_txd[7]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {test_hunter_dut/com_dut/com_cs_dut/state[0]} {test_hunter_dut/com_dut/com_cs_dut/state[1]} {test_hunter_dut/com_dut/com_cs_dut/state[2]} {test_hunter_dut/com_dut/com_cs_dut/state[3]} {test_hunter_dut/com_dut/com_cs_dut/state[4]} {test_hunter_dut/com_dut/com_cs_dut/state[5]} {test_hunter_dut/com_dut/com_cs_dut/state[6]} {test_hunter_dut/com_dut/com_cs_dut/state[7]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {test_hunter_dut/adc_test_dut/state[0]} {test_hunter_dut/adc_test_dut/state[1]} {test_hunter_dut/adc_test_dut/state[2]} {test_hunter_dut/adc_test_dut/state[3]} {test_hunter_dut/adc_test_dut/state[4]} {test_hunter_dut/adc_test_dut/state[5]} {test_hunter_dut/adc_test_dut/state[6]} {test_hunter_dut/adc_test_dut/state[7]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list {test_hunter_dut/com_dut/com_txd[0]} {test_hunter_dut/com_dut/com_txd[1]} {test_hunter_dut/com_dut/com_txd[2]} {test_hunter_dut/com_dut/com_txd[3]} {test_hunter_dut/com_dut/com_txd[4]} {test_hunter_dut/com_dut/com_txd[5]} {test_hunter_dut/com_dut/com_txd[6]} {test_hunter_dut/com_dut/com_txd[7]}]]
connect_debug_port u_ila_0/probe8 [get_nets [list {test_hunter_dut/console_dut/state[0]} {test_hunter_dut/console_dut/state[1]} {test_hunter_dut/console_dut/state[2]} {test_hunter_dut/console_dut/state[3]} {test_hunter_dut/console_dut/state[4]} {test_hunter_dut/console_dut/state[5]} {test_hunter_dut/console_dut/state[6]} {test_hunter_dut/console_dut/state[7]} {test_hunter_dut/console_dut/state[8]} {test_hunter_dut/console_dut/state[9]} {test_hunter_dut/console_dut/state[10]} {test_hunter_dut/console_dut/state[11]} {test_hunter_dut/console_dut/state[12]} {test_hunter_dut/console_dut/state[13]} {test_hunter_dut/console_dut/state[14]} {test_hunter_dut/console_dut/state[15]} {test_hunter_dut/console_dut/state[16]} {test_hunter_dut/console_dut/state[17]} {test_hunter_dut/console_dut/state[18]} {test_hunter_dut/console_dut/state[19]} {test_hunter_dut/console_dut/state[20]} {test_hunter_dut/console_dut/state[21]} {test_hunter_dut/console_dut/state[22]} {test_hunter_dut/console_dut/state[23]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {test_hunter_dut/com_dut/com_rxd[0]} {test_hunter_dut/com_dut/com_rxd[1]} {test_hunter_dut/com_dut/com_rxd[2]} {test_hunter_dut/com_dut/com_rxd[3]} {test_hunter_dut/com_dut/com_rxd[4]} {test_hunter_dut/com_dut/com_rxd[5]} {test_hunter_dut/com_dut/com_rxd[6]} {test_hunter_dut/com_dut/com_rxd[7]}]]
connect_debug_port u_ila_0/probe10 [get_nets [list {test_hunter_dut/pin_txd[0]} {test_hunter_dut/pin_txd[1]} {test_hunter_dut/pin_txd[2]} {test_hunter_dut/pin_txd[3]}]]
connect_debug_port u_ila_0/probe11 [get_nets [list test_collect_dut/fd_read]]
connect_debug_port u_ila_0/probe12 [get_nets [list test_collect_dut/fd_send]]
connect_debug_port u_ila_0/probe13 [get_nets [list test_hunter_dut/fire_read]]
connect_debug_port u_ila_0/probe14 [get_nets [list test_hunter_dut/fire_send]]
connect_debug_port u_ila_0/probe15 [get_nets [list test_collect_dut/fs_read]]
connect_debug_port u_ila_0/probe16 [get_nets [list test_collect_dut/fs_send]]
connect_debug_port u_ila_0/probe17 [get_nets [list test_hunter_dut/pin_rxd]]
connect_debug_port u_ila_0/probe18 [get_nets [list test_collect_dut/pin_txd]]
connect_debug_port dbg_hub/clk [get_nets clk_200]

connect_debug_port u_ila_0/clk [get_nets [list clk_BUFG]]
connect_debug_port dbg_hub/clk [get_nets clk_BUFG]

connect_debug_port u_ila_0/clk [get_nets [list clk_wiz_dut/inst/clk_200]]
connect_debug_port dbg_hub/clk [get_nets clk_200]



connect_debug_port u_ila_0/clk [get_nets [list clk_wiz_dut/inst/clk_100]]
connect_debug_port u_ila_0/probe0 [get_nets [list {usb_dut/usb_cs_dut/state[0]} {usb_dut/usb_cs_dut/state[1]} {usb_dut/usb_cs_dut/state[2]} {usb_dut/usb_cs_dut/state[3]} {usb_dut/usb_cs_dut/state[4]} {usb_dut/usb_cs_dut/state[5]} {usb_dut/usb_cs_dut/state[6]} {usb_dut/usb_cs_dut/state[7]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {usb_dut/com_txd[0]} {usb_dut/com_txd[1]} {usb_dut/com_txd[2]} {usb_dut/com_txd[3]} {usb_dut/com_txd[4]} {usb_dut/com_txd[5]} {usb_dut/com_txd[6]} {usb_dut/com_txd[7]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {pin_rxd[0]} {pin_rxd[1]} {pin_rxd[2]} {pin_rxd[3]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {usb_dut/com_rxd[0]} {usb_dut/com_rxd[1]} {usb_dut/com_rxd[2]} {usb_dut/com_rxd[3]} {usb_dut/com_rxd[4]} {usb_dut/com_rxd[5]} {usb_dut/com_rxd[6]} {usb_dut/com_rxd[7]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {state[0]} {state[1]} {state[2]} {state[3]} {state[4]} {state[5]} {state[6]} {state[7]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list fire_read]]
connect_debug_port u_ila_0/probe6 [get_nets [list fire_send]]
connect_debug_port u_ila_0/probe7 [get_nets [list pin_txd]]
connect_debug_port dbg_hub/clk [get_nets clk_100]

connect_debug_port u_ila_0/clk [get_nets [list gig_dut/inst/core_clocking_i/userclk2]]
connect_debug_port u_ila_0/probe0 [get_nets [list {gmii_txd[0]} {gmii_txd[1]} {gmii_txd[2]} {gmii_txd[3]} {gmii_txd[4]} {gmii_txd[5]} {gmii_txd[6]} {gmii_txd[7]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {gmii_rxd[0]} {gmii_rxd[1]} {gmii_rxd[2]} {gmii_rxd[3]} {gmii_rxd[4]} {gmii_rxd[5]} {gmii_rxd[6]} {gmii_rxd[7]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list gmii_rxdv]]
connect_debug_port u_ila_0/probe3 [get_nets [list gmii_rxer]]
connect_debug_port u_ila_0/probe4 [get_nets [list gmii_txen]]
connect_debug_port u_ila_0/probe5 [get_nets [list gmii_txer]]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_userclk2]

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
connect_debug_port u_ila_0/clk [get_nets [list clk_wiz_dut/inst/clk_400]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {usb_dut/usb_cs_dut/state[0]} {usb_dut/usb_cs_dut/state[1]} {usb_dut/usb_cs_dut/state[2]} {usb_dut/usb_cs_dut/state[3]} {usb_dut/usb_cs_dut/state[4]} {usb_dut/usb_cs_dut/state[5]} {usb_dut/usb_cs_dut/state[6]} {usb_dut/usb_cs_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {usb_dut/com_txd[0]} {usb_dut/com_txd[1]} {usb_dut/com_txd[2]} {usb_dut/com_txd[3]} {usb_dut/com_txd[4]} {usb_dut/com_txd[5]} {usb_dut/com_txd[6]} {usb_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {usb_dut/com_rxd[0]} {usb_dut/com_rxd[1]} {usb_dut/com_rxd[2]} {usb_dut/com_rxd[3]} {usb_dut/com_rxd[4]} {usb_dut/com_rxd[5]} {usb_dut/com_rxd[6]} {usb_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {cache_stat[0]} {cache_stat[1]} {cache_stat[2]} {cache_stat[3]} {cache_stat[4]} {cache_stat[5]} {cache_stat[6]} {cache_stat[7]} {cache_stat[8]} {cache_stat[9]} {cache_stat[10]} {cache_stat[11]} {cache_stat[12]} {cache_stat[13]} {cache_stat[14]} {cache_stat[15]} {cache_stat[16]} {cache_stat[17]} {cache_stat[18]} {cache_stat[19]} {cache_stat[20]} {cache_stat[21]} {cache_stat[22]} {cache_stat[23]} {cache_stat[24]} {cache_stat[25]} {cache_stat[26]} {cache_stat[27]} {cache_stat[28]} {cache_stat[29]} {cache_stat[30]} {cache_stat[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {state[0]} {state[1]} {state[2]} {state[3]} {state[4]} {state[5]} {state[6]} {state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 4 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {pin_rxd[0]} {pin_rxd[1]} {pin_rxd[2]} {pin_rxd[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {cache_cmd[0]} {cache_cmd[1]} {cache_cmd[2]} {cache_cmd[3]} {cache_cmd[4]} {cache_cmd[5]} {cache_cmd[6]} {cache_cmd[7]} {cache_cmd[8]} {cache_cmd[9]} {cache_cmd[10]} {cache_cmd[11]} {cache_cmd[12]} {cache_cmd[13]} {cache_cmd[14]} {cache_cmd[15]} {cache_cmd[16]} {cache_cmd[17]} {cache_cmd[18]} {cache_cmd[19]} {cache_cmd[20]} {cache_cmd[21]} {cache_cmd[22]} {cache_cmd[23]} {cache_cmd[24]} {cache_cmd[25]} {cache_cmd[26]} {cache_cmd[27]} {cache_cmd[28]} {cache_cmd[29]} {cache_cmd[30]} {cache_cmd[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list fire_read]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list fire_send]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list pin_txd]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_400]
