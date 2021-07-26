# free running 125 MHz
create_clock -period 8.000 -name {CLK_125_DS_clk_p[0]} [get_ports {CLK_125_DS_clk_p[0]}]

# sfp card reference clk 156.25 MHz
create_clock -period 6.400 -name GT_DIFF_REFCLK1_0_clk_p [get_ports GT_DIFF_REFCLK1_0_clk_p]

# input ports false path
set_false_path -from [get_ports {{Hot_Plug[0]} {Hot_Plug[1]} reset UART_0_rxd}]

# output ports false path
set_false_path -to [get_ports {{Hot_Plug_LEDs[0]} {Hot_Plug_LEDs[1]} {link_up[0]} {link_up[1]} {link_up[2]} {link_up[3]} TX_Disable[0] UART_0_txd}]
