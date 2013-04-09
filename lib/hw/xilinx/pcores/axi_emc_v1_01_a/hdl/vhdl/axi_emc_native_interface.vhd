-------------------------------------------------------------------------------
--  axi_emc_native_interface - entity/architecture pair
-------------------------------------------------------------------------------
--
-- ************************************************************************
-- ** DISCLAIMER OF LIABILITY                                            **
-- **                                                                    **
-- ** This file contains proprietary and confidential information of     **
-- ** Xilinx, Inc. ("Xilinx"), that is distributed under a license       **
-- ** from Xilinx, and may be used, copied and/or disclosed only         **
-- ** pursuant to the terms of a valid license agreement with Xilinx.    **
-- **                                                                    **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION              **
-- ** ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER         **
-- ** EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                **
-- ** LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,          **
-- ** MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx      **
-- ** does not warrant that functions included in the Materials will     **
-- ** meet the requirements of Licensee, or that the operation of the    **
-- ** Materials will be uninterrupted or error-free, or that defects     **
-- ** in the Materials will be corrected. Furthermore, Xilinx does       **
-- ** not warrant or make any representations regarding use, or the      **
-- ** results of the use, of the Materials in terms of correctness,      **
-- ** accuracy, reliability or otherwise.                                **
-- **                                                                    **
-- ** Xilinx products are not designed or intended to be fail-safe,      **
-- ** or for use in any application requiring fail-safe performance,     **
-- ** such as life-support or safety devices or systems, Class III       **
-- ** medical devices, nuclear facilities, applications related to       **
-- ** the deployment of airbags, or any other applications that could    **
-- ** lead to death, personal injury or severe property or               **
-- ** environmental damage (individually and collectively, "critical     **
-- ** applications"). Customer assumes the sole risk and liability       **
-- ** of any use of Xilinx products in critical applications,            **
-- ** subject only to applicable laws and regulations governing          **
-- ** limitations on product liability.                                  **
-- **                                                                    **
-- ** Copyright 1995-2011 Xilinx, Inc.                                   **
-- ** All rights reserved.                                               **
-- **                                                                    **
-- ** This disclaimer and copyright notice must be retained as part      **
-- ** of this file at all times.                                         **
-- ************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        axi_emc_native_interface.vhd
-- Version:         v1.01.a
-- Description:     Native AXI interface to the EMC core.
-------------------------------------------------------------------------------
-- Structure:
--              axi_emc.vhd
--                  -- axi_emc_native_interface.vhd
--                     -- axi_emc_addr_gen.vhd
--                     -- axi_emc_address_decode.vhd
--                  -- emc.vhd
--                      -- ipic_if.vhd
--                      -- addr_counter_mux.vhd
--                      -- counters.vhd
--                      -- select_param.vhd
--                      -- mem_state_machine.vhd
--                      -- mem_steer.vhd
--                      -- io_registers.vhd
-------------------------------------------------------------------------------
-- Author:      SK
--
-- History:
-- ~~~~~~
--  SK 09/20/10
-- ^^^^^^
--  -- Designed the native interface for AXI to reduce the utilization of core.
--  -- Added "enable_rdce_cmb   <= '0'; in the default signal lists in state machine.
-- ~~~~~~
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_misc.all;
-- library unsigned is used for overloading of "=" which allows integer to
-- be compared to std_logic_vector
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;
use proc_common_v3_00_a.family.all;
use proc_common_v3_00_a.all;

library axi_emc_v1_01_a;
    use axi_emc_v1_01_a.all;

----------------------------------------------------------------------------
entity axi_emc_native_interface is
   -- Generics to be set by user
    generic (

        C_FAMILY                       : string := "virtex6";
        ---- AXI MEM Parameters
        C_S_AXI_MEM_ADDR_WIDTH         : integer range 32 to 32 := 32;
        C_S_AXI_MEM_DATA_WIDTH         : integer                := 32;--8,16,32,64
        C_S_AXI_MEM_ID_WIDTH           : integer range 1  to 16 := 4;

        C_S_AXI_MEM0_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_MEM0_HIGHADDR          : std_logic_vector := x"00000000";
        C_S_AXI_MEM1_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_MEM1_HIGHADDR          : std_logic_vector := x"00000000";
        C_S_AXI_MEM2_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_MEM2_HIGHADDR          : std_logic_vector := x"00000000";
        C_S_AXI_MEM3_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_S_AXI_MEM3_HIGHADDR          : std_logic_vector := x"00000000";

        AXI_ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE :=
       (
         X"0000_0000_7000_0000", -- IP user0 base address
         X"0000_0000_7000_00FF", -- IP user0 high address

         X"0000_0000_7000_0100", -- IP user1 base address
         X"0000_0000_7000_01FF"  -- IP user1 high address
       );
       AXI_ARD_NUM_CE_ARRAY     : INTEGER_ARRAY_TYPE :=
        (
          1,         -- User0 CE Number -- only 1 is supported per addr range
          1          -- User1 CE Number -- only 1 is supported per addr range
       );
        C_NUM_BANKS_MEM         : integer

        );
   port(
    S_AXI_ACLK          : in  std_logic;
    S_AXI_ARESETN       : in  std_logic;
--   -- AXI Write Address Channel Signals
    S_AXI_MEM_AWID    : in  std_logic_vector((C_S_AXI_MEM_ID_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_AWADDR  : in  std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_AWLEN   : in  std_logic_vector(7 downto 0);
    S_AXI_MEM_AWSIZE  : in  std_logic_vector(2 downto 0);
    S_AXI_MEM_AWBURST : in  std_logic_vector(1 downto 0);
    S_AXI_MEM_AWLOCK  : in  std_logic;
    S_AXI_MEM_AWCACHE : in  std_logic_vector(3 downto 0);
    S_AXI_MEM_AWPROT  : in  std_logic_vector(2 downto 0);
    S_AXI_MEM_AWVALID : in  std_logic;
    S_AXI_MEM_AWREADY : out std_logic;
--   -- AXI Write Channel Signals
    S_AXI_MEM_WDATA   : in  std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_WSTRB   : in  std_logic_vector
                            (((C_S_AXI_MEM_DATA_WIDTH/8)-1) downto 0);
    S_AXI_MEM_WLAST   : in  std_logic;
    S_AXI_MEM_WVALID  : in  std_logic;
    S_AXI_MEM_WREADY  : out std_logic;
--   -- AXI Write Response Channel Signals
    S_AXI_MEM_BID     : out std_logic_vector((C_S_AXI_MEM_ID_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_BRESP   : out std_logic_vector(1 downto 0);
    S_AXI_MEM_BVALID  : out std_logic;
    S_AXI_MEM_BREADY  : in  std_logic;
--   -- AXI Read Address Channel Signals
    S_AXI_MEM_ARID    : in  std_logic_vector((C_S_AXI_MEM_ID_WIDTH-1) downto 0);
    S_AXI_MEM_ARADDR  : in  std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1) downto 0);
    S_AXI_MEM_ARLEN   : in  std_logic_vector(7 downto 0);
    S_AXI_MEM_ARSIZE  : in  std_logic_vector(2 downto 0);
    S_AXI_MEM_ARBURST : in  std_logic_vector(1 downto 0);
    S_AXI_MEM_ARLOCK  : in  std_logic;
    S_AXI_MEM_ARCACHE : in  std_logic_vector(3 downto 0);
    S_AXI_MEM_ARPROT  : in  std_logic_vector(2 downto 0);
    S_AXI_MEM_ARVALID : in  std_logic;
    S_AXI_MEM_ARREADY : out std_logic;

--   -- AXI Read Data Channel Signals
    S_AXI_MEM_RID     : out std_logic_vector((C_S_AXI_MEM_ID_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_RDATA   : out std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1)
                                                                downto 0);
    S_AXI_MEM_RRESP   : out std_logic_vector(1 downto 0);
    S_AXI_MEM_RLAST   : out std_logic;
    S_AXI_MEM_RVALID  : out std_logic;
    S_AXI_MEM_RREADY  : in  std_logic;

-- IP Interconnect (IPIC) port signals ------------------------------------
      -- Controls to the IP/IPIF modules
    -- IP Interconnect (IPIC) port signals
    IP2Bus_Data       : in std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1) downto 0);
    IP2Bus_WrAck      : in std_logic;
    IP2Bus_RdAck      : in std_logic;
    IP2Bus_AddrAck    : in std_logic;
    IP2Bus_Error      : in std_logic;

    -- these signals are generate little endian but reveresed in the top level file
    Bus2IP_Addr       : out std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1) downto 0);
    Bus2IP_Data       : out std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1) downto 0);
    Bus2IP_RNW        : out std_logic;
    Bus2IP_BE         : out std_logic_vector(((C_S_AXI_MEM_DATA_WIDTH/8)-1)downto 0);
    Bus2IP_Burst      : out std_logic;

    Bus2IP_BurstLength : out std_logic_vector(7 downto 0);
    Bus2IP_RdReq       : out std_logic;
    Bus2IP_WrReq       : out std_logic;
    Bus2IP_CS       : out std_logic_vector
                              (((AXI_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1 downto 0);
    Bus2IP_RdCE     : out std_logic_vector
                              (0 to calc_num_ce(AXI_ARD_NUM_CE_ARRAY)-1);
    Bus2IP_WrCE     : out std_logic_vector
                              (0 to calc_num_ce(AXI_ARD_NUM_CE_ARRAY)-1);
    Type_of_xfer    : out std_logic
    );
end axi_emc_native_interface;
-----------------------------------------------------------------------------

architecture imp of axi_emc_native_interface is
----------------------------------

constant ACTIVE_LOW_RESET    : integer := 0;
constant C_RDATA_FIFO_DEPTH  : integer := 32;
constant COUNTER_WIDTH       : integer := clog2(C_RDATA_FIFO_DEPTH);
constant ZERO_ADDR_PAD  : std_logic_vector(0 to 64-C_S_AXI_MEM_ADDR_WIDTH-1)
                        := (others => '0');

constant RD_DATA_FIFO_DWIDTH : integer := (C_S_AXI_MEM_DATA_WIDTH+1);
constant ALL_1               : std_logic_vector(0 to COUNTER_WIDTH-1)
                             := (others => '1');
constant ZEROES              : std_logic_vector(0 to clog2(C_RDATA_FIFO_DEPTH)-1)
                             := (others => '0');

-- local type declarations
   type decode_bit_array_type is Array(natural range 0 to (
                           (AXI_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1) of
                           integer;

   type short_addr_array_type is Array(natural range 0 to
                           AXI_ARD_ADDR_RANGE_ARRAY'LENGTH-1) of
                           std_logic_vector(0 to(C_S_AXI_MEM_ADDR_WIDTH-1));
-----------------------------------------------------------------------------
   ----------------------------------------------------------------------------
-- This function converts a 64 bit address range array to a AWIDTH bit
-- address range array.
   ----------------------------------------------------------------------------
   function slv64_2_slv_awidth(slv64_addr_array   : SLV64_ARRAY_TYPE;
                               awidth             : integer)
                        return short_addr_array_type is

    variable temp_addr   : std_logic_vector(0 to 63);
    variable slv_array   : short_addr_array_type;
    begin
        for array_index in 0 to slv64_addr_array'length-1 loop
            temp_addr := slv64_addr_array(array_index);
            slv_array(array_index) := temp_addr((64-awidth) to 63);
        end loop;
    --coverage off
        return(slv_array);
    --coverage on
   end function slv64_2_slv_awidth;
   ----------------------------------------------------------------------------
-------------------------------------------------------------------------------
   constant NUM_CE_SIGNALS       : integer :=
                                    calc_num_ce(AXI_ARD_NUM_CE_ARRAY);

   signal pselect_hit_i    : std_logic_vector
                            (0 to ((AXI_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
   signal cs_out_i         : std_logic_vector
                            (0 to ((AXI_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
   signal ce_expnd_i       : std_logic_vector(0 to NUM_CE_SIGNALS-1);
   signal rdce_out_i       : std_logic_vector(0 to NUM_CE_SIGNALS-1);
   signal wrce_out_i       : std_logic_vector(0 to NUM_CE_SIGNALS-1);
   signal cs_reg           : std_logic_vector
                            (0 to ((AXI_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1)
                           :=(others => '0');
   signal rd_data_fifo_error : std_logic;
   signal last_rd_data_cmb   : std_logic;
   signal rd_fifo_full       : std_logic;
   signal fifo_empty         : std_logic;
   signal last_fifo_data     : std_logic;
   signal rd_fifo_out        : std_logic_vector(C_S_AXI_MEM_DATA_WIDTH downto 0);
   signal rd_data_count      : std_logic_vector(7 downto 0);
   signal ORed_cs : std_logic;

---------------------------------------
type STATE_TYPE is
                  (IDLE,
                   RD,
                   RD_LAST,
                   WR,
                   WR_WAIT,
                   WR_RESP,
                   WR_LAST,
                   RESP);
signal emc_addr_ps: STATE_TYPE;
signal emc_addr_ns: STATE_TYPE;
-----------------------------------------
signal single_transfer_cmb : std_logic;

signal addr_sm_ps_IDLE_reg : std_logic;
signal addr_sm_ns_IDLE_cmb : std_logic;
signal wr_transaction      : std_logic;
signal wr_addr_transaction : std_logic;

signal fifo_full           : std_logic;
signal bvalid_cmb          : std_logic;
signal enable_cs_cmb       : std_logic;
signal rst_wrce_cmb        : std_logic;
signal rst_rdce_cmb        : std_logic;
signal rd_fifo_wr_en       : std_logic;
signal rd_fifo_rd_en       : std_logic;
signal type_of_xfer_reg    : std_logic;
signal Type_of_xfer_cmb    : std_logic;

signal addr_sm_ps_idle_cmb : std_logic;
signal last_burst_cnt : std_logic;
--IPIC request qualifier signals

signal ip2bus_errack        : std_logic;

signal rd_fifo_data_in     : std_logic_vector(C_S_AXI_MEM_DATA_WIDTH downto 0);
signal rd_fifo_data_out    : std_logic_vector(C_S_AXI_MEM_DATA_WIDTH downto 0);

signal burst_length_cmb    : std_logic_vector(7 downto 0);
signal addr_int_cmb        : std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1) downto 0);
signal bus2ip_addr_i       : std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1) downto 0);
signal derived_len_reg     : std_logic_vector (3 downto 0);
signal size_cmb            : std_logic_vector (1 downto 0);
signal bus2ip_data_reg     : std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1) downto 0);
signal bus2ip_BE_reg       : std_logic_vector(((C_S_AXI_MEM_DATA_WIDTH/8)-1)downto 0);
signal Bus2ip_BE_cmb       : std_logic_vector(((C_S_AXI_MEM_DATA_WIDTH/8)-1)downto 0);

signal s_axi_mem_awready_reg : std_logic;
signal s_axi_mem_wready_reg  : std_logic;
signal s_axi_mem_bid_reg     : std_logic_vector (C_S_AXI_MEM_ID_WIDTH-1 downto 0);
signal s_axi_mem_bresp_reg   : std_logic_vector (1 downto 0);
signal s_axi_mem_bvalid_reg  : std_logic;
signal s_axi_mem_arready_reg : std_logic;
signal s_axi_mem_rid_reg     : std_logic_vector (C_S_AXI_MEM_ID_WIDTH-1 downto 0);
signal s_axi_mem_rresp_reg   : std_logic_vector (1 downto 0);
signal s_axi_mem_rlast_reg   : std_logic;
signal s_axi_mem_rvalid_reg  : std_logic;
signal  s_axi_mem_rdata_i    : std_logic_vector(C_S_AXI_MEM_DATA_WIDTH-1 downto 0);
signal  s_axi_mem_rdata_reg  : std_logic_vector(C_S_AXI_MEM_DATA_WIDTH-1 downto 0);

signal arready_cmb       : std_logic;
signal awready_cmb       : std_logic;
signal rw_flag_reg       : std_logic;

signal wready_cmb        : std_logic;
signal bus2ip_burst_reg  : std_logic ;
signal rnw_reg           : std_logic ;
signal rnw_cmb           : std_logic ;
signal store_addr_info_cmb  : std_logic ;
signal last_len_cmb      : std_logic ;
signal second_last_cnt   : std_logic;
signal bus2ip_wr_req_reg : std_logic;
signal bus2ip_rd_req_reg : std_logic;
signal burstlength_reg   : std_logic_vector(7 downto 0);

signal bus2ip_wrreq_reg  : std_logic;

signal burst_data_cnt    : std_logic_vector(7 downto 0); -- is not declared.
signal derived_size_reg  : std_logic_vector(1 downto 0); -- is not declared.

signal temp_single_0     : std_logic;
signal temp_single_1     : std_logic;
signal bus2ip_addr_cmb   : std_logic_vector(1 to 2);
signal bus2ip_addr_int   : std_logic_vector(0 to 31);
signal bus2ip_resetn     : std_logic;
signal last_data_cmb     : std_logic;

signal combine_ack       : std_logic;
signal wready_reg        : std_logic;

signal bus2ip_wr_req_cmb : std_logic;
signal bus2ip_rd_req_cmb : std_logic;

signal derived_burst_reg : std_logic_vector(1 downto 0);

signal bus2ip_rnw_i    : std_logic;
signal temp_ip2bus_data: std_logic_vector((C_S_AXI_MEM_DATA_WIDTH-1) downto 0);
signal updn_cnt_en     : std_logic;
signal rd_fifo_empty   : std_logic;
signal active_high_rst : std_logic;

signal burst_addr_cnt   : std_logic_vector(7 downto 0);
signal second_last_addr : std_logic;
signal last_addr        : std_logic;
signal stop_addr_incr   : std_logic;
signal last_rd_reg      : std_logic;
signal last_rd_data_reg : std_logic;
signal enable_rdce_cmb  : std_logic;
signal enable_wrce_combo: std_logic;
signal enable_wrce_cmb  : std_logic;
signal enable_rdce_combo: std_logic;
signal addr_sm_ps_WR_cmb: std_logic;
signal addr_sm_ps_WR_WAIT_cmb: std_logic;
signal rst_cs_cmb            : std_logic;
signal single_transfer_reg   : std_logic;
signal last_data_acked       : std_logic;

signal cnt                   : std_logic_vector((COUNTER_WIDTH-1) downto 0);
signal RdFIFO_Space_two_int  : std_logic;
signal no_space_in_fifo      : std_logic;
-----------------------------------
begin
------

ACTIVE_HIGH_RST_P: process (S_AXI_ACLK) is
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        active_high_rst <= not(S_AXI_ARESETN);
    end if;
end process ACTIVE_HIGH_RST_P;
-----------------------------------
-- AXI Side interface
---------------------
S_AXI_MEM_AWREADY  <= awready_cmb;
S_AXI_MEM_WREADY   <= wready_cmb;
S_AXI_MEM_BID      <= s_axi_mem_bid_reg;
S_AXI_MEM_BRESP    <= s_axi_mem_bresp_reg;
S_AXI_MEM_BVALID   <= s_axi_mem_bvalid_reg;

S_AXI_MEM_ARREADY  <= arready_cmb;
S_AXI_MEM_RID      <= s_axi_mem_rid_reg;
S_AXI_MEM_RRESP    <= s_axi_mem_rresp_reg;
S_AXI_MEM_RLAST    <= s_axi_mem_rlast_reg;
S_AXI_MEM_RVALID   <= s_axi_mem_rvalid_reg;
S_AXI_MEM_RDATA    <= s_axi_mem_rdata_reg;
-----------------------
-- REG_BID_P,REG_RID_P: Below process makes the RID and BID '0' at POR and
--                    : generate proper values based upon read/write
--                      transaction
-----------------------
S_AXI_MEM_RID_P: process (S_AXI_ACLK) is
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
       if (S_AXI_ARESETN='0') then
         s_axi_mem_rid_reg       <= (others=> '0');
       elsif(arready_cmb='1')then
         s_axi_mem_rid_reg       <= S_AXI_MEM_ARID;
       end if;
    end if;
end process S_AXI_MEM_RID_P;
----------------------
S_AXI_MEM_BID_P: process (S_AXI_ACLK) is
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
       if (S_AXI_ARESETN='0') then
         s_axi_mem_bid_reg       <= (others=> '0');
       elsif(awready_cmb='1')then
         s_axi_mem_bid_reg       <= S_AXI_MEM_AWID;
       end if;
    end if;
end process S_AXI_MEM_BID_P;
-----------------------
AXI_MEM_BRESP_P: process (S_AXI_ACLK) is
begin
     if(S_AXI_ACLK'event and S_AXI_ACLK='1')then
         if (addr_sm_ps_IDLE_cmb='1')then
             s_axi_mem_bresp_reg  <= (others => '0');
         elsif(ip2bus_wrack = '1') and (ip2bus_errack='1') then
             s_axi_mem_bresp_reg  <= "10";
         end if;
     end if;
end process AXI_MEM_BRESP_P;
-----------------------
AXI_MEM_BVALID_P: process (S_AXI_ACLK) is
begin
     if(S_AXI_ACLK'event and S_AXI_ACLK='1')then
         if (addr_sm_ps_IDLE_cmb='1')then
             s_axi_mem_bvalid_reg <= '0';
         elsif(last_addr = '1') and (IP2Bus_WrAck='1') then
             s_axi_mem_bvalid_reg <=  '1';
         elsif(S_AXI_MEM_BREADY='1') then
             s_axi_mem_bvalid_reg <= '0';
         end if;
     end if;
end process AXI_MEM_BVALID_P;
-----------------------
s_axi_mem_rresp_reg <= (rd_data_fifo_error & '0')
                        when (rnw_reg='1')
                        else
                        (others => '0');
-----------------------
s_axi_mem_rlast_reg <= last_rd_data_cmb and
                       last_data_acked;
-----------------------
s_axi_mem_rvalid_reg <= not fifo_empty;
-----------------------
s_axi_mem_rdata_reg <= s_axi_mem_rdata_i;
-----------------------

arready_cmb <=  -- below logic is useful in idle state only
                S_AXI_MEM_ARVALID    and
                addr_sm_ps_IDLE_cmb  and
                (not(rw_flag_reg) or
                 not(S_AXI_MEM_AWVALID)
                );

awready_cmb <= -- below logic is useful in idle state only
                (wr_transaction)     and
                 addr_sm_ps_IDLE_cmb and
                (rw_flag_reg      or
                 (not S_AXI_MEM_ARVALID)
                 );
-----------------------------------------------------------------------------
----------------------
-- IPIC Side interface
----------------------
Type_of_xfer <= type_of_xfer_reg;

bus2ip_Addr  <= bus2ip_addr_int;
Bus2ip_BE    <= bus2ip_BE_reg;
Bus2IP_Data  <= bus2ip_data_reg;
Bus2IP_Burst <= bus2ip_burst_reg;

Bus2ip_RNW   <= rnw_reg;
Bus2IP_RdReq <= bus2ip_rd_req_reg;
Bus2IP_WrReq <= bus2ip_wr_req_reg;
Bus2IP_BurstLength <= burstlength_reg;

--------------
BUS2IP_DATA_P: process (S_AXI_ACLK) is
--------------
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if ((S_AXI_ARESETN='0')) then
            bus2ip_data_reg <= (others => '0');
        elsif (((S_AXI_MEM_WVALID='1') and (wready_cmb='1'))
              ) then
            bus2ip_data_reg <= S_AXI_MEM_WDATA;
        end if;
    end if;
end process BUS2IP_DATA_P;
-------------------------
------------------------
-- BUS2IP_BE_P:Register Bus2IP_BE for write strobe during write mode else '1'.
------------------------
BUS2IP_BE_P: process (S_AXI_ACLK) is
------------
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if ((S_AXI_ARESETN='0')) then
            bus2ip_BE_reg   <= (others => '0');
        elsif ((rnw_cmb='0') and (wready_cmb='1')) then
            bus2ip_BE_reg <= S_AXI_MEM_WSTRB;
        elsif(store_addr_info_cmb = '1')or (rnw_cmb='1') then
            bus2ip_BE_reg <= Bus2ip_BE_cmb;
        end if;
    end if;
end process BUS2IP_BE_P;
------------------------
-------------- bus2ip_burst should be active till last but one transaction data ack
BUS2IP_BURST_P: process (S_AXI_ACLK) is
--------------
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if (S_AXI_ARESETN='0')then
            bus2ip_burst_reg <= '0';
        elsif(store_addr_info_cmb='1') then
            bus2ip_burst_reg <= last_len_cmb;
        elsif(last_data_cmb='1') then
            bus2ip_burst_reg <= '0';
        end if;
    end if;
end process BUS2IP_BURST_P;
---------------------------
------------------
BUS2IP_BURST_REG_P1: process (S_AXI_ACLK) is
------------------
begin
    if S_AXI_ACLK'event and S_AXI_ACLK='1' then
        if (S_AXI_ARESETN='0') then
            burstlength_reg <= (others => '0');
        elsif(store_addr_info_cmb='1')then
            burstlength_reg <= burst_length_cmb;
        end if;
    end if;
end process BUS2IP_BURST_REG_P1;
--------------------------------------

----------------------
-- internal signals
----------------------

second_last_cnt        <= not(or_reduce(burst_data_cnt(7 downto 1)))
                          and burst_data_cnt(0);

addr_sm_ns_IDLE_cmb    <= '1' when (emc_addr_ns=IDLE)    else '0';
addr_sm_ps_IDLE_cmb    <= '1' when (emc_addr_ps=IDLE)    else '0';
addr_sm_ps_WR_cmb      <= '1' when (emc_addr_ps=WR)      else '0';
addr_sm_ps_WR_WAIT_cmb <= '1' when (emc_addr_ps=WR_WAIT) else '0';

wr_transaction         <= S_AXI_MEM_AWVALID and (S_AXI_MEM_WVALID);
wr_addr_transaction    <= S_AXI_MEM_AWVALID and (not S_AXI_MEM_WVALID);
---------------------------

addr_int_cmb     <= S_AXI_MEM_ARADDR when(rnw_cmb = '1')
                    else
                    S_AXI_MEM_AWADDR;
-------------------
size_cmb         <= S_AXI_MEM_ARSIZE(1 downto 0) when (rnw_cmb = '1') else
                    S_AXI_MEM_AWSIZE(1 downto 0);
-------------------
burst_length_cmb <= S_AXI_MEM_ARLEN when (rnw_cmb = '1')
                    else
                    S_AXI_MEM_AWLEN;
-------------------
single_transfer_cmb <= not(or_reduce(burst_length_cmb));
-------------------
last_len_cmb        <= or_reduce(burst_length_cmb);
-------------------
Type_of_xfer_cmb    <= or_reduce(S_AXI_MEM_ARBURST) when (rnw_cmb = '1')
                       else
                       or_reduce(S_AXI_MEM_AWBURST);
-------------------
Bus2IP_Resetn       <= S_AXI_ARESETN;
-------------------


combine_ack <= IP2Bus_WrAck or IP2Bus_RdAck;
-----------------
BURST_DATA_CNT_P: process (S_AXI_ACLK) is
-----------------
begin
-----
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if (S_AXI_ARESETN='0') then
            burst_data_cnt  <= (others => '0');
        elsif(store_addr_info_cmb='1')     then
            burst_data_cnt  <= burst_length_cmb;
        elsif((combine_ack='1') and (last_data_cmb='0')
              )then
            burst_data_cnt  <= burst_data_cnt - '1';
        end if;
    end if;
end process BURST_DATA_CNT_P;
-----------------------------

last_data_cmb    <= not(or_reduce(burst_data_cnt));

LAST_DATA_ACKED_P: process (S_AXI_ACLK) is
-----------------
begin
-----
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if(addr_sm_ps_IDLE_cmb='1')     then
            last_data_acked <= '0';
        elsif (last_data_cmb= '1' and IP2Bus_RdAck = '1') then
            last_data_acked <= '1';
        end if;
    end if;
end process LAST_DATA_ACKED_P;
-----------------
BURST_ADDR_CNT_P: process(S_AXI_ACLK) is
-----------------
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if (store_addr_info_cmb='1') then
            burst_addr_cnt <= burst_length_cmb;
        elsif ((IP2Bus_AddrAck='1')and
                ((last_addr='0'))
               ) then
            burst_addr_cnt <= burst_addr_cnt - '1';
        end if;
    end if;
end process BURST_ADDR_CNT_P;
-----------------------------

second_last_addr <= not(or_reduce(burst_addr_cnt(7 downto 1))) and
                                                burst_addr_cnt(0);
last_addr        <= not(or_reduce(burst_addr_cnt));

stop_addr_incr   <= last_addr;
--------------------------------------------------------------------------
--Generate burst length for WRAP xfer when C_S_AXI_MEM_DATA_WIDTH = 32.
--------------------------------------------------------------------------
LEN_GEN_32 : if ( C_S_AXI_MEM_DATA_WIDTH = 32 ) generate
------------
begin
-----
--  ----------------------------------------------------------------------
--  Process DERIVED_LEN_P to find the burst length translate from byte,
--  Half word and word transfer types.
--     Logic - convert the number of data beat transfers in the equivalent words
--        ex - Wrap transfer, byte size of length       = Words
--  AXI Data   10             00          2 0001        = 0000
--  AXI Data   10             00          4 0011        = 0001
--  AXI Data   10             00          8 0111        = 0010
--  AXI Data   10             00         16 1111        = 0100
--  So pick the 3:2 bits from AXI Size
--  ----------------------------------------------------------------------
DERIVED_LEN_P: process (S_AXI_ACLK) is
--------------
begin
-----
  if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
    if (store_addr_info_cmb='1') then
        case size_cmb is
            when "00"   => derived_len_reg <= ("00" & burst_length_cmb(3 downto 2));
            when "01"   => derived_len_reg <= ('0' & burst_length_cmb(3 downto 1));
            -- coverage off
            when others => derived_len_reg <= burst_length_cmb(3 downto 0);
            -- coverage on
        end case;
    end if;
  end if;
end process DERIVED_LEN_P;
--------------------------
end generate LEN_GEN_32;

--  --------------------------------------------------------------------------
--  Generate burst length for WRAP xfer when C_S_AXI_DATA_WIDTH = 64.
--  --------------------------------------------------------------------------
LEN_GEN_64 : if ( C_S_AXI_MEM_DATA_WIDTH = 64 ) generate
------------
begin
--  ----------------------------------------------------------------------
--  Process DERIVED_LEN_P to find the burst length translate from byte,
--  Half word and word transfer types.
--  ----------------------------------------------------------------------
DERIVED_LEN_P: process (S_AXI_ACLK) is
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if (store_addr_info_cmb='1') then
            case size_cmb is
                when "00" =>derived_len_reg <=("000" & burst_length_cmb(3));
                when "01" =>derived_len_reg <=("00" & burst_length_cmb(3 downto 2));
                when "10" =>derived_len_reg <=('0' & burst_length_cmb(3 downto 1));
                -- coverage off
                when others => derived_len_reg <= burst_length_cmb(3 downto 0);
                 -- coverage on
            end case;
        end if;
  end if;
end process DERIVED_LEN_P;
--------------------------
end generate LEN_GEN_64;
------------------------
---------------------------
REG_P: process (S_AXI_ACLK) is
begin
-----
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if (S_AXI_ARESETN='0') then
            emc_addr_ps             <= IDLE;
            addr_sm_ps_IDLE_reg     <= '1';
            rnw_reg                 <= '0';
            bus2ip_wr_req_reg       <= '0';
            bus2ip_rd_req_reg       <= '0';
            last_rd_data_reg        <= '0';
        else
            emc_addr_ps             <= emc_addr_ns;
            addr_sm_ps_IDLE_reg     <= addr_sm_ns_IDLE_cmb;
            rnw_reg                 <= rnw_cmb;
            bus2ip_wr_req_reg       <= bus2ip_wr_req_cmb;
            bus2ip_rd_req_reg       <= bus2ip_rd_req_cmb;
            last_rd_data_reg        <= last_rd_data_cmb;
        end if;
    end if;
end process REG_P;
-------------------------------------------------------
REG_CONDITION_P: process (S_AXI_ACLK) is
----------------
begin
    if (S_AXI_ACLK'event and S_AXI_ACLK='1') then
        if (S_AXI_ARESETN='0') then
            type_of_xfer_reg <= '0';  -- default
            single_transfer_reg <= '0';
        elsif(store_addr_info_cmb='1') then
            single_transfer_reg <= single_transfer_cmb;
            type_of_xfer_reg <= Type_of_xfer_cmb;
            derived_size_reg <= size_cmb;
            if(rnw_cmb = '1') then
                derived_burst_reg <= S_AXI_MEM_ARBURST;
            else
                derived_burst_reg <= S_AXI_MEM_AWBURST;
            end if;
        end if;
    end if;
end process REG_CONDITION_P;
-------------------------------------------------------

--------------------------------------------------
-- RW_FLAG_P: Round robin logic for read and write
--------------------------------------------------
RW_FLAG_P: process(S_AXI_ACLK)is
----------
begin
     if(S_AXI_ACLK'event and S_AXI_ACLK='1')then
         if (S_AXI_ARESETN='0')then
                 rw_flag_reg <= '0';
         elsif((addr_sm_ps_IDLE_reg='1'))then
                 rw_flag_reg <= (rw_flag_reg and not(S_AXI_MEM_AWVALID))
                                or
                                ((not rw_flag_reg)and S_AXI_MEM_ARVALID);
         end if;
     end if;
end process RW_FLAG_P;
--------------------------------------------------
process (
         -- axi signals
         S_AXI_MEM_ARVALID,
         S_AXI_MEM_AWVALID,
         S_AXI_MEM_WVALID,
         S_AXI_MEM_WLAST,
         S_AXI_MEM_RREADY,
         S_AXI_MEM_BREADY,

         -- internal signals
         emc_addr_ps,
         single_transfer_cmb,
         wr_transaction,
         last_addr,
         last_rd_data_cmb,
         second_last_addr,
         last_data_cmb,

         IP2Bus_AddrAck,
         IP2Bus_RdAck,
         IP2Bus_WrAck,

         rd_fifo_full,
         fifo_empty,
         single_transfer_cmb,

         -- registered signals
         single_transfer_reg,
         rw_flag_reg,
         rnw_reg,
         bus2ip_wr_req_reg,
         bus2ip_rd_req_reg,
         last_data_acked,
         s_axi_mem_rlast_reg,
         addr_sm_ps_IDLE_cmb
         )is
begin   -- default states
        rnw_cmb           <= rnw_reg;
        bus2ip_wr_req_cmb <= bus2ip_wr_req_reg;
        bus2ip_rd_req_cmb <= bus2ip_rd_req_reg;

        enable_cs_cmb     <= '0';
        rst_rdce_cmb      <= '0';
        rst_wrce_cmb      <= '0';
        rst_cs_cmb        <= '0';

        enable_wrce_cmb   <= '0';
        enable_rdce_cmb   <= '0';

        store_addr_info_cmb <= '0';
        wready_cmb          <= '0';

     case emc_addr_ps is
                        -------------------------------
        when IDLE    => if ( (S_AXI_MEM_ARVALID='1') and
                             ((rw_flag_reg='0'      ) or
                              (S_AXI_MEM_AWVALID='0')
                             )
                            )then
                            enable_cs_cmb       <= '1';
                            store_addr_info_cmb <= '1';
                            if(single_transfer_cmb='1')then
                                emc_addr_ns     <= RD_LAST;
                            else
                                emc_addr_ns     <= RD;
                            end if;
                        elsif( (wr_transaction = '1') and
                                 ((rw_flag_reg='1'      ) or
                                  (S_AXI_MEM_ARVALID='0')
                                 )
                             )then
                            enable_cs_cmb <= '1';
                            store_addr_info_cmb <= '1';
                            if(single_transfer_cmb='1')then
                                emc_addr_ns   <= WR_LAST;
                            else
                                emc_addr_ns   <= WR;
                            end if;
                        else
                             emc_addr_ns <= IDLE;
                        end if;

                        wready_cmb  <= (wr_transaction)    and
                                        addr_sm_ps_IDLE_cmb and
                                        (rw_flag_reg     or
                                         (not S_AXI_MEM_ARVALID)
                                        );
                        -- priority is given for read over write
                        rnw_cmb           <=  S_AXI_MEM_ARVALID  and
                                              ( not(rw_flag_reg) or
                                               not(S_AXI_MEM_AWVALID)
                                              );
                        bus2ip_rd_req_cmb <=  S_AXI_MEM_ARVALID  and
                                              (not(rw_flag_reg)
                                               or
                                               not(S_AXI_MEM_AWVALID)
                                              );
                        bus2ip_wr_req_cmb <=  wr_transaction and
                                              (rw_flag_reg
                                               or
                                               (not S_AXI_MEM_ARVALID)
                                              );
                        -------------------------------
        when RD      => if(s_axi_mem_rlast_reg='1' and S_AXI_MEM_RREADY='1')then
                            rst_cs_cmb   <= '1';
                            rnw_cmb      <= '0';
                            emc_addr_ns  <= IDLE;
                        else
                            emc_addr_ns <= RD;
                        end if;
                        rst_rdce_cmb      <= rd_fifo_full or
                                               (last_data_cmb and IP2Bus_RdAck);
                        enable_rdce_cmb   <= fifo_empty;
                        bus2ip_rd_req_cmb <= not(last_addr and IP2Bus_AddrAck)
                                             and
                                             bus2ip_rd_req_reg;
                        -------------------------------
        when RD_LAST => if(IP2Bus_RdAck='1')then
                             rnw_cmb      <= '0';
                             rst_cs_cmb   <= '1';
                             emc_addr_ns  <= IDLE;
                        else
                             emc_addr_ns  <= RD_LAST;
                        end if;
                        rst_rdce_cmb      <= rd_fifo_full
                                             or
                                             ((last_data_cmb or
                                               single_transfer_reg)
                                               and
                                              IP2Bus_RdAck
                                              );
                        enable_rdce_cmb   <= not (fifo_empty or
                                                  (last_data_cmb and
                                                   IP2Bus_RdAck
                                                   )
                                                  );
                        -------------------------------
        when WR      => if ((IP2Bus_WrAck='1')) then
                            if (S_AXI_MEM_WVALID='0') then
                                emc_addr_ns <= WR_WAIT;
                            elsif (second_last_addr='1') then
                                emc_addr_ns <= WR_LAST;
                            else
                                emc_addr_ns <= WR;
                            end if;
                        else
                            emc_addr_ns <= WR;
                        end if;
                        bus2ip_wr_req_cmb <= '1';
                        wready_cmb        <= IP2Bus_WrAck;
                        rst_wrce_cmb      <= IP2Bus_WrAck and
                                             (not S_AXI_MEM_WVALID);
                        -------------------------------
        when WR_WAIT => if (S_AXI_MEM_WVALID='0') then
                                rst_wrce_cmb      <= '1';
                                emc_addr_ns       <= WR_WAIT;
                        elsif(last_addr='1') then
                                emc_addr_ns <= WR_LAST;
                        else
                                emc_addr_ns       <= WR;
                        end if;
                        bus2ip_wr_req_cmb <= '1';
                        wready_cmb        <= '1';
                        enable_wrce_cmb   <= S_AXI_MEM_WVALID;
                        -------------------------------
        when WR_LAST => if (last_addr='1') then
                        if ((IP2Bus_AddrAck='1'))then
                                wready_cmb        <= '0';
                                emc_addr_ns  <= RESP;
                        else
                                emc_addr_ns  <= WR_LAST;
                        end if;
                        else
                           emc_addr_ns  <= WR_LAST;
                        end if;
                        bus2ip_wr_req_cmb <= not(IP2Bus_WrAck);
                        rst_cs_cmb        <= IP2Bus_WrAck;
                        rst_wrce_cmb      <= IP2Bus_WrAck;
                        enable_wrce_cmb   <= S_AXI_MEM_WVALID;
                        -------------------------------
        when RESP    => rst_cs_cmb        <= '1';
                        rst_wrce_cmb      <= '1';
                        if(S_AXI_MEM_BREADY='1') then
                            emc_addr_ns <= IDLE;
                        else
                            emc_addr_ns <= RESP;
                        end if;
                        -------------------------------
        -- coverage off
        when others  => emc_addr_ns <= IDLE;
        -- coverage on
                        -------------------------------
        end case;
end process;
-----------------------
------------------------------------------------------------------------------
AXI_EMC_ADDR_GEN_INSTANCE_I:entity axi_emc_v1_01_a.axi_emc_addr_gen
   generic map
        (
        C_S_AXI_MEM_ADDR_WIDTH    => C_S_AXI_MEM_ADDR_WIDTH,
        C_S_AXI_MEM_DATA_WIDTH    => C_S_AXI_MEM_DATA_WIDTH
        )
    port map
        (
        Bus2IP_Clk           => S_AXI_ACLK         , -- in std_logic
        Bus2IP_Resetn        => Bus2IP_Resetn      , -- in std_logic
        -- combo I/P signals
        stop_addr_incr       => stop_addr_incr,
        Store_addr_info_cmb  => Store_addr_info_cmb, -- in std_logic;
        Addr_int_cmb         => Addr_int_cmb       , -- in std_logic_vector((C_S_AXI_ADDR_WIDTH-1)downto 0);
        Ip2Bus_Addr_ack      => IP2Bus_AddrAck     , -- in std_logic;
        Fifo_full_1          => rst_rdce_cmb, --Fifo_full          , -- in std_logic;
        Rst_Rd_CE                => rst_rdce_cmb        , -- : in std_logic;
        -- registered signals
        derived_len_reg      => derived_len_reg    , -- in std_logic_vector(3 downto 0);
        Derived_burst_reg    => Derived_burst_reg  , -- in std_logic_vector(1 downto 0);
        Derived_size_reg     => Derived_size_reg   , -- in std_logic_vector(1 downto 0);
        -- registered O/P signals
        Bus2IP_Addr          => bus2ip_addr_int      -- out std_logic_vector((C_S_AXI_ADDR_WIDTH-1)downto 0)
        );
------------------------------------------------------------------------------

enable_rdce_combo <= enable_rdce_cmb;
enable_wrce_combo <= enable_wrce_cmb;

AXI_EMC_ADDRESS_DECODE_INSTANCE_I:entity axi_emc_v1_01_a.axi_emc_address_decode
   generic map(
        C_S_AXI_ADDR_WIDTH       => C_S_AXI_MEM_ADDR_WIDTH  ,
        C_ARD_ADDR_RANGE_ARRAY   => AXI_ARD_ADDR_RANGE_ARRAY,
        C_ARD_NUM_CE_ARRAY       => AXI_ARD_NUM_CE_ARRAY    ,
        C_FAMILY                 => C_FAMILY                ,
        C_ADDR_DECODE_BITS       => C_S_AXI_MEM_ADDR_WIDTH
        )
   port map(
        Bus2IP_Clk               => S_AXI_ACLK          , -- : in  std_logic;
        Bus2IP_Resetn            => Bus2IP_Resetn       , -- : in  std_logic;

        Enable_CS                => enable_cs_cmb       , -- : in std_logic;
        Enable_RdCE              => enable_rdce_combo   , --Store_addr_info_cmb , -- : in std_logic;
        Enable_WrCE              => enable_wrce_combo   , --Store_addr_info_cmb , -- : in std_logic;

        Rst_CS                   => rst_cs_cmb          , -- : in std_logic;
        Rst_Wr_CE                => rst_wrce_cmb        , -- : in std_logic;
        Rst_Rd_CE                => rst_rdce_cmb        , -- : in std_logic;

        Addr_SM_PS_IDLE          => addr_sm_ps_IDLE_cmb , -- : in std_logic;

        Addr_int                 => Addr_int_cmb        , -- : in std_logic_vector((C_S_AXI_MEM_ADDR_WIDTH-1) downto 0);

        RNW                      => rnw_cmb             , -- : in  std_logic;
        RdFIFO_Space_two_int     => RdFIFO_Space_two_int,

        Bus2IP_CS                => bus2ip_cs           , -- out std_logic_vector((((C_ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1)downto 0);
        Bus2IP_RdCE              => bus2ip_rdce         , -- out std_logic_vector((calc_num_ce(C_ARD_NUM_CE_ARRAY)-1)downto 0);
        Bus2IP_WrCE              => bus2ip_wrce         ,   -- out std_logic_vector((calc_num_ce(C_ARD_NUM_CE_ARRAY)-1)downto 0);
        ORed_cs                  => ORed_cs
        );

-----------------------------------------------------------------------------


  rd_fifo_data_in <= (IP2Bus_Data & (IP2Bus_Error and IP2Bus_RdAck));
  rd_fifo_wr_en   <= (IP2Bus_RdAck and ORed_cs);
  rd_fifo_rd_en   <= (not fifo_empty) and S_AXI_MEM_RREADY;


  rd_fifo_empty   <= fifo_empty or (s_axi_mem_rvalid_reg and
                                    S_AXI_MEM_RREADY     and
                                    last_fifo_data);

  ------------------------
  -- RDATA_FIFO_I : read buffer
  -----------------
  RDATA_FIFO_I : entity proc_common_v3_00_a.srl_fifo_rbu_f
  generic map (
               C_DWIDTH => RD_DATA_FIFO_DWIDTH,
               C_DEPTH  => C_RDATA_FIFO_DEPTH,
               C_FAMILY => C_FAMILY
              )
  port map (
               Clk           => S_AXI_ACLK,       -- in
               --------------
               Reset         => active_high_rst,  -- in
               --------------
               FIFO_Write    => rd_fifo_wr_en,    --IP2Bus_RdAck, -- rd_fifo_wr_en,    -- in
               Data_In       => rd_fifo_data_in,  -- in std_logic_vector
               FIFO_Read     => rd_fifo_rd_en,    -- in
               Data_Out      => rd_fifo_out,      -- out std_logic_vector
               FIFO_Full     => rd_fifo_full,     -- out
               FIFO_Empty    => fifo_empty,       -- out
               Addr          => open,             -- out std_logic_vector
               Num_To_Reread => ZEROES,           -- in  std_logic_vector
               Underflow     => open,             -- out
               Overflow      => open              -- out
           );

 rd_data_fifo_error   <= rd_fifo_out(0);
 s_axi_mem_rdata_i    <= rd_fifo_out(RD_DATA_FIFO_DWIDTH-1 downto 1);

 ---------------
        updn_cnt_en     <= rd_fifo_rd_en xor rd_fifo_wr_en;

        ------------------------
        -- UPDN_COUNTER_I : The below counter used to keep track of FIFO rd/wr
        --                  The counter is loaded with the max. value at reset
        -------------------
        UPDN_COUNTER_I : entity proc_common_v3_00_a.counter_f
          generic map(
            C_NUM_BITS    =>  COUNTER_WIDTH,
            C_FAMILY      =>  "nofamily"
              )
          port map(
            Clk           =>  S_AXI_ACLK,      -- in
            Rst           =>  '0',             -- in
            Load_In       =>  ALL_1,           -- in
            Count_Enable  =>  updn_cnt_en,     -- in
            ----------------
            Count_Load    =>  active_high_rst, -- in
            ----------------
            Count_Down    =>  rd_fifo_wr_en,   -- in
            Count_Out     =>  cnt,             -- out std_logic_vector
            Carry_Out     =>  open             -- out
            );

        ------------------------
        no_space_in_fifo <= (or_reduce(cnt(COUNTER_WIDTH-1 downto 3)));

 RDDATA_CNT_P1: process (S_AXI_ACLK) is
 begin
     if S_AXI_ACLK'event and S_AXI_ACLK='1' then
         if (S_AXI_ARESETN='0') then
             RdFIFO_Space_two_int <= '1';
         elsif (cnt(COUNTER_WIDTH-1)='0' and
                cnt(COUNTER_WIDTH-2)='1' and
                cnt(COUNTER_WIDTH-3)='0' and
                cnt(COUNTER_WIDTH-4)='0' and
                cnt(COUNTER_WIDTH-5)='0'
                )then
             RdFIFO_Space_two_int <= '0';
         elsif(cnt(COUNTER_WIDTH-1)='1' and
               cnt(COUNTER_WIDTH-2)='0' and
               cnt(COUNTER_WIDTH-3)='0' and
               cnt(COUNTER_WIDTH-4)='0' and
               cnt(COUNTER_WIDTH-5)='0'
               )then
            RdFIFO_Space_two_int <= '1';
         end if;
     end if;
 end process RDDATA_CNT_P1;


 ---------------
------------------------
-- RDDATA_CNT_P : read data counter from AXI side
------------------------
 RDDATA_CNT_P: process (S_AXI_ACLK) is
 begin
     if S_AXI_ACLK'event and S_AXI_ACLK='1' then
         if (S_AXI_ARESETN='0') then
             rd_data_count <= (others => '0');
         elsif (store_addr_info_cmb='1') then
             rd_data_count <= S_AXI_MEM_ARLEN;
         elsif ((s_axi_mem_rvalid_reg='1') and (S_AXI_MEM_RREADY='1')) then
             rd_data_count <= (rd_data_count - '1');
         end if;
     end if;
 end process RDDATA_CNT_P;

 last_rd_data_cmb <= not(or_reduce(rd_data_count));
-----------------------------------------------------------------------------
------------------------------------------------------------------------------
--  ALIGN_BYTE_ENABLE_DWTH_32_GEN: Generate the below logic for 32 bit dwidth
----------------------------------
ALIGN_BYTE_ENABLE_DWTH_32_GEN: if (C_S_AXI_MEM_DATA_WIDTH = 32) generate
------------------------------
----------------------------------------------------------------------------
-- be_generate_32 : This function returns byte_enables for the 32 bit dwidth
----------------------------------------------------------------------------
   function be_generate_32 (addr_bits : std_logic_vector(1 downto 0);
                            size      : std_logic_vector(1 downto 0))
                            return std_logic_vector is

   variable int_bus2ip_be : std_logic_vector(3 downto 0):= (others => '0');
   -----
   begin
   -----

   int_bus2ip_be(0) := size(1) or
                       (
                        ((not addr_bits(1)) and  (not size(1)))
                        and
                         (not addr_bits(0) or size(0))
                       );
   int_bus2ip_be(1) := size(1) or
                       (
                        ((not addr_bits(1)) and  (not size(1)))
                        and
                         (addr_bits(0) or size(0))
                       );
   int_bus2ip_be(2) := size(1) or
                       (
                        (addr_bits(1) and  (not size(1)))
                        and
                        ((not addr_bits(0)) or size(0))
                       );
   int_bus2ip_be(3) := size(1) or
                       (
                        (addr_bits(1) and  (not size(1)))
                        and
                        (addr_bits(0) or size(0))
                        );
   -- coverage off
   return int_bus2ip_be;
   -- coverage on
   end function be_generate_32;
 -----------------------------------------------------------------------------
 ------------------------------
 begin
 -------------------------
 -- RD_ADDR_ALIGN_BE_32_P: the below logic generates the byte enables for
 --                        32 bit data width
 -------------------------
 RD_ADDR_ALIGN_BE_32_P: process(store_addr_info_cmb,
                                size_cmb,
                                S_AXI_MEM_ARADDR(1 downto 0),
                                IP2Bus_AddrAck,
                                derived_size_reg,
                                bus2ip_BE_reg
                                )is
 begin
    if(store_addr_info_cmb = '1')then
        Bus2ip_BE_cmb <= be_generate_32(S_AXI_MEM_ARADDR(1 downto 0),size_cmb);
    elsif (IP2Bus_AddrAck = '1')then
        case derived_size_reg is
            when "00" => -- byte
                Bus2ip_BE_cmb <= bus2ip_BE_reg(2 downto 0) & bus2ip_BE_reg(3);
            when "01" => -- half word
                Bus2ip_BE_cmb <= bus2ip_BE_reg(1 downto 0) &
                                                      bus2ip_BE_reg(3 downto 2);
   -- coverage off
           when others => Bus2ip_BE_cmb <= "1111";
   -- coverage on
        end case;
    else
        Bus2ip_BE_cmb <= bus2ip_BE_reg;
    end if;
 end process RD_ADDR_ALIGN_BE_32_P;
 ----------------------------------
 end generate ALIGN_BYTE_ENABLE_DWTH_32_GEN;
 ------------------------------- ------------

 ------------------------------------------------------------------------------
 --  ALIGN_BYTE_ENABLE_DWTH_64_GEN: Generate the below logic for 32 bit dwidth
 ----------------------------------
 ALIGN_BYTE_ENABLE_DWTH_64_GEN: if (C_S_AXI_MEM_DATA_WIDTH = 64) generate
 -------------------------
-- function declaration
  ---------------------------------------------------------------------------
  -- be_generate_64 : To generate the Byte Enable w.r.t size and address
  ---------------------------------------------------------------------------
  function be_generate_64 (addr_bits : std_logic_vector(2 downto 0);
                           size      : std_logic_vector(1 downto 0))
                           return std_logic_vector is

  variable int_bus2ip_be : std_logic_vector(7 downto 0):= (others => '0');
  -----
  begin
  -----
      int_bus2ip_be(0) :=(size(1) and (size(0) or ((not size(0)) and
                                                   (not addr_bits(2))))) or
                          ((not size(1))      and
                           (not addr_bits(2)) and
                           (not addr_bits(1)) and
                           (size(0) or ((not size(0)) and (not addr_bits(0))))
                          );

      int_bus2ip_be(1) :=(size(1) and (size(0) or ((not size(0)) and
                                                   (not addr_bits(2))))) or
                         ((not size(1))      and
                         (not addr_bits(2)) and
                         (not addr_bits(1)) and
                         (size(0) or ((not size(0)) and addr_bits(0)))
                          );


      int_bus2ip_be(2) := (size(1) and (size(0) or ((not size(0)) and
                                                   (not addr_bits(2))))) or
                           ((not size(1))      and
                            (not addr_bits(2)) and
                                 addr_bits(1)  and
                          (size(0) or ((not size(0)) and (not addr_bits(0))))
                          );

      int_bus2ip_be(3) := (size(1) and (size(0) or ((not size(0)) and
                                                   (not addr_bits(2))))) or
                           ((not size(1))      and
                            (not addr_bits(2)) and
                                 addr_bits(1)  and
                            (size(0) or ((not size(0)) and addr_bits(0)))
                          );


    int_bus2ip_be(4) := (size(1) and (size(0) or ((not size(0)) and
                                                        addr_bits(2)))) or
                         ((not size(1))      and
                          (not addr_bits(1)) and
                               addr_bits(2)  and
                          (size(0) or ((not size(0)) and (not addr_bits(0))))
                         );

    int_bus2ip_be(5) := (size(1) and (size(0) or ((not size(0)) and
                                                        addr_bits(2)))) or
                        ((not size(1))      and
                        (not addr_bits(1)) and
                             addr_bits(2)  and
                        (size(0) or ((not size(0)) and addr_bits(0)))
                         );

    int_bus2ip_be(6) := (size(1) and (size(0) or ((not size(0)) and
                                                       addr_bits(2)))) or
                        ((not size(1))      and
                            addr_bits(1)  and
                            addr_bits(2)  and
                        (size(0) or ((not size(0)) and (not addr_bits(0))))
                        );

    int_bus2ip_be(7) := (size(1) and (size(0) or ((not size(0)) and
                                                       addr_bits(2)))) or
                        ((not size(1))      and
                              addr_bits(1)  and
                              addr_bits(2)  and
                        (size(0) or ((not size(0)) and addr_bits(0)))
                        );


  -- coverage off
  return int_bus2ip_be;
  -- coverage on
  end function be_generate_64;
  -----------------------------------------------------------------------------
 -----
 begin
 -----
 -- RD_ADDR_ALIGN_BE_64_P: The below logic generates the byte enables for
 --                        64 bit data width
 -------------------------
 RD_ADDR_ALIGN_BE_64_P: process(store_addr_info_cmb,
                                size_cmb,
                                S_AXI_MEM_ARADDR(2 downto 0),
                                IP2Bus_AddrAck,
                                derived_size_reg,
                                Bus2ip_BE_reg
                                )is
 begin
    if(store_addr_info_cmb = '1')then
        Bus2ip_BE_cmb <= be_generate_64(S_AXI_MEM_ARADDR(2 downto 0),size_cmb);
    elsif (IP2Bus_AddrAck = '1')then
        case derived_size_reg is
            when "00" => -- byte
                Bus2ip_BE_cmb <= bus2ip_BE_reg(6 downto 0) & bus2ip_BE_reg(7);
            when "01" => -- half word
                Bus2ip_BE_cmb <= bus2ip_BE_reg(5 downto 0) &
                                                    bus2ip_BE_reg(7 downto 6);
            when "10" => -- half word
                Bus2ip_BE_cmb <= bus2ip_BE_reg(3 downto 0) &
                                                    bus2ip_BE_reg(7 downto 4);
            -- coverage off
            when others => Bus2ip_BE_cmb <= (others => '1');
            -- coverage on
        end case;
    else
            Bus2ip_BE_cmb <= bus2ip_BE_reg;
    end if;
 end process RD_ADDR_ALIGN_BE_64_P;
 -------------------------------
 end generate ALIGN_BYTE_ENABLE_DWTH_64_GEN;
 ------------------------

end architecture imp;