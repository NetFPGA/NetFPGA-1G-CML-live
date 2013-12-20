library ieee;
use ieee.std_logic_1164.all;

library nf10_axis_sim_stim_v1_00_a;
use nf10_axis_sim_stim_v1_00_a.all;

entity tb_sv_dma is
    generic (
        IRQ_DLY_CNT                         : integer   := 16;
        axi_clk_period                      : time  := 8 ns;
        tx_clk_period                       : time  := 8 ns;
        rx_clk_period                       : time  := 8 ns;
        pcie_clk_period                     : time  := 8 ns
    );
end entity;

architecture behav of tb_sv_dma is
    signal  trn_td                      : std_logic_vector(63 downto 0);
    signal  trn_trem_n                  : std_logic_vector(7 downto 0);
    signal  trn_tsof_n                  : std_logic;
    signal  trn_teof_n                  : std_logic;
    signal  trn_tsrc_rdy_n              : std_logic;
    signal  trn_tsrc_dsc_n              : std_logic;
    signal  trn_tdst_rdy_n              : std_logic                             := '0';
    signal  trn_tdst_dsc_n              : std_logic                             := '1';
    signal  trn_terrfwd_n               : std_logic;
    signal  trn_tbuf_av                 : std_logic_vector(3 downto 0)          := (others => '1');
    signal  trn_rd                      : std_logic_vector(63 downto 0)         := (others => '0');
    signal  trn_rrem_n                  : std_logic_vector(7 downto 0)          := (others => '0');
    signal  trn_rsof_n                  : std_logic                             := '0';
    signal  trn_reof_n                  : std_logic                             := '0';
    signal  trn_rsrc_rdy_n              : std_logic                             := '0';
    signal  trn_rsrc_dsc_n              : std_logic                             := '1';
    signal  trn_rdst_rdy_n              : std_logic;
    signal  trn_rerrfwd_n               : std_logic                             := '1';
    signal  trn_rnp_ok_n                : std_logic;
    signal  trn_rbar_hit_n              : std_logic_vector(6 downto 0)          := (others => '0');
    signal  trn_rfc_nph_av              : std_logic_vector(7 downto 0)          := (others => '0');
    signal  trn_rfc_npd_av              : std_logic_vector(11 downto 0)         := (others => '0');
    signal  trn_rfc_ph_av               : std_logic_vector(7 downto 0)          := (others => '0');
    signal  trn_rfc_pd_av               : std_logic_vector(11 downto 0)         := (others => '0');
    signal  trn_rcpl_streaming_n        : std_logic;
    signal  cfg_do                      : std_logic_vector(31 downto 0)         := (others => '0');
    signal  cfg_rd_wr_done_n            : std_logic                             := '0';
    signal  cfg_di                      : std_logic_vector(31 downto 0);
    signal  cfg_byte_en_n               : std_logic_vector(3 downto 0);
    signal  cfg_dwaddr                  : std_logic_vector(9 downto 0);
    signal  cfg_wr_en_n                 : std_logic;
    signal  cfg_rd_en_n                 : std_logic;
    signal  cfg_err_cor_n               : std_logic;
    signal  cfg_err_ur_n                : std_logic;
    signal  cfg_err_ecrc_n              : std_logic;
    signal  cfg_err_cpl_timeout_n       : std_logic;
    signal  cfg_err_cpl_abort_n         : std_logic;
    signal  cfg_err_cpl_unexpect_n      : std_logic;
    signal  cfg_err_posted_n            : std_logic;
    signal  cfg_err_tlp_cpl_header      : std_logic_vector(47 downto 0);
    signal  cfg_err_cpl_rdy_n           : std_logic                             := '0';
    signal  cfg_err_locked_n            : std_logic;
    signal  cfg_interrupt_n             : std_logic;
    signal  cfg_interrupt_rdy_n         : std_logic                             := '0';
    signal  cfg_interrupt_assert_n      : std_logic;
    signal  cfg_interrupt_di            : std_logic_vector(7 downto 0);
    signal  cfg_interrupt_do            : std_logic_vector(7 downto 0)          := (others => '0');
    signal  cfg_interrupt_mmenable      : std_logic_vector(2 downto 0)          := (others => '0');
    signal  cfg_interrupt_msienable     : std_logic                             := '0';
    signal  cfg_to_turnoff_n            : std_logic                             := '0';
    signal  cfg_pm_wake_n               : std_logic;
    signal  cfg_pcie_link_state_n       : std_logic_vector(2 downto 0)          := (others => '0');
    signal  cfg_trn_pending_n           : std_logic;
    signal  cfg_bus_number              : std_logic_vector(7 downto 0)          := (others => '0');
    signal  cfg_device_number           : std_logic_vector(4 downto 0)          := (others => '0');
    signal  cfg_function_number         : std_logic_vector(2 downto 0)          := (others => '0');
    signal  cfg_dsn                     : std_logic_vector(63 downto 0);
    signal  cfg_status                  : std_logic_vector(15 downto 0)         := (others => '0');
    signal  cfg_command                 : std_logic_vector(15 downto 0)         := (others => '0');
    signal  cfg_dstatus                 : std_logic_vector(15 downto 0)         := (others => '0');
    signal  cfg_dcommand                : std_logic_vector(15 downto 0)         := (others => '0');
    signal  cfg_lstatus                 : std_logic_vector(15 downto 0)         := (others => '0');
    signal  cfg_lcommand                : std_logic_vector(15 downto 0)         := (others => '0');
    signal  M_AXIS_TDATA                : std_logic_vector(63 downto 0);
    signal  M_AXIS_TSTRB                : std_logic_vector(7 downto 0);
    signal  M_AXIS_TVALID               : std_logic;
    signal  M_AXIS_TREADY               : std_logic                             := '1';
    signal  M_AXIS_TLAST                : std_logic;
    signal  M_AXIS_TUSER                : std_logic_vector(127 downto 0);
    signal  S_AXIS_TDATA                : std_logic_vector(63 downto 0)         := (others => '0');
    signal  S_AXIS_TSTRB                : std_logic_vector(7 downto 0)          := (others => '0');
    signal  S_AXIS_TVALID               : std_logic                             := '0';
    signal  S_AXIS_TREADY               : std_logic;
    signal  S_AXIS_TLAST                : std_logic                             := '0';
    signal  S_AXIS_TUSER                : std_logic_vector(127 downto 0)        := (others => '0');
    signal  IP2Bus_MstRd_Req            : std_logic;
    signal  IP2Bus_MstWr_Req            : std_logic;
    signal  IP2Bus_Mst_Addr             : std_logic_vector(31 downto 0);
    signal  IP2Bus_Mst_BE               : std_logic_vector(3 downto 0);
    signal  IP2Bus_Mst_Lock             : std_logic;
    signal  IP2Bus_Mst_Reset            : std_logic;
    signal  Bus2IP_Mst_CmdAck           : std_logic                             := '0';
    signal  Bus2IP_Mst_Cmplt            : std_logic                             := '0';
    signal  Bus2IP_Mst_Error            : std_logic                             := '0';
    signal  Bus2IP_Mst_Rearbitrate      : std_logic                             := '0';
    signal  Bus2IP_Mst_Timeout          : std_logic                             := '0';
    signal  Bus2IP_MstRd_d              : std_logic_vector(31 downto 0)         := (others => '0');
    signal  Bus2IP_MstRd_src_rdy_n      : std_logic                             := '0';
    signal  IP2Bus_MstWr_d              : std_logic_vector(31 downto 0);
    signal  Bus2IP_MstWr_dst_rdy_n      : std_logic                             := '0';
    signal  axi_clk                     : std_logic                             := '0';
    signal  tx_clk                      : std_logic                             := '0';
    signal  rx_clk                      : std_logic                             := '0';
    signal  pcie_clk                    : std_logic                             := '0';
    signal  rst                         : std_logic                             := '0';

    signal in_packet_reg                : std_logic;
    signal rst_n                        : std_logic;
    signal pcie_rx_axis_tdata           : std_logic_vector(63 downto 0);
    signal pcie_rx_axis_tstrb           : std_logic_vector(7 downto 0);
    signal pcie_rx_axis_tuser           : std_logic_vector(7 downto 0);
    signal pcie_rx_axis_tvalid          : std_logic;
    signal pcie_rx_axis_tready          : std_logic;
    signal pcie_rx_axis_tlast           : std_logic;

    signal interrupt_dly                : std_logic_vector(IRQ_DLY_CNT - 1 downto 0);
    constant ones                       : std_logic_vector(127 downto 0)        := (others => '1');
    constant zeros                      : std_logic_vector(127 downto 0)        := (others => '0');

begin

    uut : entity work.dma_engine
    port map (
       -- Tx
       trn_td                           => trn_td,
       trn_trem_n                       => trn_trem_n,
       trn_tsof_n                       => trn_tsof_n,
       trn_teof_n                       => trn_teof_n,
       trn_tsrc_rdy_n                   => trn_tsrc_rdy_n,
       trn_tsrc_dsc_n                   => trn_tsrc_dsc_n,
       trn_tdst_rdy_n                   => trn_tdst_rdy_n,
       trn_tdst_dsc_n                   => trn_tdst_dsc_n,
       trn_terrfwd_n                    => trn_terrfwd_n,
       trn_tbuf_av                      => trn_tbuf_av,
-- TX ok

       -- Rx
       trn_rd                           => trn_rd,
       trn_rrem_n                       => trn_rrem_n,
       trn_rsof_n                       => trn_rsof_n,
       trn_reof_n                       => trn_reof_n,
       trn_rsrc_rdy_n                   => trn_rsrc_rdy_n,
       trn_rsrc_dsc_n                   => trn_rsrc_dsc_n,
       trn_rdst_rdy_n                   => trn_rdst_rdy_n,
       trn_rerrfwd_n                    => trn_rerrfwd_n,
       trn_rnp_ok_n                     => trn_rnp_ok_n,
       trn_rbar_hit_n                   => trn_rbar_hit_n,
       trn_rfc_nph_av                   => trn_rfc_nph_av,                      -- not used
       trn_rfc_npd_av                   => trn_rfc_npd_av,                      -- not used
       trn_rfc_ph_av                    => trn_rfc_ph_av,                       -- not used
       trn_rfc_pd_av                    => trn_rfc_pd_av,                       -- not used
       trn_rcpl_streaming_n             => trn_rcpl_streaming_n,
-- RX OK except for trn_rbar_hit_n

       -- Host (CFG) Interface
       cfg_do                           => cfg_do,                              -- not used
       cfg_rd_wr_done_n                 => cfg_rd_wr_done_n,                    -- not used
       cfg_di                           => cfg_di,                              -- not used
       cfg_byte_en_n                    => cfg_byte_en_n,                       -- not used
       cfg_dwaddr                       => cfg_dwaddr,                          -- not used
       cfg_wr_en_n                      => cfg_wr_en_n,                         -- not used
       cfg_rd_en_n                      => cfg_rd_en_n,                         -- not used
       cfg_err_cor_n                    => cfg_err_cor_n,                       -- not used
       cfg_err_ur_n                     => cfg_err_ur_n,                        -- not used
       cfg_err_ecrc_n                   => cfg_err_ecrc_n,                      -- not used
       cfg_err_cpl_timeout_n            => cfg_err_cpl_timeout_n,               -- not used
       cfg_err_cpl_abort_n              => cfg_err_cpl_abort_n,                 -- not used
       cfg_err_cpl_unexpect_n           => cfg_err_cpl_unexpect_n,              -- not used
       cfg_err_posted_n                 => cfg_err_posted_n,                    -- not used
       cfg_err_tlp_cpl_header           => cfg_err_tlp_cpl_header,              -- not used

       cfg_err_cpl_rdy_n                => cfg_err_cpl_rdy_n,                   -- not used
       cfg_err_locked_n                 => cfg_err_locked_n,                    -- not used
       cfg_interrupt_n                  => cfg_interrupt_n,
       cfg_interrupt_rdy_n              => cfg_interrupt_rdy_n,
       cfg_interrupt_assert_n           => cfg_interrupt_assert_n,              -- not used
       cfg_interrupt_di                 => cfg_interrupt_di,
       cfg_interrupt_do                 => cfg_interrupt_do,
       cfg_interrupt_mmenable           => cfg_interrupt_mmenable,
       cfg_interrupt_msienable          => cfg_interrupt_msienable,
       cfg_to_turnoff_n                 => cfg_to_turnoff_n,                    -- not used
       cfg_pm_wake_n                    => cfg_pm_wake_n,                       -- not used
       cfg_pcie_link_state_n            => cfg_pcie_link_state_n,               -- not used
       cfg_trn_pending_n                => cfg_trn_pending_n,
       cfg_bus_number                   => cfg_bus_number,
       cfg_device_number                => cfg_device_number,
       cfg_function_number              => cfg_function_number,
       cfg_dsn                          => cfg_dsn,
       cfg_status                       => cfg_status,                          -- not used
       cfg_command                      => cfg_command,
       cfg_dstatus                      => cfg_dstatus,                         -- not used
       cfg_dcommand                     => cfg_dcommand,
       cfg_lstatus                      => cfg_lstatus,                         -- not used
       cfg_lcommand                     => cfg_lcommand,
-- CFG OK

       -- MAC tx
       M_AXIS_TDATA                     => M_AXIS_TDATA,
       M_AXIS_TSTRB                     => M_AXIS_TSTRB,
       M_AXIS_TVALID                    => M_AXIS_TVALID,
       M_AXIS_TREADY                    => M_AXIS_TREADY,
       M_AXIS_TLAST                     => M_AXIS_TLAST,
       M_AXIS_TUSER                     => M_AXIS_TUSER,

       -- MAC rx
       S_AXIS_TDATA                     => S_AXIS_TDATA,
       S_AXIS_TSTRB                     => S_AXIS_TSTRB,
       S_AXIS_TVALID                    => S_AXIS_TVALID,
       S_AXIS_TREADY                    => S_AXIS_TREADY,
       S_AXIS_TLAST                     => S_AXIS_TLAST,
       S_AXIS_TUSER                     => S_AXIS_TUSER,

       -- AXI lite master core interface
       IP2Bus_MstRd_Req                 => IP2Bus_MstRd_Req,
       IP2Bus_MstWr_Req                 => IP2Bus_MstWr_Req,
       IP2Bus_Mst_Addr                  => IP2Bus_Mst_Addr,
       IP2Bus_Mst_BE                    => IP2Bus_Mst_BE,
       IP2Bus_Mst_Lock                  => IP2Bus_Mst_Lock,
       IP2Bus_Mst_Reset                 => IP2Bus_Mst_Reset,
       Bus2IP_Mst_CmdAck                => Bus2IP_Mst_CmdAck,
       Bus2IP_Mst_Cmplt                 => Bus2IP_Mst_Cmplt,
       Bus2IP_Mst_Error                 => Bus2IP_Mst_Error,
       Bus2IP_Mst_Rearbitrate           => Bus2IP_Mst_Rearbitrate,
       Bus2IP_Mst_Timeout               => Bus2IP_Mst_Timeout,
       Bus2IP_MstRd_d                   => Bus2IP_MstRd_d,
       Bus2IP_MstRd_src_rdy_n           => Bus2IP_MstRd_src_rdy_n,
       IP2Bus_MstWr_d                   => IP2Bus_MstWr_d,
       Bus2IP_MstWr_dst_rdy_n           => Bus2IP_MstWr_dst_rdy_n,

       -- misc
       axi_clk                          => axi_clk,
       tx_clk                           => tx_clk,
       rx_clk                           => rx_clk,
       pcie_clk                         => pcie_clk,
       rst                              => rst
    );


    AXI_CLK_PROC: process
    begin
        wait for axi_clk_period / 2;
        axi_clk     <= not axi_clk;
    end process;

    TX_CLK_PROC: process
    begin
        wait for tx_clk_period / 2;
        tx_clk      <= not tx_clk;
    end process;

    RX_CLK_PROC: process
    begin
        wait for rx_clk_period / 2;
        rx_clk      <= not rx_clk;
    end process;

    PCIE_CLK_PROC: process
    begin
        wait for pcie_clk_period / 2;
        pcie_clk    <= not pcie_clk;
    end process;

    -- watch
    -- cfg_interrupt_n
    -- cfg_interrupt_di
    -- cfg_trn_pending_n
    -- cfg_dsn

    process (pcie_clk)
    begin
        if rising_edge (pcie_clk) then
            if (rst_n = '0') then
                cfg_interrupt_rdy_n         <= '1';                 -- not ready
                interrupt_dly               <= (others => '1');
            else
                cfg_interrupt_rdy_n         <= '1';
                interrupt_dly               <= interrupt_dly(IRQ_DLY_CNT - 2 downto 0) & cfg_interrupt_n;

                if (interrupt_dly = zeros(IRQ_DLY_CNT - 1 downto 0)) then
                    cfg_interrupt_rdy_n         <= '0';
                    interrupt_dly               <= (others => '1');
                end if;
            end if;
        end if;
    end process;


    process
    begin
        cfg_interrupt_do             <= (others => '0');
        cfg_interrupt_mmenable       <= "101";               -- 5 msi interrupt vector bits
        cfg_interrupt_msienable      <= '1';                 -- enable;

        cfg_bus_number               <= "00000001";          -- bus #1
        cfg_device_number            <= "00000";             -- device #0
        cfg_function_number          <= "000";               -- function #0

        cfg_command                  <= (others => '0');
        cfg_command(2)               <= '0';                 -- bus master enable
        cfg_dcommand                 <= (others => '0');
        cfg_dcommand(7 downto 5)     <= "100";               -- max_payload_size
        cfg_dcommand(14 downto 12)   <= "100";               -- max_read_request_size
        cfg_lcommand                 <= (others => '0');
        cfg_lcommand(3)              <= '1';                 -- read completion boundary: 0 - 64byte, 1 - 128byte

        rst         <= '1';
        wait for 100 ns;
        rst         <= '0';
        wait for 100 ns;
        cfg_command(2)               <= '1';

        wait;
    end process;

    rst_n   <= not rst;

    pcie_axis_driver : entity nf10_axis_sim_stim_v1_00_a.nf10_axis_sim_stim
    generic map (
        C_M_AXIS_DATA_WIDTH             => 64,
        C_M_AXIS_TUSER_WIDTH            => 8,
        input_file                      => "../pcie_stream.axi"
    )
    port map (
        ACLK                            => pcie_clk,
        ARESETN                         => rst_n,
        M_AXIS_TDATA                    => pcie_rx_axis_tdata,
        M_AXIS_TSTRB                    => pcie_rx_axis_tstrb,
        M_AXIS_TUSER                    => pcie_rx_axis_tuser,
        M_AXIS_TVALID                   => pcie_rx_axis_tvalid,
        M_AXIS_TREADY                   => pcie_rx_axis_tready,
        M_AXIS_TLAST                    => pcie_rx_axis_tlast
    );

    trn_rd(63 downto 32)    <= pcie_rx_axis_tdata(31 downto 0);
    trn_rd(31 downto 0)     <= pcie_rx_axis_tdata(63 downto 32);

    process (pcie_rx_axis_tstrb)
    begin
        for i in 7 downto 0 loop
            trn_rrem_n(7 - i)       <= not pcie_rx_axis_tstrb(i);
        end loop;
    end process;





    process (pcie_clk)
    begin
        if rising_edge (pcie_clk) then
            if (rst_n = '0') then
                in_packet_reg   <= '0';
            else
                in_packet_reg   <= in_packet_reg;
                if ((pcie_rx_axis_tvalid = '1') and (pcie_rx_axis_tready = '1')) then
                    in_packet_reg   <= not pcie_rx_axis_tlast;
                end if;
            end if;
        end if;
    end process;

    trn_rsof_n  <= not (pcie_rx_axis_tvalid and (not in_packet_reg));
    trn_reof_n  <= not pcie_rx_axis_tlast;
    trn_rsrc_rdy_n              <= not pcie_rx_axis_tvalid;
    pcie_rx_axis_tready         <= not trn_rdst_rdy_n;

    process (pcie_rx_axis_tuser)
    begin
        for i in 6 downto 0 loop
            trn_rbar_hit_n(i)           <= not pcie_rx_axis_tuser(i);
        end loop;
    end process;

end behav;

