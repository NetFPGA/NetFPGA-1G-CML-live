###############################################################################
## DISCLAIMER OF LIABILITY
##
## This file contains proprietary and confidential information of
## Xilinx, Inc. ("Xilinx"), that is distributed under a license
## from Xilinx, and may be used, copied and/or disclosed only
## pursuant to the terms of a valid license agreement with Xilinx.
##
## XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
## ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
## EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
## LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
## MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
## does not warrant that functions included in the Materials will
## meet the requirements of Licensee, or that the operation of the
## Materials will be uninterrupted or error-free, or that defects
## in the Materials will be corrected. Furthermore, Xilinx does
## not warrant or make any representations regarding use, or the
## results of the use, of the Materials in terms of correctness,
## accuracy, reliability or otherwise.
##
## Xilinx products are not designed or intended to be fail-safe,
## or for use in any application requiring fail-safe performance,
## such as life-support or safety devices or systems, Class III
## medical devices, nuclear facilities, applications related to
## the deployment of airbags, or any other applications that could
## lead to death, personal injury or severe property or
## environmental damage (individually and collectively, "critical
## applications"). Customer assumes the sole risk and liability
## of any use of Xilinx products in critical applications,
## subject only to applicable laws and regulations governing
## limitations on product liability.
##
## Copyright 1995 - 2011 Xilinx, Inc.
## All rights reserved.
##
## This disclaimer and copyright notice must be retained as part
## of this file at all times.
##
###############################################################################
##
###############################################################################
##  									
##   axi_emc_v2_1_0.tcl						
##									
###############################################################################
#
#***--------------------------------***------------------------------------***
#
#                            IPLEVEL_DRC_PROC
#
#***--------------------------------***------------------------------------***
proc syslevel_update_clock {param_handle} {
    set mhsinst [xget_hw_parent_handle $param_handle]
    set instname [xget_hw_port_value $mhsinst "S_AXI_ACLK"]
    set axi_clk_port [xget_hw_port_handle $mhsinst "S_AXI_ACLK"]
    set axi_clk_freq [xget_hw_subproperty_value $axi_clk_port "CLK_FREQ_HZ"]
    set axi_clk_period [expr {int(((1.0/$axi_clk_freq) * 1e12))}]
    return $axi_clk_period
}

#
# check C_MAX_MEM_WIDTH
# C_MAX_MEM_WIDTH = max(C_MEMx_WIDTH)
#
proc check_iplevel_settings {mhsinst} {

    xload_hw_library emc_common_v5_00_a

    hw_emc_common_v5_00_a::check_max_mem_width $mhsinst
    check_native_dwidth_and_64bit_membanks  $mhsinst
    check_regen_psram_parity  $mhsinst
    check_dwidth_matching_and_num_banks $mhsinst
	
}
     puts "Instance name for AXI EMC core "

#
# check C_NUM_CHANNELS and C_MCH_NATIVE_DWIDTH =64 only 
# if C_S_AXI_MEM_DATA_WIDTH = 64
#
# @param   mhsinst    the mhs instance handle
#
proc check_native_dwidth_and_64bit_membanks { mhsinst  } {

    set num_banks [xget_hw_parameter_value $mhsinst "C_NUM_BANKS_MEM"]
    set native_dwidth [xget_hw_parameter_value $mhsinst "C_S_AXI_MEM_DATA_WIDTH"]
    set max_width [xget_hw_parameter_value $mhsinst "C_MAX_MEM_WIDTH"]

     if {$native_dwidth == 64} {
    	
    	if {$max_width != $native_dwidth} {

		set instname [xget_hw_parameter_value $mhsinst "INSTANCE"]
        	error "Invalid $instname parameter:\C_MAX_MEM_WIDTH Should be 64 only when C_S_AXI_MEM_DATA_WIDTH is 64" "" "mdt_error"
 	}
    }

}

#
# check C_INCLUDE_DATAWIDTH_MATCHING_x, C_MEMx_WIDTH and C_S_AXI_MEM_DATA_WIDTH
# C_INCLUDE_DATAWIDTH_MATCHING_x = 0 if and only if C_S_AXI_MEM_DATA_WIDTH = C_MEMx_WIDTH
#
# @param   mhsinst    the mhs instance handle
#
proc check_dwidth_matching_and_num_banks { mhsinst  } {

    set num_banks [xget_hw_parameter_value $mhsinst "C_NUM_BANKS_MEM"]
    set native_dwidth [xget_hw_parameter_value $mhsinst "C_S_AXI_MEM_DATA_WIDTH"]

    for {set x 0} {$x < $num_banks} {incr x 1} {
        set bank_dwm [concat C_INCLUDE_DATAWIDTH_MATCHING_${x}]
        set datawidth_matching [xget_hw_parameter_value $mhsinst $bank_dwm]
        set bank_width [concat C_MEM${x}_WIDTH]
        set mem_width [xget_hw_parameter_value $mhsinst $bank_width]

        if {$native_dwidth != $mem_width} {
            if {$datawidth_matching == 0} {
                set instname [xget_hw_parameter_value $mhsinst "INSTANCE"]
		error "Invalid $instname parameter:$bank_dwm,  $bank_dwm = 0 only if $bank_width = C_S_AXI_MEM_DATA_WIDTH" "" "mdt_error"
            }
        }
        
        if {$native_dwidth == $mem_width} {
            if {$datawidth_matching == 1} {
                set instname [xget_hw_parameter_value $mhsinst "INSTANCE"]
		error "Invalid $instname parameter:$bank_dwm,  $bank_dwm = 0 only if $bank_width = C_S_AXI_MEM_DATA_WIDTH" "" "mdt_error"
            }
        }        
    }
}


proc check_regen_psram_parity { mhsinst  } {

    set num_banks [xget_hw_parameter_value $mhsinst "C_NUM_BANKS_MEM"]
    set en_register_if [xget_hw_parameter_value $mhsinst "C_S_AXI_EN_REG"]
    set register_req 0    
    for {set x 0} {$x < $num_banks} {incr x 1} {

        set bank_type [concat C_MEM${x}_TYPE]
        set mem_type [xget_hw_parameter_value $mhsinst $bank_type]
        
        set parity_type [concat C_PARITY_TYPE_MEM_${x}]
        set mem_party_type [xget_hw_parameter_value $mhsinst $parity_type]
       	
       	if {$mem_type == 4 || $mem_party_type!=0} {
           incr register_req 
        }
    }   
    if {$en_register_if == 1} {
        if {$register_req == 0} {
           set instname [xget_hw_parameter_value $mhsinst "INSTANCE"]
           error "Invalid $instname parameter:C_S_AXI_EN_REG,  C_S_AXI_EN_REG = 1 only if $bank_type = 4 or $parity_type > 0" "" "mdt_error"
        }

    }
    
    if {$en_register_if == 0} {
        if {$register_req != 0} {
           set instname [xget_hw_parameter_value $mhsinst "INSTANCE"]
           error "Invalid $instname parameter:C_S_AXI_EN_REG,  C_S_AXI_EN_REG = 1 for $bank_type = 4 or $parity_type > 0" "" "mdt_error"
        }

    }    
}

proc set_param_value {mhsinst paramname paramvalue} {
	set param_handle [xget_hw_parameter_handle $mhsinst $paramname]
	if {[string length $param_handle] == 0} {
		xadd_hw_ipinst_parameter $mhsinst $paramname $paramvalue
		} else {
			xset_hw_parameter_value $param_handle $paramvalue
		}
}

proc xps_sav_add_new_mhsinst {mergedmhs mhsinst mpd} {
    set num_banks [xget_hw_parameter_value $mpd "C_NUM_BANKS_MEM"]
    for {set x 0} {$x < $num_banks} {incr x 1} {
        set base_addr [concat C_S_AXI_MEM${x}_BASEADDR]
	set_param_value $mhsinst $base_addr "0X00000000"
        
        set high_addr [concat C_S_AXI_MEM${x}_HIGHADDR]
	set_param_value $mhsinst $high_addr "0X00FFFFFF"
    }   

    set en_register_if [xget_hw_parameter_value $mpd "C_S_AXI_EN_REG"]
    if {$en_register_if == 1} {
	set_param_value $mhsinst "C_S_AXI_REG_BASEADDR" "0X00000000"
	set_param_value $mhsinst "C_S_AXI_REG_HIGHADDR" "0X00FFFFFF"
    }
}

proc xps_sav_autobusconnection_mhsinst {mergedmhs mhsinst mpd} {
    set num_banks [xget_hw_parameter_value $mhsinst "C_NUM_BANKS_MEM"]
    for {set x 0} {$x < $num_banks} {incr x 1} {
        set base_addr [concat C_S_AXI_MEM${x}_BASEADDR]
	set_param_value $mhsinst $base_addr "0X00000000"
        
        set high_addr [concat C_S_AXI_MEM${x}_HIGHADDR]
	set_param_value $mhsinst $high_addr "0X00FFFFFF"
    }   

    set en_register_if [xget_hw_parameter_value $mpd "C_S_AXI_EN_REG"]
    if {$en_register_if == 1} {
	set_param_value $mhsinst "C_S_AXI_REG_BASEADDR" "0X00000000"
	set_param_value $mhsinst "C_S_AXI_REG_HIGHADDR" "0X00FFFFFF"
    }
}
