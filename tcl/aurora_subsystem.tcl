# -------------------------------------------------------
# скрипт для создание подсиcтемы c четыремя ядрами Aurora
# -------------------------------------------------------

# создание иерархии
create_bd_cell -type hier aurora_subsystem
current_bd_instance [get_bd_cells /aurora_subsystem]

# ядра для петли на плате KU116
create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_64b66b:12.0 aurora_card_loop

set_property -dict [list CONFIG.C_INIT_CLK.VALUE_SRC USER] [get_bd_cells aurora_card_loop]
set_property -dict [list CONFIG.CHANNEL_ENABLE {X0Y8} CONFIG.C_INIT_CLK {125} CONFIG.interface_mode {Streaming} CONFIG.C_START_QUAD {Quad_X0Y2} CONFIG.C_START_LANE {X0Y8} CONFIG.C_REFCLK_SOURCE {MGTREFCLK1_of_Quad_X0Y2} CONFIG.SupportLevel {1}] [get_bd_cells aurora_card_loop]

# CARD SFP reference clock
make_bd_intf_pins_external  [get_bd_intf_pins aurora_card_loop/GT_DIFF_REFCLK1]

# SFP 0 TX/RX lane
make_bd_intf_pins_external  [get_bd_intf_pins aurora_card_loop/GT_SERIAL_RX]
make_bd_intf_pins_external  [get_bd_intf_pins aurora_card_loop/GT_SERIAL_TX]

# link up signals
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
make_bd_pins_external  [get_bd_pins xlconcat_0/dout]
set_property name link_up [get_bd_pins dout_0]
connect_bd_net [get_bd_pins aurora_card_loop/channel_up] [get_bd_pins xlconcat_0/In0]

# init_clk, pma_init, reset
create_bd_pin -dir I init_clk
connect_bd_net [get_bd_pins init_clk] [get_bd_pins aurora_card_loop/init_clk]

create_bd_pin -dir I reset_pb
connect_bd_net [get_bd_pins reset_pb]  [get_bd_pins aurora_card_loop/reset_pb]

create_bd_pin -dir I pma_init
connect_bd_net [get_bd_pins pma_init]  [get_bd_pins aurora_card_loop/pma_init]

current_bd_instance