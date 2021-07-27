# -------------------------------------------------------
# скрипт для создание подсиcтемы c четыремя ядрами Aurora
# -------------------------------------------------------

# создание иерархии
create_bd_cell -type hier aurora_subsystem
current_bd_instance [get_bd_cells /aurora_subsystem]

# ----------------------------------------------------------------------------------------------------
# ядра для петли на плате KU116
create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_64b66b:12.0 aurora_card_loop

set_property -dict [list CONFIG.C_INIT_CLK.VALUE_SRC USER] [get_bd_cells aurora_card_loop]
set_property -dict [list CONFIG.CHANNEL_ENABLE {X0Y8} CONFIG.C_INIT_CLK {125} CONFIG.interface_mode {Streaming} CONFIG.C_START_QUAD {Quad_X0Y2} CONFIG.C_START_LANE {X0Y8} CONFIG.C_REFCLK_SOURCE {MGTREFCLK1_of_Quad_X0Y2} CONFIG.SupportLevel {1}] [get_bd_cells aurora_card_loop]

create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_64b66b:12.0 aurora_card2fmc_loop

set_property -dict [list CONFIG.C_INIT_CLK.VALUE_SRC USER] [get_bd_cells aurora_card2fmc_loop]
set_property -dict [list CONFIG.CHANNEL_ENABLE {X0Y9} CONFIG.C_INIT_CLK {125} CONFIG.dataflow_config {RX-only_Simplex} CONFIG.interface_mode {Streaming} CONFIG.C_START_QUAD {Quad_X0Y2} CONFIG.C_START_LANE {X0Y9} CONFIG.C_REFCLK_SOURCE {MGTREFCLK1_of_Quad_X0Y2}] [get_bd_cells aurora_card2fmc_loop]

# соединение ядер аврора
connect_bd_net [get_bd_pins aurora_card_loop/mmcm_not_locked_out] [get_bd_pins aurora_card2fmc_loop/mmcm_not_locked]
connect_bd_net [get_bd_pins aurora_card_loop/gt_qplllock_quad1_out] [get_bd_pins aurora_card2fmc_loop/gt_qplllock_quad1_in]
connect_bd_net [get_bd_pins aurora_card_loop/gt_qpllrefclklost_quad1_out] [get_bd_pins aurora_card2fmc_loop/gt_qpllrefclklost_quad1]
connect_bd_net [get_bd_pins aurora_card_loop/user_clk_out] [get_bd_pins aurora_card2fmc_loop/user_clk]

connect_bd_net [get_bd_pins aurora_card2fmc_loop/reset_pb] [get_bd_pins aurora_card_loop/sys_reset_out]
connect_bd_net [get_bd_pins aurora_card2fmc_loop/pma_init] [get_bd_pins aurora_card_loop/gt_reset_out]
connect_bd_net [get_bd_pins aurora_card2fmc_loop/gt_qpllclk_quad1_in] [get_bd_pins aurora_card_loop/gt_qpllclk_quad1_out]
connect_bd_net [get_bd_pins aurora_card2fmc_loop/gt_qpllrefclk_quad1_in] [get_bd_pins aurora_card_loop/gt_qpllrefclk_quad1_out]
connect_bd_net [get_bd_pins aurora_card2fmc_loop/refclk1_in] [get_bd_pins aurora_card_loop/gt_refclk1_out]

# CARD SFP reference clock
make_bd_intf_pins_external  [get_bd_intf_pins aurora_card_loop/GT_DIFF_REFCLK1]

# SFP 0 TX/RX lane
make_bd_intf_pins_external  [get_bd_intf_pins aurora_card_loop/GT_SERIAL_RX]
make_bd_intf_pins_external  [get_bd_intf_pins aurora_card_loop/GT_SERIAL_TX]

# SFP 1 TX/RX lane
make_bd_intf_pins_external  [get_bd_intf_pins aurora_card2fmc_loop/GT_SERIAL_RX]
make_bd_intf_pins_external  [get_bd_intf_pins aurora_card2fmc_loop/GT_SERIAL_TX]

# ----------------------------------------------------------------------------------------------------
# ядра для петли на плате FM414S
create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_64b66b:12.0 aurora_fmc_loop

set_property -dict [list CONFIG.C_INIT_CLK.VALUE_SRC USER] [get_bd_cells aurora_fmc_loop]
set_property -dict [list CONFIG.CHANNEL_ENABLE {X0Y12} CONFIG.C_INIT_CLK {125} CONFIG.interface_mode {Streaming} CONFIG.C_START_QUAD {Quad_X0Y3} CONFIG.C_START_LANE {X0Y12} CONFIG.C_REFCLK_SOURCE {MGTREFCLK0_of_Quad_X0Y3} CONFIG.SupportLevel {1}] [get_bd_cells aurora_fmc_loop]

create_bd_cell -type ip -vlnv xilinx.com:ip:aurora_64b66b:12.0 aurora_fmc2card_loop

set_property -dict [list CONFIG.C_INIT_CLK.VALUE_SRC USER] [get_bd_cells aurora_fmc2card_loop]
set_property -dict [list CONFIG.CHANNEL_ENABLE {X0Y13} CONFIG.C_INIT_CLK {125} CONFIG.dataflow_config {TX-only_Simplex} CONFIG.interface_mode {Streaming} CONFIG.C_START_QUAD {Quad_X0Y3} CONFIG.C_START_LANE {X0Y13} CONFIG.C_REFCLK_SOURCE {MGTREFCLK0_of_Quad_X0Y3}] [get_bd_cells aurora_fmc2card_loop]

# соединение ядер аврора
connect_bd_net [get_bd_pins aurora_fmc_loop/mmcm_not_locked_out] [get_bd_pins aurora_fmc2card_loop/mmcm_not_locked]
connect_bd_net [get_bd_pins aurora_fmc_loop/gt_qplllock_quad1_out] [get_bd_pins aurora_fmc2card_loop/gt_qplllock_quad1_in]
connect_bd_net [get_bd_pins aurora_fmc_loop/gt_qpllrefclklost_quad1_out] [get_bd_pins aurora_fmc2card_loop/gt_qpllrefclklost_quad1]
connect_bd_net [get_bd_pins aurora_fmc_loop/user_clk_out] [get_bd_pins aurora_fmc2card_loop/user_clk]
connect_bd_net [get_bd_pins aurora_fmc_loop/sync_clk_out] [get_bd_pins aurora_fmc2card_loop/sync_clk]

connect_bd_net [get_bd_pins aurora_fmc2card_loop/reset_pb] [get_bd_pins aurora_fmc_loop/sys_reset_out]
connect_bd_net [get_bd_pins aurora_fmc2card_loop/pma_init] [get_bd_pins aurora_fmc_loop/gt_reset_out]
connect_bd_net [get_bd_pins aurora_fmc2card_loop/gt_qpllclk_quad1_in] [get_bd_pins aurora_fmc_loop/gt_qpllclk_quad1_out]
connect_bd_net [get_bd_pins aurora_fmc2card_loop/gt_qpllrefclk_quad1_in] [get_bd_pins aurora_fmc_loop/gt_qpllrefclk_quad1_out]
connect_bd_net [get_bd_pins aurora_fmc2card_loop/refclk1_in] [get_bd_pins aurora_fmc_loop/gt_refclk1_out]

# FMC SFP reference clock
make_bd_intf_pins_external  [get_bd_intf_pins aurora_fmc_loop/GT_DIFF_REFCLK1]

# SFP 0 TX/RX lane
make_bd_intf_pins_external  [get_bd_intf_pins aurora_fmc_loop/GT_SERIAL_RX]
make_bd_intf_pins_external  [get_bd_intf_pins aurora_fmc_loop/GT_SERIAL_TX]

# SFP 1 TX/RX lane
make_bd_intf_pins_external  [get_bd_intf_pins aurora_fmc2card_loop/GT_SERIAL_RX]
make_bd_intf_pins_external  [get_bd_intf_pins aurora_fmc2card_loop/GT_SERIAL_TX]

# ----------------------------------------------------------------------------------------------------
# link up signals
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
make_bd_pins_external  [get_bd_pins xlconcat_0/dout]
set_property name link_up [get_bd_pins dout_0]
connect_bd_net [get_bd_pins aurora_card_loop/channel_up] [get_bd_pins xlconcat_0/In0]
connect_bd_net [get_bd_pins aurora_fmc_loop/channel_up] [get_bd_pins xlconcat_0/In1]
connect_bd_net [get_bd_pins aurora_fmc2card_loop/tx_channel_up] [get_bd_pins xlconcat_0/In2]
connect_bd_net [get_bd_pins aurora_card2fmc_loop/rx_channel_up] [get_bd_pins xlconcat_0/In3]

# init_clk, pma_init, reset
create_bd_pin -dir I init_clk
connect_bd_net [get_bd_pins init_clk] [get_bd_pins aurora_card_loop/init_clk]
connect_bd_net [get_bd_pins init_clk] [get_bd_pins aurora_card2fmc_loop/init_clk]
connect_bd_net [get_bd_pins init_clk] [get_bd_pins aurora_fmc_loop/init_clk]
connect_bd_net [get_bd_pins init_clk] [get_bd_pins aurora_fmc2card_loop/init_clk]

create_bd_pin -dir I reset_pb
connect_bd_net [get_bd_pins reset_pb]  [get_bd_pins aurora_card_loop/reset_pb]
connect_bd_net [get_bd_pins reset_pb]  [get_bd_pins aurora_fmc_loop/reset_pb]

create_bd_pin -dir I pma_init
connect_bd_net [get_bd_pins pma_init]  [get_bd_pins aurora_card_loop/pma_init]
connect_bd_net [get_bd_pins pma_init]  [get_bd_pins aurora_fmc_loop/pma_init]

# создание axi stream портов
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_1_TX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_2_TX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_3_TX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_1_RX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_2_RX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_3_RX

# создание axi stream портов
connect_bd_intf_net [get_bd_intf_pins CH_1_TX] [get_bd_intf_pins aurora_card_loop/USER_DATA_S_AXIS_TX]
connect_bd_intf_net [get_bd_intf_pins CH_1_RX] [get_bd_intf_pins aurora_card_loop/USER_DATA_M_AXIS_RX]
connect_bd_intf_net [get_bd_intf_pins CH_2_TX] [get_bd_intf_pins aurora_fmc_loop/USER_DATA_S_AXIS_TX]
connect_bd_intf_net [get_bd_intf_pins CH_2_RX] [get_bd_intf_pins aurora_fmc_loop/USER_DATA_M_AXIS_RX]
connect_bd_intf_net [get_bd_intf_pins CH_3_TX] [get_bd_intf_pins aurora_fmc2card_loop/USER_DATA_S_AXIS_TX]
connect_bd_intf_net [get_bd_intf_pins CH_3_RX] [get_bd_intf_pins aurora_card2fmc_loop/USER_DATA_M_AXIS_RX]

# выходные сигналы сброса и clock
create_bd_pin -dir O clk_aurora_card
create_bd_pin -dir O clk_aurora_fmc
create_bd_pin -dir O reset_aurora_card_n
create_bd_pin -dir O reset_aurora_fmc_n

create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not} CONFIG.LOGO_FILE {data/sym_notgate.png}] [get_bd_cells util_vector_logic_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not} CONFIG.LOGO_FILE {data/sym_notgate.png}] [get_bd_cells util_vector_logic_1]

connect_bd_net [get_bd_pins clk_aurora_card] [get_bd_pins aurora_card_loop/user_clk_out]
connect_bd_net [get_bd_pins clk_aurora_fmc] [get_bd_pins aurora_fmc_loop/user_clk_out]
connect_bd_net [get_bd_pins util_vector_logic_0/Op1] [get_bd_pins aurora_fmc_loop/sys_reset_out]
connect_bd_net [get_bd_pins util_vector_logic_1/Op1] [get_bd_pins aurora_card_loop/sys_reset_out]
connect_bd_net [get_bd_pins reset_aurora_fmc_n] [get_bd_pins util_vector_logic_0/Res]
connect_bd_net [get_bd_pins reset_aurora_card_n] [get_bd_pins util_vector_logic_1/Res]

current_bd_instance