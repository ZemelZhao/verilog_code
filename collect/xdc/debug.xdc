
connect_debug_port u_ila_0/probe3 [get_nets [list console_dut/console_core_dut/fd_conf]]
connect_debug_port u_ila_0/probe4 [get_nets [list console_dut/console_core_dut/fd_send]]



connect_debug_port u_ila_0/probe5 [get_nets [list console_dut/console_core_dut/fd_conv]]
connect_debug_port u_ila_0/probe6 [get_nets [list console_dut/console_core_dut/fd_send]]
connect_debug_port u_ila_0/probe7 [get_nets [list console_dut/console_core_dut/fs_conv]]







connect_debug_port u_ila_0/probe23 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/dev_link}]]
connect_debug_port u_ila_0/probe24 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/dev_link}]]
connect_debug_port u_ila_0/probe25 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/dev_link}]]
connect_debug_port u_ila_0/probe26 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/dev_link}]]
connect_debug_port u_ila_0/probe27 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/fs_com_read}]]
connect_debug_port u_ila_0/probe28 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/fs_com_read}]]
connect_debug_port u_ila_0/probe29 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/fs_com_read}]]
connect_debug_port u_ila_0/probe30 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/fs_com_read}]]

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
connect_debug_port u_ila_0/probe0 [get_nets [list {u_rxdv_IBUF[7]} {u_rxdv_IBUF[6]} {u_rxdv_IBUF[5]} {u_rxdv_IBUF[4]} {u_rxdv_IBUF[3]} {u_rxdv_IBUF[2]} {u_rxdv_IBUF[1]} {u_rxdv_IBUF[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {usb_inst[3].usb_dut/usb_cs_dut/state[0]} {usb_inst[3].usb_dut/usb_cs_dut/state[1]} {usb_inst[3].usb_dut/usb_cs_dut/state[2]} {usb_inst[3].usb_dut/usb_cs_dut/state[3]} {usb_inst[3].usb_dut/usb_cs_dut/state[4]} {usb_inst[3].usb_dut/usb_cs_dut/state[5]} {usb_inst[3].usb_dut/usb_cs_dut/state[6]} {usb_inst[3].usb_dut/usb_cs_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {usb_inst[3].usb_dut/com_rxd[0]} {usb_inst[3].usb_dut/com_rxd[1]} {usb_inst[3].usb_dut/com_rxd[2]} {usb_inst[3].usb_dut/com_rxd[3]} {usb_inst[3].usb_dut/com_rxd[4]} {usb_inst[3].usb_dut/com_rxd[5]} {usb_inst[3].usb_dut/com_rxd[6]} {usb_inst[3].usb_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {usb_inst[3].usb_dut/com_txd[0]} {usb_inst[3].usb_dut/com_txd[1]} {usb_inst[3].usb_dut/com_txd[2]} {usb_inst[3].usb_dut/com_txd[3]} {usb_inst[3].usb_dut/com_txd[4]} {usb_inst[3].usb_dut/com_txd[5]} {usb_inst[3].usb_dut/com_txd[6]} {usb_inst[3].usb_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 10 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {com_dut/com_cs_dut/state[0]} {com_dut/com_cs_dut/state[1]} {com_dut/com_cs_dut/state[2]} {com_dut/com_cs_dut/state[3]} {com_dut/com_cs_dut/state[4]} {com_dut/com_cs_dut/state[5]} {com_dut/com_cs_dut/state[6]} {com_dut/com_cs_dut/state[7]} {com_dut/com_cs_dut/state[8]} {com_dut/com_cs_dut/state[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 12 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {console_dut/console_core_dut/state[0]} {console_dut/console_core_dut/state[1]} {console_dut/console_core_dut/state[2]} {console_dut/console_core_dut/state[3]} {console_dut/console_core_dut/state[4]} {console_dut/console_core_dut/state[5]} {console_dut/console_core_dut/state[6]} {console_dut/console_core_dut/state[7]} {console_dut/console_core_dut/state[8]} {console_dut/console_core_dut/state[9]} {console_dut/console_core_dut/state[10]} {console_dut/console_core_dut/state[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 10 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {console_dut/console_com_dut/state[0]} {console_dut/console_com_dut/state[1]} {console_dut/console_com_dut/state[2]} {console_dut/console_com_dut/state[3]} {console_dut/console_com_dut/state[4]} {console_dut/console_com_dut/state[5]} {console_dut/console_com_dut/state[6]} {console_dut/console_com_dut/state[7]} {console_dut/console_com_dut/state[8]} {console_dut/console_com_dut/state[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 6 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {console_dut/console_data_dut/state[0]} {console_dut/console_data_dut/state[1]} {console_dut/console_data_dut/state[2]} {console_dut/console_data_dut/state[3]} {console_dut/console_data_dut/state[4]} {console_dut/console_data_dut/state[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 12 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[0]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[1]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[2]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[3]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[4]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[5]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[6]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[7]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[8]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[9]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[10]} {console_dut/console_usb_dut/console_usb_dev_inst[0].console_usb_dev_dut/state[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 20 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {console_dut/console_usb_dut/console_usb_core_dut/state[0]} {console_dut/console_usb_dut/console_usb_core_dut/state[1]} {console_dut/console_usb_dut/console_usb_core_dut/state[2]} {console_dut/console_usb_dut/console_usb_core_dut/state[3]} {console_dut/console_usb_dut/console_usb_core_dut/state[4]} {console_dut/console_usb_dut/console_usb_core_dut/state[5]} {console_dut/console_usb_dut/console_usb_core_dut/state[6]} {console_dut/console_usb_dut/console_usb_core_dut/state[7]} {console_dut/console_usb_dut/console_usb_core_dut/state[8]} {console_dut/console_usb_dut/console_usb_core_dut/state[9]} {console_dut/console_usb_dut/console_usb_core_dut/state[10]} {console_dut/console_usb_dut/console_usb_core_dut/state[11]} {console_dut/console_usb_dut/console_usb_core_dut/state[12]} {console_dut/console_usb_dut/console_usb_core_dut/state[13]} {console_dut/console_usb_dut/console_usb_core_dut/state[14]} {console_dut/console_usb_dut/console_usb_core_dut/state[15]} {console_dut/console_usb_dut/console_usb_core_dut/state[16]} {console_dut/console_usb_dut/console_usb_core_dut/state[17]} {console_dut/console_usb_dut/console_usb_core_dut/state[18]} {console_dut/console_usb_dut/console_usb_core_dut/state[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 12 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[0]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[1]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[2]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[3]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[4]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[5]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[6]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[7]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[8]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[9]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[10]} {console_dut/console_usb_dut/console_usb_dev_inst[2].console_usb_dev_dut/state[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 12 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[0]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[1]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[2]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[3]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[4]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[5]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[6]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[7]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[8]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[9]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[10]} {console_dut/console_usb_dut/console_usb_dev_inst[1].console_usb_dev_dut/state[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 12 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[0]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[1]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[2]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[3]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[4]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[5]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[6]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[7]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[8]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[9]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[10]} {console_dut/console_usb_dut/console_usb_dev_inst[3].console_usb_dev_dut/state[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {console_dut/console_usb_dut/fs_read[7]} {console_dut/console_usb_dut/fs_read[6]} {console_dut/console_usb_dut/fs_read[5]} {console_dut/console_usb_dut/fs_read[4]} {console_dut/console_usb_dut/fs_read[3]} {console_dut/console_usb_dut/fs_read[2]} {console_dut/console_usb_dut/fs_read[1]} {console_dut/console_usb_dut/fs_read[0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 8 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {usb_inst[0].usb_dut/usb_cs_dut/state[0]} {usb_inst[0].usb_dut/usb_cs_dut/state[1]} {usb_inst[0].usb_dut/usb_cs_dut/state[2]} {usb_inst[0].usb_dut/usb_cs_dut/state[3]} {usb_inst[0].usb_dut/usb_cs_dut/state[4]} {usb_inst[0].usb_dut/usb_cs_dut/state[5]} {usb_inst[0].usb_dut/usb_cs_dut/state[6]} {usb_inst[0].usb_dut/usb_cs_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 8 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {usb_inst[0].usb_dut/com_rxd[0]} {usb_inst[0].usb_dut/com_rxd[1]} {usb_inst[0].usb_dut/com_rxd[2]} {usb_inst[0].usb_dut/com_rxd[3]} {usb_inst[0].usb_dut/com_rxd[4]} {usb_inst[0].usb_dut/com_rxd[5]} {usb_inst[0].usb_dut/com_rxd[6]} {usb_inst[0].usb_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {usb_inst[0].usb_dut/com_txd[0]} {usb_inst[0].usb_dut/com_txd[1]} {usb_inst[0].usb_dut/com_txd[2]} {usb_inst[0].usb_dut/com_txd[3]} {usb_inst[0].usb_dut/com_txd[4]} {usb_inst[0].usb_dut/com_txd[5]} {usb_inst[0].usb_dut/com_txd[6]} {usb_inst[0].usb_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 8 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {usb_inst[1].usb_dut/usb_cs_dut/state[0]} {usb_inst[1].usb_dut/usb_cs_dut/state[1]} {usb_inst[1].usb_dut/usb_cs_dut/state[2]} {usb_inst[1].usb_dut/usb_cs_dut/state[3]} {usb_inst[1].usb_dut/usb_cs_dut/state[4]} {usb_inst[1].usb_dut/usb_cs_dut/state[5]} {usb_inst[1].usb_dut/usb_cs_dut/state[6]} {usb_inst[1].usb_dut/usb_cs_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 8 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {usb_inst[1].usb_dut/com_rxd[0]} {usb_inst[1].usb_dut/com_rxd[1]} {usb_inst[1].usb_dut/com_rxd[2]} {usb_inst[1].usb_dut/com_rxd[3]} {usb_inst[1].usb_dut/com_rxd[4]} {usb_inst[1].usb_dut/com_rxd[5]} {usb_inst[1].usb_dut/com_rxd[6]} {usb_inst[1].usb_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 8 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {usb_inst[1].usb_dut/com_txd[0]} {usb_inst[1].usb_dut/com_txd[1]} {usb_inst[1].usb_dut/com_txd[2]} {usb_inst[1].usb_dut/com_txd[3]} {usb_inst[1].usb_dut/com_txd[4]} {usb_inst[1].usb_dut/com_txd[5]} {usb_inst[1].usb_dut/com_txd[6]} {usb_inst[1].usb_dut/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 8 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {usb_inst[2].usb_dut/usb_cs_dut/state[0]} {usb_inst[2].usb_dut/usb_cs_dut/state[1]} {usb_inst[2].usb_dut/usb_cs_dut/state[2]} {usb_inst[2].usb_dut/usb_cs_dut/state[3]} {usb_inst[2].usb_dut/usb_cs_dut/state[4]} {usb_inst[2].usb_dut/usb_cs_dut/state[5]} {usb_inst[2].usb_dut/usb_cs_dut/state[6]} {usb_inst[2].usb_dut/usb_cs_dut/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 8 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {usb_inst[2].usb_dut/com_rxd[0]} {usb_inst[2].usb_dut/com_rxd[1]} {usb_inst[2].usb_dut/com_rxd[2]} {usb_inst[2].usb_dut/com_rxd[3]} {usb_inst[2].usb_dut/com_rxd[4]} {usb_inst[2].usb_dut/com_rxd[5]} {usb_inst[2].usb_dut/com_rxd[6]} {usb_inst[2].usb_dut/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 8 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {usb_inst[2].usb_dut/com_txd[0]} {usb_inst[2].usb_dut/com_txd[1]} {usb_inst[2].usb_dut/com_txd[2]} {usb_inst[2].usb_dut/com_txd[3]} {usb_inst[2].usb_dut/com_txd[4]} {usb_inst[2].usb_dut/com_txd[5]} {usb_inst[2].usb_dut/com_txd[6]} {usb_inst[2].usb_dut/com_txd[7]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_fast]
