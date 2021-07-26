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
# сигналы SFP Hot Plug и TX Disable
create_bd_port -dir I -from 1 -to 0 Hot_Plug
create_bd_port -dir O -from 1 -to 0 Hot_Plug_LEDs
connect_bd_net [get_bd_ports Hot_Plug] [get_bd_ports Hot_Plug_LEDs]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]
make_bd_pins_external  [get_bd_pins xlconstant_0/dout]
set_property name TX_Disable [get_bd_ports dout_0]

# -----------------------------------------------------------
# создание подсистемы с ядрами Aurora 
source tcl/aurora_subsystem.tcl

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


# -----------------------------------------------------------
# проверка итогового проекта и создание wrapper
regenerate_bd_layout
validate_bd_design
save_bd_design
close_bd_design [get_bd_designs Aurua_Loop]

make_wrapper -files [get_files Aurora_Loop/Aurora_Loop.srcs/sources_1/bd/Aurua_Loop/Aurua_Loop.bd] -top
add_files -norecurse Aurora_Loop/Aurora_Loop.srcs/sources_1/bd/Aurua_Loop/hdl/Aurua_Loop_wrapper.v
