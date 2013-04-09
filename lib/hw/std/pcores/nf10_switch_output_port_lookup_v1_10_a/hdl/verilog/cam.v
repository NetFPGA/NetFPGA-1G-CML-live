////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: O.87xd
//  \   \         Application: netgen
//  /   /         Filename: cam.v
// /___/   /\     Timestamp: Mon Mar 11 19:26:41 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -sim -ofmt verilog cam.ngc 
// Device	: xc5vtx240t-ff1759-2
// Input file	: cam.ngc
// Output file	: cam.v
// # of Modules	: 1
// Design Name	: cam_wrapper
// Xilinx        : /media/Xilinx13.4/ISE_DS/ISE/
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module cam (
  CLK, WE, BUSY, MATCH, DIN, WR_ADDR, CMP_DIN, MATCH_ADDR
);
  input CLK;
  input WE;
  output BUSY;
  output MATCH;
  input [47 : 0] DIN;
  input [3 : 0] WR_ADDR;
  input [47 : 0] CMP_DIN;
  output [3 : 0] MATCH_ADDR;
// synthesis translate_off
  wire NlwRenamedSig_OI_BUSY;
  wire N0;
  wire N1;
  wire \top_cam/rtl_cam/wren ;
  wire \top_cam/rtl_cam/rw_dec_clr_i ;
  wire \top_cam/rtl_cam/clog/int_reg_en_i_112 ;
  wire \top_cam/rtl_cam/matches[0] ;
  wire \top_cam/rtl_cam/matches[1] ;
  wire \top_cam/rtl_cam/matches[2] ;
  wire \top_cam/rtl_cam/matches[3] ;
  wire \top_cam/rtl_cam/matches[4] ;
  wire \top_cam/rtl_cam/matches[5] ;
  wire \top_cam/rtl_cam/matches[6] ;
  wire \top_cam/rtl_cam/matches[8] ;
  wire \top_cam/rtl_cam/matches[10] ;
  wire \top_cam/rtl_cam/matches[12] ;
  wire \top_cam/rtl_cam/matches[13] ;
  wire \top_cam/rtl_cam/matches[14] ;
  wire \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_4 ;
  wire \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_5 ;
  wire \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_3_f7_407 ;
  wire \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_51_408 ;
  wire \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_6 ;
  wire \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_4_f7_410 ;
  wire \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[5] ;
  wire \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[2] ;
  wire \top_cam/rtl_cam/clog/gwsig.end_next_write_WE_MUX_80_o ;
  wire \top_cam/rtl_cam/clog/gwsig.end_next_write_433 ;
  wire \top_cam/rtl_cam/mlog/match_addr_bin_bf_reg(1)1_435 ;
  wire N2;
  wire \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0)(3)1 ;
  wire \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)1_440 ;
  wire \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)2_441 ;
  wire N4;
  wire N6;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i1_445 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i2_446 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i3_447 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i4_448 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i5_449 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i6_450 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i7_451 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i8_452 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i9_453 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i10_454 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i11_455 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i12_456 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i13_457 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i14_458 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i15_459 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i16_460 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i17_461 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i18_462 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i19_463 ;
  wire \top_cam/rtl_cam/clog/rw_dec_clr_i20_464 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_15_rstpot_465 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_14_rstpot_466 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_13_rstpot_467 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_12_rstpot_468 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_11_rstpot_469 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_10_rstpot_470 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_9_rstpot_471 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_8_rstpot_472 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_7_rstpot_473 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_6_rstpot_474 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_5_rstpot_475 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_4_rstpot_476 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_3_rstpot_477 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_2_rstpot_478 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_1_rstpot_479 ;
  wire \top_cam/rtl_cam/mlog/blkmem_match_disable_0_rstpot_480 ;
  wire \top_cam/rtl_cam/clog/int_reg_en_i_1_481 ;
  wire N8;
  wire N9;
  wire N10;
  wire N11;
  wire N12;
  wire N13;
  wire N14;
  wire N15;
  wire N16;
  wire N17;
  wire N18;
  wire N19;
  wire N20;
  wire N21;
  wire N22;
  wire N23;
  wire N24;
  wire N25;
  wire N26;
  wire N27;
  wire N28;
  wire N29;
  wire \top_cam/rtl_cam/clog/int_reg_en_i_2_504 ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED ;
  wire \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED ;
  wire [3 : 0] \top_cam/rtl_cam/wr_addr_ilog ;
  wire [47 : 0] \top_cam/rtl_cam/wr_data ;
  wire [47 : 0] \top_cam/rtl_cam/ilog/gwl.din_q ;
  wire [3 : 0] \top_cam/rtl_cam/ilog/gwl.wr_addr_q ;
  wire [47 : 0] \top_cam/rtl_cam/mem/gblk.blkmem/mux_out ;
  wire [15 : 0] \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) ;
  wire [15 : 0] \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) ;
  wire [15 : 0] \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) ;
  wire [15 : 0] \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) ;
  wire [15 : 0] \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) ;
  wire [47 : 0] \top_cam/rtl_cam/mem/gblk.blkmem/memory_out ;
  wire [2 : 2] \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(4) ;
  wire [3 : 3] \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0) ;
  wire [1 : 1] \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(2) ;
  wire [15 : 0] \top_cam/rtl_cam/mlog/blkmem_match_disable ;
  wire [1 : 1] \top_cam/rtl_cam/mlog/match_addr_bin_bf_reg ;
  wire [3 : 3] \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0) ;
  wire [2 : 2] \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3) ;
  assign
    BUSY = NlwRenamedSig_OI_BUSY;
  VCC   XST_VCC (
    .P(N0)
  );
  GND   XST_GND (
    .G(N1)
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_47  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [47]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [47])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_46  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [46]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [46])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_45  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [45]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [45])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_44  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [44]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [44])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_43  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [43]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [43])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_42  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [42]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [42])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_41  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [41]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [41])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_40  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [40]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [40])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_39  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [39]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [39])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_38  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [38]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [38])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_37  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [37]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [37])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_36  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [36]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [36])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_35  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [35]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [35])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_34  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [34]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [34])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_33  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [33]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [33])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_32  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [32]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [32])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_31  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [31]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [31])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_30  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [30]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [30])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_29  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [29]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [29])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_28  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [28]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [28])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_27  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [27]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [27])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_26  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [26]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [26])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_25  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [25]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [25])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_24  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [24]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [24])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_23  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [23]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [23])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_22  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [22]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [22])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_21  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [21]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [21])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_20  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [20]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [20])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_19  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [19]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [19])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_18  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [18]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [18])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_17  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [17]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [17])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_16  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [16]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [16])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_15  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [15]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [15])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_14  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [14]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [14])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_13  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [13]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [13])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_12  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [12]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [12])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_11  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [11]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [11])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_10  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [10]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [10])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_9  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [9]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [9])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_8  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [8]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [8])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_7  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [7]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [7])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_6  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [6]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [6])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_5  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [5]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [5])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_4  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [4]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [4])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_3  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [3]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [3])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_2  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [2]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [2])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_1  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [1]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [1])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.din_q_0  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_data [0]),
    .Q(\top_cam/rtl_cam/ilog/gwl.din_q [0])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.wr_addr_q_3  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .Q(\top_cam/rtl_cam/ilog/gwl.wr_addr_q [3])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.wr_addr_q_2  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .Q(\top_cam/rtl_cam/ilog/gwl.wr_addr_q [2])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.wr_addr_q_1  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .Q(\top_cam/rtl_cam/ilog/gwl.wr_addr_q [1])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/ilog/gwl.wr_addr_q_0  (
    .C(CLK),
    .D(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .Q(\top_cam/rtl_cam/ilog/gwl.wr_addr_q [0])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM47  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [46]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [46])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM46  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [45]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [45])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM48  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [47]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [47])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM44  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [43]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [43])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM43  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [42]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [42])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM45  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [44]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [44])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM41  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [40]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [40])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM40  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [39]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [39])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM42  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [41]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [41])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM39  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [38]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [38])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM38  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [37]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [37])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM37  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [36]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [36])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM36  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [35]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [35])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM34  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [33]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [33])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM33  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [32]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [32])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM35  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [34]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [34])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM32  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [31]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [31])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM31  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [30]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [30])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM30  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [29]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [29])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM29  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [28]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [28])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM27  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [26]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [26])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM26  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [25]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [25])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM28  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [27]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [27])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM25  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [24]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [24])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM24  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [23]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [23])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM23  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [22]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [22])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM22  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [21]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [21])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM20  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [19]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [19])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM19  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [18]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [18])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM21  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [20]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [20])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM17  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [16]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [16])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM16  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [15]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [15])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM18  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [17]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [17])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM14  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [13]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [13])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM13  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [12]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [12])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM15  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [14]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [14])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM12  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [11]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [11])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM11  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [10]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [10])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM10  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [9]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [9])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM9  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [8]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [8])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM7  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [6]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [6])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM6  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [5]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [5])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM8  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [7]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [7])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM5  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [4]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [4])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM4  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [3]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [3])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM3  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [2]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [2])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM2  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [1]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [1])
  );
  RAM32X1S #(
    .INIT ( 32'h00000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gdmem.eram/Mram_MEM1  (
    .A0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .A1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .A2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .A3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .A4(N1),
    .D(\top_cam/rtl_cam/wr_data [0]),
    .WCLK(CLK),
    .WE(NlwRenamedSig_OI_BUSY),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [0])
  );
  MUXF7   \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_3_f7  (
    .I0(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_5 ),
    .I1(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_4 ),
    .S(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(4) [2]),
    .O(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_3_f7_407 )
  );
  MUXF7   \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_4_f7  (
    .I0(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_6 ),
    .I1(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_51_408 ),
    .S(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[2] ),
    .O(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_4_f7_410 )
  );
  MUXF8   \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_2_f8  (
    .I0(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_4_f7_410 ),
    .I1(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_3_f7_407 ),
    .S(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0) [3]),
    .O(MATCH_ADDR[0])
  );
  FDRS #(
    .INIT ( 1'b1 ))
  \top_cam/rtl_cam/clog/int_reg_en_i  (
    .C(CLK),
    .D(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .R(\top_cam/rtl_cam/clog/gwsig.end_next_write_WE_MUX_80_o ),
    .S(\top_cam/rtl_cam/clog/gwsig.end_next_write_433 ),
    .Q(\top_cam/rtl_cam/clog/int_reg_en_i_112 )
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/clog/gwsig.end_next_write  (
    .C(CLK),
    .D(\top_cam/rtl_cam/clog/gwsig.end_next_write_WE_MUX_80_o ),
    .Q(\top_cam/rtl_cam/clog/gwsig.end_next_write_433 )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_WR_ADDR_INT11  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.wr_addr_q [0]),
    .I2(WR_ADDR[0]),
    .O(\top_cam/rtl_cam/wr_addr_ilog [0])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_WR_ADDR_INT21  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.wr_addr_q [1]),
    .I2(WR_ADDR[1]),
    .O(\top_cam/rtl_cam/wr_addr_ilog [1])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_WR_ADDR_INT31  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.wr_addr_q [2]),
    .I2(WR_ADDR[2]),
    .O(\top_cam/rtl_cam/wr_addr_ilog [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_WR_ADDR_INT41  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.wr_addr_q [3]),
    .I2(WR_ADDR[3]),
    .O(\top_cam/rtl_cam/wr_addr_ilog [3])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT110  (
    .I0(DIN[0]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [0]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [0])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT210  (
    .I0(DIN[1]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [1]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [1])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT310  (
    .I0(DIN[10]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [10]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [10])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT49  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [11]),
    .I2(DIN[11]),
    .O(\top_cam/rtl_cam/wr_data [11])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT51  (
    .I0(DIN[12]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [12]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [12])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT61  (
    .I0(DIN[13]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [13]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [13])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT71  (
    .I0(DIN[14]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [14]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [14])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT81  (
    .I0(DIN[15]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [15]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [15])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT91  (
    .I0(DIN[16]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [16]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [16])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT101  (
    .I0(DIN[17]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [17]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [17])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT111  (
    .I0(DIN[18]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [18]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [18])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT121  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [19]),
    .I2(DIN[19]),
    .O(\top_cam/rtl_cam/wr_data [19])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT131  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [2]),
    .I2(DIN[2]),
    .O(\top_cam/rtl_cam/wr_data [2])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT141  (
    .I0(DIN[20]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [20]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [20])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT151  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [21]),
    .I2(DIN[21]),
    .O(\top_cam/rtl_cam/wr_data [21])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT161  (
    .I0(DIN[22]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [22]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [22])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT171  (
    .I0(DIN[23]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [23]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [23])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT181  (
    .I0(DIN[24]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [24]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [24])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT191  (
    .I0(DIN[25]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [25]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [25])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT201  (
    .I0(DIN[26]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [26]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [26])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT211  (
    .I0(DIN[27]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [27]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [27])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT221  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [28]),
    .I2(DIN[28]),
    .O(\top_cam/rtl_cam/wr_data [28])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT231  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [29]),
    .I2(DIN[29]),
    .O(\top_cam/rtl_cam/wr_data [29])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT241  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [3]),
    .I2(DIN[3]),
    .O(\top_cam/rtl_cam/wr_data [3])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT251  (
    .I0(DIN[30]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [30]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [30])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT261  (
    .I0(DIN[31]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [31]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [31])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT271  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [32]),
    .I2(DIN[32]),
    .O(\top_cam/rtl_cam/wr_data [32])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT281  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [33]),
    .I2(DIN[33]),
    .O(\top_cam/rtl_cam/wr_data [33])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT291  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [34]),
    .I2(DIN[34]),
    .O(\top_cam/rtl_cam/wr_data [34])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT301  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [35]),
    .I2(DIN[35]),
    .O(\top_cam/rtl_cam/wr_data [35])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT311  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [36]),
    .I2(DIN[36]),
    .O(\top_cam/rtl_cam/wr_data [36])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT321  (
    .I0(DIN[37]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [37]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [37])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT331  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [38]),
    .I2(DIN[38]),
    .O(\top_cam/rtl_cam/wr_data [38])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT341  (
    .I0(DIN[39]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [39]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [39])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT351  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [4]),
    .I2(DIN[4]),
    .O(\top_cam/rtl_cam/wr_data [4])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT361  (
    .I0(DIN[40]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [40]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_1_481 ),
    .O(\top_cam/rtl_cam/wr_data [40])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT371  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [41]),
    .I2(DIN[41]),
    .O(\top_cam/rtl_cam/wr_data [41])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT381  (
    .I0(DIN[42]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [42]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [42])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT391  (
    .I0(DIN[43]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [43]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [43])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT401  (
    .I0(DIN[44]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [44]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [44])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT411  (
    .I0(DIN[45]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [45]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [45])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT421  (
    .I0(DIN[46]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [46]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/wr_data [46])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT431  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [47]),
    .I2(DIN[47]),
    .O(\top_cam/rtl_cam/wr_data [47])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT441  (
    .I0(DIN[5]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [5]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [5])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT451  (
    .I0(DIN[6]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [6]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [6])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT461  (
    .I0(DIN[7]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [7]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [7])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT471  (
    .I0(DIN[8]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [8]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [8])
  );
  LUT3 #(
    .INIT ( 8'hAC ))
  \top_cam/rtl_cam/ilog/Mmux_gwl.din_q[47]_DIN[47]_mux_5_OUT481  (
    .I0(DIN[9]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [9]),
    .I2(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/wr_data [9])
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out141  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [14]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [14]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [14]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [14]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [14]),
    .O(\top_cam/rtl_cam/matches[14] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out131  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [13]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [13]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [13]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [13]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [13]),
    .O(\top_cam/rtl_cam/matches[13] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out121  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [12]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [12]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [12]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [12]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [12]),
    .O(\top_cam/rtl_cam/matches[12] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out101  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [10]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [10]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [10]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [10]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [10]),
    .O(\top_cam/rtl_cam/matches[10] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out81  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [8]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [8]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [8]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [8]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [8]),
    .O(\top_cam/rtl_cam/matches[8] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out61  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [6]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [6]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [6]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [6]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [6]),
    .O(\top_cam/rtl_cam/matches[6] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out51  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [5]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [5]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [5]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [5]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [5]),
    .O(\top_cam/rtl_cam/matches[5] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out41  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [4]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [4]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [4]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [4]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [4]),
    .O(\top_cam/rtl_cam/matches[4] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out31  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [3]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [3]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [3]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [3]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [3]),
    .O(\top_cam/rtl_cam/matches[3] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out21  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [2]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [2]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [2]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [2]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [2]),
    .O(\top_cam/rtl_cam/matches[2] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out11  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [1]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [1]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [1]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [1]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [1]),
    .O(\top_cam/rtl_cam/matches[1] )
  );
  LUT5 #(
    .INIT ( 32'h80000000 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/out1  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [0]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [0]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [0]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [0]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [0]),
    .O(\top_cam/rtl_cam/matches[0] )
  );
  LUT4 #(
    .INIT ( 16'h4F44 ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(5)1  (
    .I0(\top_cam/rtl_cam/mlog/blkmem_match_disable [5]),
    .I1(\top_cam/rtl_cam/matches[5] ),
    .I2(\top_cam/rtl_cam/mlog/blkmem_match_disable [4]),
    .I3(\top_cam/rtl_cam/matches[4] ),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[5] )
  );
  LUT4 #(
    .INIT ( 16'h4F44 ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(1)1  (
    .I0(\top_cam/rtl_cam/mlog/blkmem_match_disable [13]),
    .I1(\top_cam/rtl_cam/matches[13] ),
    .I2(\top_cam/rtl_cam/mlog/blkmem_match_disable [12]),
    .I3(\top_cam/rtl_cam/matches[12] ),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0) [3])
  );
  LUT3 #(
    .INIT ( 8'h1B ))
  \top_cam/rtl_cam/mlog/match_addr_bin_bf_reg(2)1  (
    .I0(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0) [3]),
    .I1(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[2] ),
    .I2(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(4) [2]),
    .O(MATCH_ADDR[2])
  );
  LUT5 #(
    .INIT ( 32'h22F2FFFF ))
  \top_cam/rtl_cam/mlog/match_addr_bin_bf_reg(1)1  (
    .I0(\top_cam/rtl_cam/matches[2] ),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [2]),
    .I2(\top_cam/rtl_cam/matches[3] ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [3]),
    .I4(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[5] ),
    .O(\top_cam/rtl_cam/mlog/match_addr_bin_bf_reg [1])
  );
  LUT4 #(
    .INIT ( 16'hB0BB ))
  \top_cam/rtl_cam/mlog/match_addr_bin_bf_reg(1)2  (
    .I0(\top_cam/rtl_cam/mlog/blkmem_match_disable [1]),
    .I1(\top_cam/rtl_cam/matches[1] ),
    .I2(\top_cam/rtl_cam/mlog/blkmem_match_disable [0]),
    .I3(\top_cam/rtl_cam/matches[0] ),
    .O(\top_cam/rtl_cam/mlog/match_addr_bin_bf_reg(1)1_435 )
  );
  LUT6 #(
    .INIT ( 64'hAEBF041504150415 ))
  \top_cam/rtl_cam/mlog/match_addr_bin_bf_reg(1)3  (
    .I0(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0) [3]),
    .I1(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[2] ),
    .I2(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(2) [1]),
    .I3(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0) [3]),
    .I4(\top_cam/rtl_cam/mlog/match_addr_bin_bf_reg(1)1_435 ),
    .I5(\top_cam/rtl_cam/mlog/match_addr_bin_bf_reg [1]),
    .O(MATCH_ADDR[1])
  );
  LUT4 #(
    .INIT ( 16'hF7FF ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(2)(1)_SW0  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [11]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [11]),
    .I2(\top_cam/rtl_cam/mlog/blkmem_match_disable [11]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [11]),
    .O(N2)
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFF2222F222 ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(2)(1)  (
    .I0(\top_cam/rtl_cam/matches[10] ),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [10]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [11]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [11]),
    .I4(N2),
    .I5(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(2) [1]),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[2] )
  );
  LUT6 #(
    .INIT ( 64'h2000000000000000 ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0)(3)2  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [15]),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [15]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [15]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [15]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [15]),
    .I5(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [15]),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0)(3)1 )
  );
  LUT6 #(
    .INIT ( 64'hFFFFFFFFFFFFEEFE ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0)(3)3  (
    .I0(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0) [3]),
    .I1(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0) [3]),
    .I2(\top_cam/rtl_cam/matches[14] ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [14]),
    .I4(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red[2] ),
    .I5(\top_cam/rtl_cam/mlog/binad.bin_proc.matches_red(0)(3)1 ),
    .O(MATCH)
  );
  LUT6 #(
    .INIT ( 64'h22F222F2FFFF22F2 ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)1  (
    .I0(\top_cam/rtl_cam/matches[3] ),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [3]),
    .I2(\top_cam/rtl_cam/matches[4] ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [4]),
    .I4(\top_cam/rtl_cam/matches[1] ),
    .I5(\top_cam/rtl_cam/mlog/blkmem_match_disable [1]),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3) [2])
  );
  LUT6 #(
    .INIT ( 64'h22F222F2FFFF22F2 ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)2  (
    .I0(\top_cam/rtl_cam/matches[2] ),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [2]),
    .I2(\top_cam/rtl_cam/matches[0] ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [0]),
    .I4(\top_cam/rtl_cam/matches[6] ),
    .I5(\top_cam/rtl_cam/mlog/blkmem_match_disable [6]),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)1_440 )
  );
  LUT6 #(
    .INIT ( 64'h2000000000000000 ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)3  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [7]),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [7]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [7]),
    .I3(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [7]),
    .I4(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [7]),
    .I5(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [7]),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)2_441 )
  );
  LUT5 #(
    .INIT ( 32'hFFFFFFAE ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)4  (
    .I0(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3) [2]),
    .I1(\top_cam/rtl_cam/matches[5] ),
    .I2(\top_cam/rtl_cam/mlog/blkmem_match_disable [5]),
    .I3(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)1_440 ),
    .I4(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)2_441 ),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0) [3])
  );
  LUT4 #(
    .INIT ( 16'hB0BB ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(4)(2)(1)_SW0  (
    .I0(\top_cam/rtl_cam/mlog/blkmem_match_disable [0]),
    .I1(\top_cam/rtl_cam/matches[0] ),
    .I2(\top_cam/rtl_cam/mlog/blkmem_match_disable [2]),
    .I3(\top_cam/rtl_cam/matches[2] ),
    .O(N4)
  );
  LUT5 #(
    .INIT ( 32'h22F2FFFF ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(4)(2)(1)  (
    .I0(\top_cam/rtl_cam/matches[3] ),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [3]),
    .I2(\top_cam/rtl_cam/matches[1] ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [1]),
    .I4(N4),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(4) [2])
  );
  LUT3 #(
    .INIT ( 8'hDF ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(2)(1)_SW0  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [9]),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [9]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [9]),
    .O(N6)
  );
  LUT6 #(
    .INIT ( 64'h00800080FFFF0080 ))
  \top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(2)(1)  (
    .I0(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [9]),
    .I1(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [9]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [9]),
    .I3(N6),
    .I4(\top_cam/rtl_cam/matches[8] ),
    .I5(\top_cam/rtl_cam/mlog/blkmem_match_disable [8]),
    .O(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(2) [1])
  );
  LUT6 #(
    .INIT ( 64'h7FBFDFEFF7FBFDFE ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i2  (
    .I0(CMP_DIN[8]),
    .I1(CMP_DIN[5]),
    .I2(CMP_DIN[6]),
    .I3(\top_cam/rtl_cam/wr_data [8]),
    .I4(\top_cam/rtl_cam/wr_data [5]),
    .I5(\top_cam/rtl_cam/wr_data [6]),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i1_445 )
  );
  LUT6 #(
    .INIT ( 64'h7FDFF7FDBFEFFBFE ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i3  (
    .I0(CMP_DIN[1]),
    .I1(CMP_DIN[9]),
    .I2(CMP_DIN[7]),
    .I3(\top_cam/rtl_cam/wr_data [9]),
    .I4(\top_cam/rtl_cam/wr_data [7]),
    .I5(\top_cam/rtl_cam/wr_data [1]),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i2_446 )
  );
  LUT5 #(
    .INIT ( 32'hFFFFFFF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i5  (
    .I0(CMP_DIN[0]),
    .I1(\top_cam/rtl_cam/wr_data [0]),
    .I2(\top_cam/rtl_cam/clog/rw_dec_clr_i3_447 ),
    .I3(\top_cam/rtl_cam/clog/rw_dec_clr_i1_445 ),
    .I4(\top_cam/rtl_cam/clog/rw_dec_clr_i2_446 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i4_448 )
  );
  LUT6 #(
    .INIT ( 64'h7FBFDFEFF7FBFDFE ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i8  (
    .I0(CMP_DIN[14]),
    .I1(CMP_DIN[12]),
    .I2(CMP_DIN[13]),
    .I3(\top_cam/rtl_cam/wr_data [14]),
    .I4(\top_cam/rtl_cam/wr_data [12]),
    .I5(\top_cam/rtl_cam/wr_data [13]),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i7_451 )
  );
  LUT5 #(
    .INIT ( 32'hFFFFFFF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i9  (
    .I0(CMP_DIN[10]),
    .I1(\top_cam/rtl_cam/wr_data [10]),
    .I2(\top_cam/rtl_cam/clog/rw_dec_clr_i6_450 ),
    .I3(\top_cam/rtl_cam/clog/rw_dec_clr_i5_449 ),
    .I4(\top_cam/rtl_cam/clog/rw_dec_clr_i7_451 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i8_452 )
  );
  LUT5 #(
    .INIT ( 32'hFFFFFFF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i13  (
    .I0(CMP_DIN[20]),
    .I1(\top_cam/rtl_cam/wr_data [20]),
    .I2(\top_cam/rtl_cam/clog/rw_dec_clr_i10_454 ),
    .I3(\top_cam/rtl_cam/clog/rw_dec_clr_i9_453 ),
    .I4(\top_cam/rtl_cam/clog/rw_dec_clr_i11_455 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i12_456 )
  );
  LUT5 #(
    .INIT ( 32'hFFFFFFF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i17  (
    .I0(CMP_DIN[30]),
    .I1(\top_cam/rtl_cam/wr_data [30]),
    .I2(\top_cam/rtl_cam/clog/rw_dec_clr_i13_457 ),
    .I3(\top_cam/rtl_cam/clog/rw_dec_clr_i15_459 ),
    .I4(\top_cam/rtl_cam/clog/rw_dec_clr_i14_458 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i16_460 )
  );
  LUT6 #(
    .INIT ( 64'hEAAAAAAAAAAAAAAA ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i22  (
    .I0(\top_cam/rtl_cam/clog/rw_dec_clr_i ),
    .I1(\top_cam/rtl_cam/clog/rw_dec_clr_i20_464 ),
    .I2(\top_cam/rtl_cam/clog/rw_dec_clr_i12_456 ),
    .I3(\top_cam/rtl_cam/clog/rw_dec_clr_i8_452 ),
    .I4(\top_cam/rtl_cam/clog/rw_dec_clr_i16_460 ),
    .I5(\top_cam/rtl_cam/clog/rw_dec_clr_i4_448 ),
    .O(\top_cam/rtl_cam/rw_dec_clr_i )
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_15  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_15_rstpot_465 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [15])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_14  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_14_rstpot_466 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [14])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_13  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_13_rstpot_467 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [13])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_12  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_12_rstpot_468 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [12])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_11  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_11_rstpot_469 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [11])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_10  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_10_rstpot_470 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [10])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_9  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_9_rstpot_471 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [9])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_8  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_8_rstpot_472 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [8])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_7  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_7_rstpot_473 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [7])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_6  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_6_rstpot_474 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [6])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_5  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_5_rstpot_475 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [5])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_4  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_4_rstpot_476 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [4])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_3  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_3_rstpot_477 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [3])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_2  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_2_rstpot_478 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [2])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_1  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_1_rstpot_479 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [1])
  );
  FD #(
    .INIT ( 1'b0 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_0  (
    .C(CLK),
    .D(\top_cam/rtl_cam/mlog/blkmem_match_disable_0_rstpot_480 ),
    .Q(\top_cam/rtl_cam/mlog/blkmem_match_disable [0])
  );
  LUT4 #(
    .INIT ( 16'h5554 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i21  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/clog/rw_dec_clr_i19_463 ),
    .I2(\top_cam/rtl_cam/clog/rw_dec_clr_i17_461 ),
    .I3(\top_cam/rtl_cam/clog/rw_dec_clr_i18_462 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i20_464 )
  );
  LUT6 #(
    .INIT ( 64'h2D78FFFFFFFF2D78 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i20  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_1_481 ),
    .I1(DIN[47]),
    .I2(CMP_DIN[47]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [47]),
    .I4(CMP_DIN[40]),
    .I5(\top_cam/rtl_cam/wr_data [40]),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i19_463 )
  );
  LUT5 #(
    .INIT ( 32'h00008000 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_15_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_15_rstpot_465 )
  );
  LUT5 #(
    .INIT ( 32'h00000080 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_14_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_14_rstpot_466 )
  );
  LUT5 #(
    .INIT ( 32'h00000080 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_13_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_13_rstpot_467 )
  );
  LUT5 #(
    .INIT ( 32'h00000020 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_12_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_12_rstpot_468 )
  );
  LUT5 #(
    .INIT ( 32'h00000080 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_11_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_11_rstpot_469 )
  );
  LUT5 #(
    .INIT ( 32'h00000020 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_10_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_10_rstpot_470 )
  );
  LUT5 #(
    .INIT ( 32'h00000020 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_9_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_9_rstpot_471 )
  );
  LUT5 #(
    .INIT ( 32'h00000004 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_8_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_8_rstpot_472 )
  );
  LUT5 #(
    .INIT ( 32'h00000080 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_7_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_7_rstpot_473 )
  );
  LUT5 #(
    .INIT ( 32'h00000020 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_6_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_6_rstpot_474 )
  );
  LUT5 #(
    .INIT ( 32'h00000020 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_5_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_5_rstpot_475 )
  );
  LUT5 #(
    .INIT ( 32'h00000004 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_4_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_4_rstpot_476 )
  );
  LUT5 #(
    .INIT ( 32'h00000020 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_3_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_3_rstpot_477 )
  );
  LUT5 #(
    .INIT ( 32'h00000004 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_2_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_2_rstpot_478 )
  );
  LUT5 #(
    .INIT ( 32'h00000004 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_1_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_1_rstpot_479 )
  );
  LUT5 #(
    .INIT ( 32'h00000001 ))
  \top_cam/rtl_cam/mlog/blkmem_match_disable_0_rstpot  (
    .I0(\top_cam/rtl_cam/wr_addr_ilog [0]),
    .I1(\top_cam/rtl_cam/wr_addr_ilog [2]),
    .I2(\top_cam/rtl_cam/wr_addr_ilog [3]),
    .I3(\top_cam/rtl_cam/wr_addr_ilog [1]),
    .I4(\top_cam/rtl_cam/rw_dec_clr_i ),
    .O(\top_cam/rtl_cam/mlog/blkmem_match_disable_0_rstpot_480 )
  );
  LUT2 #(
    .INIT ( 4'h2 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i1  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(WE),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i )
  );
  LUT2 #(
    .INIT ( 4'hD ))
  \top_cam/rtl_cam/clog/WREN1  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(WE),
    .O(\top_cam/rtl_cam/wren )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \top_cam/rtl_cam/clog/gwsig.end_next_write_WE_MUX_80_o1  (
    .I0(WE),
    .I1(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .O(\top_cam/rtl_cam/clog/gwsig.end_next_write_WE_MUX_80_o )
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out110  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [0]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [0]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [0])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out210  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [1]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [1]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [1])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out310  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [10]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [10]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [10])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out49  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [11]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [11]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [11])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out51  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [12]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [12]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [12])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out61  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [13]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [13]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [13])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out71  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [14]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [14]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [14])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out81  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [15]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [15]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [15])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out91  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [16]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [16]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [16])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out101  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [17]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [17]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [17])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out111  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [18]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [18]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [18])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out121  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [19]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [19]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [19])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out131  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [2]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [2]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [2])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out141  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [20]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [20]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [20])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out151  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [21]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [21]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [21])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out161  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [22]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [22]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [22])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out171  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [23]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [23]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [23])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out181  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [24]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [24]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [24])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out191  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [25]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [25]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [25])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out201  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [26]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [26]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [26])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out211  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [27]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [27]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [27])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out221  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [28]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [28]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [28])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out231  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [29]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [29]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [29])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out241  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [3]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [3]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [3])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out251  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [30]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [30]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [30])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out261  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [31]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [31]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [31])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out271  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [32]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [32]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [32])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out281  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [33]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [33]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [33])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out291  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [34]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [34]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [34])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out301  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [35]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [35]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [35])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out311  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [36]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [36]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [36])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out321  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [37]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [37]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [37])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out331  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [38]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [38]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [38])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out341  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [39]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [39]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [39])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out351  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [4]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [4]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [4])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out361  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [40]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [40]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [40])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out371  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [41]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [41]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [41])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out381  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [42]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [42]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [42])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out391  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [43]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [43]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [43])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out401  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [44]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [44]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [44])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out411  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [45]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [45]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [45])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out421  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [46]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [46]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [46])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out431  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [47]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [47]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [47])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out441  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [5]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [5]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [5])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out451  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [6]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [6]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [6])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out461  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [7]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [7]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [7])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out471  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [8]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [8]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [8])
  );
  LUT3 #(
    .INIT ( 8'hE4 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/Mmux_mux_out481  (
    .I0(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [9]),
    .I2(\top_cam/rtl_cam/mem/gblk.blkmem/memory_out [9]),
    .O(\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [9])
  );
  LUT5 #(
    .INIT ( 32'h01000101 ))
  \top_cam/rtl_cam/mlog/match_addr_bin_bf_reg(3)1  (
    .I0(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3) [2]),
    .I1(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)1_440 ),
    .I2(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(0)(3)(2)2_441 ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [5]),
    .I4(\top_cam/rtl_cam/matches[5] ),
    .O(MATCH_ADDR[3])
  );
  FDRS #(
    .INIT ( 1'b1 ))
  \top_cam/rtl_cam/clog/int_reg_en_i_1  (
    .C(CLK),
    .D(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .R(\top_cam/rtl_cam/clog/gwsig.end_next_write_WE_MUX_80_o ),
    .S(\top_cam/rtl_cam/clog/gwsig.end_next_write_433 ),
    .Q(\top_cam/rtl_cam/clog/int_reg_en_i_1_481 )
  );
  INV   \top_cam/rtl_cam/mem/gblk.blkmem/wr_count_inv1_INV_0  (
    .I(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(NlwRenamedSig_OI_BUSY)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i16  (
    .I0(N8),
    .I1(N9),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i15_459 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i16_F  (
    .I0(CMP_DIN[33]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [33]),
    .I2(CMP_DIN[32]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [32]),
    .I4(CMP_DIN[34]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [34]),
    .O(N8)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i16_G  (
    .I0(CMP_DIN[33]),
    .I1(DIN[33]),
    .I2(CMP_DIN[32]),
    .I3(DIN[32]),
    .I4(CMP_DIN[34]),
    .I5(DIN[34]),
    .O(N9)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i14  (
    .I0(N10),
    .I1(N11),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i13_457 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i14_F  (
    .I0(CMP_DIN[36]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [36]),
    .I2(CMP_DIN[35]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [35]),
    .I4(CMP_DIN[38]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [38]),
    .O(N10)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i14_G  (
    .I0(CMP_DIN[36]),
    .I1(DIN[36]),
    .I2(CMP_DIN[35]),
    .I3(DIN[35]),
    .I4(CMP_DIN[38]),
    .I5(DIN[38]),
    .O(N11)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i4  (
    .I0(N12),
    .I1(N13),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i3_447 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i4_F  (
    .I0(CMP_DIN[3]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [3]),
    .I2(CMP_DIN[2]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [2]),
    .I4(CMP_DIN[4]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [4]),
    .O(N12)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i4_G  (
    .I0(CMP_DIN[3]),
    .I1(DIN[3]),
    .I2(CMP_DIN[2]),
    .I3(DIN[2]),
    .I4(CMP_DIN[4]),
    .I5(DIN[4]),
    .O(N13)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i18  (
    .I0(N14),
    .I1(N15),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i17_461 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i18_F  (
    .I0(CMP_DIN[46]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [46]),
    .I2(CMP_DIN[45]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [45]),
    .I4(CMP_DIN[41]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [41]),
    .O(N14)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i18_G  (
    .I0(CMP_DIN[46]),
    .I1(DIN[46]),
    .I2(CMP_DIN[45]),
    .I3(DIN[45]),
    .I4(CMP_DIN[41]),
    .I5(DIN[41]),
    .O(N15)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i11  (
    .I0(N16),
    .I1(N17),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i10_454 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i11_F  (
    .I0(CMP_DIN[27]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [27]),
    .I2(CMP_DIN[29]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [29]),
    .I4(CMP_DIN[21]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [21]),
    .O(N16)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i11_G  (
    .I0(CMP_DIN[27]),
    .I1(DIN[27]),
    .I2(CMP_DIN[29]),
    .I3(DIN[29]),
    .I4(CMP_DIN[21]),
    .I5(DIN[21]),
    .O(N17)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i7  (
    .I0(N18),
    .I1(N19),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i6_450 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i7_F  (
    .I0(CMP_DIN[17]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [17]),
    .I2(CMP_DIN[19]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [19]),
    .I4(CMP_DIN[11]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [11]),
    .O(N18)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i7_G  (
    .I0(CMP_DIN[17]),
    .I1(DIN[17]),
    .I2(CMP_DIN[19]),
    .I3(DIN[19]),
    .I4(CMP_DIN[11]),
    .I5(DIN[11]),
    .O(N19)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i10  (
    .I0(N20),
    .I1(N21),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i9_453 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i10_F  (
    .I0(CMP_DIN[26]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [26]),
    .I2(CMP_DIN[25]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [25]),
    .I4(CMP_DIN[28]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [28]),
    .O(N20)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i10_G  (
    .I0(CMP_DIN[26]),
    .I1(DIN[26]),
    .I2(CMP_DIN[25]),
    .I3(DIN[25]),
    .I4(CMP_DIN[28]),
    .I5(DIN[28]),
    .O(N21)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i15  (
    .I0(N22),
    .I1(N23),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i14_458 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i15_F  (
    .I0(CMP_DIN[37]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [37]),
    .I2(CMP_DIN[39]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [39]),
    .I4(CMP_DIN[31]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [31]),
    .O(N22)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i15_G  (
    .I0(CMP_DIN[37]),
    .I1(DIN[37]),
    .I2(CMP_DIN[39]),
    .I3(DIN[39]),
    .I4(CMP_DIN[31]),
    .I5(DIN[31]),
    .O(N23)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i12  (
    .I0(N24),
    .I1(N25),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i11_455 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i12_F  (
    .I0(CMP_DIN[23]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [23]),
    .I2(CMP_DIN[22]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [22]),
    .I4(CMP_DIN[24]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [24]),
    .O(N24)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i12_G  (
    .I0(CMP_DIN[23]),
    .I1(DIN[23]),
    .I2(CMP_DIN[22]),
    .I3(DIN[22]),
    .I4(CMP_DIN[24]),
    .I5(DIN[24]),
    .O(N25)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i19  (
    .I0(N26),
    .I1(N27),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i18_462 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i19_F  (
    .I0(CMP_DIN[43]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [43]),
    .I2(CMP_DIN[42]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [42]),
    .I4(CMP_DIN[44]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [44]),
    .O(N26)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i19_G  (
    .I0(CMP_DIN[43]),
    .I1(DIN[43]),
    .I2(CMP_DIN[42]),
    .I3(DIN[42]),
    .I4(CMP_DIN[44]),
    .I5(DIN[44]),
    .O(N27)
  );
  MUXF7   \top_cam/rtl_cam/clog/rw_dec_clr_i6  (
    .I0(N28),
    .I1(N29),
    .S(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 ),
    .O(\top_cam/rtl_cam/clog/rw_dec_clr_i5_449 )
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i6_F  (
    .I0(CMP_DIN[16]),
    .I1(\top_cam/rtl_cam/ilog/gwl.din_q [16]),
    .I2(CMP_DIN[15]),
    .I3(\top_cam/rtl_cam/ilog/gwl.din_q [15]),
    .I4(CMP_DIN[18]),
    .I5(\top_cam/rtl_cam/ilog/gwl.din_q [18]),
    .O(N28)
  );
  LUT6 #(
    .INIT ( 64'h6FF6FFFFFFFF6FF6 ))
  \top_cam/rtl_cam/clog/rw_dec_clr_i6_G  (
    .I0(CMP_DIN[16]),
    .I1(DIN[16]),
    .I2(CMP_DIN[15]),
    .I3(DIN[15]),
    .I4(CMP_DIN[18]),
    .I5(DIN[18]),
    .O(N29)
  );
  FDRS #(
    .INIT ( 1'b1 ))
  \top_cam/rtl_cam/clog/int_reg_en_i_2  (
    .C(CLK),
    .D(\top_cam/rtl_cam/clog/int_reg_en_i_112 ),
    .R(\top_cam/rtl_cam/clog/gwsig.end_next_write_WE_MUX_80_o ),
    .S(\top_cam/rtl_cam/clog/gwsig.end_next_write_433 ),
    .Q(\top_cam/rtl_cam/clog/int_reg_en_i_2_504 )
  );
  RAMB36_EXP #(
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .INITP_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_10 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_11 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_12 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_13 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_14 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_15 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_16 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_17 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_18 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_19 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_20 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_21 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_22 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_23 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_24 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_25 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_26 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_27 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_28 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_29 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_30 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_31 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_32 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_33 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_34 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_35 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_36 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_37 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_38 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_39 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_40 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_41 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_42 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_43 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_44 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_45 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_46 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_47 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_48 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_49 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_50 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_51 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_52 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_53 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_54 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_55 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_56 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_57 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_58 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_59 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_60 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_61 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_62 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_63 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_64 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_65 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_66 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_67 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_68 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_69 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_70 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_71 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_72 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_73 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_74 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_75 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_76 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_77 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_78 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_79 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_A ( 36'h000000000 ),
    .INIT_B ( 36'h000000000 ),
    .INIT_FILE ( "NONE" ),
    .RAM_EXTENSION_A ( "NONE" ),
    .RAM_EXTENSION_B ( "NONE" ),
    .READ_WIDTH_A ( 1 ),
    .READ_WIDTH_B ( 36 ),
    .SIM_COLLISION_CHECK ( "NONE" ),
    .SIM_MODE ( "SAFE" ),
    .SRVAL_A ( 36'h000000000 ),
    .SRVAL_B ( 36'h000000000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ),
    .WRITE_WIDTH_A ( 1 ),
    .WRITE_WIDTH_B ( 36 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36  (
    .ENAU(N0),
    .ENAL(N0),
    .ENBU(N0),
    .ENBL(N0),
    .SSRAU(N1),
    .SSRAL(N1),
    .SSRBU(N1),
    .SSRBL(N1),
    .CLKAU(CLK),
    .CLKAL(CLK),
    .CLKBU(CLK),
    .CLKBL(CLK),
    .REGCLKAU(CLK),
    .REGCLKAL(CLK),
    .REGCLKBU(CLK),
    .REGCLKBL(CLK),
    .REGCEAU(N1),
    .REGCEAL(N1),
    .REGCEBU(N1),
    .REGCEBL(N1),
    .CASCADEINLATA(N1),
    .CASCADEINLATB(N1),
    .CASCADEINREGA(N1),
    .CASCADEINREGB(N1),
    .CASCADEOUTLATA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED )
,
    .CASCADEOUTLATB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED )
,
    .CASCADEOUTREGA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED )
,
    .CASCADEOUTREGB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED )
,
    .DIA({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, 
NlwRenamedSig_OI_BUSY}),
    .DIPA({N1, N1, N1, N1}),
    .DIB({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1}),
    .DIPB({N1, N1, N1, N1}),
    .ADDRAL({N0, N1, N1, \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [47], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [46], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [45], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [44], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [43], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [42], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [41], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [40], N1, 
\top_cam/rtl_cam/wr_addr_ilog [3], \top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRAU({N1, N1, \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [47], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [46], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [45], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [44], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [43], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [42], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [41], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [40], N1, 
\top_cam/rtl_cam/wr_addr_ilog [3], \top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRBL({N0, N1, N1, CMP_DIN[47], CMP_DIN[46], CMP_DIN[45], CMP_DIN[44], CMP_DIN[43], CMP_DIN[42], CMP_DIN[41], CMP_DIN[40], N0, N0, N0, N0, N0}),
    .ADDRBU({N1, N1, CMP_DIN[47], CMP_DIN[46], CMP_DIN[45], CMP_DIN[44], CMP_DIN[43], CMP_DIN[42], CMP_DIN[41], CMP_DIN[40], N0, N0, N0, N0, N0}),
    .WEAU({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEAL({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEBU({N1, N1, N1, N1, N1, N1, N1, N1}),
    .WEBL({N1, N1, N1, N1, N1, N1, N1, N1}),
    .DOA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED 
, \NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED 
}),
    .DOPA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED 
}),
    .DOB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED 
, \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [15], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [14], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [13], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [12], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [11], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [10], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [9], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [8], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [7], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [6], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [5], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [4], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [3], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [2], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [1], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(4) [0]}),
    .DOPB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED 
, 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[4].gincp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED 
})
  );
  RAMB36_EXP #(
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .INITP_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_10 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_11 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_12 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_13 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_14 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_15 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_16 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_17 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_18 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_19 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_20 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_21 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_22 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_23 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_24 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_25 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_26 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_27 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_28 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_29 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_30 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_31 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_32 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_33 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_34 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_35 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_36 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_37 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_38 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_39 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_40 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_41 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_42 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_43 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_44 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_45 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_46 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_47 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_48 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_49 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_50 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_51 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_52 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_53 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_54 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_55 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_56 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_57 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_58 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_59 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_60 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_61 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_62 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_63 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_64 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_65 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_66 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_67 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_68 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_69 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_70 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_71 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_72 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_73 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_74 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_75 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_76 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_77 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_78 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_79 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_A ( 36'h000000000 ),
    .INIT_B ( 36'h000000000 ),
    .INIT_FILE ( "NONE" ),
    .RAM_EXTENSION_A ( "NONE" ),
    .RAM_EXTENSION_B ( "NONE" ),
    .READ_WIDTH_A ( 1 ),
    .READ_WIDTH_B ( 36 ),
    .SIM_COLLISION_CHECK ( "NONE" ),
    .SIM_MODE ( "SAFE" ),
    .SRVAL_A ( 36'h000000000 ),
    .SRVAL_B ( 36'h000000000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ),
    .WRITE_WIDTH_A ( 1 ),
    .WRITE_WIDTH_B ( 36 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36  (
    .ENAU(N0),
    .ENAL(N0),
    .ENBU(N0),
    .ENBL(N0),
    .SSRAU(N1),
    .SSRAL(N1),
    .SSRBU(N1),
    .SSRBL(N1),
    .CLKAU(CLK),
    .CLKAL(CLK),
    .CLKBU(CLK),
    .CLKBL(CLK),
    .REGCLKAU(CLK),
    .REGCLKAL(CLK),
    .REGCLKBU(CLK),
    .REGCLKBL(CLK),
    .REGCEAU(N1),
    .REGCEAL(N1),
    .REGCEBU(N1),
    .REGCEBL(N1),
    .CASCADEINLATA(N1),
    .CASCADEINLATB(N1),
    .CASCADEINREGA(N1),
    .CASCADEINREGB(N1),
    .CASCADEOUTLATA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED )
,
    .CASCADEOUTLATB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED )
,
    .CASCADEOUTREGA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED )
,
    .CASCADEOUTREGB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED )
,
    .DIA({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, 
NlwRenamedSig_OI_BUSY}),
    .DIPA({N1, N1, N1, N1}),
    .DIB({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1}),
    .DIPB({N1, N1, N1, N1}),
    .ADDRAL({N0, \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [39], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [38], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [37], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [36], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [35], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [34], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [33], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [32], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [31], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [30], N1, \top_cam/rtl_cam/wr_addr_ilog [3], 
\top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRAU({\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [39], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [38], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [37], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [36], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [35], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [34], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [33], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [32], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [31], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [30], N1, \top_cam/rtl_cam/wr_addr_ilog [3], 
\top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRBL({N0, CMP_DIN[39], CMP_DIN[38], CMP_DIN[37], CMP_DIN[36], CMP_DIN[35], CMP_DIN[34], CMP_DIN[33], CMP_DIN[32], CMP_DIN[31], CMP_DIN[30], N0
, N0, N0, N0, N0}),
    .ADDRBU({CMP_DIN[39], CMP_DIN[38], CMP_DIN[37], CMP_DIN[36], CMP_DIN[35], CMP_DIN[34], CMP_DIN[33], CMP_DIN[32], CMP_DIN[31], CMP_DIN[30], N0, N0
, N0, N0, N0}),
    .WEAU({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEAL({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEBU({N1, N1, N1, N1, N1, N1, N1, N1}),
    .WEBL({N1, N1, N1, N1, N1, N1, N1, N1}),
    .DOA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED }),
    .DOPA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED }),
    .DOB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED , 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [15], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [14], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [13], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [12], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [11], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [10], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [9], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [8], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [7], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [6], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [5], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [4], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [3], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [2], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [1], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(3) [0]}),
    .DOPB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[3].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED })
  );
  RAMB36_EXP #(
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .INITP_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_10 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_11 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_12 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_13 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_14 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_15 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_16 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_17 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_18 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_19 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_20 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_21 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_22 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_23 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_24 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_25 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_26 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_27 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_28 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_29 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_30 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_31 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_32 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_33 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_34 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_35 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_36 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_37 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_38 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_39 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_40 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_41 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_42 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_43 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_44 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_45 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_46 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_47 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_48 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_49 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_50 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_51 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_52 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_53 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_54 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_55 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_56 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_57 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_58 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_59 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_60 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_61 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_62 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_63 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_64 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_65 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_66 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_67 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_68 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_69 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_70 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_71 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_72 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_73 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_74 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_75 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_76 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_77 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_78 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_79 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_A ( 36'h000000000 ),
    .INIT_B ( 36'h000000000 ),
    .INIT_FILE ( "NONE" ),
    .RAM_EXTENSION_A ( "NONE" ),
    .RAM_EXTENSION_B ( "NONE" ),
    .READ_WIDTH_A ( 1 ),
    .READ_WIDTH_B ( 36 ),
    .SIM_COLLISION_CHECK ( "NONE" ),
    .SIM_MODE ( "SAFE" ),
    .SRVAL_A ( 36'h000000000 ),
    .SRVAL_B ( 36'h000000000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ),
    .WRITE_WIDTH_A ( 1 ),
    .WRITE_WIDTH_B ( 36 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36  (
    .ENAU(N0),
    .ENAL(N0),
    .ENBU(N0),
    .ENBL(N0),
    .SSRAU(N1),
    .SSRAL(N1),
    .SSRBU(N1),
    .SSRBL(N1),
    .CLKAU(CLK),
    .CLKAL(CLK),
    .CLKBU(CLK),
    .CLKBL(CLK),
    .REGCLKAU(CLK),
    .REGCLKAL(CLK),
    .REGCLKBU(CLK),
    .REGCLKBL(CLK),
    .REGCEAU(N1),
    .REGCEAL(N1),
    .REGCEBU(N1),
    .REGCEBL(N1),
    .CASCADEINLATA(N1),
    .CASCADEINLATB(N1),
    .CASCADEINREGA(N1),
    .CASCADEINREGB(N1),
    .CASCADEOUTLATA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED )
,
    .CASCADEOUTLATB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED )
,
    .CASCADEOUTREGA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED )
,
    .CASCADEOUTREGB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED )
,
    .DIA({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, 
NlwRenamedSig_OI_BUSY}),
    .DIPA({N1, N1, N1, N1}),
    .DIB({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1}),
    .DIPB({N1, N1, N1, N1}),
    .ADDRAL({N0, \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [29], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [28], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [27], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [26], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [25], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [24], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [23], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [22], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [21], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [20], N1, \top_cam/rtl_cam/wr_addr_ilog [3], 
\top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRAU({\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [29], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [28], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [27], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [26], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [25], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [24], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [23], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [22], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [21], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [20], N1, \top_cam/rtl_cam/wr_addr_ilog [3], 
\top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRBL({N0, CMP_DIN[29], CMP_DIN[28], CMP_DIN[27], CMP_DIN[26], CMP_DIN[25], CMP_DIN[24], CMP_DIN[23], CMP_DIN[22], CMP_DIN[21], CMP_DIN[20], N0
, N0, N0, N0, N0}),
    .ADDRBU({CMP_DIN[29], CMP_DIN[28], CMP_DIN[27], CMP_DIN[26], CMP_DIN[25], CMP_DIN[24], CMP_DIN[23], CMP_DIN[22], CMP_DIN[21], CMP_DIN[20], N0, N0
, N0, N0, N0}),
    .WEAU({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEAL({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEBU({N1, N1, N1, N1, N1, N1, N1, N1}),
    .WEBL({N1, N1, N1, N1, N1, N1, N1, N1}),
    .DOA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED }),
    .DOPA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED }),
    .DOB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED , 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [15], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [14], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [13], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [12], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [11], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [10], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [9], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [8], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [7], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [6], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [5], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [4], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [3], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [2], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [1], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(2) [0]}),
    .DOPB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[2].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED })
  );
  RAMB36_EXP #(
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .INITP_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_10 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_11 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_12 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_13 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_14 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_15 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_16 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_17 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_18 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_19 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_20 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_21 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_22 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_23 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_24 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_25 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_26 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_27 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_28 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_29 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_30 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_31 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_32 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_33 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_34 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_35 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_36 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_37 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_38 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_39 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_40 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_41 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_42 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_43 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_44 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_45 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_46 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_47 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_48 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_49 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_50 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_51 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_52 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_53 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_54 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_55 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_56 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_57 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_58 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_59 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_60 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_61 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_62 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_63 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_64 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_65 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_66 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_67 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_68 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_69 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_70 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_71 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_72 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_73 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_74 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_75 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_76 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_77 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_78 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_79 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_A ( 36'h000000000 ),
    .INIT_B ( 36'h000000000 ),
    .INIT_FILE ( "NONE" ),
    .RAM_EXTENSION_A ( "NONE" ),
    .RAM_EXTENSION_B ( "NONE" ),
    .READ_WIDTH_A ( 1 ),
    .READ_WIDTH_B ( 36 ),
    .SIM_COLLISION_CHECK ( "NONE" ),
    .SIM_MODE ( "SAFE" ),
    .SRVAL_A ( 36'h000000000 ),
    .SRVAL_B ( 36'h000000000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ),
    .WRITE_WIDTH_A ( 1 ),
    .WRITE_WIDTH_B ( 36 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36  (
    .ENAU(N0),
    .ENAL(N0),
    .ENBU(N0),
    .ENBL(N0),
    .SSRAU(N1),
    .SSRAL(N1),
    .SSRBU(N1),
    .SSRBL(N1),
    .CLKAU(CLK),
    .CLKAL(CLK),
    .CLKBU(CLK),
    .CLKBL(CLK),
    .REGCLKAU(CLK),
    .REGCLKAL(CLK),
    .REGCLKBU(CLK),
    .REGCLKBL(CLK),
    .REGCEAU(N1),
    .REGCEAL(N1),
    .REGCEBU(N1),
    .REGCEBL(N1),
    .CASCADEINLATA(N1),
    .CASCADEINLATB(N1),
    .CASCADEINREGA(N1),
    .CASCADEINREGB(N1),
    .CASCADEOUTLATA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED )
,
    .CASCADEOUTLATB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED )
,
    .CASCADEOUTREGA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED )
,
    .CASCADEOUTREGB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED )
,
    .DIA({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, 
NlwRenamedSig_OI_BUSY}),
    .DIPA({N1, N1, N1, N1}),
    .DIB({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1}),
    .DIPB({N1, N1, N1, N1}),
    .ADDRAL({N0, \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [19], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [18], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [17], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [16], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [15], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [14], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [13], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [12], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [11], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [10], N1, \top_cam/rtl_cam/wr_addr_ilog [3], 
\top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRAU({\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [19], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [18], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [17], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [16], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [15], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [14], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [13], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [12], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [11], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [10], N1, \top_cam/rtl_cam/wr_addr_ilog [3], 
\top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRBL({N0, CMP_DIN[19], CMP_DIN[18], CMP_DIN[17], CMP_DIN[16], CMP_DIN[15], CMP_DIN[14], CMP_DIN[13], CMP_DIN[12], CMP_DIN[11], CMP_DIN[10], N0
, N0, N0, N0, N0}),
    .ADDRBU({CMP_DIN[19], CMP_DIN[18], CMP_DIN[17], CMP_DIN[16], CMP_DIN[15], CMP_DIN[14], CMP_DIN[13], CMP_DIN[12], CMP_DIN[11], CMP_DIN[10], N0, N0
, N0, N0, N0}),
    .WEAU({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEAL({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEBU({N1, N1, N1, N1, N1, N1, N1, N1}),
    .WEBL({N1, N1, N1, N1, N1, N1, N1, N1}),
    .DOA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED }),
    .DOPA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED }),
    .DOB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED , 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [15], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [14], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [13], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [12], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [11], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [10], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [9], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [8], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [7], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [6], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [5], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [4], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [3], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [2], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [1], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(1) [0]}),
    .DOPB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[1].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED })
  );
  RAMB36_EXP #(
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .INITP_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_10 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_11 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_12 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_13 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_14 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_15 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_16 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_17 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_18 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_19 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_20 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_21 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_22 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_23 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_24 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_25 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_26 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_27 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_28 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_29 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_2F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_30 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_31 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_32 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_33 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_34 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_35 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_36 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_37 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_38 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_39 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_3F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_40 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_41 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_42 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_43 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_44 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_45 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_46 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_47 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_48 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_49 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_4F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_50 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_51 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_52 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_53 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_54 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_55 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_56 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_57 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_58 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_59 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_5F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_60 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_61 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_62 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_63 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_64 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_65 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_66 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_67 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_68 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_69 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_6F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_70 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_71 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_72 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_73 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_74 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_75 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_76 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_77 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_78 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_79 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_7F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_A ( 36'h000000000 ),
    .INIT_B ( 36'h000000000 ),
    .INIT_FILE ( "NONE" ),
    .RAM_EXTENSION_A ( "NONE" ),
    .RAM_EXTENSION_B ( "NONE" ),
    .READ_WIDTH_A ( 1 ),
    .READ_WIDTH_B ( 36 ),
    .SIM_COLLISION_CHECK ( "NONE" ),
    .SIM_MODE ( "SAFE" ),
    .SRVAL_A ( 36'h000000000 ),
    .SRVAL_B ( 36'h000000000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ),
    .WRITE_WIDTH_A ( 1 ),
    .WRITE_WIDTH_B ( 36 ))
  \top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36  (
    .ENAU(N0),
    .ENAL(N0),
    .ENBU(N0),
    .ENBL(N0),
    .SSRAU(N1),
    .SSRAL(N1),
    .SSRBU(N1),
    .SSRBL(N1),
    .CLKAU(CLK),
    .CLKAL(CLK),
    .CLKBU(CLK),
    .CLKBL(CLK),
    .REGCLKAU(CLK),
    .REGCLKAL(CLK),
    .REGCLKBU(CLK),
    .REGCLKBL(CLK),
    .REGCEAU(N1),
    .REGCEAL(N1),
    .REGCEBU(N1),
    .REGCEBL(N1),
    .CASCADEINLATA(N1),
    .CASCADEINLATB(N1),
    .CASCADEINREGA(N1),
    .CASCADEINREGB(N1),
    .CASCADEOUTLATA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATA_UNCONNECTED )
,
    .CASCADEOUTLATB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTLATB_UNCONNECTED )
,
    .CASCADEOUTREGA
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGA_UNCONNECTED )
,
    .CASCADEOUTREGB
(\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_CASCADEOUTREGB_UNCONNECTED )
,
    .DIA({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, 
NlwRenamedSig_OI_BUSY}),
    .DIPA({N1, N1, N1, N1}),
    .DIB({N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1, N1}),
    .DIPB({N1, N1, N1, N1}),
    .ADDRAL({N0, \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [9], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [8], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [7], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [6], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [5], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [4], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [3], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [2], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [1], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [0], N1, \top_cam/rtl_cam/wr_addr_ilog [3], 
\top_cam/rtl_cam/wr_addr_ilog [2], \top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRAU({\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [9], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [8], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [7]
, \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [6], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [5], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [4], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [3], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [2], \top_cam/rtl_cam/mem/gblk.blkmem/mux_out [1], 
\top_cam/rtl_cam/mem/gblk.blkmem/mux_out [0], N1, \top_cam/rtl_cam/wr_addr_ilog [3], \top_cam/rtl_cam/wr_addr_ilog [2], 
\top_cam/rtl_cam/wr_addr_ilog [1], \top_cam/rtl_cam/wr_addr_ilog [0]}),
    .ADDRBL({N0, CMP_DIN[9], CMP_DIN[8], CMP_DIN[7], CMP_DIN[6], CMP_DIN[5], CMP_DIN[4], CMP_DIN[3], CMP_DIN[2], CMP_DIN[1], CMP_DIN[0], N0, N0, N0, 
N0, N0}),
    .ADDRBU({CMP_DIN[9], CMP_DIN[8], CMP_DIN[7], CMP_DIN[6], CMP_DIN[5], CMP_DIN[4], CMP_DIN[3], CMP_DIN[2], CMP_DIN[1], CMP_DIN[0], N0, N0, N0, N0, 
N0}),
    .WEAU({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEAL({\top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren , \top_cam/rtl_cam/wren }),
    .WEBU({N1, N1, N1, N1, N1, N1, N1, N1}),
    .WEBL({N1, N1, N1, N1, N1, N1, N1, N1}),
    .DOA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(31)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(30)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(29)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(28)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(27)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(26)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(25)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(24)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(23)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(22)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(21)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(20)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(19)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(18)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(17)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(16)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(15)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(14)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(13)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(12)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(11)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(10)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(9)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(8)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(7)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(6)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(5)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(4)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOA(0)_UNCONNECTED }),
    .DOPA({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPA(0)_UNCONNECTED }),
    .DOB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(31)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(30)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(29)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(28)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(27)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(26)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(25)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(24)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(23)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(22)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(21)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(20)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(19)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(18)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(17)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOB(16)_UNCONNECTED , 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [15], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [14], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [13], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [12], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [11], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [10], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [9], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [8], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [7], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [6], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [5], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [4], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [3], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [2], 
\top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [1], \top_cam/rtl_cam/mem/gblk.blkmem/matches_vector(0) [0]}),
    .DOPB({
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(3)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(2)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(1)_UNCONNECTED , 
\NLW_top_cam/rtl_cam/mem/gblk.blkmem/gextw[0].gcp.extd/gextd[0].gincp.extdp/v5prim.BRAM_TDP_MACRO_inst/ramb_v5.ramb36_dp.ram36_DOPB(0)_UNCONNECTED })
  );
  LUT6 #(
    .INIT ( 64'hDDFDDDFD0000DDFD ))
  \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_61  (
    .I0(\top_cam/rtl_cam/matches[14] ),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [14]),
    .I2(\top_cam/rtl_cam/matches[13] ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [13]),
    .I4(\top_cam/rtl_cam/matches[12] ),
    .I5(\top_cam/rtl_cam/mlog/blkmem_match_disable [12]),
    .O(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_6 )
  );
  LUT5 #(
    .INIT ( 32'hF7A2F7F7 ))
  \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_511  (
    .I0(\top_cam/rtl_cam/mlog/binad.bin_proc.bin_matches_tmp(2) [1]),
    .I1(\top_cam/rtl_cam/matches[8] ),
    .I2(\top_cam/rtl_cam/mlog/blkmem_match_disable [8]),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [10]),
    .I4(\top_cam/rtl_cam/matches[10] ),
    .O(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_51_408 )
  );
  LUT6 #(
    .INIT ( 64'hDDFDDDFD0000DDFD ))
  \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_51  (
    .I0(\top_cam/rtl_cam/matches[6] ),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [6]),
    .I2(\top_cam/rtl_cam/matches[5] ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [5]),
    .I4(\top_cam/rtl_cam/matches[4] ),
    .I5(\top_cam/rtl_cam/mlog/blkmem_match_disable [4]),
    .O(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_5 )
  );
  LUT6 #(
    .INIT ( 64'hDDFDDDFD0000DDFD ))
  \top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_41  (
    .I0(\top_cam/rtl_cam/matches[2] ),
    .I1(\top_cam/rtl_cam/mlog/blkmem_match_disable [2]),
    .I2(\top_cam/rtl_cam/matches[1] ),
    .I3(\top_cam/rtl_cam/mlog/blkmem_match_disable [1]),
    .I4(\top_cam/rtl_cam/matches[0] ),
    .I5(\top_cam/rtl_cam/mlog/blkmem_match_disable [0]),
    .O(\top_cam/rtl_cam/mlog/Mmux_binad.bin_proc.bin_matches_tmp(0)(0)_4 )
  );
// synthesis translate_on
endmodule


`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

