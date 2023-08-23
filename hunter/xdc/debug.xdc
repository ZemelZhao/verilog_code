
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
connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {nolabel_line10/ram_rxd[0]} {nolabel_line10/ram_rxd[1]} {nolabel_line10/ram_rxd[2]} {nolabel_line10/ram_rxd[3]} {nolabel_line10/ram_rxd[4]} {nolabel_line10/ram_rxd[5]} {nolabel_line10/ram_rxd[6]} {nolabel_line10/ram_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {nolabel_line10/rx_ram_txd[0]} {nolabel_line10/rx_ram_txd[1]} {nolabel_line10/rx_ram_txd[2]} {nolabel_line10/rx_ram_txd[3]} {nolabel_line10/rx_ram_txd[4]} {nolabel_line10/rx_ram_txd[5]} {nolabel_line10/rx_ram_txd[6]} {nolabel_line10/rx_ram_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {nolabel_line10/state[0]} {nolabel_line10/state[1]} {nolabel_line10/state[2]} {nolabel_line10/state[3]} {nolabel_line10/state[4]} {nolabel_line10/state[5]} {nolabel_line10/state[6]} {nolabel_line10/state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {nolabel_line10/com_rxd[0]} {nolabel_line10/com_rxd[1]} {nolabel_line10/com_rxd[2]} {nolabel_line10/com_rxd[3]} {nolabel_line10/com_rxd[4]} {nolabel_line10/com_rxd[5]} {nolabel_line10/com_rxd[6]} {nolabel_line10/com_rxd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {nolabel_line10/ram_txd[0]} {nolabel_line10/ram_txd[1]} {nolabel_line10/ram_txd[2]} {nolabel_line10/ram_txd[3]} {nolabel_line10/ram_txd[4]} {nolabel_line10/ram_txd[5]} {nolabel_line10/ram_txd[6]} {nolabel_line10/ram_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 12 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {nolabel_line10/ram_txa[0]} {nolabel_line10/ram_txa[1]} {nolabel_line10/ram_txa[2]} {nolabel_line10/ram_txa[3]} {nolabel_line10/ram_txa[4]} {nolabel_line10/ram_txa[5]} {nolabel_line10/ram_txa[6]} {nolabel_line10/ram_txa[7]} {nolabel_line10/ram_txa[8]} {nolabel_line10/ram_txa[9]} {nolabel_line10/ram_txa[10]} {nolabel_line10/ram_txa[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {nolabel_line10/rx_bdata[0]} {nolabel_line10/rx_bdata[1]} {nolabel_line10/rx_bdata[2]} {nolabel_line10/rx_bdata[3]} {nolabel_line10/rx_bdata[4]} {nolabel_line10/rx_bdata[5]} {nolabel_line10/rx_bdata[6]} {nolabel_line10/rx_bdata[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 4 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {nolabel_line10/rx_btype[0]} {nolabel_line10/rx_btype[1]} {nolabel_line10/rx_btype[2]} {nolabel_line10/rx_btype[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 4 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {nolabel_line10/rx_didx[0]} {nolabel_line10/rx_didx[1]} {nolabel_line10/rx_didx[2]} {nolabel_line10/rx_didx[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {nolabel_line10/com_txd[0]} {nolabel_line10/com_txd[1]} {nolabel_line10/com_txd[2]} {nolabel_line10/com_txd[3]} {nolabel_line10/com_txd[4]} {nolabel_line10/com_txd[5]} {nolabel_line10/com_txd[6]} {nolabel_line10/com_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 4 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {nolabel_line10/btype[0]} {nolabel_line10/btype[1]} {nolabel_line10/btype[2]} {nolabel_line10/btype[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 12 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {nolabel_line10/ram_rxa[0]} {nolabel_line10/ram_rxa[1]} {nolabel_line10/ram_rxa[2]} {nolabel_line10/ram_rxa[3]} {nolabel_line10/ram_rxa[4]} {nolabel_line10/ram_rxa[5]} {nolabel_line10/ram_rxa[6]} {nolabel_line10/ram_rxa[7]} {nolabel_line10/ram_rxa[8]} {nolabel_line10/ram_rxa[9]} {nolabel_line10/ram_rxa[10]} {nolabel_line10/ram_rxa[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list nolabel_line10/fd_ram_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list nolabel_line10/fd_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list nolabel_line10/fd_typec_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list nolabel_line10/fs_ram_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list nolabel_line10/fs_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list nolabel_line10/fs_typec_tx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list nolabel_line10/ram_txen]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
