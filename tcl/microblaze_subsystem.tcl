# --------------------------------------------------------------
# скрипт для создание подсиcтемы c ядром и периферией Microblaze
# --------------------------------------------------------------

# добавление microblaze
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {1} axi_periph {Enabled} cache {None} clk {/util_ds_buf_1/BUFG_O (125 MHz)} debug_module {Debug Only} ecc {None} local_mem {64KB} preset {None}}  [get_bd_cells microblaze_0]
set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells microblaze_0_xlconcat]
set_property -dict [list CONFIG.C_FSL_LINKS {3}] [get_bd_cells microblaze_0]

# создание иерархии
group_bd_cells microblaze_subsystem [get_bd_cells rst_util_ds_buf_1_100M] [get_bd_cells microblaze_0_xlconcat] [get_bd_cells microblaze_0] [get_bd_cells microblaze_0_axi_intc] [get_bd_cells microblaze_0_axi_periph] [get_bd_cells microblaze_0_local_memory]
current_bd_instance [get_bd_cells /microblaze_subsystem]

# сигнал захвата фазы DCM
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins rst_util_ds_buf_1_100M/dcm_locked]

# увеличение числа портов interconnect
set_property -dict [list CONFIG.NUM_MI {4}] [get_bd_cells microblaze_0_axi_periph]
connect_bd_net [get_bd_pins Clk] [get_bd_pins microblaze_0_axi_periph/M01_ACLK]
connect_bd_net [get_bd_pins Clk] [get_bd_pins microblaze_0_axi_periph/M02_ACLK]
connect_bd_net [get_bd_pins Clk] [get_bd_pins microblaze_0_axi_periph/M03_ACLK]
connect_bd_net [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins rst_util_ds_buf_1_100M/peripheral_aresetn]
connect_bd_net [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins rst_util_ds_buf_1_100M/peripheral_aresetn]
connect_bd_net [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins rst_util_ds_buf_1_100M/peripheral_aresetn]

# внешний сигнал сброса
make_bd_pins_external  [get_bd_pins rst_util_ds_buf_1_100M/ext_reset_in]
set_property name pb_reset [get_bd_pins ext_reset_in_0]

# добавление UART
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0

connect_bd_intf_net [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
connect_bd_net [get_bd_pins Clk] [get_bd_pins axi_uartlite_0/s_axi_aclk]
connect_bd_net [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins rst_util_ds_buf_1_100M/peripheral_aresetn]

make_bd_intf_pins_external  [get_bd_intf_pins axi_uartlite_0/UART]

# добавление GPIO Aurora Reset
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_reset
set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_GPIO2_WIDTH {1} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS_2 {0} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_reset]

connect_bd_intf_net [get_bd_intf_pins axi_gpio_reset/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
connect_bd_net [get_bd_pins Clk] [get_bd_pins axi_gpio_reset/s_axi_aclk]
connect_bd_net [get_bd_pins axi_gpio_reset/s_axi_aresetn] [get_bd_pins rst_util_ds_buf_1_100M/peripheral_aresetn]

create_bd_pin -dir O aurora_reset
create_bd_pin -dir O aurora_pma_init

connect_bd_net [get_bd_pins aurora_reset] [get_bd_pins axi_gpio_reset/gpio_io_o]
connect_bd_net [get_bd_pins aurora_pma_init] [get_bd_pins axi_gpio_reset/gpio2_io_o]

# добавление GPIO Aurora Hot Plug
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_hot_plug
set_property -dict [list CONFIG.C_GPIO_WIDTH {4} CONFIG.C_ALL_INPUTS {1} CONFIG.C_INTERRUPT_PRESENT {1}] [get_bd_cells axi_gpio_hot_plug]

connect_bd_intf_net [get_bd_intf_pins axi_gpio_hot_plug/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
connect_bd_net [get_bd_pins Clk] [get_bd_pins axi_gpio_hot_plug/s_axi_aclk]
connect_bd_net [get_bd_pins axi_gpio_hot_plug/s_axi_aresetn] [get_bd_pins rst_util_ds_buf_1_100M/peripheral_aresetn]

create_bd_pin -dir I -from 3 -to 0 SPF_hot_pug
connect_bd_net [get_bd_pins SPF_hot_pug] [get_bd_pins axi_gpio_hot_plug/gpio_io_i]

connect_bd_net [get_bd_pins axi_gpio_hot_plug/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In0]

# создание axi stream портов
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_1_TX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_2_TX
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 CH_3_TX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_1_RX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_2_RX
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 CH_3_RX

# подключение axi stream портов
connect_bd_intf_net [get_bd_intf_pins CH_1_RX] [get_bd_intf_pins microblaze_0/S0_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_2_RX] [get_bd_intf_pins microblaze_0/S1_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_3_RX] [get_bd_intf_pins microblaze_0/S2_AXIS]

connect_bd_intf_net [get_bd_intf_pins CH_1_TX] [get_bd_intf_pins microblaze_0/M0_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_2_TX] [get_bd_intf_pins microblaze_0/M1_AXIS]
connect_bd_intf_net [get_bd_intf_pins CH_3_TX] [get_bd_intf_pins microblaze_0/M2_AXIS]

assign_bd_address

current_bd_instance
