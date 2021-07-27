# -------------------------------------------------------
# скрипт для создание подсиcтемы c dual clock fifo
# -------------------------------------------------------

# создание иерархии
create_bd_cell -type hier fifo_subsystem
current_bd_instance [get_bd_cells /fifo_subsystem]

# добавление fifo microblaze в aurora
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_mb2aurora_1
set_property -dict [list CONFIG.FIFO_DEPTH {16} CONFIG.IS_ACLK_ASYNC {1}] [get_bd_cells axis_data_fifo_mb2aurora_1]

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_mb2aurora_2
set_property -dict [list CONFIG.FIFO_DEPTH {16} CONFIG.IS_ACLK_ASYNC {1}] [get_bd_cells axis_data_fifo_mb2aurora_2]

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_mb2aurora_3
set_property -dict [list CONFIG.FIFO_DEPTH {16} CONFIG.IS_ACLK_ASYNC {1}] [get_bd_cells axis_data_fifo_mb2aurora_3]

# добавление fifo aurora в microblaze 
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_aurora2mb_1
set_property -dict [list CONFIG.FIFO_DEPTH {16} CONFIG.IS_ACLK_ASYNC {1}] [get_bd_cells axis_data_fifo_aurora2mb_1]

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_aurora2mb_2
set_property -dict [list CONFIG.FIFO_DEPTH {16} CONFIG.IS_ACLK_ASYNC {1}] [get_bd_cells axis_data_fifo_aurora2mb_2]

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_aurora2mb_3
set_property -dict [list CONFIG.FIFO_DEPTH {16} CONFIG.IS_ACLK_ASYNC {1}] [get_bd_cells axis_data_fifo_aurora2mb_3]

# добавление convertor 32 в 64
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_32_to_64_1
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {8}] [get_bd_cells axis_dwidth_converter_32_to_64_1]

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_32_to_64_2
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {8}] [get_bd_cells axis_dwidth_converter_32_to_64_2]

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_32_to_64_3
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {8}] [get_bd_cells axis_dwidth_converter_32_to_64_3]

# добавление convertor 64 в 32
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_64_to_32_1
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4}] [get_bd_cells axis_dwidth_converter_64_to_32_1]

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_64_to_32_2
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4}] [get_bd_cells axis_dwidth_converter_64_to_32_2]

create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_converter_64_to_32_3
set_property -dict [list CONFIG.M_TDATA_NUM_BYTES {4}] [get_bd_cells axis_dwidth_converter_64_to_32_3]

# создание портов тактового сигнала и сброса
create_bd_pin -dir I clk_mb
create_bd_pin -dir I clk_aurora_card
create_bd_pin -dir I clk_aurora_fmc
create_bd_pin -dir I reset_card_n
create_bd_pin -dir I reset_fmc_n

# тактовые сигналы для width convertors
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_dwidth_converter_32_to_64_3/aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_dwidth_converter_64_to_32_1/aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_dwidth_converter_64_to_32_2/aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_dwidth_converter_64_to_32_3/aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_dwidth_converter_32_to_64_1/aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_dwidth_converter_32_to_64_2/aclk]

# сбросы для width convertors
connect_bd_net [get_bd_pins reset_card_n] [get_bd_pins axis_dwidth_converter_64_to_32_1/aresetn]
connect_bd_net [get_bd_pins reset_fmc_n]  [get_bd_pins axis_dwidth_converter_64_to_32_2/aresetn]
connect_bd_net [get_bd_pins reset_fmc_n]  [get_bd_pins axis_dwidth_converter_64_to_32_3/aresetn]
connect_bd_net [get_bd_pins reset_fmc_n]  [get_bd_pins axis_dwidth_converter_32_to_64_3/aresetn]
connect_bd_net [get_bd_pins reset_card_n] [get_bd_pins axis_dwidth_converter_32_to_64_1/aresetn]
connect_bd_net [get_bd_pins reset_fmc_n]  [get_bd_pins axis_dwidth_converter_32_to_64_2/aresetn]

# fifo microblaze clock
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_data_fifo_mb2aurora_2/s_axis_aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_data_fifo_mb2aurora_3/s_axis_aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_data_fifo_mb2aurora_1/s_axis_aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_data_fifo_aurora2mb_3/m_axis_aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_data_fifo_aurora2mb_2/m_axis_aclk]
connect_bd_net [get_bd_pins clk_mb] [get_bd_pins axis_data_fifo_aurora2mb_1/m_axis_aclk]

# fifo aurora card clock
connect_bd_net [get_bd_pins clk_aurora_card] [get_bd_pins axis_data_fifo_aurora2mb_1/s_axis_aclk]
connect_bd_net [get_bd_pins clk_aurora_card] [get_bd_pins axis_data_fifo_mb2aurora_1/m_axis_aclk]
connect_bd_net [get_bd_pins clk_aurora_card] [get_bd_pins axis_data_fifo_aurora2mb_3/s_axis_aclk]

# fifo aurora fmc clock
connect_bd_net [get_bd_pins clk_aurora_fmc] [get_bd_pins axis_data_fifo_aurora2mb_2/s_axis_aclk]
connect_bd_net [get_bd_pins clk_aurora_fmc] [get_bd_pins axis_data_fifo_mb2aurora_2/m_axis_aclk]
connect_bd_net [get_bd_pins clk_aurora_fmc] [get_bd_pins axis_data_fifo_mb2aurora_3/m_axis_aclk]

# сбросы для fifo
connect_bd_net [get_bd_pins reset_card_n] [get_bd_pins axis_data_fifo_aurora2mb_1/s_axis_aresetn]
connect_bd_net [get_bd_pins reset_card_n] [get_bd_pins axis_data_fifo_mb2aurora_1/s_axis_aresetn]
connect_bd_net [get_bd_pins reset_fmc_n]  [get_bd_pins axis_data_fifo_aurora2mb_2/s_axis_aresetn]
connect_bd_net [get_bd_pins reset_fmc_n]  [get_bd_pins axis_data_fifo_mb2aurora_2/s_axis_aresetn]
connect_bd_net [get_bd_pins reset_fmc_n]  [get_bd_pins axis_data_fifo_aurora2mb_3/s_axis_aresetn]
connect_bd_net [get_bd_pins reset_fmc_n]  [get_bd_pins axis_data_fifo_mb2aurora_3/s_axis_aresetn]

# создание axi stream портов
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_mb_1_TX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_mb_2_TX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_mb_3_TX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_mb_1_RX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_mb_2_RX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_mb_3_RX

create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_aurora_1_RX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_aurora_2_RX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_aurora_3_RX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_aurora_1_TX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_aurora_2_TX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_aurora_3_TX

# соединение axis портов
connect_bd_intf_net [get_bd_intf_pins CH_mb_1_TX] [get_bd_intf_pins axis_dwidth_converter_32_to_64_1/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_mb_2_TX] [get_bd_intf_pins axis_dwidth_converter_32_to_64_2/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_mb_3_TX] [get_bd_intf_pins axis_dwidth_converter_32_to_64_3/S_AXIS]

connect_bd_intf_net [get_bd_intf_pins CH_mb_1_RX] [get_bd_intf_pins axis_dwidth_converter_64_to_32_1/M_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_mb_2_RX] [get_bd_intf_pins axis_dwidth_converter_64_to_32_2/M_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_mb_3_RX] [get_bd_intf_pins axis_dwidth_converter_64_to_32_3/M_AXIS]

connect_bd_intf_net [get_bd_intf_pins CH_aurora_1_RX] [get_bd_intf_pins axis_data_fifo_aurora2mb_1/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_aurora_2_RX] [get_bd_intf_pins axis_data_fifo_aurora2mb_2/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_aurora_3_RX] [get_bd_intf_pins axis_data_fifo_aurora2mb_3/S_AXIS]

connect_bd_intf_net [get_bd_intf_pins CH_aurora_1_TX] [get_bd_intf_pins axis_data_fifo_mb2aurora_1/M_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_aurora_2_TX] [get_bd_intf_pins axis_data_fifo_mb2aurora_2/M_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_aurora_3_TX] [get_bd_intf_pins axis_data_fifo_mb2aurora_3/M_AXIS]

# соединение fifo и width converter
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_aurora2mb_1/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_64_to_32_1/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_aurora2mb_2/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_64_to_32_2/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_aurora2mb_3/M_AXIS] [get_bd_intf_pins axis_dwidth_converter_64_to_32_3/S_AXIS]

connect_bd_intf_net [get_bd_intf_pins axis_dwidth_converter_32_to_64_1/M_AXIS] [get_bd_intf_pins axis_data_fifo_mb2aurora_1/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_dwidth_converter_32_to_64_2/M_AXIS] [get_bd_intf_pins axis_data_fifo_mb2aurora_2/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins axis_dwidth_converter_32_to_64_3/M_AXIS] [get_bd_intf_pins axis_data_fifo_mb2aurora_3/S_AXIS]

current_bd_instance