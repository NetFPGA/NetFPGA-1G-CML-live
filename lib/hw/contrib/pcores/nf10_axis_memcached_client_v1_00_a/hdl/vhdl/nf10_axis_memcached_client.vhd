------------------------------------------------------------------------------
--
--  NetFPGA-10G http://www.netfpga.org
--
--  File:
--        nf10_axis_memcached_client.vhd
--
--  Library:
--        hw/std/pcores/nf10_axis_memcached_client
--
--  Author:
--        Jeremia Baer
--
--  Description:
--        Configurable testclient for memcached servers.
--        
--
--  Copyright notice:
--        Copyright (C) 2010, 2011 Xilinx, Inc.
--
--  Licence:
--        This file is part of the NetFPGA 10G development base package.
--
--        This file is free code: you can redistribute it and/or modify it under
--        the terms of the GNU Lesser General Public License version 2.1 as
--        published by the Free Software Foundation.
--
--        This package is distributed in the hope that it will be useful, but
--        WITHOUT ANY WARRANTY; without even the implied warranty of
--        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--        Lesser General Public License for more details.
--
--        You should have received a copy of the GNU Lesser General Public
--        License along with the NetFPGA source package.  If not, see
--        http://www.gnu.org/licenses/.
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity nf10_axis_memcached_client is
generic (
    C_BASEADDR           : std_logic_vector(31 downto 0) := x"00000000";
    C_HIGHADDR           : std_logic_vector(31 downto 0) := x"00000700";
    C_M_AXIS_DATA_WIDTH  : integer := 64; -- max 256bit supported
    C_S_AXIS_DATA_WIDTH  : integer := 64; -- max 256bit supported
    C_S_AXIS_TUSER_WIDTH : integer := 128;
    C_M_AXIS_TUSER_WIDTH : integer := 128;
    C_GEN_PKT_SIZE       : integer := 15;--30; -- in words;
    C_CHECK_PKT_SIZE     : integer := 22;--30; -- in words;
    C_IFG_SIZE           : integer := 5;  -- in words irrespective of backpressure
    C_S_AXI_ADDR_WIDTH   : integer := 32;
    C_S_AXI_DATA_WIDTH   : integer := 32;
    DEBUG                : integer := 0;
    WC_MAX               : integer := 190;
    WC_WIDTH             : integer := 8
);
port (
    ACLK               : in  std_logic;
    ARESETN            : in  std_logic;
    -- axi streaming data interface
    M_AXIS_TDATA       : out std_logic_vector (C_M_AXIS_DATA_WIDTH-1 downto 0);
    M_AXIS_TSTRB       : out std_logic_vector (C_M_AXIS_DATA_WIDTH/8-1 downto 0);
    M_AXIS_TUSER       : out std_logic_vector (C_M_AXIS_TUSER_WIDTH-1 downto 0);
    M_AXIS_TVALID      : out std_logic;
    M_AXIS_TREADY      : in  std_logic;
    M_AXIS_TLAST       : out std_logic;
    S_AXIS_TDATA       : in  std_logic_vector (C_S_AXIS_DATA_WIDTH-1 downto 0);
    S_AXIS_TSTRB       : in  std_logic_vector (C_S_AXIS_DATA_WIDTH/8-1 downto 0);
    S_AXIS_TUSER       : in  std_logic_vector (C_S_AXIS_TUSER_WIDTH-1 downto 0);
    S_AXIS_TVALID      : in  std_logic;
    S_AXIS_TREADY      : out std_logic;
    S_AXIS_TLAST       : in  std_logic;
    -- axi lite control/status interface
    S_AXI_ACLK         : in  std_logic;
    S_AXI_ARESETN      : in  std_logic;
    S_AXI_AWADDR       : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID      : in  std_logic;
    S_AXI_AWREADY      : out std_logic;
    S_AXI_WDATA        : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB        : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID       : in  std_logic;
    S_AXI_WREADY       : out std_logic;
    S_AXI_BRESP        : out std_logic_vector(1 downto 0);
    S_AXI_BVALID       : out std_logic;
    S_AXI_BREADY       : in  std_logic;
    S_AXI_ARADDR       : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID      : in  std_logic;
    S_AXI_ARREADY      : out std_logic;
    S_AXI_RDATA        : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP        : out std_logic_vector(1 downto 0);
    S_AXI_RVALID       : out std_logic;
    S_AXI_RREADY       : in  std_logic
);
end entity;

architecture structural of nf10_axis_memcached_client is

    -- Configuration / Register File ---------------------------------
    signal tx_count          : std_logic_vector(31 downto 0);
    signal rx_count          : std_logic_vector(31 downto 0);
    signal err_count         : std_logic_vector(31 downto 0);
    signal run               : std_logic;
    signal counter_reset     : std_logic;

    signal oneshot_go          : std_logic;
    signal oneshot_done        : std_logic;
    signal oneshot_latency     : integer;
    signal oneshot_latency_vec : std_logic_vector(31 downto 0);

    signal tx_word_cnt            : integer;
    signal tx_word_cnt_vec        : std_logic_vector(WC_WIDTH-1 downto 0);
    signal tx_strobe              : std_logic_vector(7 downto 0);
    signal tx_word_index_next     : integer;
    signal tx_word_index_next_vec : std_logic_vector(WC_WIDTH-1 downto 0);

    signal rx_word_cnt            : integer;
    signal rx_word_cnt_vec        : std_logic_vector(WC_WIDTH-1 downto 0);
    signal rx_strobe              : std_logic_vector(7 downto 0);
    signal rx_word_index_next     : integer;
    signal rx_word_index_next_vec : std_logic_vector(WC_WIDTH-1 downto 0);
    signal rx_check_word          : std_logic_vector(63 downto 0);

    signal dyn_ifg : integer;
    signal dyn_ifg_vec : std_logic_vector(31 downto 0);
    signal ifg_limit     : integer;

    signal chipscope_clk : std_logic;
    signal chipscope_data : std_logic_vector(255 downto 0);

    component axi4_lite_regs_memcached_client
    generic (
        BASEADDR      : std_logic_vector(31 downto 0);
        WC_MAX        : integer := 32;
        WC_WIDTH      : integer := 6
    );
    port (
        -- axi lite control/status interface
        ACLK         : in  std_logic;
        ARESETN      : in  std_logic;
        AWADDR       : in  std_logic_vector(31 downto 0);
        AWVALID      : in  std_logic;
        AWREADY      : out std_logic;
        WDATA        : in  std_logic_vector(31 downto 0);
        WSTRB        : in  std_logic_vector( 3 downto 0);
        WVALID       : in  std_logic;
        WREADY       : out std_logic;
        BRESP        : out std_logic_vector(1 downto 0);
        BVALID       : out std_logic;
        BREADY       : in  std_logic;
        ARADDR       : in  std_logic_vector(31 downto 0);
        ARVALID      : in  std_logic;
        ARREADY      : out std_logic;
        RDATA        : out std_logic_vector(31 downto 0);
        RRESP        : out std_logic_vector(1 downto 0);
        RVALID       : out std_logic;
        RREADY       : in  std_logic;

        -- packet generator/checker configuration/control
        AXIS_ACLK           : in std_logic;

        counter_reset       : out std_logic;
        run                 : out std_logic;
        ifg                 : out std_logic_vector(31 downto 0);

        tx_count            : in std_logic_vector(31 downto 0);
        rx_count            : in std_logic_vector(31 downto 0);
        err_count           : in std_logic_vector(31 downto 0);

        tx_word_count       : out std_logic_vector(WC_WIDTH-1 downto 0);
        tx_last_strobe      : out std_logic_vector(         7 downto 0);
        tx_word_index_next  : in  std_logic_vector(WC_WIDTH-1 downto 0);
        tx_word_data        : out std_logic_vector(        63 downto 0);

        oneshot_go          : out std_logic;
        oneshot_done        : in  std_logic;
        oneshot_latency     : in  std_logic_vector(31 downto 0);

        rx_word_count       : out std_logic_vector(WC_WIDTH-1 downto 0);
        rx_last_strobe      : out std_logic_vector(         7 downto 0);
        rx_word_index_next  : in  std_logic_vector(WC_WIDTH-1 downto 0);
        rx_word_data        : out std_logic_vector(        63 downto 0);

        chipscope_clk : out std_logic;
        chipscope_data : out std_logic_vector(255 downto 0)
    );
    end component;

    -- Generator state -----------------------------------------------
    constant GEN_PKT         : std_logic_vector(1 downto 0) := "00";
    constant GEN_IFG         : std_logic_vector(1 downto 0) := "01";
    constant GEN_WAIT        : std_logic_vector(1 downto 0) := "10";
    signal   gen_state       : std_logic_vector(1  downto 0);
    signal   gen_word_num    : integer;

    -- Checker state -------------------------------------------------
    constant CHECK_COMPARE   : std_logic_vector(1 downto 0) := "11";
    constant CHECK_WAIT_LAST : std_logic_vector(1 downto 0) := "10";
    constant CHECK_FINISH    : std_logic_vector(1 downto 0) := "01";
    signal   check_state     : std_logic_vector(1  downto 0);
    signal   check_word_num  : integer;
    signal   check_ok        : std_logic;

    -- Oneshot state -------------------------------------------------
    constant ONES_WAIT       : std_logic_vector(1 downto 0) := "01";
    constant ONES_TRIGGER    : std_logic_vector(1 downto 0) := "10";
    constant ONES_MEASURE    : std_logic_vector(1 downto 0) := "11";
    constant ONESHOT_MAX     : integer := 800000000; -- 5s @ 160MHz
    signal   oneshot_state   : std_logic_vector(1  downto 0);

    -- Internal copy of output ports ---------------------------------
    signal M_AXIS_TDATA_int  : std_logic_vector (C_M_AXIS_DATA_WIDTH-1 downto 0);
    signal M_AXIS_TSTRB_int  : std_logic_vector (C_M_AXIS_DATA_WIDTH/8-1 downto 0);
    signal M_AXIS_TUSER_int  : std_logic_vector (C_M_AXIS_TUSER_WIDTH-1 downto 0);
    signal M_AXIS_TVALID_int : std_logic;
    signal M_AXIS_TLAST_int  : std_logic;
    signal M_AXIS_TREADY_int : std_logic;

    -- Chipscope -----------------------------------------------------
    signal ila_data       : std_logic_vector(255 downto 0);
    signal ila_clk        : std_logic;
    signal ila_control0   : std_logic_vector(35 downto 0);
    signal ila_control1   : std_logic_vector(35 downto 0);
    signal vio_syncout    : std_logic_Vector(63 downto 0) := x"0000000000000010";

    component icon_v5
    port (
        CONTROL0 : inout std_logic_vector(35 downto 0);
        CONTROL1 : inout std_logic_vector(35 downto 0));
    end component;

    component ila256_v5
    port (
        CLK     : in std_logic;
        CONTROL : inout std_logic_vector(35 downto 0);
        TRIG0   : in std_logic_vector(255 downto 0));
    end component;

    component vio_sync64_v5
    port (
        CLK      : in std_logic;
        CONTROL  : inout std_logic_vector(35 downto 0);
        SYNC_OUT : out std_logic_vector(63 downto 0));
    end component;
    
begin

----------------------------------------------------------------------
-- Configuration / Register File
----------------------------------------------------------------------

regs : axi4_lite_regs_memcached_client
generic map (
    BASEADDR => C_BASEADDR,
    WC_MAX   => WC_MAX,
    WC_WIDTH => WC_WIDTH
)
port map (
    AXIS_ACLK => ACLK,

    ACLK      => S_AXI_ACLK,
    ARESETN   => S_AXI_ARESETN,
    AWADDR    => S_AXI_AWADDR,
    AWVALID   => S_AXI_AWVALID,
    AWREADY   => S_AXI_AWREADY,
    WDATA     => S_AXI_WDATA,
    WSTRB     => S_AXI_WSTRB,
    WVALID    => S_AXI_WVALID,
    WREADY    => S_AXI_WREADY,
    BRESP     => S_AXI_BRESP,
    BVALID    => S_AXI_BVALID,
    BREADY    => S_AXI_BREADY,
    ARADDR    => S_AXI_ARADDR,
    ARVALID   => S_AXI_ARVALID,
    ARREADY   => S_AXI_ARREADY,
    RDATA     => S_AXI_RDATA,
    RRESP     => S_AXI_RRESP,
    RVALID    => S_AXI_RVALID,
    RREADY    => S_AXI_RREADY,

    run => run,
    counter_reset => counter_reset,
    ifg => dyn_ifg_vec,

    tx_count  => tx_count,
    rx_count  => rx_count,
    err_count => err_count,

    oneshot_go => oneshot_go,
    oneshot_done => oneshot_done,
    oneshot_latency => oneshot_latency_vec,

    tx_word_count  => tx_word_cnt_vec,
    tx_last_strobe => tx_strobe,
    tx_word_index_next  => tx_word_index_next_vec,
    tx_word_data   => M_AXIS_TDATA_int,

    rx_word_count  => rx_word_cnt_vec,
    rx_last_strobe => rx_strobe,
    rx_word_index_next  => rx_word_index_next_vec,
    rx_word_data   => rx_check_word,

    chipscope_clk => chipscope_clk,
    chipscope_data => chipscope_data
);

tx_word_index_next_vec <= conv_std_logic_vector(tx_word_index_next, WC_WIDTH);
rx_word_index_next_vec <= conv_std_logic_vector(rx_word_index_next, WC_WIDTH);

tx_word_cnt <= conv_integer(tx_word_cnt_vec);
rx_word_cnt <= conv_integer(rx_word_cnt_vec);
dyn_ifg <= conv_integer(dyn_ifg_vec); --10; 

oneshot_latency_vec <= conv_std_logic_vector(oneshot_latency, 32);

----------------------------------------------------------------------
-- Packet Generator
----------------------------------------------------------------------

M_AXIS_TVALID_int <= '1' when (gen_state = GEN_PKT) else '0';
M_AXIS_TLAST_int  <= '1' when (gen_word_num = tx_word_cnt-1) else '0';
M_AXIS_TSTRB_int  <= tx_strobe when (gen_word_num = tx_word_cnt-1) else
                     (others => '1');
--M_AXIS_TDATA_int  <= test_pkt(gen_word_num) when (gen_word_num < 32) else
--                     (others => '0'); -- direclty up there
M_AXIS_TUSER_int  <= (others => '0');

tx_word_index_next <= 0                when (gen_state = GEN_WAIT) else
                      gen_word_num + 1 when (M_AXIS_TREADY_int = '1') else
                      gen_word_num;

gen_p: process(ACLK, ARESETN)
    variable tx_count_next : std_logic_vector(31 downto 0);
begin
    if (ARESETN='0') then
        gen_state     <= GEN_WAIT;
        gen_word_num  <= 0;
        tx_count      <= (others => '0');
        ifg_limit     <= tx_word_cnt + dyn_ifg - 2;

    elsif (ACLK = '1' and ACLK'event) then   
        tx_count_next := tx_count;
        if gen_state = GEN_PKT then
            if (M_AXIS_TREADY_int='1') then
                if (gen_word_num = tx_word_cnt-1 ) then
                    tx_count_next := tx_count_next + 1;
                    gen_state <= GEN_IFG;
                end if;
                gen_word_num <= gen_word_num + 1;
            end if;

        elsif gen_state = GEN_IFG then
            if(gen_word_num < ifg_limit) then
                gen_state <= GEN_IFG;
            else
                gen_state <= GEN_WAIT;
            end if;
            gen_word_num <= gen_word_num + 1;

        elsif gen_state = GEN_WAIT then
            if ((run = '1') or (oneshot_state = ONES_TRIGGER)) then
                gen_word_num  <= 0;
                gen_state     <= GEN_PKT;
            end if;
        end if;

        if(counter_reset = '1') then
            tx_count_next := (others => '0');
        end if;
        tx_count  <= tx_count_next;
        ifg_limit <= tx_word_cnt + dyn_ifg - 2;
    end if;
end process;

----------------------------------------------------------------------
-- Packet Checker
----------------------------------------------------------------------

S_AXIS_TREADY <= '0' when (check_state = CHECK_FINISH) else '1';

rx_word_index_next <= 0                  when (check_state = CHECK_FINISH) else
                      check_word_num + 1 when (S_AXIS_TVALID = '1') else
                      check_word_num;

check_p: process(ACLK, ARESETN)
    variable last_ok : boolean;
    variable rx_count_next : std_logic_vector(31 downto 0);
    variable err_count_next : std_logic_vector(31 downto 0);
begin
    if (ARESETN='0') then
        check_state <= CHECK_COMPARE;
        rx_count  <= (others => '0');
        err_count <= (others => '0');
        check_ok  <= '1';
        check_word_num <= 0;

    elsif (ACLK = '1' and ACLK'event) then
        rx_count_next := rx_count;
        err_count_next := err_count;
        if check_state = CHECK_COMPARE then
            if (S_AXIS_TVALID = '1') then
                if (check_word_num /= rx_word_cnt-1 and S_AXIS_TDATA = rx_check_word) then
                    check_ok <= check_ok;
                elsif(check_word_num = rx_word_cnt-1 and S_AXIS_TLAST = '1' and S_AXIS_TSTRB = rx_strobe) then
                    case rx_strobe is
                        when "00000001" => last_ok := (S_AXIS_TDATA( 7 downto 0) = rx_check_word( 7 downto 0));
                        when "00000011" => last_ok := (S_AXIS_TDATA(15 downto 0) = rx_check_word(15 downto 0));
                        when "00000111" => last_ok := (S_AXIS_TDATA(23 downto 0) = rx_check_word(23 downto 0));
                        when "00001111" => last_ok := (S_AXIS_TDATA(31 downto 0) = rx_check_word(31 downto 0));
                        when "00011111" => last_ok := (S_AXIS_TDATA(39 downto 0) = rx_check_word(39 downto 0));
                        when "00111111" => last_ok := (S_AXIS_TDATA(47 downto 0) = rx_check_word(47 downto 0));
                        when "01111111" => last_ok := (S_AXIS_TDATA(55 downto 0) = rx_check_word(55 downto 0));
                        when others     => last_ok := (S_AXIS_TDATA = rx_check_word);
                    end case;
                    if last_ok then
                        check_ok <= check_ok;
                    else
                        check_ok <= '0';
                    end if;
                else
                    check_ok <= '0';
                end if;

                if (check_word_num = rx_word_cnt-1) then
                    if (S_AXIS_TLAST='1') then
                        check_state <= CHECK_FINISH;
                    else
                        -- packet is longer
                        check_ok <= '0';
                        check_state <= CHECK_WAIT_LAST;
                    end if;
                elsif(S_AXIS_TLAST = '1') then
                    -- packet is shorter
                    check_ok <= '0';
                    check_state <= CHECK_FINISH;
                end if;

                check_word_num <= check_word_num + 1;
            end if;

        elsif check_state = CHECK_FINISH then
            if (check_ok='1') then
                rx_count_next := rx_count_next + 1;
            else
                err_count_next := err_count_next + 1;
            end if;
            check_state <= CHECK_COMPARE;
            check_ok <='1';
            check_word_num <= 0;

        elsif check_state = CHECK_WAIT_LAST then
            if (S_AXIS_TLAST='1' and S_AXIS_TVALID = '1') then
                check_state <= CHECK_FINISH;
            end if;
        end if;

        if counter_reset = '1' then
            rx_count_next := (others => '0');
            err_count_next := (others => '0');
        end if;
        rx_count <= rx_count_next;
        err_count <= err_count_next;
    end if;
end process;

----------------------------------------------------------------------
-- Oneshot / Latency Measurement
----------------------------------------------------------------------

oneshot_p: process(ACLK, ARESETN)
    variable oneshot_state_next   : std_logic_vector(1 downto 0);
    variable oneshot_latency_next : integer;
begin
    if (ARESETN='0') then
        oneshot_state   <= ONES_WAIT;
        oneshot_done    <= '0';
        oneshot_latency <= 0;

    elsif (ACLK='1' and ACLK'event) then
        oneshot_state_next   := oneshot_state;
        oneshot_latency_next := oneshot_latency;

        if(oneshot_state = ONES_WAIT) then
            if(gen_state = GEN_WAIT and oneshot_go = '1') then
                oneshot_state_next   := ONES_TRIGGER;
            end if;

        elsif(oneshot_state = ONES_TRIGGER) then
            oneshot_state_next   := ONES_MEASURE;
            oneshot_latency_next := 0;

        elsif(oneshot_state = ONES_MEASURE) then
            if(S_AXIS_TVALID = '1') then
                oneshot_state_next := ONES_WAIT;
            elsif(oneshot_latency_next = ONESHOT_MAX) then -- timeout
                oneshot_state_next   := ONES_WAIT;
                oneshot_latency_next := 0;
            else
                oneshot_latency_next := oneshot_latency_next + 1;
            end if;

        end if;

        oneshot_state   <= oneshot_state_next;
        oneshot_latency <= oneshot_latency_next;
        if((oneshot_state = ONES_MEASURE) and (oneshot_state_next = ONES_WAIT)) then
            oneshot_done <= '1';
        else
            oneshot_done <= '0';
        end if;

    end if;
end process;

----------------------------------------------------------------------
-- Output / Chipscope
----------------------------------------------------------------------

ila_data(63 downto 0)    <= M_AXIS_TDATA_int; -- which is tx_word_data
ila_data(64)             <= M_AXIS_TVALID_int;
ila_data(65)             <= M_AXIS_TREADY;
ila_data(66)             <= M_AXIS_TLAST_int;
ila_data(74 downto 67)   <= M_AXIS_TSTRB_int;
ila_data(80 downto 75)   <= tx_word_cnt_vec(5 downto 0);
ila_data(88 downto 81)   <= tx_strobe;
ila_data(93 downto 89)   <= tx_word_index_next_vec(4 downto 0); -- 1 bit missing
ila_data(95 downto 94)   <= gen_state;

ila_data(191 downto 128) <= S_AXIS_TDATA;
ila_data(192)            <= S_AXIS_TVALID;
ila_data(193)            <= '1';
ila_data(194)            <= S_AXIS_TLAST;
ila_data(202 downto 195) <= S_AXIS_TSTRB;
ila_data(208 downto 203) <= rx_word_cnt_vec(5 downto 0);
ila_data(216 downto 209) <= rx_strobe;
ila_data(221 downto 217) <= rx_word_index_next_vec(4 downto 0); -- 1 bit missing
ila_data(223 downto 222) <= check_state;

--ila_data(127 downto 96)  <= rx_check_word(31 downto 0);
--ila_data(255 downto 224) <= rx_check_word(63 downto 32);

ila_data(225 downto 224) <= oneshot_state;
ila_data(226)            <= oneshot_done;
ila_data(255 downto 227) <= oneshot_latency_vec(28 downto 0);

M_AXIS_TDATA           <= M_AXIS_TDATA_int;
M_AXIS_TVALID          <= M_AXIS_TVALID_int;
M_AXIS_TLAST           <= M_AXIS_TLAST_int;
M_AXIS_TSTRB           <= M_AXIS_TSTRB_int;
M_AXIS_TUSER           <= M_AXIS_TUSER_int;
M_AXIS_TREADY_int <= M_AXIS_TREADY;

F: if (DEBUG = 1) generate 
begin

i1_icon : icon_v5
port map(
    CONTROL0  => ila_control0,
    CONTROL1  => ila_control1
);

i1_ila : ila256_v5
port map(
    CLK     => ACLK,
    CONTROL => ila_control0,
    TRIG0   => ila_data
);

i1_vio : vio_sync64_v5
port map(
    CLK      => ACLK,
    CONTROL  => ila_control1,
    SYNC_OUT => vio_syncout
);

--i1_icon : icon_v5
--port map(
--    CONTROL0  => ila_control0,
--    CONTROL1  => ila_control1
--);
--
--i1_ila : ila256_v5
--port map(
--    CLK     => chipscope_clk,
--    CONTROL => ila_control0,
--    TRIG0   => chipscope_data
--);
--
--i1_vio : vio_sync64_v5
--port map(
--    CLK      => chipscope_clk,
--    CONTROL  => ila_control1,
--    SYNC_OUT => vio_syncout
--);

end generate F;

end structural;
