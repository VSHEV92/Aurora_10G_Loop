# free running 125 MHz
create_clock -period 8.000 -name {CLK_125_DS_clk_p[0]} [get_ports {CLK_125_DS_clk_p[0]}]

# sfp card reference clk 156.25 MHz
create_clock -period 6.400 -name GT_DIFF_REFCLK1_0_clk_p [get_ports GT_DIFF_REFCLK1_0_clk_p]

# sfp fmc reference clk 156.25 MHz
create_clock -period 6.400 -name GT_DIFF_REFCLK1_1_clk_p [get_ports GT_DIFF_REFCLK1_1_clk_p]

# input ports false path
set_false_path -from [get_ports {{Hot_Plug[0]} {Hot_Plug[1]} reset UART_0_rxd}]

# output ports false path
set_false_path -to [get_ports {{Hot_Plug_LEDs[0]} {Hot_Plug_LEDs[1]} {link_up[0]} {link_up[1]} {link_up[2]} {link_up[3]} {TX_Disable[0]} UART_0_txd}]

# asynchronous groups
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {Aurora_Loop_i/aurora_subsystem/aurora_card_loop/inst/Aurora_Loop_aurora_card_loop_0_core_i/Aurora_Loop_aurora_card_loop_0_wrapper_i/Aurora_Loop_aurora_card_loop_0_multi_gt_i/Aurora_Loop_aurora_card_loop_0_gt_i/inst/gen_gtwizard_gtye4_top.Aurora_Loop_aurora_card_loop_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[2].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks {CLK_125_DS_clk_p[0]}]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {Aurora_Loop_i/aurora_subsystem/aurora_fmc_loop/inst/Aurora_Loop_aurora_fmc_loop_0_core_i/Aurora_Loop_aurora_fmc_loop_0_wrapper_i/Aurora_Loop_aurora_fmc_loop_0_multi_gt_i/Aurora_Loop_aurora_fmc_loop_0_gt_i/inst/gen_gtwizard_gtye4_top.Aurora_Loop_aurora_fmc_loop_0_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[3].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks {CLK_125_DS_clk_p[0]}]
