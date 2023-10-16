connect_debug_port u_ila_0/probe0 [get_nets [list {usb_rxd1[0]} {usb_rxd1[1]} {usb_rxd1[2]} {usb_rxd1[3]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {txd[0]} {txd[1]} {txd[2]} {txd[3]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {usb_rxd0[0]} {usb_rxd0[1]} {usb_rxd0[2]} {usb_rxd0[3]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {next_state[0]} {next_state[1]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {state[0]} {state[1]}]]



connect_debug_port u_ila_0/probe0 [get_nets [list {usb_rxf_OBUF[0]} {usb_rxf_OBUF[1]} {usb_rxf_OBUF[2]} {usb_rxf_OBUF[3]} {usb_rxf_OBUF[4]} {usb_rxf_OBUF[5]} {usb_rxf_OBUF[6]} {usb_rxf_OBUF[7]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {usb_rxd0[0]} {usb_rxd0[1]} {usb_rxd0[2]} {usb_rxd0[3]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {usb_txf_OBUF[0]} {usb_txf_OBUF[1]} {usb_txf_OBUF[2]} {usb_txf_OBUF[3]} {usb_txf_OBUF[4]} {usb_txf_OBUF[5]} {usb_txf_OBUF[6]} {usb_txf_OBUF[7]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list usb_txd0]]
connect_debug_port dbg_hub/clk [get_nets clk]

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
connect_debug_port u_ila_0/clk [get_nets [list clk_wiz_dut/inst/clk_out_200]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {pin_rxd[0]} {pin_rxd[1]} {pin_rxd[2]} {pin_rxd[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list fire_read]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list fire_send]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list pin_txd]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out_200]
