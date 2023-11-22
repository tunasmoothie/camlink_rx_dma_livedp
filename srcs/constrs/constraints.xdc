# Bitstream Compression
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]


############################################################
# CLOCK RELATED CONSTRAINTS
############################################################

# -- 54 MHz clock from FMC HPC0 --
create_clock -period 18.520 -name cam_clk_0 -waveform {0.000 9.260} [get_ports cam_clk_0]
set_property PACKAGE_PIN R8 [get_ports cam_clk_0]
set_property IOSTANDARD LVCMOS18 [get_ports cam_clk_0]

# -- 10 MHz clock from FMC HPC1 --
create_clock -period 100.000 -name cam_clk_1 -waveform {0.000 50.000} [get_ports cam_clk_1]
set_property PACKAGE_PIN P9 [get_ports cam_clk_1]
set_property IOSTANDARD LVCMOS18 [get_ports cam_clk_1]


set_clock_groups -asynchronous -group [get_clocks clk_100M_top_clk_wiz_1_0] -group [get_clocks cam_clk_0] -group [get_clocks cam_clk_1]
set_false_path -from [get_clocks clk_100M_top_clk_wiz_1_0] to [get_clocks cam_clk_0]


############################################################
# PIN RELATED CONSTRAINTS
############################################################

# Clock Pins
set_property PACKAGE_PIN R8 [get_ports cam_clk_0]
set_property PACKAGE_PIN P9 [get_ports cam_clk_1]


# HPC0 Data Pins
set_property PACKAGE_PIN L16 [get_ports {cmlink_base_0[27]}]
set_property PACKAGE_PIN K16 [get_ports {cmlink_base_0[26]}]
set_property PACKAGE_PIN L15 [get_ports {cmlink_base_0[25]}]
set_property PACKAGE_PIN K15 [get_ports {cmlink_base_0[24]}]
set_property PACKAGE_PIN N13 [get_ports {cmlink_base_0[23]}]
set_property PACKAGE_PIN M13 [get_ports {cmlink_base_0[22]}]
set_property PACKAGE_PIN M15 [get_ports {cmlink_base_0[21]}]
set_property PACKAGE_PIN M14 [get_ports {cmlink_base_0[20]}]
set_property PACKAGE_PIN M11 [get_ports {cmlink_base_0[19]}]
set_property PACKAGE_PIN L11 [get_ports {cmlink_base_0[18]}]
set_property PACKAGE_PIN U9 [get_ports {cmlink_base_0[17]}]
set_property PACKAGE_PIN U8 [get_ports {cmlink_base_0[16]}]
set_property PACKAGE_PIN V8 [get_ports {cmlink_base_0[15]}]
set_property PACKAGE_PIN V7 [get_ports {cmlink_base_0[14]}]
set_property PACKAGE_PIN V12 [get_ports {cmlink_base_0[13]}]
set_property PACKAGE_PIN V11 [get_ports {cmlink_base_0[12]}]
set_property PACKAGE_PIN L13 [get_ports {cmlink_base_0[11]}]
set_property PACKAGE_PIN K13 [get_ports {cmlink_base_0[10]}]
set_property PACKAGE_PIN P12 [get_ports {cmlink_base_0[9]}]
set_property PACKAGE_PIN N12 [get_ports {cmlink_base_0[8]}]
set_property PACKAGE_PIN L12 [get_ports {cmlink_base_0[7]}]
set_property PACKAGE_PIN K12 [get_ports {cmlink_base_0[6]}]
set_property PACKAGE_PIN T7 [get_ports {cmlink_base_0[5]}]
set_property PACKAGE_PIN T6 [get_ports {cmlink_base_0[4]}]
set_property PACKAGE_PIN V6 [get_ports {cmlink_base_0[3]}]
set_property PACKAGE_PIN U6 [get_ports {cmlink_base_0[2]}]
set_property PACKAGE_PIN U11 [get_ports {cmlink_base_0[1]}]
set_property PACKAGE_PIN T11 [get_ports {cmlink_base_0[0]}]


# HPC1 Data Pins
# Due to incomplete FMC pinning, some ports are undefined
set_property PACKAGE_PIN AE12 [get_ports {cam_data_in_1_0[27]}]
set_property PACKAGE_PIN AF12 [get_ports {cam_data_in_1_0[26]}]
set_property PACKAGE_PIN T12 [get_ports {cam_data_in_1_0[25]}]
set_property PACKAGE_PIN R12 [get_ports {cam_data_in_1_0[24]}]
set_property PACKAGE_PIN AB11 [get_ports {cam_data_in_1_0[23]}]
set_property PACKAGE_PIN AB10 [get_ports {cam_data_in_1_0[22]}]
set_property PACKAGE_PIN AF11 [get_ports {cam_data_in_1_0[21]}]
set_property PACKAGE_PIN AG11 [get_ports {cam_data_in_1_0[20]}]
set_property PACKAGE_PIN AE10 [get_ports {cam_data_in_1_0[19]}]
set_property PACKAGE_PIN AF10 [get_ports {cam_data_in_1_0[18]}]
set_property PACKAGE_PIN W12 [get_ports {cam_data_in_1_0[17]}]
set_property PACKAGE_PIN W11 [get_ports {cam_data_in_1_0[16]}]
#set_property PACKAGE_PIN V8 [get_ports {cam_data_in_1[15]}]
#set_property PACKAGE_PIN V7 [get_ports {cam_data_in_1[14]}]
#set_property PACKAGE_PIN V12 [get_ports {cam_data_in_1[13]}]
#set_property PACKAGE_PIN V11 [get_ports {cam_data_in_1[12]}]
set_property PACKAGE_PIN AA11 [get_ports {cam_data_in_1_1[11]}]
set_property PACKAGE_PIN AA10 [get_ports {cam_data_in_1_1[10]}]
set_property PACKAGE_PIN AC12 [get_ports {cam_data_in_1_1[9]}]
set_property PACKAGE_PIN AC11 [get_ports {cam_data_in_1_1[8]}]
set_property PACKAGE_PIN AH12 [get_ports {cam_data_in_1_1[7]}]
set_property PACKAGE_PIN AH11 [get_ports {cam_data_in_1_1[6]}]
set_property PACKAGE_PIN T13 [get_ports {cam_data_in_1_1[5]}]
set_property PACKAGE_PIN R13 [get_ports {cam_data_in_1_1[4]}]
#set_property PACKAGE_PIN V6 [get_ports {cam_data_in_1[3]}]
#set_property PACKAGE_PIN U6 [get_ports {cam_data_in_1[2]}]
#set_property PACKAGE_PIN U11 [get_ports {cam_data_in_1[1]}]
#set_property PACKAGE_PIN T11 [get_ports {cam_data_in_1[0]}]


set_property IOSTANDARD LVCMOS18 [get_ports cam_clk_0]
set_property IOSTANDARD LVCMOS18 [get_ports cam_clk_1]

set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[27]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[26]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[25]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[24]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[23]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[22]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[21]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[20]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[19]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[18]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cmlink_base_0[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[27]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[26]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[25]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[24]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[23]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[22]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[21]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[20]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[19]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[18]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_0[16]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_0[15]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_0[14]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_0[13]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_0[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_1[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_1[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_1[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_1[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_1[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_1[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_1[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_1_1[4]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_0[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_0[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_0[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {cam_data_in_0[0]}]


############################################################
# DEBUG/ILA RELATED CONSTRAINTS
############################################################

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]

