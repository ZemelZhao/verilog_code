











create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 65536 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list crep_dut/clk_wiz_dut/inst/clk_fast]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 12 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[0]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[1]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[2]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[3]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[4]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[5]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[6]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[7]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[8]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[9]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[10]} {usb_inst[0].usb_dut/usb_cs_dut/rm_ram_init[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {usb_inst[0].usb_dut/usb_rm_dut/state[0]} {usb_inst[0].usb_dut/usb_rm_dut/state[1]} {usb_inst[0].usb_dut/usb_rm_dut/state[2]} {usb_inst[0].usb_dut/usb_rm_dut/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 12 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {usb_inst[0].usb_dut/ram_txa[0]} {usb_inst[0].usb_dut/ram_txa[1]} {usb_inst[0].usb_dut/ram_txa[2]} {usb_inst[0].usb_dut/ram_txa[3]} {usb_inst[0].usb_dut/ram_txa[4]} {usb_inst[0].usb_dut/ram_txa[5]} {usb_inst[0].usb_dut/ram_txa[6]} {usb_inst[0].usb_dut/ram_txa[7]} {usb_inst[0].usb_dut/ram_txa[8]} {usb_inst[0].usb_dut/ram_txa[9]} {usb_inst[0].usb_dut/ram_txa[10]} {usb_inst[0].usb_dut/ram_txa[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {usb_inst[0].usb_dut/ram_txd[0]} {usb_inst[0].usb_dut/ram_txd[1]} {usb_inst[0].usb_dut/ram_txd[2]} {usb_inst[0].usb_dut/ram_txd[3]} {usb_inst[0].usb_dut/ram_txd[4]} {usb_inst[0].usb_dut/ram_txd[5]} {usb_inst[0].usb_dut/ram_txd[6]} {usb_inst[0].usb_dut/ram_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {ram_data_txd[0]} {ram_data_txd[1]} {ram_data_txd[2]} {ram_data_txd[3]} {ram_data_txd[4]} {ram_data_txd[5]} {ram_data_txd[6]} {ram_data_txd[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 15 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {ram_data_txa[0]} {ram_data_txa[1]} {ram_data_txa[2]} {ram_data_txa[3]} {ram_data_txa[4]} {ram_data_txa[5]} {ram_data_txa[6]} {ram_data_txa[7]} {ram_data_txa[8]} {ram_data_txa[9]} {ram_data_txa[10]} {ram_data_txa[11]} {ram_data_txa[12]} {ram_data_txa[13]} {ram_data_txa[14]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list ram_data_txen]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {usb_inst[0].usb_dut/ram_txen}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_fast]
