# создание проекта для платы KU116 с мезонином FM414S

# -----------------------------------------------------------
set Project_Name Aurora_Loop

# если проект с таким именем существует удаляем его
close_project -quiet
if { [file exists $Project_Name] != 0 } { 
	file delete -force $Project_Name
}

# создаем проект
create_project $Project_Name ./$Project_Name -part xcku5p-ffvb676-2-e

# настройка кэша ip ядер
config_ip_cache -import_from_project -use_cache_location ip_cache
update_ip_catalog

# добавление constraint файлов
add_files -fileset constrs_1 constraints/pins.xdc
add_files -fileset constrs_1 constraints/timing.xdc

# -----------------------------------------------------------
# создаем block design
create_bd_design "Aurora_Loop"

# -----------------------------------------------------------
# буферы для тактового сигнала 125 MHz
create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0
set_property -dict [list CONFIG.C_BUF_TYPE {IBUFDS}] [get_bd_cells util_ds_buf_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_1
set_property -dict [list CONFIG.C_BUF_TYPE {BUFG}] [get_bd_cells util_ds_buf_1]

make_bd_intf_pins_external  [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
set_property name CLK_125_DS [get_bd_intf_ports CLK_IN_D_0]

connect_bd_net [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins util_ds_buf_1/BUFG_I]
set_property CONFIG.FREQ_HZ 125000000 [get_bd_intf_ports /CLK_125_DS]

# -----------------------------------------------------------
# создание подсистемы с Microblaze
source tcl/microblaze_subsystem.tcl

# -----------------------------------------------------------
# создание подсистемы с dual clock 
source tcl/fifo_subsystem.tcl

# -----------------------------------------------------------
# создание подсистемы с ядрами Aurora 
source tcl/aurora_subsystem.tcl

# -----------------------------------------------------------
# сигналы SFP Hot Plug и TX Disable
create_bd_port -dir I -from 1 -to 0 Hot_Plug
create_bd_port -dir O -from 1 -to 0 Hot_Plug_LEDs
connect_bd_net [get_bd_ports Hot_Plug] [get_bd_ports Hot_Plug_LEDs]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]
make_bd_pins_external  [get_bd_pins xlconstant_0/dout]
set_property name TX_Disable [get_bd_ports dout_1]

# -----------------------------------------------------------
# внешний сигнал сброса и link up
set_property name reset [get_bd_ports ext_reset_in_0]
set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports reset]
set_property name link_up [get_bd_ports dout_0]

# -----------------------------------------------------------
# подключение сигналов подсистем
connect_bd_net [get_bd_pins aurora_subsystem/init_clk] [get_bd_pins util_ds_buf_1/BUFG_O]
connect_bd_net [get_bd_pins microblaze_subsystem/aurora_reset] [get_bd_pins aurora_subsystem/reset_pb]
connect_bd_net [get_bd_pins microblaze_subsystem/aurora_pma_init] [get_bd_pins aurora_subsystem/pma_init]

connect_bd_net [get_bd_pins microblaze_subsystem/SPF_hot_pug] [get_bd_pins aurora_subsystem/link_up]

connect_bd_net [get_bd_pins fifo_subsystem/clk_mb]            [get_bd_pins util_ds_buf_1/BUFG_O]
connect_bd_net [get_bd_pins aurora_subsystem/clk_aurora_card] [get_bd_pins fifo_subsystem/clk_aurora_card]
connect_bd_net [get_bd_pins aurora_subsystem/clk_aurora_fmc]  [get_bd_pins fifo_subsystem/clk_aurora_fmc]

connect_bd_net [get_bd_pins fifo_subsystem/reset_card_n]         [get_bd_pins aurora_subsystem/reset_aurora_card_n]
connect_bd_net [get_bd_pins aurora_subsystem/reset_aurora_fmc_n] [get_bd_pins fifo_subsystem/reset_fmc_n]

connect_bd_intf_net [get_bd_intf_pins microblaze_subsystem/CH_1_TX] [get_bd_intf_pins fifo_subsystem/CH_mb_1_TX]
connect_bd_intf_net [get_bd_intf_pins microblaze_subsystem/CH_2_TX] [get_bd_intf_pins fifo_subsystem/CH_mb_2_TX]
connect_bd_intf_net [get_bd_intf_pins microblaze_subsystem/CH_3_TX] [get_bd_intf_pins fifo_subsystem/CH_mb_3_TX]

connect_bd_intf_net [get_bd_intf_pins fifo_subsystem/CH_aurora_1_TX] [get_bd_intf_pins aurora_subsystem/CH_1_TX]
connect_bd_intf_net [get_bd_intf_pins fifo_subsystem/CH_aurora_2_TX] [get_bd_intf_pins aurora_subsystem/CH_2_TX]
connect_bd_intf_net [get_bd_intf_pins fifo_subsystem/CH_aurora_3_TX] [get_bd_intf_pins aurora_subsystem/CH_3_TX]

connect_bd_intf_net [get_bd_intf_pins fifo_subsystem/CH_mb_1_RX] [get_bd_intf_pins microblaze_subsystem/CH_1_RX]
connect_bd_intf_net [get_bd_intf_pins fifo_subsystem/CH_mb_2_RX] [get_bd_intf_pins microblaze_subsystem/CH_2_RX]
connect_bd_intf_net [get_bd_intf_pins fifo_subsystem/CH_mb_3_RX] [get_bd_intf_pins microblaze_subsystem/CH_3_RX]

connect_bd_intf_net [get_bd_intf_pins aurora_subsystem/CH_1_RX] [get_bd_intf_pins fifo_subsystem/CH_aurora_1_RX]
connect_bd_intf_net [get_bd_intf_pins aurora_subsystem/CH_2_RX] [get_bd_intf_pins fifo_subsystem/CH_aurora_2_RX]
connect_bd_intf_net [get_bd_intf_pins aurora_subsystem/CH_3_RX] [get_bd_intf_pins fifo_subsystem/CH_aurora_3_RX]

# -----------------------------------------------------------
# добавление ila
create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0
set_property -dict [list CONFIG.C_BRAM_CNT {6} CONFIG.C_NUM_MONITOR_SLOTS {6}] [get_bd_cells system_ila_0]
set_property -dict [list CONFIG.C_BRAM_CNT {35} CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0}] [get_bd_cells system_ila_0]
set_property -dict [list CONFIG.C_BRAM_CNT {35} CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0}] [get_bd_cells system_ila_0]
set_property -dict [list CONFIG.C_BRAM_CNT {35} CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0}] [get_bd_cells system_ila_0]
set_property -dict [list CONFIG.C_BRAM_CNT {35} CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0}] [get_bd_cells system_ila_0]
set_property -dict [list CONFIG.C_BRAM_CNT {35} CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0}] [get_bd_cells system_ila_0]
set_property -dict [list CONFIG.C_BRAM_CNT {35} CONFIG.C_SLOT_5_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0}] [get_bd_cells system_ila_0]
set_property -dict [list CONFIG.C_BRAM_CNT {2} CONFIG.C_EN_STRG_QUAL {1} CONFIG.C_INPUT_PIPE_STAGES {6} CONFIG.C_PROBE0_MU_CNT {2} CONFIG.ALL_PROBE_SAME_MU_CNT {2}] [get_bd_cells system_ila_0]
connect_bd_net [get_bd_pins system_ila_0/clk] [get_bd_pins util_ds_buf_1/BUFG_O]
connect_bd_net [get_bd_pins system_ila_0/resetn] [get_bd_pins microblaze_subsystem/mb_periph_resetn]

connect_bd_intf_net [get_bd_intf_pins system_ila_0/SLOT_0_AXIS] [get_bd_intf_pins microblaze_subsystem/CH_1_RX]
connect_bd_intf_net [get_bd_intf_pins system_ila_0/SLOT_1_AXIS] [get_bd_intf_pins microblaze_subsystem/CH_2_RX]
connect_bd_intf_net [get_bd_intf_pins system_ila_0/SLOT_2_AXIS] [get_bd_intf_pins microblaze_subsystem/CH_3_RX]
connect_bd_intf_net [get_bd_intf_pins system_ila_0/SLOT_3_AXIS] [get_bd_intf_pins fifo_subsystem/CH_mb_1_TX]
connect_bd_intf_net [get_bd_intf_pins system_ila_0/SLOT_4_AXIS] [get_bd_intf_pins fifo_subsystem/CH_mb_2_TX]
connect_bd_intf_net [get_bd_intf_pins system_ila_0/SLOT_5_AXIS] [get_bd_intf_pins fifo_subsystem/CH_mb_3_TX]

# -----------------------------------------------------------
# проверка итогового проекта
regenerate_bd_layout
validate_bd_design
save_bd_design
close_bd_design [get_bd_designs Aurua_Loop]
