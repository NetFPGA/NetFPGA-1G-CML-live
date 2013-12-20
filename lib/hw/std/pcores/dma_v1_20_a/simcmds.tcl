
set lib_path {/home/jhirata/devel/netfpga/cml-repo/lib/hw/std/pcores}

alib nf10_axis_sim_pkg_v1_00_a
acom -dbg -work nf10_axis_sim_pkg_v1_00_a $lib_path/nf10_axis_sim_pkg_v1_00_a/simhdl/vhdl/nf10_axis_sim_pkg.vhd

alib nf10_axis_sim_stim_v1_00_a
acom -dbg -work nf10_axis_sim_stim_v1_00_a $lib_path/nf10_axis_sim_stim_v1_00_a/simhdl/vhdl/nf10_axis_sim_stim.vhd


alib work
alog -dbg ../hdl/SystemVerilog/dma_defs.vh
alog -dbg ../hdl/SystemVerilog/small_async_fifo.v
alog -dbg ../hdl/SystemVerilog/lib.v
alog -dbg ../hdl/SystemVerilog/mem.v
alog -dbg ../hdl/SystemVerilog/axi.v
alog -dbg ../hdl/SystemVerilog/cfg.v
alog -dbg ../hdl/SystemVerilog/pcie_cm_q.v
alog -dbg ../hdl/SystemVerilog/pcie_rd_q.v
alog -dbg ../hdl/SystemVerilog/pcie_rx_cm.v
alog -dbg ../hdl/SystemVerilog/pcie_rx_rd.v
alog -dbg ../hdl/SystemVerilog/pcie_rx_wr.v
alog -dbg ../hdl/SystemVerilog/pcie_tx_cm.v
alog -dbg ../hdl/SystemVerilog/pcie_tx_q.v
alog -dbg ../hdl/SystemVerilog/pcie_tx_rd.v
alog -dbg ../hdl/SystemVerilog/pcie_tx_wr.v
alog -dbg ../hdl/SystemVerilog/pcie_wr_q.v
alog -dbg ../hdl/SystemVerilog/pcie_tx.v
alog -dbg ../hdl/SystemVerilog/pcie_rx.v
alog -dbg ../hdl/SystemVerilog/stats.v
alog -dbg ../hdl/SystemVerilog/iface.v
alog -dbg ../hdl/SystemVerilog/rx_ctrl.v
alog -dbg ../hdl/SystemVerilog/tx_ctrl.v
alog -dbg ../hdl/SystemVerilog/dma.v

acom -dbg ../simhdl/vhdl/tb_sv_dma.vhd

asim -dbg tb_sv_dma


wave -vgroup "dma" sim:/tb_sv_dma/uut/*
wave -vgroup "iface" sim:/tb_sv_dma/uut/u_iface/*
wave -vgroup "tx_ctrl" sim:/tb_sv_dma/uut/u_iface/u_tx_ctrl/*
wave -vgroup "pcie_rx_cm" sim:/tb_sv_dma/uut/u_pcie_rx/u_pcie_rx_cm/*
wave -vgroup "tx_pkt_mem" sim:/tb_sv_dma/uut/u_iface/u_mem_tx_pkt/*
wave -vgroup "pcie_rx" sim:/tb_sv_dma/uut/u_pcie_rx/*
wave -vgroup "pcie_rx_wr" sim:/tb_sv_dma/uut/u_pcie_rx/u_pcie_rx_wr/*

