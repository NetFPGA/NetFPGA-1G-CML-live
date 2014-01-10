#  NetFPGA-1G-CML http://www.netfpga.org
#
#  File:
#       dma_sv_compile.tcl 
#
#  Library:
#        hw/contrib/pcores/dma_v1_20_a
#
#  Author:
#        Jack Meador
#
#  Description:
#        vivado -mode tcl -source dma_sv_compile.tcl
#        
#        Compile dma_engine System Verilog module into EDF netlist and
#        Verilog structural simulation model
#
#  Copyright notice:
#        Copyright (C) 2013 Computer Measurement Laboratory, LLC
#
#  Licence:
#        This file is part of the NetFPGA 10G development base package.
#
#        This file is free code: you can redistribute it and/or modify it under
#        the terms of the GNU Lesser General Public License version 2.1 as
#        published by the Free Software Foundation.
#
#        This package is distributed in the hope that it will be useful, but
#        WITHOUT ANY WARRANTY; without even the implied warranty of
#        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#        Lesser General Public License for more details.
#
#        You should have received a copy of the GNU Lesser General Public
#        License along with the NetFPGA source package.  If not, see
#        http://www.gnu.org/licenses/.
#
#


# set project variables
set project_name vivado_work
set source_dir hdl/SystemVerilog
set netlist_dir netlist 
set model_dir  simhdl/verilog
set ip_name dma_engine 

# keep this directory from filling up with old logs and journals
exec rm -f [glob -nocomplain *.backup.jou]
exec rm -f [glob -nocomplain *.backup.log]

create_project -force $ip_name $project_name

# create results dirs if they don't already exist
exec mkdir -p $netlist_dir
exec mkdir -p $model_dir

set_property part xc7k325tffg676-1 [current_project]

# Add DMA System Verilog 
add_files -scan_for_includes -fileset [current_fileset] \
  $source_dir/axi.v \
  $source_dir/cfg.v \
  $source_dir/dma.v \
  $source_dir/iface.v \
  $source_dir/lib.v \
  $source_dir/mem.v \
  $source_dir/pcie_cm_q.v \
  $source_dir/pcie_rx_cm.v \
  $source_dir/pcie_tx_q.v \
  $source_dir/pcie_rx_rd.v \
  $source_dir/pcie_tx_rd.v \
  $source_dir/rx_ctrl.v \
  $source_dir/pcie_rx.v \
  $source_dir/pcie_tx.v \
  $source_dir/small_async_fifo.v \
  $source_dir/pcie_rx_wr.v \
  $source_dir/pcie_tx_wr.v \
  $source_dir/stats.v \
  $source_dir/pcie_rd_q.v \
  $source_dir/pcie_tx_cm.v \
  $source_dir/pcie_wr_q.v \
  $source_dir/tx_ctrl.v

set_property file_type SystemVerilog [get_files *.v]

synth_design -top dma_engine -no_iobuf

write_edif -force $netlist_dir/$ip_name.edf
#write_verilog -force $model_dir/$ip_name.v
exit
