# clock 125 MHZ
set_property PACKAGE_PIN G12 [get_ports {CLK_125_DS_clk_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {CLK_125_DS_clk_p[0]}]

# FMC SFP hot plug inputs
set_property PACKAGE_PIN AC18 [get_ports {Hot_Plug[1]}]
set_property PACKAGE_PIN Y20 [get_ports {Hot_Plug[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Hot_Plug[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Hot_Plug[0]}]

# FMC SFP hot plug leds
set_property PACKAGE_PIN AD20 [get_ports {Hot_Plug_LEDs[0]}]
set_property PACKAGE_PIN AE20 [get_ports {Hot_Plug_LEDs[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Hot_Plug_LEDs[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {Hot_Plug_LEDs[0]}]

# FMC SFP TX Disable
set_property PACKAGE_PIN AA20 [get_ports {TX_Disable[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TX_Disable[0]}]

# aurora card clk ref
set_property PACKAGE_PIN M7 [get_ports GT_DIFF_REFCLK1_0_clk_p]

# link up leds
set_property PACKAGE_PIN G10 [get_ports {link_up[0]}]
set_property PACKAGE_PIN G9 [get_ports {link_up[1]}]
set_property PACKAGE_PIN F10 [get_ports {link_up[2]}]
set_property PACKAGE_PIN F9 [get_ports {link_up[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {link_up[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {link_up[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {link_up[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {link_up[0]}]

# reset button
set_property PACKAGE_PIN B9 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# uart
set_property PACKAGE_PIN W12 [get_ports UART_0_rxd]
set_property PACKAGE_PIN W13 [get_ports UART_0_txd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_0_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_0_txd]

