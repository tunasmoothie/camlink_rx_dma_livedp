
################################################################
# This is a generated script based on design: top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source top_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# axis_camlink_rx, axis_camlink_rx, axis_video_crop, axis_video_crop, axis_video_overlay

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu9eg-ffvb1156-2-e
   set_property BOARD_PART xilinx.com:zcu102:part0:3.4 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name camlink_dma_4panel

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_0 "Incomplete FMC pin set,
bits [15:12] and [3:0] discarded" [get_bd_designs $design_name]
  set_property USER_COMMENTS.comment_2 "Lower bits discarded 
for 8 BPC pixel format" [get_bd_designs $design_name]

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:v_axi4s_vid_out:4.0\
xilinx.com:ip:v_tc:6.2\
xilinx.com:ip:v_tpg:8.2\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:zynq_ultra_ps_e:3.4\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_vdma:6.3\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
axis_camlink_rx\
axis_camlink_rx\
axis_video_crop\
axis_video_crop\
axis_video_overlay\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: vmda_block
proc create_hier_cell_vmda_block { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_vmda_block() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_S2MM

  create_bd_intf_pin -mode Monitor -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_S2MM1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_S2MM2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_S2MM3


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir I -type clk m_axis_mm2s_aclk
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_0 ]
  set_property -dict [list \
    CONFIG.c_addr_width {40} \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_s2mm_genlock_mode {2} \
    CONFIG.c_s2mm_linebuffer_depth {512} \
    CONFIG.c_s2mm_max_burst_length {16} \
    CONFIG.c_use_s2mm_fsync {2} \
  ] $axi_vdma_0


  # Create instance: axi_vdma_1, and set properties
  set axi_vdma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_1 ]
  set_property -dict [list \
    CONFIG.c_addr_width {40} \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_s2mm_genlock_mode {2} \
    CONFIG.c_s2mm_max_burst_length {16} \
    CONFIG.c_use_s2mm_fsync {2} \
  ] $axi_vdma_1


  # Create instance: axi_vdma_2, and set properties
  set axi_vdma_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_2 ]
  set_property -dict [list \
    CONFIG.c_addr_width {40} \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_s2mm_genlock_mode {2} \
    CONFIG.c_s2mm_max_burst_length {16} \
  ] $axi_vdma_2


  # Create instance: axi_vdma_3, and set properties
  set axi_vdma_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_3 ]
  set_property -dict [list \
    CONFIG.c_addr_width {40} \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_s2mm_genlock_mode {2} \
    CONFIG.c_s2mm_max_burst_length {16} \
    CONFIG.c_use_s2mm_fsync {2} \
  ] $axi_vdma_3


  # Create instance: axi_vdma_4, and set properties
  set axi_vdma_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_4 ]
  set_property -dict [list \
    CONFIG.c_addr_width {40} \
    CONFIG.c_include_s2mm {0} \
    CONFIG.c_m_axis_mm2s_tdata_width {24} \
    CONFIG.c_mm2s_max_burst_length {16} \
  ] $axi_vdma_4


  # Create instance: axi_vdma_5, and set properties
  set axi_vdma_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_5 ]
  set_property -dict [list \
    CONFIG.c_addr_width {40} \
    CONFIG.c_include_s2mm {0} \
    CONFIG.c_m_axis_mm2s_tdata_width {24} \
    CONFIG.c_mm2s_max_burst_length {16} \
  ] $axi_vdma_5


  # Create instance: axi_vdma_read, and set properties
  set axi_vdma_read [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_read ]
  set_property -dict [list \
    CONFIG.c_addr_width {40} \
    CONFIG.c_include_mm2s {1} \
    CONFIG.c_include_s2mm {0} \
    CONFIG.c_m_axis_mm2s_tdata_width {24} \
    CONFIG.c_mm2s_genlock_mode {3} \
    CONFIG.c_mm2s_linebuffer_depth {2048} \
    CONFIG.c_mm2s_max_burst_length {16} \
    CONFIG.c_use_mm2s_fsync {0} \
  ] $axi_vdma_read


  # Create instance: axis_video_overlay_0, and set properties
  set block_name axis_video_overlay
  set block_cell_name axis_video_overlay_0
  if { [catch {set axis_video_overlay_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_video_overlay_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: vdma_ctrl_intrcnt, and set properties
  set vdma_ctrl_intrcnt [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 vdma_ctrl_intrcnt ]
  set_property -dict [list \
    CONFIG.NUM_MI {8} \
    CONFIG.NUM_SI {1} \
  ] $vdma_ctrl_intrcnt


  # Create interface connections
  connect_bd_intf_net -intf_net axi_ctrl_M00_AXI [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins vdma_ctrl_intrcnt/M00_AXI]
  connect_bd_intf_net -intf_net axi_ctrl_M01_AXI [get_bd_intf_pins axi_vdma_1/S_AXI_LITE] [get_bd_intf_pins vdma_ctrl_intrcnt/M01_AXI]
  connect_bd_intf_net -intf_net axi_ctrl_M02_AXI [get_bd_intf_pins axi_vdma_2/S_AXI_LITE] [get_bd_intf_pins vdma_ctrl_intrcnt/M02_AXI]
  connect_bd_intf_net -intf_net axi_ctrl_M03_AXI [get_bd_intf_pins axi_vdma_3/S_AXI_LITE] [get_bd_intf_pins vdma_ctrl_intrcnt/M03_AXI]
  connect_bd_intf_net -intf_net axi_ctrl_M04_AXI [get_bd_intf_pins axi_vdma_read/S_AXI_LITE] [get_bd_intf_pins vdma_ctrl_intrcnt/M04_AXI]
  connect_bd_intf_net -intf_net axi_ctrl_M05_AXI [get_bd_intf_pins M05_AXI] [get_bd_intf_pins vdma_ctrl_intrcnt/M05_AXI]
  connect_bd_intf_net -intf_net axi_ctrl_M07_AXI [get_bd_intf_pins axi_vdma_4/S_AXI_LITE] [get_bd_intf_pins vdma_ctrl_intrcnt/M07_AXI]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM1] [get_bd_intf_pins axi_vdma_1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_2_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM2] [get_bd_intf_pins axi_vdma_2/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_3_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM3] [get_bd_intf_pins axi_vdma_3/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_4_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_4/M_AXIS_MM2S] [get_bd_intf_pins axis_video_overlay_0/S_AXIS_VID0]
  connect_bd_intf_net -intf_net [get_bd_intf_nets axi_vdma_4_M_AXIS_MM2S] [get_bd_intf_pins M_AXIS_MM2S] [get_bd_intf_pins axi_vdma_4/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_4_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_vdma_4/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_5_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_5/M_AXIS_MM2S] [get_bd_intf_pins axis_video_overlay_0/S_AXIS_VID1]
  connect_bd_intf_net -intf_net [get_bd_intf_nets axi_vdma_5_M_AXIS_MM2S] [get_bd_intf_pins M_AXIS_MM2S1] [get_bd_intf_pins axi_vdma_5/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_5_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins axi_vdma_5/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_read_M_AXIS_MM2S [get_bd_intf_pins M_AXIS_MM2S2] [get_bd_intf_pins axi_vdma_read/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_read_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins axi_vdma_read/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axis_video_crop_0_m_axis [get_bd_intf_pins S_AXIS_S2MM] [get_bd_intf_pins axi_vdma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axis_video_crop_1_m_axis [get_bd_intf_pins S_AXIS_S2MM2] [get_bd_intf_pins axi_vdma_1/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axis_video_overlay_0_m_axis [get_bd_intf_pins axi_vdma_3/S_AXIS_S2MM] [get_bd_intf_pins axis_video_overlay_0/M_AXIS]
  connect_bd_intf_net -intf_net [get_bd_intf_nets axis_video_overlay_0_m_axis] [get_bd_intf_pins S_AXIS_S2MM1] [get_bd_intf_pins axis_video_overlay_0/M_AXIS]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins vdma_ctrl_intrcnt/S00_AXI]
  connect_bd_intf_net -intf_net v_tpg_0_m_axis_video [get_bd_intf_pins S_AXIS_S2MM3] [get_bd_intf_pins axi_vdma_2/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net vdma_ctrl_intrcnt_M06_AXI [get_bd_intf_pins axi_vdma_5/S_AXI_LITE] [get_bd_intf_pins vdma_ctrl_intrcnt/M06_AXI]

  # Create port connections
  connect_bd_net -net axi_vdma_0_s2mm_frame_ptr_out [get_bd_pins axi_vdma_0/s2mm_frame_ptr_out] [get_bd_pins axi_vdma_4/mm2s_frame_ptr_in] [get_bd_pins axi_vdma_read/mm2s_frame_ptr_in]
  connect_bd_net -net axi_vdma_1_s2mm_frame_ptr_out [get_bd_pins axi_vdma_1/s2mm_frame_ptr_out] [get_bd_pins axi_vdma_5/mm2s_frame_ptr_in]
  connect_bd_net -net clk_wiz_0_vidclk_148_5 [get_bd_pins m_axis_mm2s_aclk] [get_bd_pins axi_vdma_read/m_axis_mm2s_aclk]
  connect_bd_net -net clk_wiz_1_clk_100M [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_1/s_axi_lite_aclk] [get_bd_pins axi_vdma_1/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_2/s_axi_lite_aclk] [get_bd_pins axi_vdma_2/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_3/s_axi_lite_aclk] [get_bd_pins axi_vdma_3/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_4/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_4/s_axi_lite_aclk] [get_bd_pins axi_vdma_5/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_5/s_axi_lite_aclk] [get_bd_pins axi_vdma_read/s_axi_lite_aclk] [get_bd_pins axis_video_overlay_0/axis_clk] [get_bd_pins vdma_ctrl_intrcnt/aclk]
  connect_bd_net -net clk_wiz_1_clk_200M [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_1/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_2/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_3/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_4/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_5/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_read/m_axi_mm2s_aclk]
  connect_bd_net -net zynq_clk100_rst_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins axi_vdma_1/axi_resetn] [get_bd_pins axi_vdma_2/axi_resetn] [get_bd_pins axi_vdma_3/axi_resetn] [get_bd_pins axi_vdma_4/axi_resetn] [get_bd_pins axi_vdma_5/axi_resetn] [get_bd_pins axi_vdma_read/axi_resetn] [get_bd_pins axis_video_overlay_0/aresetn] [get_bd_pins vdma_ctrl_intrcnt/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: clks_rsts
proc create_hier_cell_clks_rsts { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_clks_rsts() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -type clk clk_100M
  create_bd_pin -dir I -type clk clk_in1
  create_bd_pin -dir I -type clk clk_in2
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn1
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn2
  create_bd_pin -dir O -type clk slowest_sync_clk
  create_bd_pin -dir O -type clk slowest_sync_clk1

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {233.232} \
    CONFIG.CLKOUT1_PHASE_ERROR {404.832} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {148.5} \
    CONFIG.CLKOUT2_JITTER {108.264} \
    CONFIG.CLKOUT2_PHASE_ERROR {87.473} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {148.5} \
    CONFIG.CLKOUT2_USED {false} \
    CONFIG.CLK_OUT1_PORT {vidclk_148_5} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {87.625} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.375} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
    CONFIG.MMCM_DIVCLK_DIVIDE {8} \
    CONFIG.NUM_OUT_CLKS {1} \
    CONFIG.PRIM_SOURCE {Global_buffer} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]
  set_property -dict [list \
    CONFIG.CLKOUT2_JITTER {102.096} \
    CONFIG.CLKOUT2_PHASE_ERROR {87.187} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLK_OUT1_PORT {clk_100M} \
    CONFIG.CLK_OUT2_PORT {clk_200M} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {6} \
    CONFIG.NUM_OUT_CLKS {2} \
    CONFIG.PRIM_SOURCE {Global_buffer} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_1


  # Create instance: vid_clk_148_5_rst, and set properties
  set vid_clk_148_5_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 vid_clk_148_5_rst ]

  # Create instance: zynq_clk100_rst, and set properties
  set zynq_clk100_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 zynq_clk100_rst ]

  # Create instance: zynq_clk200_rst, and set properties
  set zynq_clk200_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 zynq_clk200_rst ]

  # Create port connections
  connect_bd_net -net clk_wiz_0_vidclk_148_5 [get_bd_pins slowest_sync_clk1] [get_bd_pins clk_wiz_0/vidclk_148_5] [get_bd_pins vid_clk_148_5_rst/slowest_sync_clk]
  connect_bd_net -net clk_wiz_1_clk_100M [get_bd_pins clk_100M] [get_bd_pins clk_wiz_1/clk_100M] [get_bd_pins zynq_clk100_rst/slowest_sync_clk]
  connect_bd_net -net clk_wiz_1_clk_200M [get_bd_pins slowest_sync_clk] [get_bd_pins clk_wiz_1/clk_200M] [get_bd_pins zynq_clk200_rst/slowest_sync_clk]
  connect_bd_net -net zynq_clk100_rst_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins zynq_clk100_rst/peripheral_aresetn]
  connect_bd_net -net zynq_clk200_rst_peripheral_aresetn [get_bd_pins peripheral_aresetn1] [get_bd_pins zynq_clk200_rst/peripheral_aresetn]
  connect_bd_net -net zynq_clk74_25_rst_peripheral_aresetn [get_bd_pins peripheral_aresetn2] [get_bd_pins vid_clk_148_5_rst/peripheral_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1 [get_bd_pins clk_in2] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk2 [get_bd_pins clk_in1] [get_bd_pins clk_wiz_1/clk_in1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins ext_reset_in] [get_bd_pins vid_clk_148_5_rst/ext_reset_in] [get_bd_pins zynq_clk100_rst/ext_reset_in] [get_bd_pins zynq_clk200_rst/ext_reset_in]

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /clks_rsts] -layout_string {
   "ActiveEmotionalView":"Default View",
   "Default View_ScaleFactor":"0.885484",
   "Default View_TopLeft":"-272,1",
   "ExpandedHierarchyInLayout":"",
   "guistr":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port port-id_clk_100M -pg 1 -lvl 3 -x 630 -y 20 -defaultsOSRD
preplace port port-id_ext_reset_in -pg 1 -lvl 0 -x 0 -y 160 -defaultsOSRD
preplace port port-id_clk_in1 -pg 1 -lvl 0 -x 0 -y 90 -defaultsOSRD
preplace port port-id_slowest_sync_clk -pg 1 -lvl 3 -x 630 -y 400 -defaultsOSRD
preplace port port-id_clk_in2 -pg 1 -lvl 0 -x 0 -y 420 -defaultsOSRD
preplace port port-id_slowest_sync_clk1 -pg 1 -lvl 3 -x 630 -y 420 -defaultsOSRD
preplace portBus peripheral_aresetn -pg 1 -lvl 3 -x 630 -y 160 -defaultsOSRD
preplace portBus peripheral_aresetn1 -pg 1 -lvl 3 -x 630 -y 340 -defaultsOSRD
preplace portBus peripheral_aresetn2 -pg 1 -lvl 3 -x 630 -y 560 -defaultsOSRD
preplace inst zynq_clk100_rst -pg 1 -lvl 2 -x 430 -y 120 -defaultsOSRD
preplace inst clk_wiz_1 -pg 1 -lvl 1 -x 130 -y 90 -defaultsOSRD
preplace inst zynq_clk200_rst -pg 1 -lvl 2 -x 430 -y 300 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 1 -x 130 -y 420 -defaultsOSRD
preplace inst vid_clk_148_5_rst -pg 1 -lvl 2 -x 430 -y 520 -defaultsOSRD
preplace netloc clk_wiz_1_clk_100M 1 1 2 240 20 NJ
preplace netloc zynq_ultra_ps_e_0_pl_resetn0 1 0 2 NJ 160 250
preplace netloc zynq_clk100_rst_peripheral_aresetn 1 2 1 NJ 160
preplace netloc zynq_ultra_ps_e_0_pl_clk2 1 0 1 NJ 90
preplace netloc clk_wiz_1_clk_200M 1 1 2 240 400 NJ
preplace netloc zynq_clk200_rst_peripheral_aresetn 1 2 1 NJ 340
preplace netloc zynq_ultra_ps_e_0_pl_clk1 1 0 1 NJ 420
preplace netloc clk_wiz_0_vidclk_148_5 1 1 2 240 420 NJ
preplace netloc zynq_clk74_25_rst_peripheral_aresetn 1 2 1 NJ 560
levelinfo -pg 1 0 130 430 630
pagesize -pg 1 -db -bbox -sgen -140 0 860 620
"
}

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set cam_clk_0 [ create_bd_port -dir I -type clk -freq_hz 53999000 cam_clk_0 ]
  set cam_clk_1 [ create_bd_port -dir I -type clk -freq_hz 75000000 cam_clk_1 ]
  set cam_data_in_1_0 [ create_bd_port -dir I -from 27 -to 16 -type data cam_data_in_1_0 ]
  set cam_data_in_1_1 [ create_bd_port -dir I -from 11 -to 4 -type data cam_data_in_1_1 ]
  set cmlink_base_0 [ create_bd_port -dir I -from 27 -to 0 cmlink_base_0 ]

  # Create instance: axis_camlink_rx_0, and set properties
  set block_name axis_camlink_rx
  set block_cell_name axis_camlink_rx_0
  if { [catch {set axis_camlink_rx_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_camlink_rx_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axis_camlink_rx_1, and set properties
  set block_name axis_camlink_rx
  set block_cell_name axis_camlink_rx_1
  if { [catch {set axis_camlink_rx_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_camlink_rx_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [list \
    CONFIG.M_HAS_TLAST {1} \
    CONFIG.M_HAS_TREADY {1} \
    CONFIG.M_TDATA_NUM_BYTES {3} \
    CONFIG.M_TUSER_WIDTH {1} \
    CONFIG.S_HAS_TLAST {1} \
    CONFIG.S_HAS_TREADY {1} \
    CONFIG.S_TDATA_NUM_BYTES {3} \
    CONFIG.S_TUSER_WIDTH {1} \
    CONFIG.TDATA_REMAP {tdata[13:6],tdata[13:6],tdata[13:6]} \
  ] $axis_subset_converter_0


  # Create instance: axis_subset_converter_2, and set properties
  set axis_subset_converter_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_2 ]
  set_property -dict [list \
    CONFIG.M_HAS_TLAST {1} \
    CONFIG.M_HAS_TREADY {1} \
    CONFIG.M_TDATA_NUM_BYTES {3} \
    CONFIG.M_TUSER_WIDTH {1} \
    CONFIG.S_HAS_TLAST {1} \
    CONFIG.S_HAS_TREADY {1} \
    CONFIG.S_TDATA_NUM_BYTES {3} \
    CONFIG.S_TUSER_WIDTH {1} \
    CONFIG.TDATA_REMAP {tdata[11:4],tdata[11:4],tdata[11:4]} \
  ] $axis_subset_converter_2


  # Create instance: axis_video_crop_0, and set properties
  set block_name axis_video_crop
  set block_cell_name axis_video_crop_0
  if { [catch {set axis_video_crop_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_video_crop_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.H_OFFSET {320} \
    CONFIG.VIDEO_IN_H {1024} \
    CONFIG.VIDEO_IN_W {1280} \
    CONFIG.VIDEO_OUT_H {480} \
    CONFIG.VIDEO_OUT_W {640} \
    CONFIG.V_OFFSET {272} \
  ] $axis_video_crop_0


  # Create instance: axis_video_crop_1, and set properties
  set block_name axis_video_crop
  set block_cell_name axis_video_crop_1
  if { [catch {set axis_video_crop_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $axis_video_crop_1 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.H_OFFSET {24} \
    CONFIG.VIDEO_IN_H {520} \
    CONFIG.VIDEO_IN_W {688} \
    CONFIG.VIDEO_OUT_H {480} \
    CONFIG.VIDEO_OUT_W {640} \
    CONFIG.V_OFFSET {20} \
  ] $axis_video_crop_1


  # Create instance: clks_rsts
  create_hier_cell_clks_rsts [current_bd_instance .] clks_rsts

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_SI {7} \
  ] $smartconnect_0


  # Create instance: smartconnect_1, and set properties
  set smartconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1 ]
  set_property CONFIG.NUM_SI {1} $smartconnect_1


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {16384} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
  ] $system_ila_0


  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {16384} \
    CONFIG.C_NUM_MONITOR_SLOTS {3} \
    CONFIG.C_SLOT {2} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
  ] $system_ila_1


  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
  set_property -dict [list \
    CONFIG.C_ADDR_WIDTH {11} \
    CONFIG.C_HAS_ASYNC_CLK {0} \
    CONFIG.C_HYSTERESIS_LEVEL {18} \
    CONFIG.C_NATIVE_COMPONENT_WIDTH {12} \
    CONFIG.C_PIXELS_PER_CLOCK {1} \
    CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH {8} \
    CONFIG.C_VTG_MASTER_SLAVE {1} \
  ] $v_axi4s_vid_out_0


  # Create instance: v_tc_0, and set properties
  set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 v_tc_0 ]
  set_property -dict [list \
    CONFIG.HAS_AXI4_LITE {false} \
    CONFIG.VIDEO_MODE {1080p} \
    CONFIG.enable_detection {false} \
    CONFIG.enable_generation {true} \
  ] $v_tc_0


  # Create instance: v_tpg_0, and set properties
  set v_tpg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tpg:8.2 v_tpg_0 ]
  set_property -dict [list \
    CONFIG.MAX_COLS {1920} \
    CONFIG.MAX_ROWS {1080} \
  ] $v_tpg_0


  # Create instance: vmda_block
  create_hier_cell_vmda_block [current_bd_instance .] vmda_block

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {4} \
    CONFIG.IN1_WIDTH {8} \
    CONFIG.IN2_WIDTH {4} \
    CONFIG.IN3_WIDTH {12} \
    CONFIG.NUM_PORTS {4} \
  ] $xlconcat_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {4} \
  ] $xlconstant_0


  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.4 zynq_ultra_ps_e_0 ]
  set_property -dict [list \
    CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
    CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
    CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
    CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {1} \
    CONFIG.PSU_MIO_13_POLARITY {Default} \
    CONFIG.PSU_MIO_22_POLARITY {Default} \
    CONFIG.PSU_MIO_23_POLARITY {Default} \
    CONFIG.PSU_MIO_26_POLARITY {Default} \
    CONFIG.PSU_MIO_38_POLARITY {Default} \
    CONFIG.PSU_MIO_43_POLARITY {Default} \
    CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad\
SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#UART 1#UART 1#GPIO0 MIO#GPIO0 MIO#CAN 1#CAN 1#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#PCIE#PMU GPO 0#PMU GPO 1#PMU GPO 2#PMU GPO 3#PMU\
GPO 4#PMU GPO 5#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem\
3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
    CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#txd#rxd#gpio0[22]#gpio0[23]#phy_tx#phy_rx#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#reset_n#gpo[0]#gpo[1]#gpo[2]#gpo[3]#gpo[4]#gpo[5]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#sdio1_wp#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out}\
\
    CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
    CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
    CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.560059} \
    CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
    CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 24 .. 25} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.880127} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.280029} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.940063} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.997501} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.783037} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.970032} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.940063} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {499.950043} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.280029} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.950043} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.995003} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.950043} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.850098} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.987511} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.950043} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.481262} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.987511} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.481262} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.975021} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.998001} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
    CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
    CONFIG.PSU__DDRC__BG_ADDR_COUNT {2} \
    CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
    CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
    CONFIG.PSU__DDRC__CL {15} \
    CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
    CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
    CONFIG.PSU__DDRC__CWL {14} \
    CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
    CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
    CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
    CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
    CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
    CONFIG.PSU__DDRC__DRAM_WIDTH {8 Bits} \
    CONFIG.PSU__DDRC__ECC {Disabled} \
    CONFIG.PSU__DDRC__FGRM {1X} \
    CONFIG.PSU__DDRC__LP_ASR {manual normal} \
    CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
    CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
    CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
    CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
    CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
    CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
    CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
    CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
    CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
    CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
    CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
    CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
    CONFIG.PSU__DDRC__T_FAW {30.0} \
    CONFIG.PSU__DDRC__T_RAS_MIN {33} \
    CONFIG.PSU__DDRC__T_RC {47.06} \
    CONFIG.PSU__DDRC__T_RCD {15} \
    CONFIG.PSU__DDRC__T_RP {15} \
    CONFIG.PSU__DDRC__VREF {1} \
    CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
    CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
    CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
    CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
    CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {0} \
    CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DLL__ISUSED {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
    CONFIG.PSU__DP__LANE_SEL {Single Lower} \
    CONFIG.PSU__DP__REF_CLK_FREQ {27} \
    CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3} \
    CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
    CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
    CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
    CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
    CONFIG.PSU__ENET3__PTP__ENABLE {0} \
    CONFIG.PSU__ENET3__TSU__ENABLE {0} \
    CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
    CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__FPGA_PL1_ENABLE {1} \
    CONFIG.PSU__GEM3_COHERENCY {0} \
    CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__GEM__TSU__ENABLE {0} \
    CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
    CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
    CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GT__LINK_SPEED {HBR} \
    CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
    CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
    CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
    CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.990005} \
    CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
    CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
    CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
    CONFIG.PSU__PCIE__BAR0_ENABLE {0} \
    CONFIG.PSU__PCIE__BAR0_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR1_ENABLE {0} \
    CONFIG.PSU__PCIE__BAR1_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR2_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR3_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR4_VAL {0x0} \
    CONFIG.PSU__PCIE__BAR5_VAL {0x0} \
    CONFIG.PSU__PCIE__CLASS_CODE_BASE {0x06} \
    CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {0x0} \
    CONFIG.PSU__PCIE__CLASS_CODE_SUB {0x4} \
    CONFIG.PSU__PCIE__CLASS_CODE_VALUE {0x60400} \
    CONFIG.PSU__PCIE__CRS_SW_VISIBILITY {1} \
    CONFIG.PSU__PCIE__DEVICE_ID {0xD021} \
    CONFIG.PSU__PCIE__DEVICE_PORT_TYPE {Root Port} \
    CONFIG.PSU__PCIE__EROM_ENABLE {0} \
    CONFIG.PSU__PCIE__EROM_VAL {0x0} \
    CONFIG.PSU__PCIE__LANE0__ENABLE {1} \
    CONFIG.PSU__PCIE__LANE0__IO {GT Lane0} \
    CONFIG.PSU__PCIE__LANE1__ENABLE {0} \
    CONFIG.PSU__PCIE__LANE2__ENABLE {0} \
    CONFIG.PSU__PCIE__LANE3__ENABLE {0} \
    CONFIG.PSU__PCIE__LINK_SPEED {5.0 Gb/s} \
    CONFIG.PSU__PCIE__MAXIMUM_LINK_WIDTH {x1} \
    CONFIG.PSU__PCIE__MAX_PAYLOAD_SIZE {256 bytes} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {0} \
    CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {1} \
    CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO {MIO 31} \
    CONFIG.PSU__PCIE__REF_CLK_FREQ {100} \
    CONFIG.PSU__PCIE__REF_CLK_SEL {Ref Clk0} \
    CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
    CONFIG.PSU__PCIE__REVISION_ID {0x0} \
    CONFIG.PSU__PCIE__SUBSYSTEM_ID {0x7} \
    CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {0x10EE} \
    CONFIG.PSU__PCIE__VENDOR_ID {0x10EE} \
    CONFIG.PSU__PL_CLK0_BUF {TRUE} \
    CONFIG.PSU__PL_CLK1_BUF {TRUE} \
    CONFIG.PSU__PMU_COHERENCY {0} \
    CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
    CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
    CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
    CONFIG.PSU__PMU__GPI0__ENABLE {0} \
    CONFIG.PSU__PMU__GPI1__ENABLE {0} \
    CONFIG.PSU__PMU__GPI2__ENABLE {0} \
    CONFIG.PSU__PMU__GPI3__ENABLE {0} \
    CONFIG.PSU__PMU__GPI4__ENABLE {0} \
    CONFIG.PSU__PMU__GPI5__ENABLE {0} \
    CONFIG.PSU__PMU__GPO0__ENABLE {1} \
    CONFIG.PSU__PMU__GPO0__IO {MIO 32} \
    CONFIG.PSU__PMU__GPO1__ENABLE {1} \
    CONFIG.PSU__PMU__GPO1__IO {MIO 33} \
    CONFIG.PSU__PMU__GPO2__ENABLE {1} \
    CONFIG.PSU__PMU__GPO2__IO {MIO 34} \
    CONFIG.PSU__PMU__GPO2__POLARITY {high} \
    CONFIG.PSU__PMU__GPO3__ENABLE {1} \
    CONFIG.PSU__PMU__GPO3__IO {MIO 35} \
    CONFIG.PSU__PMU__GPO3__POLARITY {low} \
    CONFIG.PSU__PMU__GPO4__ENABLE {1} \
    CONFIG.PSU__PMU__GPO4__IO {MIO 36} \
    CONFIG.PSU__PMU__GPO4__POLARITY {low} \
    CONFIG.PSU__PMU__GPO5__ENABLE {1} \
    CONFIG.PSU__PMU__GPO5__IO {MIO 37} \
    CONFIG.PSU__PMU__GPO5__POLARITY {low} \
    CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
    CONFIG.PSU__PRESET_APPLIED {1} \
    CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;1|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1}\
\
    CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;1|FPD;PCIE_LOW;E0000000;EFFFFFFF;1|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;1|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;1|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;1|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;1|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display\
Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;1|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1}\
\
    CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.330} \
    CONFIG.PSU__QSPI_COHERENCY {0} \
    CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
    CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
    CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
    CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
    CONFIG.PSU__SATA__LANE0__ENABLE {0} \
    CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
    CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1} \
    CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
    CONFIG.PSU__SD1_COHERENCY {0} \
    CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__SD1__CLK_100_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_200_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_50_DDR_ITAP_DLY {0x3D} \
    CONFIG.PSU__SD1__CLK_50_DDR_OTAP_DLY {0x4} \
    CONFIG.PSU__SD1__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD1__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
    CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
    CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
    CONFIG.PSU__SD1__GRP_WP__ENABLE {1} \
    CONFIG.PSU__SD1__GRP_WP__IO {MIO 44} \
    CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
    CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
    CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
    CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
    CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
    CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
    CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
    CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
    CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
    CONFIG.PSU__UART0__BAUD_RATE {115200} \
    CONFIG.PSU__UART0__MODEM__ENABLE {0} \
    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
    CONFIG.PSU__UART1__BAUD_RATE {115200} \
    CONFIG.PSU__UART1__MODEM__ENABLE {0} \
    CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
    CONFIG.PSU__USB0_COHERENCY {0} \
    CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
    CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
    CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
    CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
    CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
    CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
    CONFIG.PSU__USE__IRQ0 {1} \
    CONFIG.PSU__USE__M_AXI_GP0 {1} \
    CONFIG.PSU__USE__M_AXI_GP1 {0} \
    CONFIG.PSU__USE__M_AXI_GP2 {0} \
    CONFIG.PSU__USE__S_AXI_GP0 {0} \
    CONFIG.PSU__USE__S_AXI_GP2 {1} \
    CONFIG.PSU__USE__S_AXI_GP3 {0} \
    CONFIG.PSU__USE__VIDEO {1} \
  ] $zynq_ultra_ps_e_0


  # Create interface connections
  connect_bd_intf_net -intf_net axi_ctrl_M05_AXI [get_bd_intf_pins v_tpg_0/s_axi_CTRL] [get_bd_intf_pins vmda_block/M05_AXI]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins vmda_block/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_S2MM [get_bd_intf_pins smartconnect_0/S01_AXI] [get_bd_intf_pins vmda_block/M_AXI_S2MM1]
  connect_bd_intf_net -intf_net axi_vdma_2_M_AXI_S2MM [get_bd_intf_pins smartconnect_0/S02_AXI] [get_bd_intf_pins vmda_block/M_AXI_S2MM2]
  connect_bd_intf_net -intf_net axi_vdma_3_M_AXI_S2MM [get_bd_intf_pins smartconnect_0/S03_AXI] [get_bd_intf_pins vmda_block/M_AXI_S2MM3]
connect_bd_intf_net -intf_net axi_vdma_4_M_AXIS_MM2S [get_bd_intf_pins system_ila_1/SLOT_0_AXIS] [get_bd_intf_pins vmda_block/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_4_M_AXI_MM2S [get_bd_intf_pins smartconnect_0/S05_AXI] [get_bd_intf_pins vmda_block/M_AXI_MM2S]
connect_bd_intf_net -intf_net axi_vdma_5_M_AXIS_MM2S [get_bd_intf_pins system_ila_1/SLOT_1_AXIS] [get_bd_intf_pins vmda_block/M_AXIS_MM2S1]
  connect_bd_intf_net -intf_net axi_vdma_5_M_AXI_MM2S [get_bd_intf_pins smartconnect_0/S06_AXI] [get_bd_intf_pins vmda_block/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net axi_vdma_read_M_AXIS_MM2S [get_bd_intf_pins v_axi4s_vid_out_0/video_in] [get_bd_intf_pins vmda_block/M_AXIS_MM2S2]
  connect_bd_intf_net -intf_net axi_vdma_read_M_AXI_MM2S [get_bd_intf_pins smartconnect_0/S04_AXI] [get_bd_intf_pins vmda_block/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net axis_camlink_rx_1_m_axis [get_bd_intf_pins axis_camlink_rx_1/M_AXIS] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins axis_video_crop_1/s_axis]
  connect_bd_intf_net -intf_net axis_video_crop_0_m_axis [get_bd_intf_pins axis_video_crop_0/m_axis] [get_bd_intf_pins vmda_block/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axis_video_crop_1_m_axis [get_bd_intf_pins axis_video_crop_1/m_axis] [get_bd_intf_pins vmda_block/S_AXIS_S2MM2]
connect_bd_intf_net -intf_net axis_video_overlay_0_m_axis [get_bd_intf_pins system_ila_1/SLOT_2_AXIS] [get_bd_intf_pins vmda_block/S_AXIS_S2MM1]
  connect_bd_intf_net -intf_net cam_in_axi4s_0_m_axis [get_bd_intf_pins axis_camlink_rx_0/M_AXIS] [get_bd_intf_pins axis_subset_converter_2/S_AXIS]
connect_bd_intf_net -intf_net [get_bd_intf_nets cam_in_axi4s_0_m_axis] [get_bd_intf_pins axis_camlink_rx_0/M_AXIS] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net smartconnect_1_M00_AXI [get_bd_intf_pins smartconnect_1/M00_AXI] [get_bd_intf_pins vmda_block/S00_AXI]
  connect_bd_intf_net -intf_net v_proc_ss_0_m_axis [get_bd_intf_pins axis_subset_converter_2/M_AXIS] [get_bd_intf_pins axis_video_crop_0/s_axis]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]
  connect_bd_intf_net -intf_net v_tpg_0_m_axis_video [get_bd_intf_pins v_tpg_0/m_axis_video] [get_bd_intf_pins vmda_block/S_AXIS_S2MM3]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins smartconnect_1/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]

  # Create port connections
  connect_bd_net -net cam_clk_0_1 [get_bd_ports cam_clk_0] [get_bd_pins axis_camlink_rx_0/cam_clk]
  connect_bd_net -net cam_clk_1_1 [get_bd_ports cam_clk_1] [get_bd_pins axis_camlink_rx_1/cam_clk]
  connect_bd_net -net cam_data_in_1_0_1 [get_bd_ports cam_data_in_1_0] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net cam_data_in_1_1_1 [get_bd_ports cam_data_in_1_1] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net clk_wiz_0_vidclk_148_5 [get_bd_pins clks_rsts/slowest_sync_clk1] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins v_tc_0/clk] [get_bd_pins vmda_block/m_axis_mm2s_aclk] [get_bd_pins zynq_ultra_ps_e_0/dp_video_in_clk]
  connect_bd_net -net clk_wiz_1_clk_100M [get_bd_pins axis_camlink_rx_0/axis_clk] [get_bd_pins axis_camlink_rx_1/axis_clk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_2/aclk] [get_bd_pins axis_video_crop_0/axis_clk] [get_bd_pins axis_video_crop_1/axis_clk] [get_bd_pins clks_rsts/clk_100M] [get_bd_pins smartconnect_1/aclk] [get_bd_pins system_ila_0/clk] [get_bd_pins system_ila_1/clk] [get_bd_pins v_tpg_0/ap_clk] [get_bd_pins vmda_block/s_axi_lite_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
  connect_bd_net -net clk_wiz_1_clk_200M [get_bd_pins clks_rsts/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins vmda_block/m_axi_s2mm_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  connect_bd_net -net cmlink_base_0_1 [get_bd_ports cmlink_base_0] [get_bd_pins axis_camlink_rx_0/cam_data_in]
  connect_bd_net -net v_axi4s_vid_out_0_vid_active_video [get_bd_pins v_axi4s_vid_out_0/vid_active_video] [get_bd_pins zynq_ultra_ps_e_0/dp_live_video_in_de]
  connect_bd_net -net v_axi4s_vid_out_0_vid_data [get_bd_pins v_axi4s_vid_out_0/vid_data] [get_bd_pins zynq_ultra_ps_e_0/dp_live_video_in_pixel1]
  connect_bd_net -net v_axi4s_vid_out_0_vid_hsync [get_bd_pins v_axi4s_vid_out_0/vid_hsync] [get_bd_pins zynq_ultra_ps_e_0/dp_live_video_in_hsync]
  connect_bd_net -net v_axi4s_vid_out_0_vid_vsync [get_bd_pins v_axi4s_vid_out_0/vid_vsync] [get_bd_pins zynq_ultra_ps_e_0/dp_live_video_in_vsync]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins v_tc_0/gen_clken]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axis_camlink_rx_1/cam_data_in] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In2] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net zynq_clk100_rst_peripheral_aresetn [get_bd_pins axis_camlink_rx_0/aresetn] [get_bd_pins axis_camlink_rx_1/aresetn] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_subset_converter_2/aresetn] [get_bd_pins axis_video_crop_0/aresetn] [get_bd_pins axis_video_crop_1/aresetn] [get_bd_pins clks_rsts/peripheral_aresetn] [get_bd_pins smartconnect_1/aresetn] [get_bd_pins system_ila_0/resetn] [get_bd_pins system_ila_1/resetn] [get_bd_pins v_tpg_0/ap_rst_n] [get_bd_pins vmda_block/axi_resetn]
  connect_bd_net -net zynq_clk200_rst_peripheral_aresetn [get_bd_pins clks_rsts/peripheral_aresetn1] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net zynq_clk74_25_rst_peripheral_aresetn [get_bd_pins clks_rsts/peripheral_aresetn2] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins v_tc_0/resetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1 [get_bd_pins clks_rsts/clk_in2] [get_bd_pins zynq_ultra_ps_e_0/pl_clk1]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk2 [get_bd_pins clks_rsts/clk_in1] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins clks_rsts/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vmda_block/axi_vdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vmda_block/axi_vdma_1/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vmda_block/axi_vdma_2/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vmda_block/axi_vdma_3/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vmda_block/axi_vdma_4/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vmda_block/axi_vdma_5/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs vmda_block/axi_vdma_read/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs v_tpg_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_1/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_2/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_3/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_4/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_5/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force
  assign_bd_address -offset 0x000800000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_read/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_read/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_read/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_read/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] -force
  assign_bd_address -offset 0xC0000000 -range 0x20000000 -target_address_space [get_bd_addr_spaces vmda_block/axi_vdma_read/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] -force

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   "ActiveEmotionalView":"def",
   "Default View_ScaleFactor":"1.31369",
   "Default View_TopLeft":"-2600,166",
   "ExpandedHierarchyInLayout":"",
   "comment_0":"Incomplete FMC pin set,
bits [15:12] and [3:0] discarded",
   "comment_2":"Lower bits discarded 
for 8 BPC pixel format",
   "commentid":"comment_0|comment_2|",
   "def_DefaultLayers":"",
   "def_DefaultScaleFactor":"1.31369",
   "def_DefaultTopLeft":"-2600,166",
   "def_ExpandedHierarchyInLayout":"",
   "def_Layers":"",
   "def_Layout":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port port-id_cam_clk_0 -pg 1 -lvl 0 -x -220 -y 390 -defaultsOSRD
preplace port port-id_cam_clk_1 -pg 1 -lvl 0 -x -220 -y 550 -defaultsOSRD
preplace portBus cmlink_base_0 -pg 1 -lvl 0 -x -220 -y 410 -defaultsOSRD
preplace portBus cam_data_in_1_1 -pg 1 -lvl 0 -x -220 -y 730 -defaultsOSRD
preplace portBus cam_data_in_1_0 -pg 1 -lvl 0 -x -220 -y 770 -defaultsOSRD
preplace inst zynq_ultra_ps_e_0 -pg 1 -lvl 7 -x 2757 -y 480 -defaultsOSRD
preplace inst smartconnect_0 -pg 1 -lvl 6 -x 2160 -y 390 -defaultsOSRD
preplace inst axis_subset_converter_2 -pg 1 -lvl 2 -x 400 -y 630 -defaultsOSRD
preplace inst v_axi4s_vid_out_0 -pg 1 -lvl 5 -x 1693 -y 470 -defaultsOSRD
preplace inst v_tc_0 -pg 1 -lvl 5 -x 1693 -y 720 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 1 -x 10 -y 740 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 1 -x 10 -y 870 -defaultsOSRD
preplace inst axis_subset_converter_0 -pg 1 -lvl 2 -x 400 -y 480 -defaultsOSRD
preplace inst axis_video_crop_1 -pg 1 -lvl 3 -x 730 -y 460 -defaultsOSRD
preplace inst system_ila_0 -pg 1 -lvl 6 -x 2160 -y 760 -defaultsOSRD
preplace inst system_ila_1 -pg 1 -lvl 6 -x 2160 -y 960 -defaultsOSRD
preplace inst smartconnect_1 -pg 1 -lvl 8 -x 3310 -y 620 -defaultsOSRD
preplace inst v_tpg_0 -pg 1 -lvl 1 -x 10 -y 1000 -defaultsOSRD
preplace inst axis_video_crop_0 -pg 1 -lvl 3 -x 730 -y 620 -defaultsOSRD
preplace inst clks_rsts -pg 1 -lvl 8 -x 3310 -y 460 -defaultsOSRD
preplace inst vmda_block -pg 1 -lvl 4 -x 1230 -y 600 -defaultsOSRD
preplace inst axis_camlink_rx_0 -pg 1 -lvl 1 -x 10 -y 420 -defaultsOSRD
preplace inst axis_camlink_rx_1 -pg 1 -lvl 1 -x 10 -y 580 -defaultsOSRD
preplace netloc cam_clk_0_1 1 0 1 NJ 390
preplace netloc cam_clk_1_1 1 0 1 NJ 550
preplace netloc cam_data_in_1_0_1 1 0 1 NJ 770
preplace netloc cam_data_in_1_1_1 1 0 1 NJ 730
preplace netloc clk_wiz_0_vidclk_148_5 1 3 6 900 760 1460 150 N 150 2330J 280 N 280 3490
preplace netloc clk_wiz_1_clk_100M 1 0 9 -200 300 240 390 580 710 870 810 1470 830 1970 670 2350 670 3120J 710 3510
preplace netloc clk_wiz_1_clk_200M 1 3 6 900 180 N 180 1990 220 2360J 290 N 290 3470
preplace netloc cmlink_base_0_1 1 0 1 NJ 410
preplace netloc v_axi4s_vid_out_0_vid_active_video 1 5 2 1880 530 2340
preplace netloc v_axi4s_vid_out_0_vid_data 1 5 2 1870 540 2360
preplace netloc v_axi4s_vid_out_0_vid_hsync 1 5 2 1930 250 2310
preplace netloc v_axi4s_vid_out_0_vid_vsync 1 5 2 1920 240 2320
preplace netloc v_axi4s_vid_out_0_vtg_ce 1 4 2 1530 190 1860J
preplace netloc xlconcat_0_dout 1 0 2 -180 290 190
preplace netloc xlconstant_0_dout 1 0 2 -170 320 180
preplace netloc zynq_clk100_rst_peripheral_aresetn 1 0 9 -190 310 210 400 570 720 880 840 N 840 1990 680 NJ 680 3140J 700 3480
preplace netloc zynq_clk200_rst_peripheral_aresetn 1 5 4 2010 230 N 230 N 230 3500
preplace netloc zynq_clk74_25_rst_peripheral_aresetn 1 4 5 1520 170 N 170 N 170 N 170 3520
preplace netloc zynq_ultra_ps_e_0_pl_clk1 1 7 1 3140 480n
preplace netloc zynq_ultra_ps_e_0_pl_clk2 1 7 1 3120 460n
preplace netloc zynq_ultra_ps_e_0_pl_resetn0 1 7 1 3110 440n
preplace netloc axi_ctrl_M05_AXI 1 0 5 -160 330 N 330 N 330 N 330 1390
preplace netloc axi_vdma_0_M_AXI_S2MM 1 4 2 1480 280 1960
preplace netloc axi_vdma_1_M_AXI_S2MM 1 4 2 1490 290 1950
preplace netloc axi_vdma_2_M_AXI_S2MM 1 4 2 1430 230 2000
preplace netloc axi_vdma_3_M_AXI_S2MM 1 4 2 1450 240 1880
preplace netloc axi_vdma_4_M_AXIS_MM2S 1 4 2 1420 250 1900
preplace netloc axi_vdma_4_M_AXI_MM2S 1 4 2 1500 300 1910
preplace netloc axi_vdma_5_M_AXIS_MM2S 1 4 2 1440 260 1890
preplace netloc axi_vdma_5_M_AXI_MM2S 1 4 2 1410 200 1980
preplace netloc axi_vdma_read_M_AXIS_MM2S 1 4 1 1510 410n
preplace netloc axi_vdma_read_M_AXI_MM2S 1 4 2 1470 220 1970
preplace netloc axis_camlink_rx_1_m_axis 1 1 1 230 460n
preplace netloc axis_subset_converter_0_M_AXIS 1 2 1 560 440n
preplace netloc axis_video_crop_0_m_axis 1 3 1 N 590
preplace netloc axis_video_crop_1_m_axis 1 3 1 870 430n
preplace netloc axis_video_overlay_0_m_axis 1 4 2 1400 210 1940
preplace netloc cam_in_axi4s_0_m_axis 1 1 5 200 820 N 820 N 820 N 820 2010
preplace netloc smartconnect_0_M00_AXI 1 6 1 2300 350n
preplace netloc smartconnect_1_M00_AXI 1 3 6 890 160 N 160 NJ 160 NJ 160 NJ 160 3530
preplace netloc v_proc_ss_0_m_axis 1 2 1 590 600n
preplace netloc v_tc_0_vtiming_out 1 4 2 1540 270 1850
preplace netloc v_tpg_0_m_axis_video 1 1 3 220 370 N 370 880
preplace netloc zynq_ultra_ps_e_0_M_AXI_HPM0_FPD 1 7 1 3130 400n
preplace cgraphic comment_2 place left 756 316 textcolor 4 linecolor 3 linewidth 2
preplace cgraphic comment_0 place left -74 636 textcolor 4 linecolor 3 linewidth 2
levelinfo -pg 1 -220 10 400 730 1230 1693 2160 2757 3310 3550
pagesize -pg 1 -db -bbox -sgen -450 0 3550 2170
",
   "def_Layout_Default":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port port-id_cam_clk_0 -pg 1 -lvl 0 -x -3310 -y -180 -defaultsOSRD
preplace port port-id_cam_clk_1 -pg 1 -lvl 0 -x -3310 -y 380 -defaultsOSRD
preplace portBus cmlink_base_0 -pg 1 -lvl 0 -x -3310 -y -40 -defaultsOSRD
preplace portBus cam_data_in_1_1 -pg 1 -lvl 0 -x -3310 -y 240 -defaultsOSRD
preplace portBus cam_data_in_1_0 -pg 1 -lvl 0 -x -3310 -y 280 -defaultsOSRD
preplace inst zynq_ultra_ps_e_0 -pg 1 -lvl 6 -x -750 -y -430 -defaultsOSRD
preplace inst axi_vdma_0 -pg 1 -lvl 3 -x -2290 -y 0 -defaultsOSRD
preplace inst smartconnect_0 -pg 1 -lvl 5 -x -1380 -y -560 -defaultsOSRD
preplace inst zynq_clk100_rst -pg 1 -lvl 7 -x -140 -y -100 -defaultsOSRD
preplace inst smartconnect_1 -pg 1 -lvl 7 -x -140 -y -540 -defaultsOSRD
preplace inst axis_subset_converter_2 -pg 1 -lvl 2 -x -2730 -y -210 -defaultsOSRD
preplace inst v_axi4s_vid_out_0 -pg 1 -lvl 5 -x -1380 -y -190 -defaultsOSRD
preplace inst v_tc_0 -pg 1 -lvl 5 -x -1380 -y 120 -defaultsOSRD
preplace inst zynq_clk_148_5_rst -pg 1 -lvl 7 -x -140 -y 180 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 1 -x -3110 -y 250 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 1 -x -3110 -y 120 -defaultsOSRD
preplace inst axis_subset_converter_0 -pg 1 -lvl 2 -x -2730 -y 810 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 7 -x -140 -y -380 -defaultsOSRD
preplace inst axi_vdma_read -pg 1 -lvl 4 -x -1820 -y 130 -defaultsOSRD
preplace inst axi_vdma_1 -pg 1 -lvl 3 -x -2290 -y 210 -defaultsOSRD
preplace inst v_tpg_0 -pg 1 -lvl 2 -x -2730 -y 270 -defaultsOSRD
preplace inst axis_video_crop_0 -pg 1 -lvl 2 -x -2730 -y 110 -defaultsOSRD
preplace inst axis_video_crop_1 -pg 1 -lvl 2 -x -2730 -y 660 -defaultsOSRD
preplace inst system_ila_0 -pg 1 -lvl 3 -x -2290 -y -200 -defaultsOSRD
preplace inst system_ila_1 -pg 1 -lvl 3 -x -2290 -y 880 -defaultsOSRD
preplace inst cam_in_axi4s_0 -pg 1 -lvl 1 -x -3110 -y -30 -defaultsOSRD
preplace inst cam_in_axi4s_1 -pg 1 -lvl 1 -x -3110 -y 410 -defaultsOSRD
preplace inst axi_vdma_2 -pg 1 -lvl 3 -x -2290 -y 430 -defaultsOSRD
preplace inst axi_vdma_3 -pg 1 -lvl 3 -x -2290 -y 650 -defaultsOSRD
preplace inst v_tpg_1 -pg 1 -lvl 2 -x -2730 -y 450 -defaultsOSRD
preplace inst clk_wiz_1 -pg 1 -lvl 7 -x -140 -y -270 -defaultsOSRD
preplace netloc axi_vdma_0_s2mm_frame_ptr_out 1 3 1 -2110 0n
preplace netloc cam_clk_0_1 1 0 1 -3290 -180n
preplace netloc cam_clk_1_1 1 0 1 N 380
preplace netloc cam_data_in_1_0_1 1 0 1 N 280
preplace netloc cam_data_in_1_1_1 1 0 1 N 240
preplace netloc clk_wiz_0_clk_out1 1 0 8 -3270 -120 -2930 -130 -2540 -280 -2060 -430 -1610 -430 -1170 -240 -380 -210 50
preplace netloc clk_wiz_0_clk_out2 1 3 5 -2040 20 -1600 -420 -1210 -200 -390 -200 40
preplace netloc cmlink_base_0_1 1 0 1 N -40
preplace netloc v_axi4s_vid_out_0_vid_active_video 1 5 1 -1200 -460n
preplace netloc v_axi4s_vid_out_0_vid_data 1 5 1 -1160 -440n
preplace netloc v_axi4s_vid_out_0_vid_hsync 1 5 1 -1180 -480n
preplace netloc v_axi4s_vid_out_0_vid_vsync 1 5 1 -1190 -500n
preplace netloc v_axi4s_vid_out_0_vtg_ce 1 4 2 -1580 0 -1220
preplace netloc xlconcat_0_dout 1 0 2 -3260 500 -2960
preplace netloc xlconstant_0_dout 1 0 2 -3260 60 -2960
preplace netloc zynq_clk100_rst_interconnect_aresetn 1 4 4 -1580 -20 N -20 -370 0 50
preplace netloc zynq_clk100_rst_peripheral_aresetn 1 0 8 -3280 -130 -2940 -110 -2530 -110 -2090 -110 -1590 10 NJ 10 NJ 10 40
preplace netloc zynq_clk74_25_rst_peripheral_aresetn 1 4 4 -1570 20 NJ 20 NJ 20 40
preplace netloc zynq_ultra_ps_e_0_pl_clk0 1 6 1 -390 -380n
preplace netloc zynq_ultra_ps_e_0_pl_resetn0 1 6 1 -400 -390n
preplace netloc zynq_ultra_ps_e_0_pl_clk1 1 6 1 -390 -350n
preplace netloc axi_vdma_0_M_AXI_S2MM 1 3 2 -2110 -610 N
preplace netloc axi_vdma_1_M_AXI_S2MM 1 3 2 -2100 -590 N
preplace netloc axi_vdma_2_M_AXI_S2MM 1 3 2 -2080 -570 N
preplace netloc axi_vdma_read_M_AXIS_MM2S 1 4 1 -1610 -250n
preplace netloc axi_vdma_read_M_AXI_MM2S 1 4 1 -1620 -630n
preplace netloc axis_subset_converter_0_M_AXIS 1 1 2 -2900 890 -2560
preplace netloc axis_video_crop_0_m_axis 1 2 1 -2560 -30n
preplace netloc axis_video_crop_1_m_axis 1 2 1 -2510 180n
preplace netloc cam_in_axi4s_0_m_axis 1 1 2 -2960 -290 -2530
preplace netloc cam_in_axi4s_1_m_axis 1 1 2 -2950 900 -2550
preplace netloc smartconnect_0_M00_AXI 1 5 1 N -560
preplace netloc smartconnect_1_M00_AXI 1 2 6 -2520 -750 N -750 N -750 N -750 N -750 100
preplace netloc smartconnect_1_M01_AXI 1 3 5 -2050 -740 N -740 N -740 N -740 90
preplace netloc smartconnect_1_M02_AXI 1 2 6 -2510 -730 N -730 N -730 N -730 N -730 80
preplace netloc smartconnect_1_M03_AXI 1 1 7 -2920 -720 N -720 N -720 N -720 N -720 N -720 70
preplace netloc smartconnect_1_M04_AXI 1 2 6 -2500 -710 N -710 N -710 N -710 N -710 60
preplace netloc v_proc_ss_0_m_axis 1 1 2 -2900 -120 -2560
preplace netloc v_tc_0_vtiming_out 1 4 2 -1570 -10 -1230
preplace netloc v_tpg_0_m_axis_video 1 2 1 -2520 250n
preplace netloc zynq_ultra_ps_e_0_M_AXI_HPM0_FPD 1 6 1 -400 -560n
preplace netloc v_tpg_1_m_axis_video 1 2 1 -2560 430n
preplace netloc smartconnect_1_M05_AXI 1 1 7 -2910 -700 N -700 N -700 N -700 N -700 N -700 50
preplace netloc smartconnect_1_M06_AXI 1 2 6 -2490 -690 N -690 N -690 N -690 N -690 40
preplace netloc axi_vdma_3_M_AXI_S2MM 1 3 2 -2070 -550 N
levelinfo -pg 1 -3310 -3110 -2730 -2290 -1820 -1380 -750 -140 120
pagesize -pg 1 -db -bbox -sgen -3540 -1210 120 1240
",
   "def_ScaleFactor":"0.726412",
   "def_TopLeft":"-230,150",
   "font_comment_0":"14",
   "font_comment_2":"15",
   "guistr":"# # String gsaved with Nlview 7.0r4  2019-12-20 bk=1.5203 VDI=41 GEI=36 GUI=JA:10.0 TLS
#  -string -flagsOSRD
preplace port port-id_cam_clk_0 -pg 1 -lvl 0 -x -3310 -y -180 -defaultsOSRD
preplace port port-id_cam_clk_1 -pg 1 -lvl 0 -x -3310 -y 380 -defaultsOSRD
preplace portBus cmlink_base_0 -pg 1 -lvl 0 -x -3310 -y -40 -defaultsOSRD
preplace portBus cam_data_in_1_1 -pg 1 -lvl 0 -x -3310 -y 240 -defaultsOSRD
preplace portBus cam_data_in_1_0 -pg 1 -lvl 0 -x -3310 -y 280 -defaultsOSRD
preplace inst zynq_ultra_ps_e_0 -pg 1 -lvl 6 -x -750 -y -430 -defaultsOSRD
preplace inst axi_vdma_0 -pg 1 -lvl 3 -x -2290 -y 0 -defaultsOSRD
preplace inst smartconnect_0 -pg 1 -lvl 5 -x -1380 -y -560 -defaultsOSRD
preplace inst zynq_clk100_rst -pg 1 -lvl 7 -x -140 -y -100 -defaultsOSRD
preplace inst smartconnect_1 -pg 1 -lvl 7 -x -140 -y -540 -defaultsOSRD
preplace inst axis_subset_converter_2 -pg 1 -lvl 2 -x -2730 -y -210 -defaultsOSRD
preplace inst v_axi4s_vid_out_0 -pg 1 -lvl 5 -x -1380 -y -190 -defaultsOSRD
preplace inst v_tc_0 -pg 1 -lvl 5 -x -1380 -y 120 -defaultsOSRD
preplace inst zynq_clk_148_5_rst -pg 1 -lvl 7 -x -140 -y 180 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 1 -x -3110 -y 250 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 1 -x -3110 -y 120 -defaultsOSRD
preplace inst axis_subset_converter_0 -pg 1 -lvl 2 -x -2730 -y 810 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 7 -x -140 -y -380 -defaultsOSRD
preplace inst axi_vdma_read -pg 1 -lvl 4 -x -1820 -y 130 -defaultsOSRD
preplace inst axi_vdma_1 -pg 1 -lvl 3 -x -2290 -y 210 -defaultsOSRD
preplace inst v_tpg_0 -pg 1 -lvl 2 -x -2730 -y 270 -defaultsOSRD
preplace inst axis_video_crop_0 -pg 1 -lvl 2 -x -2730 -y 110 -defaultsOSRD
preplace inst axis_video_crop_1 -pg 1 -lvl 2 -x -2730 -y 660 -defaultsOSRD
preplace inst system_ila_0 -pg 1 -lvl 3 -x -2290 -y -200 -defaultsOSRD
preplace inst system_ila_1 -pg 1 -lvl 3 -x -2290 -y 880 -defaultsOSRD
preplace inst cam_in_axi4s_0 -pg 1 -lvl 1 -x -3110 -y -30 -defaultsOSRD
preplace inst cam_in_axi4s_1 -pg 1 -lvl 1 -x -3110 -y 410 -defaultsOSRD
preplace inst axi_vdma_2 -pg 1 -lvl 3 -x -2290 -y 430 -defaultsOSRD
preplace inst axi_vdma_3 -pg 1 -lvl 3 -x -2290 -y 650 -defaultsOSRD
preplace inst v_tpg_1 -pg 1 -lvl 2 -x -2730 -y 450 -defaultsOSRD
preplace inst clk_wiz_1 -pg 1 -lvl 7 -x -140 -y -270 -defaultsOSRD
preplace netloc axi_vdma_0_s2mm_frame_ptr_out 1 3 1 -2110 0n
preplace netloc cam_clk_0_1 1 0 1 -3290 -180n
preplace netloc cam_clk_1_1 1 0 1 N 380
preplace netloc cam_data_in_1_0_1 1 0 1 N 280
preplace netloc cam_data_in_1_1_1 1 0 1 N 240
preplace netloc clk_wiz_0_clk_out1 1 0 8 -3270 -120 -2930 -130 -2540 -280 -2060 -430 -1610 -430 -1170 -240 -380 -210 50
preplace netloc clk_wiz_0_clk_out2 1 3 5 -2040 20 -1600 -420 -1210 -200 -390 -200 40
preplace netloc cmlink_base_0_1 1 0 1 N -40
preplace netloc v_axi4s_vid_out_0_vid_active_video 1 5 1 -1200 -460n
preplace netloc v_axi4s_vid_out_0_vid_data 1 5 1 -1160 -440n
preplace netloc v_axi4s_vid_out_0_vid_hsync 1 5 1 -1180 -480n
preplace netloc v_axi4s_vid_out_0_vid_vsync 1 5 1 -1190 -500n
preplace netloc v_axi4s_vid_out_0_vtg_ce 1 4 2 -1580 0 -1220
preplace netloc xlconcat_0_dout 1 0 2 -3260 500 -2960
preplace netloc xlconstant_0_dout 1 0 2 -3260 60 -2960
preplace netloc zynq_clk100_rst_interconnect_aresetn 1 4 4 -1580 -20 N -20 -370 0 50
preplace netloc zynq_clk100_rst_peripheral_aresetn 1 0 8 -3280 -130 -2940 -110 -2530 -110 -2090 -110 -1590 10 NJ 10 NJ 10 40
preplace netloc zynq_clk74_25_rst_peripheral_aresetn 1 4 4 -1570 20 NJ 20 NJ 20 40
preplace netloc zynq_ultra_ps_e_0_pl_clk0 1 6 1 -390 -380n
preplace netloc zynq_ultra_ps_e_0_pl_resetn0 1 6 1 -400 -390n
preplace netloc zynq_ultra_ps_e_0_pl_clk1 1 6 1 -390 -350n
preplace netloc axi_vdma_0_M_AXI_S2MM 1 3 2 -2110 -610 N
preplace netloc axi_vdma_1_M_AXI_S2MM 1 3 2 -2100 -590 N
preplace netloc axi_vdma_2_M_AXI_S2MM 1 3 2 -2080 -570 N
preplace netloc axi_vdma_read_M_AXIS_MM2S 1 4 1 -1610 -250n
preplace netloc axi_vdma_read_M_AXI_MM2S 1 4 1 -1620 -630n
preplace netloc axis_subset_converter_0_M_AXIS 1 1 2 -2900 890 -2560
preplace netloc axis_video_crop_0_m_axis 1 2 1 -2560 -30n
preplace netloc axis_video_crop_1_m_axis 1 2 1 -2510 180n
preplace netloc cam_in_axi4s_0_m_axis 1 1 2 -2960 -290 -2530
preplace netloc cam_in_axi4s_1_m_axis 1 1 2 -2950 900 -2550
preplace netloc smartconnect_0_M00_AXI 1 5 1 N -560
preplace netloc smartconnect_1_M00_AXI 1 2 6 -2520 -750 N -750 N -750 N -750 N -750 100
preplace netloc smartconnect_1_M01_AXI 1 3 5 -2050 -740 N -740 N -740 N -740 90
preplace netloc smartconnect_1_M02_AXI 1 2 6 -2510 -730 N -730 N -730 N -730 N -730 80
preplace netloc smartconnect_1_M03_AXI 1 1 7 -2920 -720 N -720 N -720 N -720 N -720 N -720 70
preplace netloc smartconnect_1_M04_AXI 1 2 6 -2500 -710 N -710 N -710 N -710 N -710 60
preplace netloc v_proc_ss_0_m_axis 1 1 2 -2900 -120 -2560
preplace netloc v_tc_0_vtiming_out 1 4 2 -1570 -10 -1230
preplace netloc v_tpg_0_m_axis_video 1 2 1 -2520 250n
preplace netloc zynq_ultra_ps_e_0_M_AXI_HPM0_FPD 1 6 1 -400 -560n
preplace netloc v_tpg_1_m_axis_video 1 2 1 -2560 430n
preplace netloc smartconnect_1_M05_AXI 1 1 7 -2910 -700 N -700 N -700 N -700 N -700 N -700 50
preplace netloc smartconnect_1_M06_AXI 1 2 6 -2490 -690 N -690 N -690 N -690 N -690 40
preplace netloc axi_vdma_3_M_AXI_S2MM 1 3 2 -2070 -550 N
levelinfo -pg 1 -3310 -3110 -2730 -2290 -1820 -1380 -750 -140 120
pagesize -pg 1 -db -bbox -sgen -3540 -1210 120 1240
"
}

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


