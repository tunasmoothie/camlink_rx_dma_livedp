set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

#54 MHz
set_property PACKAGE_PIN R8 [get_ports cam_clk_0]
set_property IOSTANDARD LVCMOS18 [get_ports cam_clk_0]

create_clock -period 18.520 -name cam_clk_0 -waveform {0.000 9.260} [get_ports cam_clk_0]

#21.04 MHz
set_property PACKAGE_PIN P9 [get_ports cam_clk_1]
set_property IOSTANDARD LVCMOS18 [get_ports cam_clk_1]

create_clock -period 47.528 -name cam_clk_1 -waveform {0.000 23.753} [get_ports cam_clk_1]

# HPC0 Pins
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


# HPC1 Pins
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


set_max_delay -from [get_pins top_i/axi_vdma_1/U0/GEN_SPRT_FOR_S2MM.GEN_S2MM_DRE_ON_SKID.I_S2MM_SKID_FLUSH_SOF/sig_s_ready_out_reg/C] -to [get_pins top_i/cam_in_axi4s_1/inst/FIFO36E2_inst/RDEN] 0.510
