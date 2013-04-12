//-----------------------------------------------------------------------------
// system.v
//-----------------------------------------------------------------------------

module system
  (
    RESET,
    RS232_Uart_1_sout,
    RS232_Uart_1_sin,
    CLK,
    nf10_10g_interface_0_xaui_tx_l0_p_pin,
    nf10_10g_interface_0_xaui_tx_l0_n_pin,
    nf10_10g_interface_0_xaui_tx_l1_p_pin,
    nf10_10g_interface_0_xaui_tx_l1_n_pin,
    nf10_10g_interface_0_xaui_tx_l2_p_pin,
    nf10_10g_interface_0_xaui_tx_l3_n_pin,
    nf10_10g_interface_0_xaui_tx_l2_n_pin,
    nf10_10g_interface_0_xaui_tx_l3_p_pin,
    nf10_10g_interface_0_xaui_rx_l0_n_pin,
    nf10_10g_interface_0_xaui_rx_l1_p_pin,
    nf10_10g_interface_0_xaui_rx_l1_n_pin,
    nf10_10g_interface_0_xaui_rx_l2_p_pin,
    nf10_10g_interface_0_xaui_rx_l2_n_pin,
    nf10_10g_interface_0_xaui_rx_l3_p_pin,
    nf10_10g_interface_0_xaui_rx_l3_n_pin,
    nf10_10g_interface_0_xaui_rx_l0_p_pin,
    nf10_10g_interface_1_xaui_tx_l3_n_pin,
    nf10_10g_interface_1_xaui_tx_l1_n_pin,
    nf10_10g_interface_1_xaui_tx_l3_p_pin,
    nf10_10g_interface_1_xaui_tx_l0_p_pin,
    nf10_10g_interface_1_xaui_tx_l0_n_pin,
    nf10_10g_interface_1_xaui_tx_l1_p_pin,
    nf10_10g_interface_1_xaui_tx_l2_n_pin,
    nf10_10g_interface_1_xaui_rx_l0_p_pin,
    nf10_10g_interface_1_xaui_rx_l0_n_pin,
    nf10_10g_interface_1_xaui_rx_l1_p_pin,
    nf10_10g_interface_1_xaui_rx_l1_n_pin,
    nf10_10g_interface_1_xaui_rx_l2_p_pin,
    nf10_10g_interface_1_xaui_rx_l2_n_pin,
    nf10_10g_interface_1_xaui_rx_l3_p_pin,
    nf10_10g_interface_1_xaui_rx_l3_n_pin,
    nf10_10g_interface_1_xaui_tx_l2_p_pin,
    nf10_10g_interface_2_xaui_tx_l3_p_pin,
    nf10_10g_interface_2_xaui_tx_l3_n_pin,
    nf10_10g_interface_2_xaui_tx_l0_p_pin,
    nf10_10g_interface_2_xaui_tx_l0_n_pin,
    nf10_10g_interface_2_xaui_tx_l1_p_pin,
    nf10_10g_interface_2_xaui_tx_l2_p_pin,
    nf10_10g_interface_2_xaui_tx_l2_n_pin,
    nf10_10g_interface_2_xaui_rx_l0_p_pin,
    nf10_10g_interface_2_xaui_rx_l0_n_pin,
    nf10_10g_interface_2_xaui_rx_l1_p_pin,
    nf10_10g_interface_2_xaui_rx_l1_n_pin,
    nf10_10g_interface_2_xaui_rx_l2_p_pin,
    nf10_10g_interface_2_xaui_rx_l2_n_pin,
    nf10_10g_interface_2_xaui_rx_l3_p_pin,
    nf10_10g_interface_2_xaui_rx_l3_n_pin,
    nf10_10g_interface_2_xaui_tx_l1_n_pin,
    nf10_10g_interface_3_xaui_tx_l3_p_pin,
    nf10_10g_interface_3_xaui_tx_l3_n_pin,
    nf10_10g_interface_3_xaui_tx_l0_p_pin,
    nf10_10g_interface_3_xaui_tx_l0_n_pin,
    nf10_10g_interface_3_xaui_tx_l1_p_pin,
    nf10_10g_interface_3_xaui_tx_l2_p_pin,
    nf10_10g_interface_3_xaui_tx_l2_n_pin,
    nf10_10g_interface_3_xaui_rx_l0_p_pin,
    nf10_10g_interface_3_xaui_rx_l0_n_pin,
    nf10_10g_interface_3_xaui_rx_l1_p_pin,
    nf10_10g_interface_3_xaui_rx_l1_n_pin,
    nf10_10g_interface_3_xaui_rx_l2_p_pin,
    nf10_10g_interface_3_xaui_rx_l2_n_pin,
    nf10_10g_interface_3_xaui_rx_l3_p_pin,
    nf10_10g_interface_3_xaui_rx_l3_n_pin,
    nf10_10g_interface_3_xaui_tx_l1_n_pin,
    refclk_A_p,
    refclk_A_n,
    refclk_B_p,
    refclk_B_n,
    refclk_C_p,
    refclk_C_n,
    refclk_D_p,
    refclk_D_n,
    MDC,
    MDIO,
    PHY_RST_N,
    pcie_clk_p,
    pcie_top_0_pci_exp_0_txp_pin,
    pcie_clk_n,
    pcie_top_0_pci_exp_0_rxp_pin,
    pcie_top_0_pci_exp_0_rxn_pin,
    pcie_top_0_pci_exp_1_txp_pin,
    pcie_top_0_pci_exp_1_txn_pin,
    pcie_top_0_pci_exp_1_rxp_pin,
    pcie_top_0_pci_exp_1_rxn_pin,
    pcie_top_0_pci_exp_4_txp_pin,
    pcie_top_0_pci_exp_2_txp_pin,
    pcie_top_0_pci_exp_2_txn_pin,
    pcie_top_0_pci_exp_2_rxp_pin,
    pcie_top_0_pci_exp_2_rxn_pin,
    pcie_top_0_pci_exp_3_txp_pin,
    pcie_top_0_pci_exp_3_txn_pin,
    pcie_top_0_pci_exp_3_rxp_pin,
    pcie_top_0_pci_exp_3_rxn_pin,
    pcie_top_0_pci_exp_4_txn_pin,
    pcie_top_0_pci_exp_4_rxp_pin,
    pcie_top_0_pci_exp_4_rxn_pin,
    pcie_top_0_pci_exp_5_txp_pin,
    pcie_top_0_pci_exp_5_txn_pin,
    pcie_top_0_pci_exp_5_rxp_pin,
    pcie_top_0_pci_exp_5_rxn_pin,
    pcie_top_0_pci_exp_6_txp_pin,
    pcie_top_0_pci_exp_6_txn_pin,
    pcie_top_0_pci_exp_6_rxp_pin,
    pcie_top_0_pci_exp_6_rxn_pin,
    pcie_top_0_pci_exp_7_txn_pin,
    pcie_top_0_pci_exp_7_txp_pin,
    pcie_top_0_pci_exp_7_rxn_pin,
    pcie_top_0_pci_exp_7_rxp_pin,
    pcie_top_0_pci_exp_0_txn_pin
  );
  input RESET;
  output RS232_Uart_1_sout;
  input RS232_Uart_1_sin;
  input CLK;
  output nf10_10g_interface_0_xaui_tx_l0_p_pin;
  output nf10_10g_interface_0_xaui_tx_l0_n_pin;
  output nf10_10g_interface_0_xaui_tx_l1_p_pin;
  output nf10_10g_interface_0_xaui_tx_l1_n_pin;
  output nf10_10g_interface_0_xaui_tx_l2_p_pin;
  output nf10_10g_interface_0_xaui_tx_l3_n_pin;
  output nf10_10g_interface_0_xaui_tx_l2_n_pin;
  output nf10_10g_interface_0_xaui_tx_l3_p_pin;
  input nf10_10g_interface_0_xaui_rx_l0_n_pin;
  input nf10_10g_interface_0_xaui_rx_l1_p_pin;
  input nf10_10g_interface_0_xaui_rx_l1_n_pin;
  input nf10_10g_interface_0_xaui_rx_l2_p_pin;
  input nf10_10g_interface_0_xaui_rx_l2_n_pin;
  input nf10_10g_interface_0_xaui_rx_l3_p_pin;
  input nf10_10g_interface_0_xaui_rx_l3_n_pin;
  input nf10_10g_interface_0_xaui_rx_l0_p_pin;
  output nf10_10g_interface_1_xaui_tx_l3_n_pin;
  output nf10_10g_interface_1_xaui_tx_l1_n_pin;
  output nf10_10g_interface_1_xaui_tx_l3_p_pin;
  output nf10_10g_interface_1_xaui_tx_l0_p_pin;
  output nf10_10g_interface_1_xaui_tx_l0_n_pin;
  output nf10_10g_interface_1_xaui_tx_l1_p_pin;
  output nf10_10g_interface_1_xaui_tx_l2_n_pin;
  input nf10_10g_interface_1_xaui_rx_l0_p_pin;
  input nf10_10g_interface_1_xaui_rx_l0_n_pin;
  input nf10_10g_interface_1_xaui_rx_l1_p_pin;
  input nf10_10g_interface_1_xaui_rx_l1_n_pin;
  input nf10_10g_interface_1_xaui_rx_l2_p_pin;
  input nf10_10g_interface_1_xaui_rx_l2_n_pin;
  input nf10_10g_interface_1_xaui_rx_l3_p_pin;
  input nf10_10g_interface_1_xaui_rx_l3_n_pin;
  output nf10_10g_interface_1_xaui_tx_l2_p_pin;
  output nf10_10g_interface_2_xaui_tx_l3_p_pin;
  output nf10_10g_interface_2_xaui_tx_l3_n_pin;
  output nf10_10g_interface_2_xaui_tx_l0_p_pin;
  output nf10_10g_interface_2_xaui_tx_l0_n_pin;
  output nf10_10g_interface_2_xaui_tx_l1_p_pin;
  output nf10_10g_interface_2_xaui_tx_l2_p_pin;
  output nf10_10g_interface_2_xaui_tx_l2_n_pin;
  input nf10_10g_interface_2_xaui_rx_l0_p_pin;
  input nf10_10g_interface_2_xaui_rx_l0_n_pin;
  input nf10_10g_interface_2_xaui_rx_l1_p_pin;
  input nf10_10g_interface_2_xaui_rx_l1_n_pin;
  input nf10_10g_interface_2_xaui_rx_l2_p_pin;
  input nf10_10g_interface_2_xaui_rx_l2_n_pin;
  input nf10_10g_interface_2_xaui_rx_l3_p_pin;
  input nf10_10g_interface_2_xaui_rx_l3_n_pin;
  output nf10_10g_interface_2_xaui_tx_l1_n_pin;
  output nf10_10g_interface_3_xaui_tx_l3_p_pin;
  output nf10_10g_interface_3_xaui_tx_l3_n_pin;
  output nf10_10g_interface_3_xaui_tx_l0_p_pin;
  output nf10_10g_interface_3_xaui_tx_l0_n_pin;
  output nf10_10g_interface_3_xaui_tx_l1_p_pin;
  output nf10_10g_interface_3_xaui_tx_l2_p_pin;
  output nf10_10g_interface_3_xaui_tx_l2_n_pin;
  input nf10_10g_interface_3_xaui_rx_l0_p_pin;
  input nf10_10g_interface_3_xaui_rx_l0_n_pin;
  input nf10_10g_interface_3_xaui_rx_l1_p_pin;
  input nf10_10g_interface_3_xaui_rx_l1_n_pin;
  input nf10_10g_interface_3_xaui_rx_l2_p_pin;
  input nf10_10g_interface_3_xaui_rx_l2_n_pin;
  input nf10_10g_interface_3_xaui_rx_l3_p_pin;
  input nf10_10g_interface_3_xaui_rx_l3_n_pin;
  output nf10_10g_interface_3_xaui_tx_l1_n_pin;
  input refclk_A_p;
  input refclk_A_n;
  input refclk_B_p;
  input refclk_B_n;
  input refclk_C_p;
  input refclk_C_n;
  input refclk_D_p;
  input refclk_D_n;
  output MDC;
  inout MDIO;
  output PHY_RST_N;
  input pcie_clk_p;
  output pcie_top_0_pci_exp_0_txp_pin;
  input pcie_clk_n;
  input pcie_top_0_pci_exp_0_rxp_pin;
  input pcie_top_0_pci_exp_0_rxn_pin;
  output pcie_top_0_pci_exp_1_txp_pin;
  output pcie_top_0_pci_exp_1_txn_pin;
  input pcie_top_0_pci_exp_1_rxp_pin;
  input pcie_top_0_pci_exp_1_rxn_pin;
  output pcie_top_0_pci_exp_4_txp_pin;
  output pcie_top_0_pci_exp_2_txp_pin;
  output pcie_top_0_pci_exp_2_txn_pin;
  input pcie_top_0_pci_exp_2_rxp_pin;
  input pcie_top_0_pci_exp_2_rxn_pin;
  output pcie_top_0_pci_exp_3_txp_pin;
  output pcie_top_0_pci_exp_3_txn_pin;
  input pcie_top_0_pci_exp_3_rxp_pin;
  input pcie_top_0_pci_exp_3_rxn_pin;
  output pcie_top_0_pci_exp_4_txn_pin;
  input pcie_top_0_pci_exp_4_rxp_pin;
  input pcie_top_0_pci_exp_4_rxn_pin;
  output pcie_top_0_pci_exp_5_txp_pin;
  output pcie_top_0_pci_exp_5_txn_pin;
  input pcie_top_0_pci_exp_5_rxp_pin;
  input pcie_top_0_pci_exp_5_rxn_pin;
  output pcie_top_0_pci_exp_6_txp_pin;
  output pcie_top_0_pci_exp_6_txn_pin;
  input pcie_top_0_pci_exp_6_rxp_pin;
  input pcie_top_0_pci_exp_6_rxn_pin;
  output pcie_top_0_pci_exp_7_txn_pin;
  output pcie_top_0_pci_exp_7_txp_pin;
  input pcie_top_0_pci_exp_7_rxn_pin;
  input pcie_top_0_pci_exp_7_rxp_pin;
  output pcie_top_0_pci_exp_0_txn_pin;

  // Internal signals

  wire DIFF_INPUT_BUF_0_DIFF_INPUT_N;
  wire DIFF_INPUT_BUF_0_DIFF_INPUT_P;
  wire DIFF_INPUT_BUF_1_DIFF_INPUT_N;
  wire DIFF_INPUT_BUF_1_DIFF_INPUT_P;
  wire DIFF_INPUT_BUF_2_DIFF_INPUT_N;
  wire DIFF_INPUT_BUF_2_DIFF_INPUT_P;
  wire DIFF_INPUT_BUF_3_DIFF_INPUT_N;
  wire DIFF_INPUT_BUF_3_DIFF_INPUT_P;
  wire [0:0] Peripheral_aresetn;
  wire [159:0] axi_interconnect_0_M_ARADDR;
  wire [9:0] axi_interconnect_0_M_ARBURST;
  wire [19:0] axi_interconnect_0_M_ARCACHE;
  wire [4:0] axi_interconnect_0_M_ARESETN;
  wire [9:0] axi_interconnect_0_M_ARID;
  wire [39:0] axi_interconnect_0_M_ARLEN;
  wire [4:0] axi_interconnect_0_M_ARREADY;
  wire [14:0] axi_interconnect_0_M_ARSIZE;
  wire [4:0] axi_interconnect_0_M_ARVALID;
  wire [159:0] axi_interconnect_0_M_AWADDR;
  wire [9:0] axi_interconnect_0_M_AWBURST;
  wire [19:0] axi_interconnect_0_M_AWCACHE;
  wire [9:0] axi_interconnect_0_M_AWID;
  wire [39:0] axi_interconnect_0_M_AWLEN;
  wire [4:0] axi_interconnect_0_M_AWREADY;
  wire [14:0] axi_interconnect_0_M_AWSIZE;
  wire [4:0] axi_interconnect_0_M_AWVALID;
  wire [9:0] axi_interconnect_0_M_BID;
  wire [4:0] axi_interconnect_0_M_BREADY;
  wire [9:0] axi_interconnect_0_M_BRESP;
  wire [4:0] axi_interconnect_0_M_BVALID;
  wire [159:0] axi_interconnect_0_M_RDATA;
  wire [9:0] axi_interconnect_0_M_RID;
  wire [4:0] axi_interconnect_0_M_RLAST;
  wire [4:0] axi_interconnect_0_M_RREADY;
  wire [9:0] axi_interconnect_0_M_RRESP;
  wire [4:0] axi_interconnect_0_M_RVALID;
  wire [159:0] axi_interconnect_0_M_WDATA;
  wire [4:0] axi_interconnect_0_M_WLAST;
  wire [4:0] axi_interconnect_0_M_WREADY;
  wire [19:0] axi_interconnect_0_M_WSTRB;
  wire [4:0] axi_interconnect_0_M_WVALID;
  wire [95:0] axi_interconnect_0_S_ARADDR;
  wire [5:0] axi_interconnect_0_S_ARBURST;
  wire [11:0] axi_interconnect_0_S_ARCACHE;
  wire [2:0] axi_interconnect_0_S_ARESETN;
  wire [5:0] axi_interconnect_0_S_ARID;
  wire [23:0] axi_interconnect_0_S_ARLEN;
  wire [5:0] axi_interconnect_0_S_ARLOCK;
  wire [8:0] axi_interconnect_0_S_ARPROT;
  wire [11:0] axi_interconnect_0_S_ARQOS;
  wire [2:0] axi_interconnect_0_S_ARREADY;
  wire [8:0] axi_interconnect_0_S_ARSIZE;
  wire [2:0] axi_interconnect_0_S_ARVALID;
  wire [95:0] axi_interconnect_0_S_AWADDR;
  wire [5:0] axi_interconnect_0_S_AWBURST;
  wire [11:0] axi_interconnect_0_S_AWCACHE;
  wire [5:0] axi_interconnect_0_S_AWID;
  wire [23:0] axi_interconnect_0_S_AWLEN;
  wire [5:0] axi_interconnect_0_S_AWLOCK;
  wire [8:0] axi_interconnect_0_S_AWPROT;
  wire [11:0] axi_interconnect_0_S_AWQOS;
  wire [2:0] axi_interconnect_0_S_AWREADY;
  wire [8:0] axi_interconnect_0_S_AWSIZE;
  wire [2:0] axi_interconnect_0_S_AWVALID;
  wire [5:0] axi_interconnect_0_S_BID;
  wire [2:0] axi_interconnect_0_S_BREADY;
  wire [5:0] axi_interconnect_0_S_BRESP;
  wire [2:0] axi_interconnect_0_S_BVALID;
  wire [95:0] axi_interconnect_0_S_RDATA;
  wire [5:0] axi_interconnect_0_S_RID;
  wire [2:0] axi_interconnect_0_S_RLAST;
  wire [2:0] axi_interconnect_0_S_RREADY;
  wire [5:0] axi_interconnect_0_S_RRESP;
  wire [2:0] axi_interconnect_0_S_RVALID;
  wire [95:0] axi_interconnect_0_S_WDATA;
  wire [2:0] axi_interconnect_0_S_WLAST;
  wire [2:0] axi_interconnect_0_S_WREADY;
  wire [11:0] axi_interconnect_0_S_WSTRB;
  wire [2:0] axi_interconnect_0_S_WVALID;
  wire [0:0] connectnetwork_0_reset_reset_0_Reset_2_adhoc;
  wire control_clk;
  wire core_clk;
  wire dcm_locked;
  wire [255:0] dma_0_M_AXIS_TDATA;
  wire dma_0_M_AXIS_TLAST;
  wire dma_0_M_AXIS_TREADY;
  wire [31:0] dma_0_M_AXIS_TSTRB;
  wire [127:0] dma_0_M_AXIS_TUSER;
  wire dma_0_M_AXIS_TVALID;
  wire microblaze_0_Reset_reset_0_Reset_0_adhoc;
  wire [0:31] microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr;
  wire microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk;
  wire [0:31] microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din;
  wire [0:31] microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout;
  wire microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN;
  wire microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst;
  wire [0:3] microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN;
  wire [0:31] microblaze_0_dlmb_LMB_ABus;
  wire microblaze_0_dlmb_LMB_AddrStrobe;
  wire [0:3] microblaze_0_dlmb_LMB_BE;
  wire [0:31] microblaze_0_dlmb_LMB_ReadDBus;
  wire microblaze_0_dlmb_LMB_ReadStrobe;
  wire microblaze_0_dlmb_LMB_Ready;
  wire microblaze_0_dlmb_LMB_Rst;
  wire [0:31] microblaze_0_dlmb_LMB_WriteDBus;
  wire microblaze_0_dlmb_LMB_WriteStrobe;
  wire [0:31] microblaze_0_dlmb_M_ABus;
  wire microblaze_0_dlmb_M_AddrStrobe;
  wire [0:3] microblaze_0_dlmb_M_BE;
  wire [0:31] microblaze_0_dlmb_M_DBus;
  wire microblaze_0_dlmb_M_ReadStrobe;
  wire microblaze_0_dlmb_M_WriteStrobe;
  wire [0:31] microblaze_0_dlmb_Sl_DBus;
  wire [0:0] microblaze_0_dlmb_Sl_Ready;
  wire [0:31] microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr;
  wire microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk;
  wire [0:31] microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din;
  wire [0:31] microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout;
  wire microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN;
  wire microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst;
  wire [0:3] microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN;
  wire [0:31] microblaze_0_ilmb_LMB_ABus;
  wire microblaze_0_ilmb_LMB_AddrStrobe;
  wire [0:3] microblaze_0_ilmb_LMB_BE;
  wire [0:31] microblaze_0_ilmb_LMB_ReadDBus;
  wire microblaze_0_ilmb_LMB_ReadStrobe;
  wire microblaze_0_ilmb_LMB_Ready;
  wire microblaze_0_ilmb_LMB_Rst;
  wire [0:31] microblaze_0_ilmb_LMB_WriteDBus;
  wire microblaze_0_ilmb_LMB_WriteStrobe;
  wire [0:31] microblaze_0_ilmb_M_ABus;
  wire microblaze_0_ilmb_M_AddrStrobe;
  wire microblaze_0_ilmb_M_ReadStrobe;
  wire [0:31] microblaze_0_ilmb_Sl_DBus;
  wire [0:0] microblaze_0_ilmb_Sl_Ready;
  wire net_gnd0;
  wire [0:0] net_gnd1;
  wire [0:1] net_gnd2;
  wire [2:0] net_gnd3;
  wire [0:3] net_gnd4;
  wire [4:0] net_gnd5;
  wire [0:7] net_gnd8;
  wire [0:31] net_gnd32;
  wire [255:0] nf10_10g_interface_0_M_AXIS_TDATA;
  wire nf10_10g_interface_0_M_AXIS_TLAST;
  wire nf10_10g_interface_0_M_AXIS_TREADY;
  wire [31:0] nf10_10g_interface_0_M_AXIS_TSTRB;
  wire [127:0] nf10_10g_interface_0_M_AXIS_TUSER;
  wire nf10_10g_interface_0_M_AXIS_TVALID;
  wire nf10_10g_interface_0_xaui_rx_l0_n;
  wire nf10_10g_interface_0_xaui_rx_l0_p;
  wire nf10_10g_interface_0_xaui_rx_l1_n;
  wire nf10_10g_interface_0_xaui_rx_l1_p;
  wire nf10_10g_interface_0_xaui_rx_l2_n;
  wire nf10_10g_interface_0_xaui_rx_l2_p;
  wire nf10_10g_interface_0_xaui_rx_l3_n;
  wire nf10_10g_interface_0_xaui_rx_l3_p;
  wire nf10_10g_interface_0_xaui_tx_l0_n;
  wire nf10_10g_interface_0_xaui_tx_l0_p;
  wire nf10_10g_interface_0_xaui_tx_l1_n;
  wire nf10_10g_interface_0_xaui_tx_l1_p;
  wire nf10_10g_interface_0_xaui_tx_l2_n;
  wire nf10_10g_interface_0_xaui_tx_l2_p;
  wire nf10_10g_interface_0_xaui_tx_l3_n;
  wire nf10_10g_interface_0_xaui_tx_l3_p;
  wire [255:0] nf10_10g_interface_1_M_AXIS_TDATA;
  wire nf10_10g_interface_1_M_AXIS_TLAST;
  wire nf10_10g_interface_1_M_AXIS_TREADY;
  wire [31:0] nf10_10g_interface_1_M_AXIS_TSTRB;
  wire [127:0] nf10_10g_interface_1_M_AXIS_TUSER;
  wire nf10_10g_interface_1_M_AXIS_TVALID;
  wire nf10_10g_interface_1_xaui_rx_l0_n;
  wire nf10_10g_interface_1_xaui_rx_l0_p;
  wire nf10_10g_interface_1_xaui_rx_l1_n;
  wire nf10_10g_interface_1_xaui_rx_l1_p;
  wire nf10_10g_interface_1_xaui_rx_l2_n;
  wire nf10_10g_interface_1_xaui_rx_l2_p;
  wire nf10_10g_interface_1_xaui_rx_l3_n;
  wire nf10_10g_interface_1_xaui_rx_l3_p;
  wire nf10_10g_interface_1_xaui_tx_l0_n;
  wire nf10_10g_interface_1_xaui_tx_l0_p;
  wire nf10_10g_interface_1_xaui_tx_l1_n;
  wire nf10_10g_interface_1_xaui_tx_l1_p;
  wire nf10_10g_interface_1_xaui_tx_l2_n;
  wire nf10_10g_interface_1_xaui_tx_l2_p;
  wire nf10_10g_interface_1_xaui_tx_l3_n;
  wire nf10_10g_interface_1_xaui_tx_l3_p;
  wire [255:0] nf10_10g_interface_2_M_AXIS_TDATA;
  wire nf10_10g_interface_2_M_AXIS_TLAST;
  wire nf10_10g_interface_2_M_AXIS_TREADY;
  wire [31:0] nf10_10g_interface_2_M_AXIS_TSTRB;
  wire [127:0] nf10_10g_interface_2_M_AXIS_TUSER;
  wire nf10_10g_interface_2_M_AXIS_TVALID;
  wire nf10_10g_interface_2_xaui_rx_l0_n;
  wire nf10_10g_interface_2_xaui_rx_l0_p;
  wire nf10_10g_interface_2_xaui_rx_l1_n;
  wire nf10_10g_interface_2_xaui_rx_l1_p;
  wire nf10_10g_interface_2_xaui_rx_l2_n;
  wire nf10_10g_interface_2_xaui_rx_l2_p;
  wire nf10_10g_interface_2_xaui_rx_l3_n;
  wire nf10_10g_interface_2_xaui_rx_l3_p;
  wire nf10_10g_interface_2_xaui_tx_l0_n;
  wire nf10_10g_interface_2_xaui_tx_l0_p;
  wire nf10_10g_interface_2_xaui_tx_l1_n;
  wire nf10_10g_interface_2_xaui_tx_l1_p;
  wire nf10_10g_interface_2_xaui_tx_l2_n;
  wire nf10_10g_interface_2_xaui_tx_l2_p;
  wire nf10_10g_interface_2_xaui_tx_l3_n;
  wire nf10_10g_interface_2_xaui_tx_l3_p;
  wire [255:0] nf10_10g_interface_3_M_AXIS_TDATA;
  wire nf10_10g_interface_3_M_AXIS_TLAST;
  wire nf10_10g_interface_3_M_AXIS_TREADY;
  wire [31:0] nf10_10g_interface_3_M_AXIS_TSTRB;
  wire [127:0] nf10_10g_interface_3_M_AXIS_TUSER;
  wire nf10_10g_interface_3_M_AXIS_TVALID;
  wire nf10_10g_interface_3_xaui_rx_l0_n;
  wire nf10_10g_interface_3_xaui_rx_l0_p;
  wire nf10_10g_interface_3_xaui_rx_l1_n;
  wire nf10_10g_interface_3_xaui_rx_l1_p;
  wire nf10_10g_interface_3_xaui_rx_l2_n;
  wire nf10_10g_interface_3_xaui_rx_l2_p;
  wire nf10_10g_interface_3_xaui_rx_l3_n;
  wire nf10_10g_interface_3_xaui_rx_l3_p;
  wire nf10_10g_interface_3_xaui_tx_l0_n;
  wire nf10_10g_interface_3_xaui_tx_l0_p;
  wire nf10_10g_interface_3_xaui_tx_l1_n;
  wire nf10_10g_interface_3_xaui_tx_l1_p;
  wire nf10_10g_interface_3_xaui_tx_l2_n;
  wire nf10_10g_interface_3_xaui_tx_l2_p;
  wire nf10_10g_interface_3_xaui_tx_l3_n;
  wire nf10_10g_interface_3_xaui_tx_l3_p;
  wire [255:0] nf10_bram_output_queues_0_M_AXIS_0_TDATA;
  wire nf10_bram_output_queues_0_M_AXIS_0_TLAST;
  wire nf10_bram_output_queues_0_M_AXIS_0_TREADY;
  wire [31:0] nf10_bram_output_queues_0_M_AXIS_0_TSTRB;
  wire [127:0] nf10_bram_output_queues_0_M_AXIS_0_TUSER;
  wire nf10_bram_output_queues_0_M_AXIS_0_TVALID;
  wire [255:0] nf10_bram_output_queues_0_M_AXIS_1_TDATA;
  wire nf10_bram_output_queues_0_M_AXIS_1_TLAST;
  wire nf10_bram_output_queues_0_M_AXIS_1_TREADY;
  wire [31:0] nf10_bram_output_queues_0_M_AXIS_1_TSTRB;
  wire [127:0] nf10_bram_output_queues_0_M_AXIS_1_TUSER;
  wire nf10_bram_output_queues_0_M_AXIS_1_TVALID;
  wire [255:0] nf10_bram_output_queues_0_M_AXIS_2_TDATA;
  wire nf10_bram_output_queues_0_M_AXIS_2_TLAST;
  wire nf10_bram_output_queues_0_M_AXIS_2_TREADY;
  wire [31:0] nf10_bram_output_queues_0_M_AXIS_2_TSTRB;
  wire [127:0] nf10_bram_output_queues_0_M_AXIS_2_TUSER;
  wire nf10_bram_output_queues_0_M_AXIS_2_TVALID;
  wire [255:0] nf10_bram_output_queues_0_M_AXIS_3_TDATA;
  wire nf10_bram_output_queues_0_M_AXIS_3_TLAST;
  wire nf10_bram_output_queues_0_M_AXIS_3_TREADY;
  wire [31:0] nf10_bram_output_queues_0_M_AXIS_3_TSTRB;
  wire [127:0] nf10_bram_output_queues_0_M_AXIS_3_TUSER;
  wire nf10_bram_output_queues_0_M_AXIS_3_TVALID;
  wire [255:0] nf10_bram_output_queues_0_M_AXIS_4_TDATA;
  wire nf10_bram_output_queues_0_M_AXIS_4_TLAST;
  wire nf10_bram_output_queues_0_M_AXIS_4_TREADY;
  wire [31:0] nf10_bram_output_queues_0_M_AXIS_4_TSTRB;
  wire [127:0] nf10_bram_output_queues_0_M_AXIS_4_TUSER;
  wire nf10_bram_output_queues_0_M_AXIS_4_TVALID;
  wire [255:0] nf10_input_arbiter_0_M_AXIS_TDATA;
  wire nf10_input_arbiter_0_M_AXIS_TLAST;
  wire nf10_input_arbiter_0_M_AXIS_TREADY;
  wire [31:0] nf10_input_arbiter_0_M_AXIS_TSTRB;
  wire [127:0] nf10_input_arbiter_0_M_AXIS_TUSER;
  wire nf10_input_arbiter_0_M_AXIS_TVALID;
  wire nf10_mdio_0_PHY_MDC;
  wire nf10_mdio_0_PHY_MDIO_I;
  wire nf10_mdio_0_PHY_MDIO_O;
  wire nf10_mdio_0_PHY_MDIO_T;
  wire nf10_mdio_0_PHY_rst_n;
  wire [255:0] nf10_switch_output_port_lookup_0_M_AXIS_TDATA;
  wire nf10_switch_output_port_lookup_0_M_AXIS_TLAST;
  wire nf10_switch_output_port_lookup_0_M_AXIS_TREADY;
  wire [31:0] nf10_switch_output_port_lookup_0_M_AXIS_TSTRB;
  wire [127:0] nf10_switch_output_port_lookup_0_M_AXIS_TUSER;
  wire nf10_switch_output_port_lookup_0_M_AXIS_TVALID;
  wire pcie_top_0_pci_exp_0_rxn;
  wire pcie_top_0_pci_exp_0_rxp;
  wire pcie_top_0_pci_exp_0_txn;
  wire pcie_top_0_pci_exp_0_txp;
  wire pcie_top_0_pci_exp_1_rxn;
  wire pcie_top_0_pci_exp_1_rxp;
  wire pcie_top_0_pci_exp_1_txn;
  wire pcie_top_0_pci_exp_1_txp;
  wire pcie_top_0_pci_exp_2_rxn;
  wire pcie_top_0_pci_exp_2_rxp;
  wire pcie_top_0_pci_exp_2_txn;
  wire pcie_top_0_pci_exp_2_txp;
  wire pcie_top_0_pci_exp_3_rxn;
  wire pcie_top_0_pci_exp_3_rxp;
  wire pcie_top_0_pci_exp_3_txn;
  wire pcie_top_0_pci_exp_3_txp;
  wire pcie_top_0_pci_exp_4_rxn;
  wire pcie_top_0_pci_exp_4_rxp;
  wire pcie_top_0_pci_exp_4_txn;
  wire pcie_top_0_pci_exp_4_txp;
  wire pcie_top_0_pci_exp_5_rxn;
  wire pcie_top_0_pci_exp_5_rxp;
  wire pcie_top_0_pci_exp_5_txn;
  wire pcie_top_0_pci_exp_5_txp;
  wire pcie_top_0_pci_exp_6_rxn;
  wire pcie_top_0_pci_exp_6_rxp;
  wire pcie_top_0_pci_exp_6_txn;
  wire pcie_top_0_pci_exp_6_txp;
  wire pcie_top_0_pci_exp_7_rxn;
  wire pcie_top_0_pci_exp_7_rxp;
  wire pcie_top_0_pci_exp_7_txn;
  wire pcie_top_0_pci_exp_7_txp;
  wire pcie_top_0_pcie_clk_n;
  wire pcie_top_0_pcie_clk_p;
  wire [2:0] pgassign1;
  wire [4:0] pgassign2;
  wire refclk_A;
  wire refclk_B;
  wire refclk_C;
  wire refclk_D;
  wire [0:0] sys_bus_reset;

  // Internal assignments

  assign nf10_10g_interface_0_xaui_tx_l0_p_pin = nf10_10g_interface_0_xaui_tx_l0_p;
  assign nf10_10g_interface_0_xaui_tx_l0_n_pin = nf10_10g_interface_0_xaui_tx_l0_n;
  assign nf10_10g_interface_0_xaui_tx_l1_p_pin = nf10_10g_interface_0_xaui_tx_l1_p;
  assign nf10_10g_interface_0_xaui_tx_l1_n_pin = nf10_10g_interface_0_xaui_tx_l1_n;
  assign nf10_10g_interface_0_xaui_tx_l2_p_pin = nf10_10g_interface_0_xaui_tx_l2_p;
  assign nf10_10g_interface_0_xaui_tx_l3_n_pin = nf10_10g_interface_0_xaui_tx_l3_n;
  assign nf10_10g_interface_0_xaui_tx_l2_n_pin = nf10_10g_interface_0_xaui_tx_l2_n;
  assign nf10_10g_interface_0_xaui_tx_l3_p_pin = nf10_10g_interface_0_xaui_tx_l3_p;
  assign nf10_10g_interface_0_xaui_rx_l0_n = nf10_10g_interface_0_xaui_rx_l0_n_pin;
  assign nf10_10g_interface_0_xaui_rx_l1_p = nf10_10g_interface_0_xaui_rx_l1_p_pin;
  assign nf10_10g_interface_0_xaui_rx_l1_n = nf10_10g_interface_0_xaui_rx_l1_n_pin;
  assign nf10_10g_interface_0_xaui_rx_l2_p = nf10_10g_interface_0_xaui_rx_l2_p_pin;
  assign nf10_10g_interface_0_xaui_rx_l2_n = nf10_10g_interface_0_xaui_rx_l2_n_pin;
  assign nf10_10g_interface_0_xaui_rx_l3_p = nf10_10g_interface_0_xaui_rx_l3_p_pin;
  assign nf10_10g_interface_0_xaui_rx_l3_n = nf10_10g_interface_0_xaui_rx_l3_n_pin;
  assign nf10_10g_interface_0_xaui_rx_l0_p = nf10_10g_interface_0_xaui_rx_l0_p_pin;
  assign nf10_10g_interface_1_xaui_tx_l3_n_pin = nf10_10g_interface_1_xaui_tx_l3_n;
  assign nf10_10g_interface_1_xaui_tx_l1_n_pin = nf10_10g_interface_1_xaui_tx_l1_n;
  assign nf10_10g_interface_1_xaui_tx_l3_p_pin = nf10_10g_interface_1_xaui_tx_l3_p;
  assign nf10_10g_interface_1_xaui_tx_l0_p_pin = nf10_10g_interface_1_xaui_tx_l0_p;
  assign nf10_10g_interface_1_xaui_tx_l0_n_pin = nf10_10g_interface_1_xaui_tx_l0_n;
  assign nf10_10g_interface_1_xaui_tx_l1_p_pin = nf10_10g_interface_1_xaui_tx_l1_p;
  assign nf10_10g_interface_1_xaui_tx_l2_n_pin = nf10_10g_interface_1_xaui_tx_l2_n;
  assign nf10_10g_interface_1_xaui_rx_l0_p = nf10_10g_interface_1_xaui_rx_l0_p_pin;
  assign nf10_10g_interface_1_xaui_rx_l0_n = nf10_10g_interface_1_xaui_rx_l0_n_pin;
  assign nf10_10g_interface_1_xaui_rx_l1_p = nf10_10g_interface_1_xaui_rx_l1_p_pin;
  assign nf10_10g_interface_1_xaui_rx_l1_n = nf10_10g_interface_1_xaui_rx_l1_n_pin;
  assign nf10_10g_interface_1_xaui_rx_l2_p = nf10_10g_interface_1_xaui_rx_l2_p_pin;
  assign nf10_10g_interface_1_xaui_rx_l2_n = nf10_10g_interface_1_xaui_rx_l2_n_pin;
  assign nf10_10g_interface_1_xaui_rx_l3_p = nf10_10g_interface_1_xaui_rx_l3_p_pin;
  assign nf10_10g_interface_1_xaui_rx_l3_n = nf10_10g_interface_1_xaui_rx_l3_n_pin;
  assign nf10_10g_interface_1_xaui_tx_l2_p_pin = nf10_10g_interface_1_xaui_tx_l2_p;
  assign nf10_10g_interface_2_xaui_tx_l3_p_pin = nf10_10g_interface_2_xaui_tx_l3_p;
  assign nf10_10g_interface_2_xaui_tx_l3_n_pin = nf10_10g_interface_2_xaui_tx_l3_n;
  assign nf10_10g_interface_2_xaui_tx_l0_p_pin = nf10_10g_interface_2_xaui_tx_l0_p;
  assign nf10_10g_interface_2_xaui_tx_l0_n_pin = nf10_10g_interface_2_xaui_tx_l0_n;
  assign nf10_10g_interface_2_xaui_tx_l1_p_pin = nf10_10g_interface_2_xaui_tx_l1_p;
  assign nf10_10g_interface_2_xaui_tx_l2_p_pin = nf10_10g_interface_2_xaui_tx_l2_p;
  assign nf10_10g_interface_2_xaui_tx_l2_n_pin = nf10_10g_interface_2_xaui_tx_l2_n;
  assign nf10_10g_interface_2_xaui_rx_l0_p = nf10_10g_interface_2_xaui_rx_l0_p_pin;
  assign nf10_10g_interface_2_xaui_rx_l0_n = nf10_10g_interface_2_xaui_rx_l0_n_pin;
  assign nf10_10g_interface_2_xaui_rx_l1_p = nf10_10g_interface_2_xaui_rx_l1_p_pin;
  assign nf10_10g_interface_2_xaui_rx_l1_n = nf10_10g_interface_2_xaui_rx_l1_n_pin;
  assign nf10_10g_interface_2_xaui_rx_l2_p = nf10_10g_interface_2_xaui_rx_l2_p_pin;
  assign nf10_10g_interface_2_xaui_rx_l2_n = nf10_10g_interface_2_xaui_rx_l2_n_pin;
  assign nf10_10g_interface_2_xaui_rx_l3_p = nf10_10g_interface_2_xaui_rx_l3_p_pin;
  assign nf10_10g_interface_2_xaui_rx_l3_n = nf10_10g_interface_2_xaui_rx_l3_n_pin;
  assign nf10_10g_interface_2_xaui_tx_l1_n_pin = nf10_10g_interface_2_xaui_tx_l1_n;
  assign nf10_10g_interface_3_xaui_tx_l3_p_pin = nf10_10g_interface_3_xaui_tx_l3_p;
  assign nf10_10g_interface_3_xaui_tx_l3_n_pin = nf10_10g_interface_3_xaui_tx_l3_n;
  assign nf10_10g_interface_3_xaui_tx_l0_p_pin = nf10_10g_interface_3_xaui_tx_l0_p;
  assign nf10_10g_interface_3_xaui_tx_l0_n_pin = nf10_10g_interface_3_xaui_tx_l0_n;
  assign nf10_10g_interface_3_xaui_tx_l1_p_pin = nf10_10g_interface_3_xaui_tx_l1_p;
  assign nf10_10g_interface_3_xaui_tx_l2_p_pin = nf10_10g_interface_3_xaui_tx_l2_p;
  assign nf10_10g_interface_3_xaui_tx_l2_n_pin = nf10_10g_interface_3_xaui_tx_l2_n;
  assign nf10_10g_interface_3_xaui_rx_l0_p = nf10_10g_interface_3_xaui_rx_l0_p_pin;
  assign nf10_10g_interface_3_xaui_rx_l0_n = nf10_10g_interface_3_xaui_rx_l0_n_pin;
  assign nf10_10g_interface_3_xaui_rx_l1_p = nf10_10g_interface_3_xaui_rx_l1_p_pin;
  assign nf10_10g_interface_3_xaui_rx_l1_n = nf10_10g_interface_3_xaui_rx_l1_n_pin;
  assign nf10_10g_interface_3_xaui_rx_l2_p = nf10_10g_interface_3_xaui_rx_l2_p_pin;
  assign nf10_10g_interface_3_xaui_rx_l2_n = nf10_10g_interface_3_xaui_rx_l2_n_pin;
  assign nf10_10g_interface_3_xaui_rx_l3_p = nf10_10g_interface_3_xaui_rx_l3_p_pin;
  assign nf10_10g_interface_3_xaui_rx_l3_n = nf10_10g_interface_3_xaui_rx_l3_n_pin;
  assign nf10_10g_interface_3_xaui_tx_l1_n_pin = nf10_10g_interface_3_xaui_tx_l1_n;
  assign DIFF_INPUT_BUF_0_DIFF_INPUT_P = refclk_A_p;
  assign DIFF_INPUT_BUF_0_DIFF_INPUT_N = refclk_A_n;
  assign DIFF_INPUT_BUF_1_DIFF_INPUT_P = refclk_B_p;
  assign DIFF_INPUT_BUF_1_DIFF_INPUT_N = refclk_B_n;
  assign DIFF_INPUT_BUF_2_DIFF_INPUT_P = refclk_C_p;
  assign DIFF_INPUT_BUF_2_DIFF_INPUT_N = refclk_C_n;
  assign DIFF_INPUT_BUF_3_DIFF_INPUT_P = refclk_D_p;
  assign DIFF_INPUT_BUF_3_DIFF_INPUT_N = refclk_D_n;
  assign MDC = nf10_mdio_0_PHY_MDC;
  assign PHY_RST_N = nf10_mdio_0_PHY_rst_n;
  assign pcie_top_0_pcie_clk_p = pcie_clk_p;
  assign pcie_top_0_pci_exp_0_txp_pin = pcie_top_0_pci_exp_0_txp;
  assign pcie_top_0_pcie_clk_n = pcie_clk_n;
  assign pcie_top_0_pci_exp_0_rxp = pcie_top_0_pci_exp_0_rxp_pin;
  assign pcie_top_0_pci_exp_0_rxn = pcie_top_0_pci_exp_0_rxn_pin;
  assign pcie_top_0_pci_exp_1_txp_pin = pcie_top_0_pci_exp_1_txp;
  assign pcie_top_0_pci_exp_1_txn_pin = pcie_top_0_pci_exp_1_txn;
  assign pcie_top_0_pci_exp_1_rxp = pcie_top_0_pci_exp_1_rxp_pin;
  assign pcie_top_0_pci_exp_1_rxn = pcie_top_0_pci_exp_1_rxn_pin;
  assign pcie_top_0_pci_exp_4_txp_pin = pcie_top_0_pci_exp_4_txp;
  assign pcie_top_0_pci_exp_2_txp_pin = pcie_top_0_pci_exp_2_txp;
  assign pcie_top_0_pci_exp_2_txn_pin = pcie_top_0_pci_exp_2_txn;
  assign pcie_top_0_pci_exp_2_rxp = pcie_top_0_pci_exp_2_rxp_pin;
  assign pcie_top_0_pci_exp_2_rxn = pcie_top_0_pci_exp_2_rxn_pin;
  assign pcie_top_0_pci_exp_3_txp_pin = pcie_top_0_pci_exp_3_txp;
  assign pcie_top_0_pci_exp_3_txn_pin = pcie_top_0_pci_exp_3_txn;
  assign pcie_top_0_pci_exp_3_rxp = pcie_top_0_pci_exp_3_rxp_pin;
  assign pcie_top_0_pci_exp_3_rxn = pcie_top_0_pci_exp_3_rxn_pin;
  assign pcie_top_0_pci_exp_4_txn_pin = pcie_top_0_pci_exp_4_txn;
  assign pcie_top_0_pci_exp_4_rxp = pcie_top_0_pci_exp_4_rxp_pin;
  assign pcie_top_0_pci_exp_4_rxn = pcie_top_0_pci_exp_4_rxn_pin;
  assign pcie_top_0_pci_exp_5_txp_pin = pcie_top_0_pci_exp_5_txp;
  assign pcie_top_0_pci_exp_5_txn_pin = pcie_top_0_pci_exp_5_txn;
  assign pcie_top_0_pci_exp_5_rxp = pcie_top_0_pci_exp_5_rxp_pin;
  assign pcie_top_0_pci_exp_5_rxn = pcie_top_0_pci_exp_5_rxn_pin;
  assign pcie_top_0_pci_exp_6_txp_pin = pcie_top_0_pci_exp_6_txp;
  assign pcie_top_0_pci_exp_6_txn_pin = pcie_top_0_pci_exp_6_txn;
  assign pcie_top_0_pci_exp_6_rxp = pcie_top_0_pci_exp_6_rxp_pin;
  assign pcie_top_0_pci_exp_6_rxn = pcie_top_0_pci_exp_6_rxn_pin;
  assign pcie_top_0_pci_exp_7_txn_pin = pcie_top_0_pci_exp_7_txn;
  assign pcie_top_0_pci_exp_7_txp_pin = pcie_top_0_pci_exp_7_txp;
  assign pcie_top_0_pci_exp_7_rxn = pcie_top_0_pci_exp_7_rxn_pin;
  assign pcie_top_0_pci_exp_7_rxp = pcie_top_0_pci_exp_7_rxp_pin;
  assign pcie_top_0_pci_exp_0_txn_pin = pcie_top_0_pci_exp_0_txn;
  assign axi_interconnect_0_S_AWID[3:2] = 2'b00;
  assign axi_interconnect_0_S_AWID[5:4] = 2'b00;
  assign axi_interconnect_0_S_AWLEN[15:8] = 8'b00000000;
  assign axi_interconnect_0_S_AWLEN[23:16] = 8'b00000000;
  assign axi_interconnect_0_S_AWSIZE[5:3] = 3'b000;
  assign axi_interconnect_0_S_AWSIZE[8:6] = 3'b000;
  assign axi_interconnect_0_S_AWBURST[3:2] = 2'b00;
  assign axi_interconnect_0_S_AWBURST[5:4] = 2'b00;
  assign axi_interconnect_0_S_AWLOCK[3:2] = 2'b00;
  assign axi_interconnect_0_S_AWLOCK[5:4] = 2'b00;
  assign axi_interconnect_0_S_AWCACHE[7:4] = 4'b0000;
  assign axi_interconnect_0_S_AWCACHE[11:8] = 4'b0000;
  assign axi_interconnect_0_S_AWPROT[5:3] = 3'b000;
  assign axi_interconnect_0_S_AWPROT[8:6] = 3'b000;
  assign axi_interconnect_0_S_AWQOS[7:4] = 4'b0000;
  assign axi_interconnect_0_S_AWQOS[11:8] = 4'b0000;
  assign axi_interconnect_0_S_WLAST[1:1] = 1'b0;
  assign axi_interconnect_0_S_WLAST[2:2] = 1'b0;
  assign axi_interconnect_0_S_ARID[3:2] = 2'b00;
  assign axi_interconnect_0_S_ARID[5:4] = 2'b00;
  assign axi_interconnect_0_S_ARLEN[15:8] = 8'b00000000;
  assign axi_interconnect_0_S_ARLEN[23:16] = 8'b00000000;
  assign axi_interconnect_0_S_ARSIZE[5:3] = 3'b000;
  assign axi_interconnect_0_S_ARSIZE[8:6] = 3'b000;
  assign axi_interconnect_0_S_ARBURST[3:2] = 2'b00;
  assign axi_interconnect_0_S_ARBURST[5:4] = 2'b00;
  assign axi_interconnect_0_S_ARLOCK[3:2] = 2'b00;
  assign axi_interconnect_0_S_ARLOCK[5:4] = 2'b00;
  assign axi_interconnect_0_S_ARCACHE[7:4] = 4'b0000;
  assign axi_interconnect_0_S_ARCACHE[11:8] = 4'b0000;
  assign axi_interconnect_0_S_ARPROT[5:3] = 3'b000;
  assign axi_interconnect_0_S_ARPROT[8:6] = 3'b000;
  assign axi_interconnect_0_S_ARQOS[7:4] = 4'b0000;
  assign axi_interconnect_0_S_ARQOS[11:8] = 4'b0000;
  assign axi_interconnect_0_M_BID[1:0] = 2'b00;
  assign axi_interconnect_0_M_BID[3:2] = 2'b00;
  assign axi_interconnect_0_M_BID[7:6] = 2'b00;
  assign axi_interconnect_0_M_BID[9:8] = 2'b00;
  assign axi_interconnect_0_M_RID[1:0] = 2'b00;
  assign axi_interconnect_0_M_RID[3:2] = 2'b00;
  assign axi_interconnect_0_M_RID[7:6] = 2'b00;
  assign axi_interconnect_0_M_RID[9:8] = 2'b00;
  assign axi_interconnect_0_M_RLAST[0:0] = 1'b0;
  assign axi_interconnect_0_M_RLAST[1:1] = 1'b0;
  assign axi_interconnect_0_M_RLAST[3:3] = 1'b0;
  assign axi_interconnect_0_M_RLAST[4:4] = 1'b0;
  assign pgassign1[2] = control_clk;
  assign pgassign1[1] = control_clk;
  assign pgassign1[0] = control_clk;
  assign pgassign2[4] = control_clk;
  assign pgassign2[3] = control_clk;
  assign pgassign2[2] = control_clk;
  assign pgassign2[1] = control_clk;
  assign pgassign2[0] = core_clk;
  assign net_gnd0 = 1'b0;
  assign net_gnd1[0:0] = 1'b0;
  assign net_gnd2[0:1] = 2'b00;
  assign net_gnd3[2:0] = 3'b000;
  assign net_gnd32[0:31] = 32'b00000000000000000000000000000000;
  assign net_gnd4[0:3] = 4'b0000;
  assign net_gnd5[4:0] = 5'b00000;
  assign net_gnd8[0:7] = 8'b00000000;

  (* BOX_TYPE = "user_black_box" *)
  nf10_switch_output_port_lookup_0_wrapper
    nf10_switch_output_port_lookup_0 (
      .S_AXI_ACLK ( core_clk ),
      .S_AXI_ARESETN ( Peripheral_aresetn[0] ),
      .M_AXIS_TDATA ( nf10_switch_output_port_lookup_0_M_AXIS_TDATA ),
      .M_AXIS_TSTRB ( nf10_switch_output_port_lookup_0_M_AXIS_TSTRB ),
      .M_AXIS_TUSER ( nf10_switch_output_port_lookup_0_M_AXIS_TUSER ),
      .M_AXIS_TVALID ( nf10_switch_output_port_lookup_0_M_AXIS_TVALID ),
      .M_AXIS_TREADY ( nf10_switch_output_port_lookup_0_M_AXIS_TREADY ),
      .M_AXIS_TLAST ( nf10_switch_output_port_lookup_0_M_AXIS_TLAST ),
      .S_AXIS_TDATA ( nf10_input_arbiter_0_M_AXIS_TDATA ),
      .S_AXIS_TSTRB ( nf10_input_arbiter_0_M_AXIS_TSTRB ),
      .S_AXIS_TUSER ( nf10_input_arbiter_0_M_AXIS_TUSER ),
      .S_AXIS_TVALID ( nf10_input_arbiter_0_M_AXIS_TVALID ),
      .S_AXIS_TREADY ( nf10_input_arbiter_0_M_AXIS_TREADY ),
      .S_AXIS_TLAST ( nf10_input_arbiter_0_M_AXIS_TLAST ),
      .S_AXI_AWADDR ( axi_interconnect_0_M_AWADDR[31:0] ),
      .S_AXI_AWVALID ( axi_interconnect_0_M_AWVALID[0] ),
      .S_AXI_WDATA ( axi_interconnect_0_M_WDATA[31:0] ),
      .S_AXI_WSTRB ( axi_interconnect_0_M_WSTRB[3:0] ),
      .S_AXI_WVALID ( axi_interconnect_0_M_WVALID[0] ),
      .S_AXI_BREADY ( axi_interconnect_0_M_BREADY[0] ),
      .S_AXI_ARADDR ( axi_interconnect_0_M_ARADDR[31:0] ),
      .S_AXI_ARVALID ( axi_interconnect_0_M_ARVALID[0] ),
      .S_AXI_RREADY ( axi_interconnect_0_M_RREADY[0] ),
      .S_AXI_ARREADY ( axi_interconnect_0_M_ARREADY[0] ),
      .S_AXI_RDATA ( axi_interconnect_0_M_RDATA[31:0] ),
      .S_AXI_RRESP ( axi_interconnect_0_M_RRESP[1:0] ),
      .S_AXI_RVALID ( axi_interconnect_0_M_RVALID[0] ),
      .S_AXI_WREADY ( axi_interconnect_0_M_WREADY[0] ),
      .S_AXI_BRESP ( axi_interconnect_0_M_BRESP[1:0] ),
      .S_AXI_BVALID ( axi_interconnect_0_M_BVALID[0] ),
      .S_AXI_AWREADY ( axi_interconnect_0_M_AWREADY[0] )
    );

  (* BOX_TYPE = "user_black_box" *)
  axi_interconnect_0_wrapper
    axi_interconnect_0 (
      .INTERCONNECT_ACLK ( control_clk ),
      .INTERCONNECT_ARESETN ( connectnetwork_0_reset_reset_0_Reset_2_adhoc[0] ),
      .S_AXI_ARESET_OUT_N ( axi_interconnect_0_S_ARESETN ),
      .M_AXI_ARESET_OUT_N ( axi_interconnect_0_M_ARESETN ),
      .IRQ (  ),
      .S_AXI_ACLK ( pgassign1 ),
      .S_AXI_AWID ( axi_interconnect_0_S_AWID ),
      .S_AXI_AWADDR ( axi_interconnect_0_S_AWADDR ),
      .S_AXI_AWLEN ( axi_interconnect_0_S_AWLEN ),
      .S_AXI_AWSIZE ( axi_interconnect_0_S_AWSIZE ),
      .S_AXI_AWBURST ( axi_interconnect_0_S_AWBURST ),
      .S_AXI_AWLOCK ( axi_interconnect_0_S_AWLOCK ),
      .S_AXI_AWCACHE ( axi_interconnect_0_S_AWCACHE ),
      .S_AXI_AWPROT ( axi_interconnect_0_S_AWPROT ),
      .S_AXI_AWQOS ( axi_interconnect_0_S_AWQOS ),
      .S_AXI_AWUSER ( net_gnd3 ),
      .S_AXI_AWVALID ( axi_interconnect_0_S_AWVALID ),
      .S_AXI_AWREADY ( axi_interconnect_0_S_AWREADY ),
      .S_AXI_WDATA ( axi_interconnect_0_S_WDATA ),
      .S_AXI_WSTRB ( axi_interconnect_0_S_WSTRB ),
      .S_AXI_WLAST ( axi_interconnect_0_S_WLAST ),
      .S_AXI_WUSER ( net_gnd3 ),
      .S_AXI_WVALID ( axi_interconnect_0_S_WVALID ),
      .S_AXI_WREADY ( axi_interconnect_0_S_WREADY ),
      .S_AXI_BID ( axi_interconnect_0_S_BID ),
      .S_AXI_BRESP ( axi_interconnect_0_S_BRESP ),
      .S_AXI_BUSER (  ),
      .S_AXI_BVALID ( axi_interconnect_0_S_BVALID ),
      .S_AXI_BREADY ( axi_interconnect_0_S_BREADY ),
      .S_AXI_ARID ( axi_interconnect_0_S_ARID ),
      .S_AXI_ARADDR ( axi_interconnect_0_S_ARADDR ),
      .S_AXI_ARLEN ( axi_interconnect_0_S_ARLEN ),
      .S_AXI_ARSIZE ( axi_interconnect_0_S_ARSIZE ),
      .S_AXI_ARBURST ( axi_interconnect_0_S_ARBURST ),
      .S_AXI_ARLOCK ( axi_interconnect_0_S_ARLOCK ),
      .S_AXI_ARCACHE ( axi_interconnect_0_S_ARCACHE ),
      .S_AXI_ARPROT ( axi_interconnect_0_S_ARPROT ),
      .S_AXI_ARQOS ( axi_interconnect_0_S_ARQOS ),
      .S_AXI_ARUSER ( net_gnd3 ),
      .S_AXI_ARVALID ( axi_interconnect_0_S_ARVALID ),
      .S_AXI_ARREADY ( axi_interconnect_0_S_ARREADY ),
      .S_AXI_RID ( axi_interconnect_0_S_RID ),
      .S_AXI_RDATA ( axi_interconnect_0_S_RDATA ),
      .S_AXI_RRESP ( axi_interconnect_0_S_RRESP ),
      .S_AXI_RLAST ( axi_interconnect_0_S_RLAST ),
      .S_AXI_RUSER (  ),
      .S_AXI_RVALID ( axi_interconnect_0_S_RVALID ),
      .S_AXI_RREADY ( axi_interconnect_0_S_RREADY ),
      .M_AXI_ACLK ( pgassign2 ),
      .M_AXI_AWID ( axi_interconnect_0_M_AWID ),
      .M_AXI_AWADDR ( axi_interconnect_0_M_AWADDR ),
      .M_AXI_AWLEN ( axi_interconnect_0_M_AWLEN ),
      .M_AXI_AWSIZE ( axi_interconnect_0_M_AWSIZE ),
      .M_AXI_AWBURST ( axi_interconnect_0_M_AWBURST ),
      .M_AXI_AWLOCK (  ),
      .M_AXI_AWCACHE ( axi_interconnect_0_M_AWCACHE ),
      .M_AXI_AWPROT (  ),
      .M_AXI_AWREGION (  ),
      .M_AXI_AWQOS (  ),
      .M_AXI_AWUSER (  ),
      .M_AXI_AWVALID ( axi_interconnect_0_M_AWVALID ),
      .M_AXI_AWREADY ( axi_interconnect_0_M_AWREADY ),
      .M_AXI_WID (  ),
      .M_AXI_WDATA ( axi_interconnect_0_M_WDATA ),
      .M_AXI_WSTRB ( axi_interconnect_0_M_WSTRB ),
      .M_AXI_WLAST ( axi_interconnect_0_M_WLAST ),
      .M_AXI_WUSER (  ),
      .M_AXI_WVALID ( axi_interconnect_0_M_WVALID ),
      .M_AXI_WREADY ( axi_interconnect_0_M_WREADY ),
      .M_AXI_BID ( axi_interconnect_0_M_BID ),
      .M_AXI_BRESP ( axi_interconnect_0_M_BRESP ),
      .M_AXI_BUSER ( net_gnd5 ),
      .M_AXI_BVALID ( axi_interconnect_0_M_BVALID ),
      .M_AXI_BREADY ( axi_interconnect_0_M_BREADY ),
      .M_AXI_ARID ( axi_interconnect_0_M_ARID ),
      .M_AXI_ARADDR ( axi_interconnect_0_M_ARADDR ),
      .M_AXI_ARLEN ( axi_interconnect_0_M_ARLEN ),
      .M_AXI_ARSIZE ( axi_interconnect_0_M_ARSIZE ),
      .M_AXI_ARBURST ( axi_interconnect_0_M_ARBURST ),
      .M_AXI_ARLOCK (  ),
      .M_AXI_ARCACHE ( axi_interconnect_0_M_ARCACHE ),
      .M_AXI_ARPROT (  ),
      .M_AXI_ARREGION (  ),
      .M_AXI_ARQOS (  ),
      .M_AXI_ARUSER (  ),
      .M_AXI_ARVALID ( axi_interconnect_0_M_ARVALID ),
      .M_AXI_ARREADY ( axi_interconnect_0_M_ARREADY ),
      .M_AXI_RID ( axi_interconnect_0_M_RID ),
      .M_AXI_RDATA ( axi_interconnect_0_M_RDATA ),
      .M_AXI_RRESP ( axi_interconnect_0_M_RRESP ),
      .M_AXI_RLAST ( axi_interconnect_0_M_RLAST ),
      .M_AXI_RUSER ( net_gnd5 ),
      .M_AXI_RVALID ( axi_interconnect_0_M_RVALID ),
      .M_AXI_RREADY ( axi_interconnect_0_M_RREADY ),
      .S_AXI_CTRL_AWADDR ( net_gnd32[0:31] ),
      .S_AXI_CTRL_AWVALID ( net_gnd0 ),
      .S_AXI_CTRL_AWREADY (  ),
      .S_AXI_CTRL_WDATA ( net_gnd32[0:31] ),
      .S_AXI_CTRL_WVALID ( net_gnd0 ),
      .S_AXI_CTRL_WREADY (  ),
      .S_AXI_CTRL_BRESP (  ),
      .S_AXI_CTRL_BVALID (  ),
      .S_AXI_CTRL_BREADY ( net_gnd0 ),
      .S_AXI_CTRL_ARADDR ( net_gnd32[0:31] ),
      .S_AXI_CTRL_ARVALID ( net_gnd0 ),
      .S_AXI_CTRL_ARREADY (  ),
      .S_AXI_CTRL_RDATA (  ),
      .S_AXI_CTRL_RRESP (  ),
      .S_AXI_CTRL_RVALID (  ),
      .S_AXI_CTRL_RREADY ( net_gnd0 )
    );

  (* BOX_TYPE = "user_black_box" *)
  microblaze_0_wrapper
    microblaze_0 (
      .CLK ( control_clk ),
      .RESET ( microblaze_0_dlmb_LMB_Rst ),
      .MB_RESET ( microblaze_0_Reset_reset_0_Reset_0_adhoc ),
      .INTERRUPT ( net_gnd0 ),
      .EXT_BRK ( net_gnd0 ),
      .EXT_NM_BRK ( net_gnd0 ),
      .DBG_STOP ( net_gnd0 ),
      .MB_Halted (  ),
      .MB_Error (  ),
      .INSTR ( microblaze_0_ilmb_LMB_ReadDBus ),
      .IREADY ( microblaze_0_ilmb_LMB_Ready ),
      .IWAIT ( net_gnd0 ),
      .ICE ( net_gnd0 ),
      .IUE ( net_gnd0 ),
      .INSTR_ADDR ( microblaze_0_ilmb_M_ABus ),
      .IFETCH ( microblaze_0_ilmb_M_ReadStrobe ),
      .I_AS ( microblaze_0_ilmb_M_AddrStrobe ),
      .IPLB_M_ABort (  ),
      .IPLB_M_ABus (  ),
      .IPLB_M_UABus (  ),
      .IPLB_M_BE (  ),
      .IPLB_M_busLock (  ),
      .IPLB_M_lockErr (  ),
      .IPLB_M_MSize (  ),
      .IPLB_M_priority (  ),
      .IPLB_M_rdBurst (  ),
      .IPLB_M_request (  ),
      .IPLB_M_RNW (  ),
      .IPLB_M_size (  ),
      .IPLB_M_TAttribute (  ),
      .IPLB_M_type (  ),
      .IPLB_M_wrBurst (  ),
      .IPLB_M_wrDBus (  ),
      .IPLB_MBusy ( net_gnd0 ),
      .IPLB_MRdErr ( net_gnd0 ),
      .IPLB_MWrErr ( net_gnd0 ),
      .IPLB_MIRQ ( net_gnd0 ),
      .IPLB_MWrBTerm ( net_gnd0 ),
      .IPLB_MWrDAck ( net_gnd0 ),
      .IPLB_MAddrAck ( net_gnd0 ),
      .IPLB_MRdBTerm ( net_gnd0 ),
      .IPLB_MRdDAck ( net_gnd0 ),
      .IPLB_MRdDBus ( net_gnd32 ),
      .IPLB_MRdWdAddr ( net_gnd4 ),
      .IPLB_MRearbitrate ( net_gnd0 ),
      .IPLB_MSSize ( net_gnd2 ),
      .IPLB_MTimeout ( net_gnd0 ),
      .DATA_READ ( microblaze_0_dlmb_LMB_ReadDBus ),
      .DREADY ( microblaze_0_dlmb_LMB_Ready ),
      .DWAIT ( net_gnd0 ),
      .DCE ( net_gnd0 ),
      .DUE ( net_gnd0 ),
      .DATA_WRITE ( microblaze_0_dlmb_M_DBus ),
      .DATA_ADDR ( microblaze_0_dlmb_M_ABus ),
      .D_AS ( microblaze_0_dlmb_M_AddrStrobe ),
      .READ_STROBE ( microblaze_0_dlmb_M_ReadStrobe ),
      .WRITE_STROBE ( microblaze_0_dlmb_M_WriteStrobe ),
      .BYTE_ENABLE ( microblaze_0_dlmb_M_BE ),
      .DPLB_M_ABort (  ),
      .DPLB_M_ABus (  ),
      .DPLB_M_UABus (  ),
      .DPLB_M_BE (  ),
      .DPLB_M_busLock (  ),
      .DPLB_M_lockErr (  ),
      .DPLB_M_MSize (  ),
      .DPLB_M_priority (  ),
      .DPLB_M_rdBurst (  ),
      .DPLB_M_request (  ),
      .DPLB_M_RNW (  ),
      .DPLB_M_size (  ),
      .DPLB_M_TAttribute (  ),
      .DPLB_M_type (  ),
      .DPLB_M_wrBurst (  ),
      .DPLB_M_wrDBus (  ),
      .DPLB_MBusy ( net_gnd0 ),
      .DPLB_MRdErr ( net_gnd0 ),
      .DPLB_MWrErr ( net_gnd0 ),
      .DPLB_MIRQ ( net_gnd0 ),
      .DPLB_MWrBTerm ( net_gnd0 ),
      .DPLB_MWrDAck ( net_gnd0 ),
      .DPLB_MAddrAck ( net_gnd0 ),
      .DPLB_MRdBTerm ( net_gnd0 ),
      .DPLB_MRdDAck ( net_gnd0 ),
      .DPLB_MRdDBus ( net_gnd32 ),
      .DPLB_MRdWdAddr ( net_gnd4 ),
      .DPLB_MRearbitrate ( net_gnd0 ),
      .DPLB_MSSize ( net_gnd2 ),
      .DPLB_MTimeout ( net_gnd0 ),
      .M_AXI_IP_AWID (  ),
      .M_AXI_IP_AWADDR (  ),
      .M_AXI_IP_AWLEN (  ),
      .M_AXI_IP_AWSIZE (  ),
      .M_AXI_IP_AWBURST (  ),
      .M_AXI_IP_AWLOCK (  ),
      .M_AXI_IP_AWCACHE (  ),
      .M_AXI_IP_AWPROT (  ),
      .M_AXI_IP_AWQOS (  ),
      .M_AXI_IP_AWVALID (  ),
      .M_AXI_IP_AWREADY ( net_gnd0 ),
      .M_AXI_IP_WDATA (  ),
      .M_AXI_IP_WSTRB (  ),
      .M_AXI_IP_WLAST (  ),
      .M_AXI_IP_WVALID (  ),
      .M_AXI_IP_WREADY ( net_gnd0 ),
      .M_AXI_IP_BID ( net_gnd1[0:0] ),
      .M_AXI_IP_BRESP ( net_gnd2[0:1] ),
      .M_AXI_IP_BVALID ( net_gnd0 ),
      .M_AXI_IP_BREADY (  ),
      .M_AXI_IP_ARID (  ),
      .M_AXI_IP_ARADDR (  ),
      .M_AXI_IP_ARLEN (  ),
      .M_AXI_IP_ARSIZE (  ),
      .M_AXI_IP_ARBURST (  ),
      .M_AXI_IP_ARLOCK (  ),
      .M_AXI_IP_ARCACHE (  ),
      .M_AXI_IP_ARPROT (  ),
      .M_AXI_IP_ARQOS (  ),
      .M_AXI_IP_ARVALID (  ),
      .M_AXI_IP_ARREADY ( net_gnd0 ),
      .M_AXI_IP_RID ( net_gnd1[0:0] ),
      .M_AXI_IP_RDATA ( net_gnd32[0:31] ),
      .M_AXI_IP_RRESP ( net_gnd2[0:1] ),
      .M_AXI_IP_RLAST ( net_gnd0 ),
      .M_AXI_IP_RVALID ( net_gnd0 ),
      .M_AXI_IP_RREADY (  ),
      .M_AXI_DP_AWID ( axi_interconnect_0_S_AWID[0:0] ),
      .M_AXI_DP_AWADDR ( axi_interconnect_0_S_AWADDR[31:0] ),
      .M_AXI_DP_AWLEN ( axi_interconnect_0_S_AWLEN[7:0] ),
      .M_AXI_DP_AWSIZE ( axi_interconnect_0_S_AWSIZE[2:0] ),
      .M_AXI_DP_AWBURST ( axi_interconnect_0_S_AWBURST[1:0] ),
      .M_AXI_DP_AWLOCK ( axi_interconnect_0_S_AWLOCK[0] ),
      .M_AXI_DP_AWCACHE ( axi_interconnect_0_S_AWCACHE[3:0] ),
      .M_AXI_DP_AWPROT ( axi_interconnect_0_S_AWPROT[2:0] ),
      .M_AXI_DP_AWQOS ( axi_interconnect_0_S_AWQOS[3:0] ),
      .M_AXI_DP_AWVALID ( axi_interconnect_0_S_AWVALID[0] ),
      .M_AXI_DP_AWREADY ( axi_interconnect_0_S_AWREADY[0] ),
      .M_AXI_DP_WDATA ( axi_interconnect_0_S_WDATA[31:0] ),
      .M_AXI_DP_WSTRB ( axi_interconnect_0_S_WSTRB[3:0] ),
      .M_AXI_DP_WLAST ( axi_interconnect_0_S_WLAST[0] ),
      .M_AXI_DP_WVALID ( axi_interconnect_0_S_WVALID[0] ),
      .M_AXI_DP_WREADY ( axi_interconnect_0_S_WREADY[0] ),
      .M_AXI_DP_BID ( axi_interconnect_0_S_BID[0:0] ),
      .M_AXI_DP_BRESP ( axi_interconnect_0_S_BRESP[1:0] ),
      .M_AXI_DP_BVALID ( axi_interconnect_0_S_BVALID[0] ),
      .M_AXI_DP_BREADY ( axi_interconnect_0_S_BREADY[0] ),
      .M_AXI_DP_ARID ( axi_interconnect_0_S_ARID[0:0] ),
      .M_AXI_DP_ARADDR ( axi_interconnect_0_S_ARADDR[31:0] ),
      .M_AXI_DP_ARLEN ( axi_interconnect_0_S_ARLEN[7:0] ),
      .M_AXI_DP_ARSIZE ( axi_interconnect_0_S_ARSIZE[2:0] ),
      .M_AXI_DP_ARBURST ( axi_interconnect_0_S_ARBURST[1:0] ),
      .M_AXI_DP_ARLOCK ( axi_interconnect_0_S_ARLOCK[0] ),
      .M_AXI_DP_ARCACHE ( axi_interconnect_0_S_ARCACHE[3:0] ),
      .M_AXI_DP_ARPROT ( axi_interconnect_0_S_ARPROT[2:0] ),
      .M_AXI_DP_ARQOS ( axi_interconnect_0_S_ARQOS[3:0] ),
      .M_AXI_DP_ARVALID ( axi_interconnect_0_S_ARVALID[0] ),
      .M_AXI_DP_ARREADY ( axi_interconnect_0_S_ARREADY[0] ),
      .M_AXI_DP_RID ( axi_interconnect_0_S_RID[0:0] ),
      .M_AXI_DP_RDATA ( axi_interconnect_0_S_RDATA[31:0] ),
      .M_AXI_DP_RRESP ( axi_interconnect_0_S_RRESP[1:0] ),
      .M_AXI_DP_RLAST ( axi_interconnect_0_S_RLAST[0] ),
      .M_AXI_DP_RVALID ( axi_interconnect_0_S_RVALID[0] ),
      .M_AXI_DP_RREADY ( axi_interconnect_0_S_RREADY[0] ),
      .M_AXI_IC_AWID (  ),
      .M_AXI_IC_AWADDR (  ),
      .M_AXI_IC_AWLEN (  ),
      .M_AXI_IC_AWSIZE (  ),
      .M_AXI_IC_AWBURST (  ),
      .M_AXI_IC_AWLOCK (  ),
      .M_AXI_IC_AWCACHE (  ),
      .M_AXI_IC_AWPROT (  ),
      .M_AXI_IC_AWQOS (  ),
      .M_AXI_IC_AWVALID (  ),
      .M_AXI_IC_AWREADY ( net_gnd0 ),
      .M_AXI_IC_WDATA (  ),
      .M_AXI_IC_WSTRB (  ),
      .M_AXI_IC_WLAST (  ),
      .M_AXI_IC_WVALID (  ),
      .M_AXI_IC_WREADY ( net_gnd0 ),
      .M_AXI_IC_BID ( net_gnd1[0:0] ),
      .M_AXI_IC_BRESP ( net_gnd2[0:1] ),
      .M_AXI_IC_BVALID ( net_gnd0 ),
      .M_AXI_IC_BREADY (  ),
      .M_AXI_IC_ARID (  ),
      .M_AXI_IC_ARADDR (  ),
      .M_AXI_IC_ARLEN (  ),
      .M_AXI_IC_ARSIZE (  ),
      .M_AXI_IC_ARBURST (  ),
      .M_AXI_IC_ARLOCK (  ),
      .M_AXI_IC_ARCACHE (  ),
      .M_AXI_IC_ARPROT (  ),
      .M_AXI_IC_ARQOS (  ),
      .M_AXI_IC_ARVALID (  ),
      .M_AXI_IC_ARREADY ( net_gnd0 ),
      .M_AXI_IC_RID ( net_gnd1[0:0] ),
      .M_AXI_IC_RDATA ( net_gnd32[0:31] ),
      .M_AXI_IC_RRESP ( net_gnd2[0:1] ),
      .M_AXI_IC_RLAST ( net_gnd0 ),
      .M_AXI_IC_RVALID ( net_gnd0 ),
      .M_AXI_IC_RREADY (  ),
      .M_AXI_DC_AWID (  ),
      .M_AXI_DC_AWADDR (  ),
      .M_AXI_DC_AWLEN (  ),
      .M_AXI_DC_AWSIZE (  ),
      .M_AXI_DC_AWBURST (  ),
      .M_AXI_DC_AWLOCK (  ),
      .M_AXI_DC_AWCACHE (  ),
      .M_AXI_DC_AWPROT (  ),
      .M_AXI_DC_AWQOS (  ),
      .M_AXI_DC_AWVALID (  ),
      .M_AXI_DC_AWREADY ( net_gnd0 ),
      .M_AXI_DC_WDATA (  ),
      .M_AXI_DC_WSTRB (  ),
      .M_AXI_DC_WLAST (  ),
      .M_AXI_DC_WVALID (  ),
      .M_AXI_DC_WREADY ( net_gnd0 ),
      .M_AXI_DC_BID ( net_gnd1[0:0] ),
      .M_AXI_DC_BRESP ( net_gnd2[0:1] ),
      .M_AXI_DC_BVALID ( net_gnd0 ),
      .M_AXI_DC_BREADY (  ),
      .M_AXI_DC_ARID (  ),
      .M_AXI_DC_ARADDR (  ),
      .M_AXI_DC_ARLEN (  ),
      .M_AXI_DC_ARSIZE (  ),
      .M_AXI_DC_ARBURST (  ),
      .M_AXI_DC_ARLOCK (  ),
      .M_AXI_DC_ARCACHE (  ),
      .M_AXI_DC_ARPROT (  ),
      .M_AXI_DC_ARQOS (  ),
      .M_AXI_DC_ARVALID (  ),
      .M_AXI_DC_ARREADY ( net_gnd0 ),
      .M_AXI_DC_RID ( net_gnd1[0:0] ),
      .M_AXI_DC_RDATA ( net_gnd32[0:31] ),
      .M_AXI_DC_RRESP ( net_gnd2[0:1] ),
      .M_AXI_DC_RLAST ( net_gnd0 ),
      .M_AXI_DC_RVALID ( net_gnd0 ),
      .M_AXI_DC_RREADY (  ),
      .DBG_CLK ( net_gnd0 ),
      .DBG_TDI ( net_gnd0 ),
      .DBG_TDO (  ),
      .DBG_REG_EN ( net_gnd8 ),
      .DBG_SHIFT ( net_gnd0 ),
      .DBG_CAPTURE ( net_gnd0 ),
      .DBG_UPDATE ( net_gnd0 ),
      .DEBUG_RST ( net_gnd0 ),
      .Trace_Instruction (  ),
      .Trace_Valid_Instr (  ),
      .Trace_PC (  ),
      .Trace_Reg_Write (  ),
      .Trace_Reg_Addr (  ),
      .Trace_MSR_Reg (  ),
      .Trace_PID_Reg (  ),
      .Trace_New_Reg_Value (  ),
      .Trace_Exception_Taken (  ),
      .Trace_Exception_Kind (  ),
      .Trace_Jump_Taken (  ),
      .Trace_Delay_Slot (  ),
      .Trace_Data_Address (  ),
      .Trace_Data_Access (  ),
      .Trace_Data_Read (  ),
      .Trace_Data_Write (  ),
      .Trace_Data_Write_Value (  ),
      .Trace_Data_Byte_Enable (  ),
      .Trace_DCache_Req (  ),
      .Trace_DCache_Hit (  ),
      .Trace_DCache_Rdy (  ),
      .Trace_DCache_Read (  ),
      .Trace_ICache_Req (  ),
      .Trace_ICache_Hit (  ),
      .Trace_ICache_Rdy (  ),
      .Trace_OF_PipeRun (  ),
      .Trace_EX_PipeRun (  ),
      .Trace_MEM_PipeRun (  ),
      .Trace_MB_Halted (  ),
      .Trace_Jump_Hit (  ),
      .FSL0_S_CLK (  ),
      .FSL0_S_READ (  ),
      .FSL0_S_DATA ( net_gnd32 ),
      .FSL0_S_CONTROL ( net_gnd0 ),
      .FSL0_S_EXISTS ( net_gnd0 ),
      .FSL0_M_CLK (  ),
      .FSL0_M_WRITE (  ),
      .FSL0_M_DATA (  ),
      .FSL0_M_CONTROL (  ),
      .FSL0_M_FULL ( net_gnd0 ),
      .FSL1_S_CLK (  ),
      .FSL1_S_READ (  ),
      .FSL1_S_DATA ( net_gnd32 ),
      .FSL1_S_CONTROL ( net_gnd0 ),
      .FSL1_S_EXISTS ( net_gnd0 ),
      .FSL1_M_CLK (  ),
      .FSL1_M_WRITE (  ),
      .FSL1_M_DATA (  ),
      .FSL1_M_CONTROL (  ),
      .FSL1_M_FULL ( net_gnd0 ),
      .FSL2_S_CLK (  ),
      .FSL2_S_READ (  ),
      .FSL2_S_DATA ( net_gnd32 ),
      .FSL2_S_CONTROL ( net_gnd0 ),
      .FSL2_S_EXISTS ( net_gnd0 ),
      .FSL2_M_CLK (  ),
      .FSL2_M_WRITE (  ),
      .FSL2_M_DATA (  ),
      .FSL2_M_CONTROL (  ),
      .FSL2_M_FULL ( net_gnd0 ),
      .FSL3_S_CLK (  ),
      .FSL3_S_READ (  ),
      .FSL3_S_DATA ( net_gnd32 ),
      .FSL3_S_CONTROL ( net_gnd0 ),
      .FSL3_S_EXISTS ( net_gnd0 ),
      .FSL3_M_CLK (  ),
      .FSL3_M_WRITE (  ),
      .FSL3_M_DATA (  ),
      .FSL3_M_CONTROL (  ),
      .FSL3_M_FULL ( net_gnd0 ),
      .FSL4_S_CLK (  ),
      .FSL4_S_READ (  ),
      .FSL4_S_DATA ( net_gnd32 ),
      .FSL4_S_CONTROL ( net_gnd0 ),
      .FSL4_S_EXISTS ( net_gnd0 ),
      .FSL4_M_CLK (  ),
      .FSL4_M_WRITE (  ),
      .FSL4_M_DATA (  ),
      .FSL4_M_CONTROL (  ),
      .FSL4_M_FULL ( net_gnd0 ),
      .FSL5_S_CLK (  ),
      .FSL5_S_READ (  ),
      .FSL5_S_DATA ( net_gnd32 ),
      .FSL5_S_CONTROL ( net_gnd0 ),
      .FSL5_S_EXISTS ( net_gnd0 ),
      .FSL5_M_CLK (  ),
      .FSL5_M_WRITE (  ),
      .FSL5_M_DATA (  ),
      .FSL5_M_CONTROL (  ),
      .FSL5_M_FULL ( net_gnd0 ),
      .FSL6_S_CLK (  ),
      .FSL6_S_READ (  ),
      .FSL6_S_DATA ( net_gnd32 ),
      .FSL6_S_CONTROL ( net_gnd0 ),
      .FSL6_S_EXISTS ( net_gnd0 ),
      .FSL6_M_CLK (  ),
      .FSL6_M_WRITE (  ),
      .FSL6_M_DATA (  ),
      .FSL6_M_CONTROL (  ),
      .FSL6_M_FULL ( net_gnd0 ),
      .FSL7_S_CLK (  ),
      .FSL7_S_READ (  ),
      .FSL7_S_DATA ( net_gnd32 ),
      .FSL7_S_CONTROL ( net_gnd0 ),
      .FSL7_S_EXISTS ( net_gnd0 ),
      .FSL7_M_CLK (  ),
      .FSL7_M_WRITE (  ),
      .FSL7_M_DATA (  ),
      .FSL7_M_CONTROL (  ),
      .FSL7_M_FULL ( net_gnd0 ),
      .FSL8_S_CLK (  ),
      .FSL8_S_READ (  ),
      .FSL8_S_DATA ( net_gnd32 ),
      .FSL8_S_CONTROL ( net_gnd0 ),
      .FSL8_S_EXISTS ( net_gnd0 ),
      .FSL8_M_CLK (  ),
      .FSL8_M_WRITE (  ),
      .FSL8_M_DATA (  ),
      .FSL8_M_CONTROL (  ),
      .FSL8_M_FULL ( net_gnd0 ),
      .FSL9_S_CLK (  ),
      .FSL9_S_READ (  ),
      .FSL9_S_DATA ( net_gnd32 ),
      .FSL9_S_CONTROL ( net_gnd0 ),
      .FSL9_S_EXISTS ( net_gnd0 ),
      .FSL9_M_CLK (  ),
      .FSL9_M_WRITE (  ),
      .FSL9_M_DATA (  ),
      .FSL9_M_CONTROL (  ),
      .FSL9_M_FULL ( net_gnd0 ),
      .FSL10_S_CLK (  ),
      .FSL10_S_READ (  ),
      .FSL10_S_DATA ( net_gnd32 ),
      .FSL10_S_CONTROL ( net_gnd0 ),
      .FSL10_S_EXISTS ( net_gnd0 ),
      .FSL10_M_CLK (  ),
      .FSL10_M_WRITE (  ),
      .FSL10_M_DATA (  ),
      .FSL10_M_CONTROL (  ),
      .FSL10_M_FULL ( net_gnd0 ),
      .FSL11_S_CLK (  ),
      .FSL11_S_READ (  ),
      .FSL11_S_DATA ( net_gnd32 ),
      .FSL11_S_CONTROL ( net_gnd0 ),
      .FSL11_S_EXISTS ( net_gnd0 ),
      .FSL11_M_CLK (  ),
      .FSL11_M_WRITE (  ),
      .FSL11_M_DATA (  ),
      .FSL11_M_CONTROL (  ),
      .FSL11_M_FULL ( net_gnd0 ),
      .FSL12_S_CLK (  ),
      .FSL12_S_READ (  ),
      .FSL12_S_DATA ( net_gnd32 ),
      .FSL12_S_CONTROL ( net_gnd0 ),
      .FSL12_S_EXISTS ( net_gnd0 ),
      .FSL12_M_CLK (  ),
      .FSL12_M_WRITE (  ),
      .FSL12_M_DATA (  ),
      .FSL12_M_CONTROL (  ),
      .FSL12_M_FULL ( net_gnd0 ),
      .FSL13_S_CLK (  ),
      .FSL13_S_READ (  ),
      .FSL13_S_DATA ( net_gnd32 ),
      .FSL13_S_CONTROL ( net_gnd0 ),
      .FSL13_S_EXISTS ( net_gnd0 ),
      .FSL13_M_CLK (  ),
      .FSL13_M_WRITE (  ),
      .FSL13_M_DATA (  ),
      .FSL13_M_CONTROL (  ),
      .FSL13_M_FULL ( net_gnd0 ),
      .FSL14_S_CLK (  ),
      .FSL14_S_READ (  ),
      .FSL14_S_DATA ( net_gnd32 ),
      .FSL14_S_CONTROL ( net_gnd0 ),
      .FSL14_S_EXISTS ( net_gnd0 ),
      .FSL14_M_CLK (  ),
      .FSL14_M_WRITE (  ),
      .FSL14_M_DATA (  ),
      .FSL14_M_CONTROL (  ),
      .FSL14_M_FULL ( net_gnd0 ),
      .FSL15_S_CLK (  ),
      .FSL15_S_READ (  ),
      .FSL15_S_DATA ( net_gnd32 ),
      .FSL15_S_CONTROL ( net_gnd0 ),
      .FSL15_S_EXISTS ( net_gnd0 ),
      .FSL15_M_CLK (  ),
      .FSL15_M_WRITE (  ),
      .FSL15_M_DATA (  ),
      .FSL15_M_CONTROL (  ),
      .FSL15_M_FULL ( net_gnd0 ),
      .M0_AXIS_TLAST (  ),
      .M0_AXIS_TDATA (  ),
      .M0_AXIS_TVALID (  ),
      .M0_AXIS_TREADY ( net_gnd0 ),
      .S0_AXIS_TLAST ( net_gnd0 ),
      .S0_AXIS_TDATA ( net_gnd32[0:31] ),
      .S0_AXIS_TVALID ( net_gnd0 ),
      .S0_AXIS_TREADY (  ),
      .M1_AXIS_TLAST (  ),
      .M1_AXIS_TDATA (  ),
      .M1_AXIS_TVALID (  ),
      .M1_AXIS_TREADY ( net_gnd0 ),
      .S1_AXIS_TLAST ( net_gnd0 ),
      .S1_AXIS_TDATA ( net_gnd32[0:31] ),
      .S1_AXIS_TVALID ( net_gnd0 ),
      .S1_AXIS_TREADY (  ),
      .M2_AXIS_TLAST (  ),
      .M2_AXIS_TDATA (  ),
      .M2_AXIS_TVALID (  ),
      .M2_AXIS_TREADY ( net_gnd0 ),
      .S2_AXIS_TLAST ( net_gnd0 ),
      .S2_AXIS_TDATA ( net_gnd32[0:31] ),
      .S2_AXIS_TVALID ( net_gnd0 ),
      .S2_AXIS_TREADY (  ),
      .M3_AXIS_TLAST (  ),
      .M3_AXIS_TDATA (  ),
      .M3_AXIS_TVALID (  ),
      .M3_AXIS_TREADY ( net_gnd0 ),
      .S3_AXIS_TLAST ( net_gnd0 ),
      .S3_AXIS_TDATA ( net_gnd32[0:31] ),
      .S3_AXIS_TVALID ( net_gnd0 ),
      .S3_AXIS_TREADY (  ),
      .M4_AXIS_TLAST (  ),
      .M4_AXIS_TDATA (  ),
      .M4_AXIS_TVALID (  ),
      .M4_AXIS_TREADY ( net_gnd0 ),
      .S4_AXIS_TLAST ( net_gnd0 ),
      .S4_AXIS_TDATA ( net_gnd32[0:31] ),
      .S4_AXIS_TVALID ( net_gnd0 ),
      .S4_AXIS_TREADY (  ),
      .M5_AXIS_TLAST (  ),
      .M5_AXIS_TDATA (  ),
      .M5_AXIS_TVALID (  ),
      .M5_AXIS_TREADY ( net_gnd0 ),
      .S5_AXIS_TLAST ( net_gnd0 ),
      .S5_AXIS_TDATA ( net_gnd32[0:31] ),
      .S5_AXIS_TVALID ( net_gnd0 ),
      .S5_AXIS_TREADY (  ),
      .M6_AXIS_TLAST (  ),
      .M6_AXIS_TDATA (  ),
      .M6_AXIS_TVALID (  ),
      .M6_AXIS_TREADY ( net_gnd0 ),
      .S6_AXIS_TLAST ( net_gnd0 ),
      .S6_AXIS_TDATA ( net_gnd32[0:31] ),
      .S6_AXIS_TVALID ( net_gnd0 ),
      .S6_AXIS_TREADY (  ),
      .M7_AXIS_TLAST (  ),
      .M7_AXIS_TDATA (  ),
      .M7_AXIS_TVALID (  ),
      .M7_AXIS_TREADY ( net_gnd0 ),
      .S7_AXIS_TLAST ( net_gnd0 ),
      .S7_AXIS_TDATA ( net_gnd32[0:31] ),
      .S7_AXIS_TVALID ( net_gnd0 ),
      .S7_AXIS_TREADY (  ),
      .M8_AXIS_TLAST (  ),
      .M8_AXIS_TDATA (  ),
      .M8_AXIS_TVALID (  ),
      .M8_AXIS_TREADY ( net_gnd0 ),
      .S8_AXIS_TLAST ( net_gnd0 ),
      .S8_AXIS_TDATA ( net_gnd32[0:31] ),
      .S8_AXIS_TVALID ( net_gnd0 ),
      .S8_AXIS_TREADY (  ),
      .M9_AXIS_TLAST (  ),
      .M9_AXIS_TDATA (  ),
      .M9_AXIS_TVALID (  ),
      .M9_AXIS_TREADY ( net_gnd0 ),
      .S9_AXIS_TLAST ( net_gnd0 ),
      .S9_AXIS_TDATA ( net_gnd32[0:31] ),
      .S9_AXIS_TVALID ( net_gnd0 ),
      .S9_AXIS_TREADY (  ),
      .M10_AXIS_TLAST (  ),
      .M10_AXIS_TDATA (  ),
      .M10_AXIS_TVALID (  ),
      .M10_AXIS_TREADY ( net_gnd0 ),
      .S10_AXIS_TLAST ( net_gnd0 ),
      .S10_AXIS_TDATA ( net_gnd32[0:31] ),
      .S10_AXIS_TVALID ( net_gnd0 ),
      .S10_AXIS_TREADY (  ),
      .M11_AXIS_TLAST (  ),
      .M11_AXIS_TDATA (  ),
      .M11_AXIS_TVALID (  ),
      .M11_AXIS_TREADY ( net_gnd0 ),
      .S11_AXIS_TLAST ( net_gnd0 ),
      .S11_AXIS_TDATA ( net_gnd32[0:31] ),
      .S11_AXIS_TVALID ( net_gnd0 ),
      .S11_AXIS_TREADY (  ),
      .M12_AXIS_TLAST (  ),
      .M12_AXIS_TDATA (  ),
      .M12_AXIS_TVALID (  ),
      .M12_AXIS_TREADY ( net_gnd0 ),
      .S12_AXIS_TLAST ( net_gnd0 ),
      .S12_AXIS_TDATA ( net_gnd32[0:31] ),
      .S12_AXIS_TVALID ( net_gnd0 ),
      .S12_AXIS_TREADY (  ),
      .M13_AXIS_TLAST (  ),
      .M13_AXIS_TDATA (  ),
      .M13_AXIS_TVALID (  ),
      .M13_AXIS_TREADY ( net_gnd0 ),
      .S13_AXIS_TLAST ( net_gnd0 ),
      .S13_AXIS_TDATA ( net_gnd32[0:31] ),
      .S13_AXIS_TVALID ( net_gnd0 ),
      .S13_AXIS_TREADY (  ),
      .M14_AXIS_TLAST (  ),
      .M14_AXIS_TDATA (  ),
      .M14_AXIS_TVALID (  ),
      .M14_AXIS_TREADY ( net_gnd0 ),
      .S14_AXIS_TLAST ( net_gnd0 ),
      .S14_AXIS_TDATA ( net_gnd32[0:31] ),
      .S14_AXIS_TVALID ( net_gnd0 ),
      .S14_AXIS_TREADY (  ),
      .M15_AXIS_TLAST (  ),
      .M15_AXIS_TDATA (  ),
      .M15_AXIS_TVALID (  ),
      .M15_AXIS_TREADY ( net_gnd0 ),
      .S15_AXIS_TLAST ( net_gnd0 ),
      .S15_AXIS_TDATA ( net_gnd32[0:31] ),
      .S15_AXIS_TVALID ( net_gnd0 ),
      .S15_AXIS_TREADY (  ),
      .ICACHE_FSL_IN_CLK (  ),
      .ICACHE_FSL_IN_READ (  ),
      .ICACHE_FSL_IN_DATA ( net_gnd32 ),
      .ICACHE_FSL_IN_CONTROL ( net_gnd0 ),
      .ICACHE_FSL_IN_EXISTS ( net_gnd0 ),
      .ICACHE_FSL_OUT_CLK (  ),
      .ICACHE_FSL_OUT_WRITE (  ),
      .ICACHE_FSL_OUT_DATA (  ),
      .ICACHE_FSL_OUT_CONTROL (  ),
      .ICACHE_FSL_OUT_FULL ( net_gnd0 ),
      .DCACHE_FSL_IN_CLK (  ),
      .DCACHE_FSL_IN_READ (  ),
      .DCACHE_FSL_IN_DATA ( net_gnd32 ),
      .DCACHE_FSL_IN_CONTROL ( net_gnd0 ),
      .DCACHE_FSL_IN_EXISTS ( net_gnd0 ),
      .DCACHE_FSL_OUT_CLK (  ),
      .DCACHE_FSL_OUT_WRITE (  ),
      .DCACHE_FSL_OUT_DATA (  ),
      .DCACHE_FSL_OUT_CONTROL (  ),
      .DCACHE_FSL_OUT_FULL ( net_gnd0 )
    );

  (* BOX_TYPE = "user_black_box" *)
  microblaze_0_ilmb_wrapper
    microblaze_0_ilmb (
      .LMB_Clk ( control_clk ),
      .SYS_Rst ( sys_bus_reset[0] ),
      .LMB_Rst ( microblaze_0_ilmb_LMB_Rst ),
      .M_ABus ( microblaze_0_ilmb_M_ABus ),
      .M_ReadStrobe ( microblaze_0_ilmb_M_ReadStrobe ),
      .M_WriteStrobe ( net_gnd0 ),
      .M_AddrStrobe ( microblaze_0_ilmb_M_AddrStrobe ),
      .M_DBus ( net_gnd32 ),
      .M_BE ( net_gnd4 ),
      .Sl_DBus ( microblaze_0_ilmb_Sl_DBus ),
      .Sl_Ready ( microblaze_0_ilmb_Sl_Ready[0:0] ),
      .LMB_ABus ( microblaze_0_ilmb_LMB_ABus ),
      .LMB_ReadStrobe ( microblaze_0_ilmb_LMB_ReadStrobe ),
      .LMB_WriteStrobe ( microblaze_0_ilmb_LMB_WriteStrobe ),
      .LMB_AddrStrobe ( microblaze_0_ilmb_LMB_AddrStrobe ),
      .LMB_ReadDBus ( microblaze_0_ilmb_LMB_ReadDBus ),
      .LMB_WriteDBus ( microblaze_0_ilmb_LMB_WriteDBus ),
      .LMB_Ready ( microblaze_0_ilmb_LMB_Ready ),
      .LMB_BE ( microblaze_0_ilmb_LMB_BE )
    );

  (* BOX_TYPE = "user_black_box" *)
  microblaze_0_dlmb_wrapper
    microblaze_0_dlmb (
      .LMB_Clk ( control_clk ),
      .SYS_Rst ( sys_bus_reset[0] ),
      .LMB_Rst ( microblaze_0_dlmb_LMB_Rst ),
      .M_ABus ( microblaze_0_dlmb_M_ABus ),
      .M_ReadStrobe ( microblaze_0_dlmb_M_ReadStrobe ),
      .M_WriteStrobe ( microblaze_0_dlmb_M_WriteStrobe ),
      .M_AddrStrobe ( microblaze_0_dlmb_M_AddrStrobe ),
      .M_DBus ( microblaze_0_dlmb_M_DBus ),
      .M_BE ( microblaze_0_dlmb_M_BE ),
      .Sl_DBus ( microblaze_0_dlmb_Sl_DBus ),
      .Sl_Ready ( microblaze_0_dlmb_Sl_Ready[0:0] ),
      .LMB_ABus ( microblaze_0_dlmb_LMB_ABus ),
      .LMB_ReadStrobe ( microblaze_0_dlmb_LMB_ReadStrobe ),
      .LMB_WriteStrobe ( microblaze_0_dlmb_LMB_WriteStrobe ),
      .LMB_AddrStrobe ( microblaze_0_dlmb_LMB_AddrStrobe ),
      .LMB_ReadDBus ( microblaze_0_dlmb_LMB_ReadDBus ),
      .LMB_WriteDBus ( microblaze_0_dlmb_LMB_WriteDBus ),
      .LMB_Ready ( microblaze_0_dlmb_LMB_Ready ),
      .LMB_BE ( microblaze_0_dlmb_LMB_BE )
    );

  (* BOX_TYPE = "user_black_box" *)
  microblaze_0_i_bram_ctrl_wrapper
    microblaze_0_i_bram_ctrl (
      .LMB_Clk ( control_clk ),
      .LMB_Rst ( microblaze_0_ilmb_LMB_Rst ),
      .LMB_ABus ( microblaze_0_ilmb_LMB_ABus ),
      .LMB_WriteDBus ( microblaze_0_ilmb_LMB_WriteDBus ),
      .LMB_AddrStrobe ( microblaze_0_ilmb_LMB_AddrStrobe ),
      .LMB_ReadStrobe ( microblaze_0_ilmb_LMB_ReadStrobe ),
      .LMB_WriteStrobe ( microblaze_0_ilmb_LMB_WriteStrobe ),
      .LMB_BE ( microblaze_0_ilmb_LMB_BE ),
      .Sl_DBus ( microblaze_0_ilmb_Sl_DBus ),
      .Sl_Ready ( microblaze_0_ilmb_Sl_Ready[0] ),
      .BRAM_Rst_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst ),
      .BRAM_Clk_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk ),
      .BRAM_EN_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN ),
      .BRAM_WEN_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN ),
      .BRAM_Addr_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr ),
      .BRAM_Din_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din ),
      .BRAM_Dout_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout )
    );

  (* BOX_TYPE = "user_black_box" *)
  microblaze_0_d_bram_ctrl_wrapper
    microblaze_0_d_bram_ctrl (
      .LMB_Clk ( control_clk ),
      .LMB_Rst ( microblaze_0_dlmb_LMB_Rst ),
      .LMB_ABus ( microblaze_0_dlmb_LMB_ABus ),
      .LMB_WriteDBus ( microblaze_0_dlmb_LMB_WriteDBus ),
      .LMB_AddrStrobe ( microblaze_0_dlmb_LMB_AddrStrobe ),
      .LMB_ReadStrobe ( microblaze_0_dlmb_LMB_ReadStrobe ),
      .LMB_WriteStrobe ( microblaze_0_dlmb_LMB_WriteStrobe ),
      .LMB_BE ( microblaze_0_dlmb_LMB_BE ),
      .Sl_DBus ( microblaze_0_dlmb_Sl_DBus ),
      .Sl_Ready ( microblaze_0_dlmb_Sl_Ready[0] ),
      .BRAM_Rst_A ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst ),
      .BRAM_Clk_A ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk ),
      .BRAM_EN_A ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN ),
      .BRAM_WEN_A ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN ),
      .BRAM_Addr_A ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr ),
      .BRAM_Din_A ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din ),
      .BRAM_Dout_A ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout )
    );

  (* BOX_TYPE = "user_black_box" *)
  microblaze_0_bram_block_wrapper
    microblaze_0_bram_block (
      .BRAM_Rst_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst ),
      .BRAM_Clk_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk ),
      .BRAM_EN_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN ),
      .BRAM_WEN_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN ),
      .BRAM_Addr_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr ),
      .BRAM_Din_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din ),
      .BRAM_Dout_A ( microblaze_0_i_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout ),
      .BRAM_Rst_B ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Rst ),
      .BRAM_Clk_B ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Clk ),
      .BRAM_EN_B ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_EN ),
      .BRAM_WEN_B ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_WEN ),
      .BRAM_Addr_B ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Addr ),
      .BRAM_Din_B ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Din ),
      .BRAM_Dout_B ( microblaze_0_d_bram_ctrl_2_microblaze_0_bram_block_BRAM_Dout )
    );

  (* BOX_TYPE = "user_black_box" *)
  reset_0_wrapper
    reset_0 (
      .Slowest_sync_clk ( control_clk ),
      .Ext_Reset_In ( RESET ),
      .Aux_Reset_In ( net_gnd0 ),
      .MB_Debug_Sys_Rst ( net_gnd0 ),
      .Core_Reset_Req_0 ( net_gnd0 ),
      .Chip_Reset_Req_0 ( net_gnd0 ),
      .System_Reset_Req_0 ( net_gnd0 ),
      .Core_Reset_Req_1 ( net_gnd0 ),
      .Chip_Reset_Req_1 ( net_gnd0 ),
      .System_Reset_Req_1 ( net_gnd0 ),
      .Dcm_locked ( dcm_locked ),
      .RstcPPCresetcore_0 (  ),
      .RstcPPCresetchip_0 (  ),
      .RstcPPCresetsys_0 (  ),
      .RstcPPCresetcore_1 (  ),
      .RstcPPCresetchip_1 (  ),
      .RstcPPCresetsys_1 (  ),
      .MB_Reset ( microblaze_0_Reset_reset_0_Reset_0_adhoc ),
      .Bus_Struct_Reset ( sys_bus_reset[0:0] ),
      .Peripheral_Reset (  ),
      .Interconnect_aresetn ( connectnetwork_0_reset_reset_0_Reset_2_adhoc[0:0] ),
      .Peripheral_aresetn ( Peripheral_aresetn[0:0] )
    );

  (* BOX_TYPE = "user_black_box" *)
  rs232_uart_1_wrapper
    RS232_Uart_1 (
      .S_AXI_ACLK ( control_clk ),
      .S_AXI_ARESETN ( axi_interconnect_0_M_ARESETN[1] ),
      .Interrupt (  ),
      .S_AXI_AWADDR ( axi_interconnect_0_M_AWADDR[63:32] ),
      .S_AXI_AWVALID ( axi_interconnect_0_M_AWVALID[1] ),
      .S_AXI_AWREADY ( axi_interconnect_0_M_AWREADY[1] ),
      .S_AXI_WDATA ( axi_interconnect_0_M_WDATA[63:32] ),
      .S_AXI_WSTRB ( axi_interconnect_0_M_WSTRB[7:4] ),
      .S_AXI_WVALID ( axi_interconnect_0_M_WVALID[1] ),
      .S_AXI_WREADY ( axi_interconnect_0_M_WREADY[1] ),
      .S_AXI_BRESP ( axi_interconnect_0_M_BRESP[3:2] ),
      .S_AXI_BVALID ( axi_interconnect_0_M_BVALID[1] ),
      .S_AXI_BREADY ( axi_interconnect_0_M_BREADY[1] ),
      .S_AXI_ARADDR ( axi_interconnect_0_M_ARADDR[63:32] ),
      .S_AXI_ARVALID ( axi_interconnect_0_M_ARVALID[1] ),
      .S_AXI_ARREADY ( axi_interconnect_0_M_ARREADY[1] ),
      .S_AXI_RDATA ( axi_interconnect_0_M_RDATA[63:32] ),
      .S_AXI_RRESP ( axi_interconnect_0_M_RRESP[3:2] ),
      .S_AXI_RVALID ( axi_interconnect_0_M_RVALID[1] ),
      .S_AXI_RREADY ( axi_interconnect_0_M_RREADY[1] ),
      .RX ( RS232_Uart_1_sin ),
      .TX ( RS232_Uart_1_sout )
    );

  (* BOX_TYPE = "user_black_box" *)
  clock_generator_0_wrapper
    clock_generator_0 (
      .CLKIN ( CLK ),
      .CLKOUT0 ( control_clk ),
      .CLKOUT1 ( core_clk ),
      .CLKOUT2 (  ),
      .CLKOUT3 (  ),
      .CLKOUT4 (  ),
      .CLKOUT5 (  ),
      .CLKOUT6 (  ),
      .CLKOUT7 (  ),
      .CLKOUT8 (  ),
      .CLKOUT9 (  ),
      .CLKOUT10 (  ),
      .CLKOUT11 (  ),
      .CLKOUT12 (  ),
      .CLKOUT13 (  ),
      .CLKOUT14 (  ),
      .CLKOUT15 (  ),
      .CLKFBIN ( net_gnd0 ),
      .CLKFBOUT (  ),
      .PSCLK ( net_gnd0 ),
      .PSEN ( net_gnd0 ),
      .PSINCDEC ( net_gnd0 ),
      .PSDONE (  ),
      .RST ( RESET ),
      .LOCKED ( dcm_locked )
    );

  (* BOX_TYPE = "user_black_box" *)
  nf10_10g_interface_0_wrapper
    nf10_10g_interface_0 (
      .axi_aclk ( core_clk ),
      .axi_resetn ( Peripheral_aresetn[0] ),
      .m_axis_tdata ( nf10_10g_interface_0_M_AXIS_TDATA ),
      .m_axis_tstrb ( nf10_10g_interface_0_M_AXIS_TSTRB ),
      .m_axis_tuser ( nf10_10g_interface_0_M_AXIS_TUSER ),
      .m_axis_tvalid ( nf10_10g_interface_0_M_AXIS_TVALID ),
      .m_axis_tready ( nf10_10g_interface_0_M_AXIS_TREADY ),
      .m_axis_tlast ( nf10_10g_interface_0_M_AXIS_TLAST ),
      .s_axis_tdata ( nf10_bram_output_queues_0_M_AXIS_0_TDATA ),
      .s_axis_tstrb ( nf10_bram_output_queues_0_M_AXIS_0_TSTRB ),
      .s_axis_tuser ( nf10_bram_output_queues_0_M_AXIS_0_TUSER ),
      .s_axis_tvalid ( nf10_bram_output_queues_0_M_AXIS_0_TVALID ),
      .s_axis_tready ( nf10_bram_output_queues_0_M_AXIS_0_TREADY ),
      .s_axis_tlast ( nf10_bram_output_queues_0_M_AXIS_0_TLAST ),
      .refclk ( refclk_A ),
      .dclk ( control_clk ),
      .xaui_tx_l0_p ( nf10_10g_interface_0_xaui_tx_l0_p ),
      .xaui_tx_l0_n ( nf10_10g_interface_0_xaui_tx_l0_n ),
      .xaui_tx_l1_p ( nf10_10g_interface_0_xaui_tx_l1_p ),
      .xaui_tx_l1_n ( nf10_10g_interface_0_xaui_tx_l1_n ),
      .xaui_tx_l2_p ( nf10_10g_interface_0_xaui_tx_l2_p ),
      .xaui_tx_l2_n ( nf10_10g_interface_0_xaui_tx_l2_n ),
      .xaui_tx_l3_p ( nf10_10g_interface_0_xaui_tx_l3_p ),
      .xaui_tx_l3_n ( nf10_10g_interface_0_xaui_tx_l3_n ),
      .xaui_rx_l0_p ( nf10_10g_interface_0_xaui_rx_l0_p ),
      .xaui_rx_l0_n ( nf10_10g_interface_0_xaui_rx_l0_n ),
      .xaui_rx_l1_p ( nf10_10g_interface_0_xaui_rx_l1_p ),
      .xaui_rx_l1_n ( nf10_10g_interface_0_xaui_rx_l1_n ),
      .xaui_rx_l2_p ( nf10_10g_interface_0_xaui_rx_l2_p ),
      .xaui_rx_l2_n ( nf10_10g_interface_0_xaui_rx_l2_n ),
      .xaui_rx_l3_p ( nf10_10g_interface_0_xaui_rx_l3_p ),
      .xaui_rx_l3_n ( nf10_10g_interface_0_xaui_rx_l3_n )
    );

  (* BOX_TYPE = "user_black_box" *)
  nf10_10g_interface_1_wrapper
    nf10_10g_interface_1 (
      .axi_aclk ( core_clk ),
      .axi_resetn ( Peripheral_aresetn[0] ),
      .m_axis_tdata ( nf10_10g_interface_1_M_AXIS_TDATA ),
      .m_axis_tstrb ( nf10_10g_interface_1_M_AXIS_TSTRB ),
      .m_axis_tuser ( nf10_10g_interface_1_M_AXIS_TUSER ),
      .m_axis_tvalid ( nf10_10g_interface_1_M_AXIS_TVALID ),
      .m_axis_tready ( nf10_10g_interface_1_M_AXIS_TREADY ),
      .m_axis_tlast ( nf10_10g_interface_1_M_AXIS_TLAST ),
      .s_axis_tdata ( nf10_bram_output_queues_0_M_AXIS_1_TDATA ),
      .s_axis_tstrb ( nf10_bram_output_queues_0_M_AXIS_1_TSTRB ),
      .s_axis_tuser ( nf10_bram_output_queues_0_M_AXIS_1_TUSER ),
      .s_axis_tvalid ( nf10_bram_output_queues_0_M_AXIS_1_TVALID ),
      .s_axis_tready ( nf10_bram_output_queues_0_M_AXIS_1_TREADY ),
      .s_axis_tlast ( nf10_bram_output_queues_0_M_AXIS_1_TLAST ),
      .refclk ( refclk_B ),
      .dclk ( control_clk ),
      .xaui_tx_l0_p ( nf10_10g_interface_1_xaui_tx_l0_p ),
      .xaui_tx_l0_n ( nf10_10g_interface_1_xaui_tx_l0_n ),
      .xaui_tx_l1_p ( nf10_10g_interface_1_xaui_tx_l1_p ),
      .xaui_tx_l1_n ( nf10_10g_interface_1_xaui_tx_l1_n ),
      .xaui_tx_l2_p ( nf10_10g_interface_1_xaui_tx_l2_p ),
      .xaui_tx_l2_n ( nf10_10g_interface_1_xaui_tx_l2_n ),
      .xaui_tx_l3_p ( nf10_10g_interface_1_xaui_tx_l3_p ),
      .xaui_tx_l3_n ( nf10_10g_interface_1_xaui_tx_l3_n ),
      .xaui_rx_l0_p ( nf10_10g_interface_1_xaui_rx_l0_p ),
      .xaui_rx_l0_n ( nf10_10g_interface_1_xaui_rx_l0_n ),
      .xaui_rx_l1_p ( nf10_10g_interface_1_xaui_rx_l1_p ),
      .xaui_rx_l1_n ( nf10_10g_interface_1_xaui_rx_l1_n ),
      .xaui_rx_l2_p ( nf10_10g_interface_1_xaui_rx_l2_p ),
      .xaui_rx_l2_n ( nf10_10g_interface_1_xaui_rx_l2_n ),
      .xaui_rx_l3_p ( nf10_10g_interface_1_xaui_rx_l3_p ),
      .xaui_rx_l3_n ( nf10_10g_interface_1_xaui_rx_l3_n )
    );

  (* BOX_TYPE = "user_black_box" *)
  nf10_10g_interface_2_wrapper
    nf10_10g_interface_2 (
      .axi_aclk ( core_clk ),
      .axi_resetn ( Peripheral_aresetn[0] ),
      .m_axis_tdata ( nf10_10g_interface_2_M_AXIS_TDATA ),
      .m_axis_tstrb ( nf10_10g_interface_2_M_AXIS_TSTRB ),
      .m_axis_tuser ( nf10_10g_interface_2_M_AXIS_TUSER ),
      .m_axis_tvalid ( nf10_10g_interface_2_M_AXIS_TVALID ),
      .m_axis_tready ( nf10_10g_interface_2_M_AXIS_TREADY ),
      .m_axis_tlast ( nf10_10g_interface_2_M_AXIS_TLAST ),
      .s_axis_tdata ( nf10_bram_output_queues_0_M_AXIS_2_TDATA ),
      .s_axis_tstrb ( nf10_bram_output_queues_0_M_AXIS_2_TSTRB ),
      .s_axis_tuser ( nf10_bram_output_queues_0_M_AXIS_2_TUSER ),
      .s_axis_tvalid ( nf10_bram_output_queues_0_M_AXIS_2_TVALID ),
      .s_axis_tready ( nf10_bram_output_queues_0_M_AXIS_2_TREADY ),
      .s_axis_tlast ( nf10_bram_output_queues_0_M_AXIS_2_TLAST ),
      .refclk ( refclk_C ),
      .dclk ( control_clk ),
      .xaui_tx_l0_p ( nf10_10g_interface_2_xaui_tx_l0_p ),
      .xaui_tx_l0_n ( nf10_10g_interface_2_xaui_tx_l0_n ),
      .xaui_tx_l1_p ( nf10_10g_interface_2_xaui_tx_l1_p ),
      .xaui_tx_l1_n ( nf10_10g_interface_2_xaui_tx_l1_n ),
      .xaui_tx_l2_p ( nf10_10g_interface_2_xaui_tx_l2_p ),
      .xaui_tx_l2_n ( nf10_10g_interface_2_xaui_tx_l2_n ),
      .xaui_tx_l3_p ( nf10_10g_interface_2_xaui_tx_l3_p ),
      .xaui_tx_l3_n ( nf10_10g_interface_2_xaui_tx_l3_n ),
      .xaui_rx_l0_p ( nf10_10g_interface_2_xaui_rx_l0_p ),
      .xaui_rx_l0_n ( nf10_10g_interface_2_xaui_rx_l0_n ),
      .xaui_rx_l1_p ( nf10_10g_interface_2_xaui_rx_l1_p ),
      .xaui_rx_l1_n ( nf10_10g_interface_2_xaui_rx_l1_n ),
      .xaui_rx_l2_p ( nf10_10g_interface_2_xaui_rx_l2_p ),
      .xaui_rx_l2_n ( nf10_10g_interface_2_xaui_rx_l2_n ),
      .xaui_rx_l3_p ( nf10_10g_interface_2_xaui_rx_l3_p ),
      .xaui_rx_l3_n ( nf10_10g_interface_2_xaui_rx_l3_n )
    );

  (* BOX_TYPE = "user_black_box" *)
  nf10_10g_interface_3_wrapper
    nf10_10g_interface_3 (
      .axi_aclk ( core_clk ),
      .axi_resetn ( Peripheral_aresetn[0] ),
      .m_axis_tdata ( nf10_10g_interface_3_M_AXIS_TDATA ),
      .m_axis_tstrb ( nf10_10g_interface_3_M_AXIS_TSTRB ),
      .m_axis_tuser ( nf10_10g_interface_3_M_AXIS_TUSER ),
      .m_axis_tvalid ( nf10_10g_interface_3_M_AXIS_TVALID ),
      .m_axis_tready ( nf10_10g_interface_3_M_AXIS_TREADY ),
      .m_axis_tlast ( nf10_10g_interface_3_M_AXIS_TLAST ),
      .s_axis_tdata ( nf10_bram_output_queues_0_M_AXIS_3_TDATA ),
      .s_axis_tstrb ( nf10_bram_output_queues_0_M_AXIS_3_TSTRB ),
      .s_axis_tuser ( nf10_bram_output_queues_0_M_AXIS_3_TUSER ),
      .s_axis_tvalid ( nf10_bram_output_queues_0_M_AXIS_3_TVALID ),
      .s_axis_tready ( nf10_bram_output_queues_0_M_AXIS_3_TREADY ),
      .s_axis_tlast ( nf10_bram_output_queues_0_M_AXIS_3_TLAST ),
      .refclk ( refclk_D ),
      .dclk ( control_clk ),
      .xaui_tx_l0_p ( nf10_10g_interface_3_xaui_tx_l0_p ),
      .xaui_tx_l0_n ( nf10_10g_interface_3_xaui_tx_l0_n ),
      .xaui_tx_l1_p ( nf10_10g_interface_3_xaui_tx_l1_p ),
      .xaui_tx_l1_n ( nf10_10g_interface_3_xaui_tx_l1_n ),
      .xaui_tx_l2_p ( nf10_10g_interface_3_xaui_tx_l2_p ),
      .xaui_tx_l2_n ( nf10_10g_interface_3_xaui_tx_l2_n ),
      .xaui_tx_l3_p ( nf10_10g_interface_3_xaui_tx_l3_p ),
      .xaui_tx_l3_n ( nf10_10g_interface_3_xaui_tx_l3_n ),
      .xaui_rx_l0_p ( nf10_10g_interface_3_xaui_rx_l0_p ),
      .xaui_rx_l0_n ( nf10_10g_interface_3_xaui_rx_l0_n ),
      .xaui_rx_l1_p ( nf10_10g_interface_3_xaui_rx_l1_p ),
      .xaui_rx_l1_n ( nf10_10g_interface_3_xaui_rx_l1_n ),
      .xaui_rx_l2_p ( nf10_10g_interface_3_xaui_rx_l2_p ),
      .xaui_rx_l2_n ( nf10_10g_interface_3_xaui_rx_l2_n ),
      .xaui_rx_l3_p ( nf10_10g_interface_3_xaui_rx_l3_p ),
      .xaui_rx_l3_n ( nf10_10g_interface_3_xaui_rx_l3_n )
    );

  (* BOX_TYPE = "user_black_box" *)
  diff_input_buf_0_wrapper
    diff_input_buf_0 (
      .SINGLE_ENDED_INPUT ( refclk_A ),
      .DIFF_INPUT_P ( DIFF_INPUT_BUF_0_DIFF_INPUT_P ),
      .DIFF_INPUT_N ( DIFF_INPUT_BUF_0_DIFF_INPUT_N )
    );

  (* BOX_TYPE = "user_black_box" *)
  diff_input_buf_1_wrapper
    diff_input_buf_1 (
      .SINGLE_ENDED_INPUT ( refclk_B ),
      .DIFF_INPUT_P ( DIFF_INPUT_BUF_1_DIFF_INPUT_P ),
      .DIFF_INPUT_N ( DIFF_INPUT_BUF_1_DIFF_INPUT_N )
    );

  (* BOX_TYPE = "user_black_box" *)
  diff_input_buf_2_wrapper
    diff_input_buf_2 (
      .SINGLE_ENDED_INPUT ( refclk_C ),
      .DIFF_INPUT_P ( DIFF_INPUT_BUF_2_DIFF_INPUT_P ),
      .DIFF_INPUT_N ( DIFF_INPUT_BUF_2_DIFF_INPUT_N )
    );

  (* BOX_TYPE = "user_black_box" *)
  diff_input_buf_3_wrapper
    diff_input_buf_3 (
      .SINGLE_ENDED_INPUT ( refclk_D ),
      .DIFF_INPUT_P ( DIFF_INPUT_BUF_3_DIFF_INPUT_P ),
      .DIFF_INPUT_N ( DIFF_INPUT_BUF_3_DIFF_INPUT_N )
    );

  (* BOX_TYPE = "user_black_box" *)
  nf10_mdio_0_wrapper
    nf10_mdio_0 (
      .S_AXI_ACLK ( control_clk ),
      .S_AXI_ARESETN ( axi_interconnect_0_M_ARESETN[2] ),
      .IP2INTC_Irpt (  ),
      .S_AXI_AWID ( axi_interconnect_0_M_AWID[5:4] ),
      .S_AXI_AWADDR ( axi_interconnect_0_M_AWADDR[95:64] ),
      .S_AXI_AWLEN ( axi_interconnect_0_M_AWLEN[23:16] ),
      .S_AXI_AWSIZE ( axi_interconnect_0_M_AWSIZE[8:6] ),
      .S_AXI_AWBURST ( axi_interconnect_0_M_AWBURST[5:4] ),
      .S_AXI_AWCACHE ( axi_interconnect_0_M_AWCACHE[11:8] ),
      .S_AXI_AWVALID ( axi_interconnect_0_M_AWVALID[2] ),
      .S_AXI_AWREADY ( axi_interconnect_0_M_AWREADY[2] ),
      .S_AXI_WDATA ( axi_interconnect_0_M_WDATA[95:64] ),
      .S_AXI_WSTRB ( axi_interconnect_0_M_WSTRB[11:8] ),
      .S_AXI_WLAST ( axi_interconnect_0_M_WLAST[2] ),
      .S_AXI_WVALID ( axi_interconnect_0_M_WVALID[2] ),
      .S_AXI_WREADY ( axi_interconnect_0_M_WREADY[2] ),
      .S_AXI_BID ( axi_interconnect_0_M_BID[5:4] ),
      .S_AXI_BRESP ( axi_interconnect_0_M_BRESP[5:4] ),
      .S_AXI_BVALID ( axi_interconnect_0_M_BVALID[2] ),
      .S_AXI_BREADY ( axi_interconnect_0_M_BREADY[2] ),
      .S_AXI_ARID ( axi_interconnect_0_M_ARID[5:4] ),
      .S_AXI_ARADDR ( axi_interconnect_0_M_ARADDR[95:64] ),
      .S_AXI_ARLEN ( axi_interconnect_0_M_ARLEN[23:16] ),
      .S_AXI_ARSIZE ( axi_interconnect_0_M_ARSIZE[8:6] ),
      .S_AXI_ARBURST ( axi_interconnect_0_M_ARBURST[5:4] ),
      .S_AXI_ARCACHE ( axi_interconnect_0_M_ARCACHE[11:8] ),
      .S_AXI_ARVALID ( axi_interconnect_0_M_ARVALID[2] ),
      .S_AXI_ARREADY ( axi_interconnect_0_M_ARREADY[2] ),
      .S_AXI_RID ( axi_interconnect_0_M_RID[5:4] ),
      .S_AXI_RDATA ( axi_interconnect_0_M_RDATA[95:64] ),
      .S_AXI_RRESP ( axi_interconnect_0_M_RRESP[5:4] ),
      .S_AXI_RLAST ( axi_interconnect_0_M_RLAST[2] ),
      .S_AXI_RVALID ( axi_interconnect_0_M_RVALID[2] ),
      .S_AXI_RREADY ( axi_interconnect_0_M_RREADY[2] ),
      .PHY_rst_n ( nf10_mdio_0_PHY_rst_n ),
      .PHY_MDC ( nf10_mdio_0_PHY_MDC ),
      .PHY_MDIO_I ( nf10_mdio_0_PHY_MDIO_I ),
      .PHY_MDIO_O ( nf10_mdio_0_PHY_MDIO_O ),
      .PHY_MDIO_T ( nf10_mdio_0_PHY_MDIO_T )
    );

  (* BOX_TYPE = "user_black_box" *)
  axi_timebase_wdt_0_wrapper
    axi_timebase_wdt_0 (
      .WDT_Reset (  ),
      .Timebase_Interrupt (  ),
      .WDT_Interrupt (  ),
      .Freeze ( net_gnd0 ),
      .S_AXI_ACLK ( control_clk ),
      .S_AXI_ARESETN ( axi_interconnect_0_M_ARESETN[3] ),
      .S_AXI_AWADDR ( axi_interconnect_0_M_AWADDR[127:96] ),
      .S_AXI_AWVALID ( axi_interconnect_0_M_AWVALID[3] ),
      .S_AXI_AWREADY ( axi_interconnect_0_M_AWREADY[3] ),
      .S_AXI_WDATA ( axi_interconnect_0_M_WDATA[127:96] ),
      .S_AXI_WSTRB ( axi_interconnect_0_M_WSTRB[15:12] ),
      .S_AXI_WVALID ( axi_interconnect_0_M_WVALID[3] ),
      .S_AXI_WREADY ( axi_interconnect_0_M_WREADY[3] ),
      .S_AXI_BRESP ( axi_interconnect_0_M_BRESP[7:6] ),
      .S_AXI_BVALID ( axi_interconnect_0_M_BVALID[3] ),
      .S_AXI_BREADY ( axi_interconnect_0_M_BREADY[3] ),
      .S_AXI_ARADDR ( axi_interconnect_0_M_ARADDR[127:96] ),
      .S_AXI_ARVALID ( axi_interconnect_0_M_ARVALID[3] ),
      .S_AXI_ARREADY ( axi_interconnect_0_M_ARREADY[3] ),
      .S_AXI_RDATA ( axi_interconnect_0_M_RDATA[127:96] ),
      .S_AXI_RRESP ( axi_interconnect_0_M_RRESP[7:6] ),
      .S_AXI_RVALID ( axi_interconnect_0_M_RVALID[3] ),
      .S_AXI_RREADY ( axi_interconnect_0_M_RREADY[3] )
    );

  (* BOX_TYPE = "user_black_box" *)
  nf10_input_arbiter_0_wrapper
    nf10_input_arbiter_0 (
      .axi_aclk ( core_clk ),
      .axi_resetn ( Peripheral_aresetn[0] ),
      .m_axis_tdata ( nf10_input_arbiter_0_M_AXIS_TDATA ),
      .m_axis_tstrb ( nf10_input_arbiter_0_M_AXIS_TSTRB ),
      .m_axis_tuser ( nf10_input_arbiter_0_M_AXIS_TUSER ),
      .m_axis_tvalid ( nf10_input_arbiter_0_M_AXIS_TVALID ),
      .m_axis_tready ( nf10_input_arbiter_0_M_AXIS_TREADY ),
      .m_axis_tlast ( nf10_input_arbiter_0_M_AXIS_TLAST ),
      .s_axis_tdata_0 ( nf10_10g_interface_0_M_AXIS_TDATA ),
      .s_axis_tstrb_0 ( nf10_10g_interface_0_M_AXIS_TSTRB ),
      .s_axis_tuser_0 ( nf10_10g_interface_0_M_AXIS_TUSER ),
      .s_axis_tvalid_0 ( nf10_10g_interface_0_M_AXIS_TVALID ),
      .s_axis_tready_0 ( nf10_10g_interface_0_M_AXIS_TREADY ),
      .s_axis_tlast_0 ( nf10_10g_interface_0_M_AXIS_TLAST ),
      .s_axis_tdata_1 ( nf10_10g_interface_1_M_AXIS_TDATA ),
      .s_axis_tstrb_1 ( nf10_10g_interface_1_M_AXIS_TSTRB ),
      .s_axis_tuser_1 ( nf10_10g_interface_1_M_AXIS_TUSER ),
      .s_axis_tvalid_1 ( nf10_10g_interface_1_M_AXIS_TVALID ),
      .s_axis_tready_1 ( nf10_10g_interface_1_M_AXIS_TREADY ),
      .s_axis_tlast_1 ( nf10_10g_interface_1_M_AXIS_TLAST ),
      .s_axis_tdata_2 ( nf10_10g_interface_2_M_AXIS_TDATA ),
      .s_axis_tstrb_2 ( nf10_10g_interface_2_M_AXIS_TSTRB ),
      .s_axis_tuser_2 ( nf10_10g_interface_2_M_AXIS_TUSER ),
      .s_axis_tvalid_2 ( nf10_10g_interface_2_M_AXIS_TVALID ),
      .s_axis_tready_2 ( nf10_10g_interface_2_M_AXIS_TREADY ),
      .s_axis_tlast_2 ( nf10_10g_interface_2_M_AXIS_TLAST ),
      .s_axis_tdata_3 ( nf10_10g_interface_3_M_AXIS_TDATA ),
      .s_axis_tstrb_3 ( nf10_10g_interface_3_M_AXIS_TSTRB ),
      .s_axis_tuser_3 ( nf10_10g_interface_3_M_AXIS_TUSER ),
      .s_axis_tvalid_3 ( nf10_10g_interface_3_M_AXIS_TVALID ),
      .s_axis_tready_3 ( nf10_10g_interface_3_M_AXIS_TREADY ),
      .s_axis_tlast_3 ( nf10_10g_interface_3_M_AXIS_TLAST ),
      .s_axis_tdata_4 ( dma_0_M_AXIS_TDATA ),
      .s_axis_tstrb_4 ( dma_0_M_AXIS_TSTRB ),
      .s_axis_tuser_4 ( dma_0_M_AXIS_TUSER ),
      .s_axis_tvalid_4 ( dma_0_M_AXIS_TVALID ),
      .s_axis_tready_4 ( dma_0_M_AXIS_TREADY ),
      .s_axis_tlast_4 ( dma_0_M_AXIS_TLAST )
    );

  (* BOX_TYPE = "user_black_box" *)
  nf10_bram_output_queues_0_wrapper
    nf10_bram_output_queues_0 (
      .axi_aclk ( core_clk ),
      .axi_resetn ( Peripheral_aresetn[0] ),
      .s_axis_tdata ( nf10_switch_output_port_lookup_0_M_AXIS_TDATA ),
      .s_axis_tstrb ( nf10_switch_output_port_lookup_0_M_AXIS_TSTRB ),
      .s_axis_tuser ( nf10_switch_output_port_lookup_0_M_AXIS_TUSER ),
      .s_axis_tvalid ( nf10_switch_output_port_lookup_0_M_AXIS_TVALID ),
      .s_axis_tready ( nf10_switch_output_port_lookup_0_M_AXIS_TREADY ),
      .s_axis_tlast ( nf10_switch_output_port_lookup_0_M_AXIS_TLAST ),
      .m_axis_tdata_0 ( nf10_bram_output_queues_0_M_AXIS_0_TDATA ),
      .m_axis_tstrb_0 ( nf10_bram_output_queues_0_M_AXIS_0_TSTRB ),
      .m_axis_tuser_0 ( nf10_bram_output_queues_0_M_AXIS_0_TUSER ),
      .m_axis_tvalid_0 ( nf10_bram_output_queues_0_M_AXIS_0_TVALID ),
      .m_axis_tready_0 ( nf10_bram_output_queues_0_M_AXIS_0_TREADY ),
      .m_axis_tlast_0 ( nf10_bram_output_queues_0_M_AXIS_0_TLAST ),
      .m_axis_tdata_1 ( nf10_bram_output_queues_0_M_AXIS_1_TDATA ),
      .m_axis_tstrb_1 ( nf10_bram_output_queues_0_M_AXIS_1_TSTRB ),
      .m_axis_tuser_1 ( nf10_bram_output_queues_0_M_AXIS_1_TUSER ),
      .m_axis_tvalid_1 ( nf10_bram_output_queues_0_M_AXIS_1_TVALID ),
      .m_axis_tready_1 ( nf10_bram_output_queues_0_M_AXIS_1_TREADY ),
      .m_axis_tlast_1 ( nf10_bram_output_queues_0_M_AXIS_1_TLAST ),
      .m_axis_tdata_2 ( nf10_bram_output_queues_0_M_AXIS_2_TDATA ),
      .m_axis_tstrb_2 ( nf10_bram_output_queues_0_M_AXIS_2_TSTRB ),
      .m_axis_tuser_2 ( nf10_bram_output_queues_0_M_AXIS_2_TUSER ),
      .m_axis_tvalid_2 ( nf10_bram_output_queues_0_M_AXIS_2_TVALID ),
      .m_axis_tready_2 ( nf10_bram_output_queues_0_M_AXIS_2_TREADY ),
      .m_axis_tlast_2 ( nf10_bram_output_queues_0_M_AXIS_2_TLAST ),
      .m_axis_tdata_3 ( nf10_bram_output_queues_0_M_AXIS_3_TDATA ),
      .m_axis_tstrb_3 ( nf10_bram_output_queues_0_M_AXIS_3_TSTRB ),
      .m_axis_tuser_3 ( nf10_bram_output_queues_0_M_AXIS_3_TUSER ),
      .m_axis_tvalid_3 ( nf10_bram_output_queues_0_M_AXIS_3_TVALID ),
      .m_axis_tready_3 ( nf10_bram_output_queues_0_M_AXIS_3_TREADY ),
      .m_axis_tlast_3 ( nf10_bram_output_queues_0_M_AXIS_3_TLAST ),
      .m_axis_tdata_4 ( nf10_bram_output_queues_0_M_AXIS_4_TDATA ),
      .m_axis_tstrb_4 ( nf10_bram_output_queues_0_M_AXIS_4_TSTRB ),
      .m_axis_tuser_4 ( nf10_bram_output_queues_0_M_AXIS_4_TUSER ),
      .m_axis_tvalid_4 ( nf10_bram_output_queues_0_M_AXIS_4_TVALID ),
      .m_axis_tready_4 ( nf10_bram_output_queues_0_M_AXIS_4_TREADY ),
      .m_axis_tlast_4 ( nf10_bram_output_queues_0_M_AXIS_4_TLAST )
    );

  (* BOX_TYPE = "user_black_box" *)
  dma_0_wrapper
    dma_0 (
      .reset_n ( Peripheral_aresetn[0] ),
      .pcie_clk_p ( pcie_top_0_pcie_clk_p ),
      .pcie_clk_n ( pcie_top_0_pcie_clk_n ),
      .pci_exp_0_txp ( pcie_top_0_pci_exp_0_txp ),
      .pci_exp_0_txn ( pcie_top_0_pci_exp_0_txn ),
      .pci_exp_0_rxp ( pcie_top_0_pci_exp_0_rxp ),
      .pci_exp_0_rxn ( pcie_top_0_pci_exp_0_rxn ),
      .pci_exp_1_txp ( pcie_top_0_pci_exp_1_txp ),
      .pci_exp_1_txn ( pcie_top_0_pci_exp_1_txn ),
      .pci_exp_1_rxp ( pcie_top_0_pci_exp_1_rxp ),
      .pci_exp_1_rxn ( pcie_top_0_pci_exp_1_rxn ),
      .pci_exp_2_txp ( pcie_top_0_pci_exp_2_txp ),
      .pci_exp_2_txn ( pcie_top_0_pci_exp_2_txn ),
      .pci_exp_2_rxp ( pcie_top_0_pci_exp_2_rxp ),
      .pci_exp_2_rxn ( pcie_top_0_pci_exp_2_rxn ),
      .pci_exp_3_txp ( pcie_top_0_pci_exp_3_txp ),
      .pci_exp_3_txn ( pcie_top_0_pci_exp_3_txn ),
      .pci_exp_3_rxp ( pcie_top_0_pci_exp_3_rxp ),
      .pci_exp_3_rxn ( pcie_top_0_pci_exp_3_rxn ),
      .pci_exp_4_txp ( pcie_top_0_pci_exp_4_txp ),
      .pci_exp_4_txn ( pcie_top_0_pci_exp_4_txn ),
      .pci_exp_4_rxp ( pcie_top_0_pci_exp_4_rxp ),
      .pci_exp_4_rxn ( pcie_top_0_pci_exp_4_rxn ),
      .pci_exp_5_txp ( pcie_top_0_pci_exp_5_txp ),
      .pci_exp_5_txn ( pcie_top_0_pci_exp_5_txn ),
      .pci_exp_5_rxp ( pcie_top_0_pci_exp_5_rxp ),
      .pci_exp_5_rxn ( pcie_top_0_pci_exp_5_rxn ),
      .pci_exp_6_txp ( pcie_top_0_pci_exp_6_txp ),
      .pci_exp_6_txn ( pcie_top_0_pci_exp_6_txn ),
      .pci_exp_6_rxp ( pcie_top_0_pci_exp_6_rxp ),
      .pci_exp_6_rxn ( pcie_top_0_pci_exp_6_rxn ),
      .pci_exp_7_txp ( pcie_top_0_pci_exp_7_txp ),
      .pci_exp_7_txn ( pcie_top_0_pci_exp_7_txn ),
      .pci_exp_7_rxp ( pcie_top_0_pci_exp_7_rxp ),
      .pci_exp_7_rxn ( pcie_top_0_pci_exp_7_rxn ),
      .M_AXI_LITE_ACLK ( control_clk ),
      .M_AXI_LITE_ARESETN ( axi_interconnect_0_S_ARESETN[1] ),
      .M_AXI_LITE_AWADDR ( axi_interconnect_0_S_AWADDR[63:32] ),
      .M_AXI_LITE_AWVALID ( axi_interconnect_0_S_AWVALID[1] ),
      .M_AXI_LITE_AWREADY ( axi_interconnect_0_S_AWREADY[1] ),
      .M_AXI_LITE_WDATA ( axi_interconnect_0_S_WDATA[63:32] ),
      .M_AXI_LITE_WSTRB ( axi_interconnect_0_S_WSTRB[7:4] ),
      .M_AXI_LITE_WVALID ( axi_interconnect_0_S_WVALID[1] ),
      .M_AXI_LITE_WREADY ( axi_interconnect_0_S_WREADY[1] ),
      .M_AXI_LITE_BRESP ( axi_interconnect_0_S_BRESP[3:2] ),
      .M_AXI_LITE_BVALID ( axi_interconnect_0_S_BVALID[1] ),
      .M_AXI_LITE_BREADY ( axi_interconnect_0_S_BREADY[1] ),
      .M_AXI_LITE_ARADDR ( axi_interconnect_0_S_ARADDR[63:32] ),
      .M_AXI_LITE_ARVALID ( axi_interconnect_0_S_ARVALID[1] ),
      .M_AXI_LITE_ARREADY ( axi_interconnect_0_S_ARREADY[1] ),
      .M_AXI_LITE_RDATA ( axi_interconnect_0_S_RDATA[63:32] ),
      .M_AXI_LITE_RRESP ( axi_interconnect_0_S_RRESP[3:2] ),
      .M_AXI_LITE_RVALID ( axi_interconnect_0_S_RVALID[1] ),
      .M_AXI_LITE_RREADY ( axi_interconnect_0_S_RREADY[1] ),
      .S_AXI_ACLK ( control_clk ),
      .S_AXI_ARESETN ( axi_interconnect_0_M_ARESETN[4] ),
      .S_AXI_AWADDR ( axi_interconnect_0_M_AWADDR[159:128] ),
      .S_AXI_AWVALID ( axi_interconnect_0_M_AWVALID[4] ),
      .S_AXI_AWREADY ( axi_interconnect_0_M_AWREADY[4] ),
      .S_AXI_WDATA ( axi_interconnect_0_M_WDATA[159:128] ),
      .S_AXI_WSTRB ( axi_interconnect_0_M_WSTRB[19:16] ),
      .S_AXI_WVALID ( axi_interconnect_0_M_WVALID[4] ),
      .S_AXI_WREADY ( axi_interconnect_0_M_WREADY[4] ),
      .S_AXI_BRESP ( axi_interconnect_0_M_BRESP[9:8] ),
      .S_AXI_BVALID ( axi_interconnect_0_M_BVALID[4] ),
      .S_AXI_BREADY ( axi_interconnect_0_M_BREADY[4] ),
      .S_AXI_ARADDR ( axi_interconnect_0_M_ARADDR[159:128] ),
      .S_AXI_ARVALID ( axi_interconnect_0_M_ARVALID[4] ),
      .S_AXI_ARREADY ( axi_interconnect_0_M_ARREADY[4] ),
      .S_AXI_RDATA ( axi_interconnect_0_M_RDATA[159:128] ),
      .S_AXI_RRESP ( axi_interconnect_0_M_RRESP[9:8] ),
      .S_AXI_RVALID ( axi_interconnect_0_M_RVALID[4] ),
      .S_AXI_RREADY ( axi_interconnect_0_M_RREADY[4] ),
      .M_AXIS_ACLK ( core_clk ),
      .M_AXIS_TDATA ( dma_0_M_AXIS_TDATA ),
      .M_AXIS_TSTRB ( dma_0_M_AXIS_TSTRB ),
      .M_AXIS_TUSER ( dma_0_M_AXIS_TUSER ),
      .M_AXIS_TVALID ( dma_0_M_AXIS_TVALID ),
      .M_AXIS_TREADY ( dma_0_M_AXIS_TREADY ),
      .M_AXIS_TLAST ( dma_0_M_AXIS_TLAST ),
      .S_AXIS_ACLK ( core_clk ),
      .S_AXIS_TDATA ( nf10_bram_output_queues_0_M_AXIS_4_TDATA ),
      .S_AXIS_TSTRB ( nf10_bram_output_queues_0_M_AXIS_4_TSTRB ),
      .S_AXIS_TUSER ( nf10_bram_output_queues_0_M_AXIS_4_TUSER ),
      .S_AXIS_TVALID ( nf10_bram_output_queues_0_M_AXIS_4_TVALID ),
      .S_AXIS_TREADY ( nf10_bram_output_queues_0_M_AXIS_4_TREADY ),
      .S_AXIS_TLAST ( nf10_bram_output_queues_0_M_AXIS_4_TLAST )
    );

  (* BOX_TYPE = "user_black_box" *)
  nf10_axi_sim_transactor_0_wrapper
    nf10_axi_sim_transactor_0 (
      .M_AXI_ACLK ( control_clk ),
      .M_AXI_ARESETN ( Peripheral_aresetn[0] ),
      .M_AXI_AWADDR ( axi_interconnect_0_S_AWADDR[95:64] ),
      .M_AXI_AWVALID ( axi_interconnect_0_S_AWVALID[2] ),
      .M_AXI_AWREADY ( axi_interconnect_0_S_AWREADY[2] ),
      .M_AXI_WDATA ( axi_interconnect_0_S_WDATA[95:64] ),
      .M_AXI_WSTRB ( axi_interconnect_0_S_WSTRB[11:8] ),
      .M_AXI_WVALID ( axi_interconnect_0_S_WVALID[2] ),
      .M_AXI_WREADY ( axi_interconnect_0_S_WREADY[2] ),
      .M_AXI_BRESP ( axi_interconnect_0_S_BRESP[5:4] ),
      .M_AXI_BVALID ( axi_interconnect_0_S_BVALID[2] ),
      .M_AXI_BREADY ( axi_interconnect_0_S_BREADY[2] ),
      .M_AXI_ARADDR ( axi_interconnect_0_S_ARADDR[95:64] ),
      .M_AXI_ARVALID ( axi_interconnect_0_S_ARVALID[2] ),
      .M_AXI_ARREADY ( axi_interconnect_0_S_ARREADY[2] ),
      .M_AXI_RDATA ( axi_interconnect_0_S_RDATA[95:64] ),
      .M_AXI_RRESP ( axi_interconnect_0_S_RRESP[5:4] ),
      .M_AXI_RVALID ( axi_interconnect_0_S_RVALID[2] ),
      .M_AXI_RREADY ( axi_interconnect_0_S_RREADY[2] )
    );

  IOBUF
    iobuf_0 (
      .I ( nf10_mdio_0_PHY_MDIO_O ),
      .IO ( MDIO ),
      .O ( nf10_mdio_0_PHY_MDIO_I ),
      .T ( nf10_mdio_0_PHY_MDIO_T )
    );

endmodule

module nf10_switch_output_port_lookup_0_wrapper
  (
    S_AXI_ACLK,
    S_AXI_ARESETN,
    M_AXIS_TDATA,
    M_AXIS_TSTRB,
    M_AXIS_TUSER,
    M_AXIS_TVALID,
    M_AXIS_TREADY,
    M_AXIS_TLAST,
    S_AXIS_TDATA,
    S_AXIS_TSTRB,
    S_AXIS_TUSER,
    S_AXIS_TVALID,
    S_AXIS_TREADY,
    S_AXIS_TLAST,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARVALID,
    S_AXI_RREADY,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_AWREADY
  );
  input S_AXI_ACLK;
  input S_AXI_ARESETN;
  output [255:0] M_AXIS_TDATA;
  output [31:0] M_AXIS_TSTRB;
  output [127:0] M_AXIS_TUSER;
  output M_AXIS_TVALID;
  input M_AXIS_TREADY;
  output M_AXIS_TLAST;
  input [255:0] S_AXIS_TDATA;
  input [31:0] S_AXIS_TSTRB;
  input [127:0] S_AXIS_TUSER;
  input S_AXIS_TVALID;
  output S_AXIS_TREADY;
  input S_AXIS_TLAST;
  input [31:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WVALID;
  input S_AXI_BREADY;
  input [31:0] S_AXI_ARADDR;
  input S_AXI_ARVALID;
  input S_AXI_RREADY;
  output S_AXI_ARREADY;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  output S_AXI_AWREADY;
endmodule

module axi_interconnect_0_wrapper
  (
    INTERCONNECT_ACLK,
    INTERCONNECT_ARESETN,
    S_AXI_ARESET_OUT_N,
    M_AXI_ARESET_OUT_N,
    IRQ,
    S_AXI_ACLK,
    S_AXI_AWID,
    S_AXI_AWADDR,
    S_AXI_AWLEN,
    S_AXI_AWSIZE,
    S_AXI_AWBURST,
    S_AXI_AWLOCK,
    S_AXI_AWCACHE,
    S_AXI_AWPROT,
    S_AXI_AWQOS,
    S_AXI_AWUSER,
    S_AXI_AWVALID,
    S_AXI_AWREADY,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WLAST,
    S_AXI_WUSER,
    S_AXI_WVALID,
    S_AXI_WREADY,
    S_AXI_BID,
    S_AXI_BRESP,
    S_AXI_BUSER,
    S_AXI_BVALID,
    S_AXI_BREADY,
    S_AXI_ARID,
    S_AXI_ARADDR,
    S_AXI_ARLEN,
    S_AXI_ARSIZE,
    S_AXI_ARBURST,
    S_AXI_ARLOCK,
    S_AXI_ARCACHE,
    S_AXI_ARPROT,
    S_AXI_ARQOS,
    S_AXI_ARUSER,
    S_AXI_ARVALID,
    S_AXI_ARREADY,
    S_AXI_RID,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RLAST,
    S_AXI_RUSER,
    S_AXI_RVALID,
    S_AXI_RREADY,
    M_AXI_ACLK,
    M_AXI_AWID,
    M_AXI_AWADDR,
    M_AXI_AWLEN,
    M_AXI_AWSIZE,
    M_AXI_AWBURST,
    M_AXI_AWLOCK,
    M_AXI_AWCACHE,
    M_AXI_AWPROT,
    M_AXI_AWREGION,
    M_AXI_AWQOS,
    M_AXI_AWUSER,
    M_AXI_AWVALID,
    M_AXI_AWREADY,
    M_AXI_WID,
    M_AXI_WDATA,
    M_AXI_WSTRB,
    M_AXI_WLAST,
    M_AXI_WUSER,
    M_AXI_WVALID,
    M_AXI_WREADY,
    M_AXI_BID,
    M_AXI_BRESP,
    M_AXI_BUSER,
    M_AXI_BVALID,
    M_AXI_BREADY,
    M_AXI_ARID,
    M_AXI_ARADDR,
    M_AXI_ARLEN,
    M_AXI_ARSIZE,
    M_AXI_ARBURST,
    M_AXI_ARLOCK,
    M_AXI_ARCACHE,
    M_AXI_ARPROT,
    M_AXI_ARREGION,
    M_AXI_ARQOS,
    M_AXI_ARUSER,
    M_AXI_ARVALID,
    M_AXI_ARREADY,
    M_AXI_RID,
    M_AXI_RDATA,
    M_AXI_RRESP,
    M_AXI_RLAST,
    M_AXI_RUSER,
    M_AXI_RVALID,
    M_AXI_RREADY,
    S_AXI_CTRL_AWADDR,
    S_AXI_CTRL_AWVALID,
    S_AXI_CTRL_AWREADY,
    S_AXI_CTRL_WDATA,
    S_AXI_CTRL_WVALID,
    S_AXI_CTRL_WREADY,
    S_AXI_CTRL_BRESP,
    S_AXI_CTRL_BVALID,
    S_AXI_CTRL_BREADY,
    S_AXI_CTRL_ARADDR,
    S_AXI_CTRL_ARVALID,
    S_AXI_CTRL_ARREADY,
    S_AXI_CTRL_RDATA,
    S_AXI_CTRL_RRESP,
    S_AXI_CTRL_RVALID,
    S_AXI_CTRL_RREADY
  );
  input INTERCONNECT_ACLK;
  input INTERCONNECT_ARESETN;
  output [2:0] S_AXI_ARESET_OUT_N;
  output [4:0] M_AXI_ARESET_OUT_N;
  output IRQ;
  input [2:0] S_AXI_ACLK;
  input [5:0] S_AXI_AWID;
  input [95:0] S_AXI_AWADDR;
  input [23:0] S_AXI_AWLEN;
  input [8:0] S_AXI_AWSIZE;
  input [5:0] S_AXI_AWBURST;
  input [5:0] S_AXI_AWLOCK;
  input [11:0] S_AXI_AWCACHE;
  input [8:0] S_AXI_AWPROT;
  input [11:0] S_AXI_AWQOS;
  input [2:0] S_AXI_AWUSER;
  input [2:0] S_AXI_AWVALID;
  output [2:0] S_AXI_AWREADY;
  input [95:0] S_AXI_WDATA;
  input [11:0] S_AXI_WSTRB;
  input [2:0] S_AXI_WLAST;
  input [2:0] S_AXI_WUSER;
  input [2:0] S_AXI_WVALID;
  output [2:0] S_AXI_WREADY;
  output [5:0] S_AXI_BID;
  output [5:0] S_AXI_BRESP;
  output [2:0] S_AXI_BUSER;
  output [2:0] S_AXI_BVALID;
  input [2:0] S_AXI_BREADY;
  input [5:0] S_AXI_ARID;
  input [95:0] S_AXI_ARADDR;
  input [23:0] S_AXI_ARLEN;
  input [8:0] S_AXI_ARSIZE;
  input [5:0] S_AXI_ARBURST;
  input [5:0] S_AXI_ARLOCK;
  input [11:0] S_AXI_ARCACHE;
  input [8:0] S_AXI_ARPROT;
  input [11:0] S_AXI_ARQOS;
  input [2:0] S_AXI_ARUSER;
  input [2:0] S_AXI_ARVALID;
  output [2:0] S_AXI_ARREADY;
  output [5:0] S_AXI_RID;
  output [95:0] S_AXI_RDATA;
  output [5:0] S_AXI_RRESP;
  output [2:0] S_AXI_RLAST;
  output [2:0] S_AXI_RUSER;
  output [2:0] S_AXI_RVALID;
  input [2:0] S_AXI_RREADY;
  input [4:0] M_AXI_ACLK;
  output [9:0] M_AXI_AWID;
  output [159:0] M_AXI_AWADDR;
  output [39:0] M_AXI_AWLEN;
  output [14:0] M_AXI_AWSIZE;
  output [9:0] M_AXI_AWBURST;
  output [9:0] M_AXI_AWLOCK;
  output [19:0] M_AXI_AWCACHE;
  output [14:0] M_AXI_AWPROT;
  output [19:0] M_AXI_AWREGION;
  output [19:0] M_AXI_AWQOS;
  output [4:0] M_AXI_AWUSER;
  output [4:0] M_AXI_AWVALID;
  input [4:0] M_AXI_AWREADY;
  output [9:0] M_AXI_WID;
  output [159:0] M_AXI_WDATA;
  output [19:0] M_AXI_WSTRB;
  output [4:0] M_AXI_WLAST;
  output [4:0] M_AXI_WUSER;
  output [4:0] M_AXI_WVALID;
  input [4:0] M_AXI_WREADY;
  input [9:0] M_AXI_BID;
  input [9:0] M_AXI_BRESP;
  input [4:0] M_AXI_BUSER;
  input [4:0] M_AXI_BVALID;
  output [4:0] M_AXI_BREADY;
  output [9:0] M_AXI_ARID;
  output [159:0] M_AXI_ARADDR;
  output [39:0] M_AXI_ARLEN;
  output [14:0] M_AXI_ARSIZE;
  output [9:0] M_AXI_ARBURST;
  output [9:0] M_AXI_ARLOCK;
  output [19:0] M_AXI_ARCACHE;
  output [14:0] M_AXI_ARPROT;
  output [19:0] M_AXI_ARREGION;
  output [19:0] M_AXI_ARQOS;
  output [4:0] M_AXI_ARUSER;
  output [4:0] M_AXI_ARVALID;
  input [4:0] M_AXI_ARREADY;
  input [9:0] M_AXI_RID;
  input [159:0] M_AXI_RDATA;
  input [9:0] M_AXI_RRESP;
  input [4:0] M_AXI_RLAST;
  input [4:0] M_AXI_RUSER;
  input [4:0] M_AXI_RVALID;
  output [4:0] M_AXI_RREADY;
  input [31:0] S_AXI_CTRL_AWADDR;
  input S_AXI_CTRL_AWVALID;
  output S_AXI_CTRL_AWREADY;
  input [31:0] S_AXI_CTRL_WDATA;
  input S_AXI_CTRL_WVALID;
  output S_AXI_CTRL_WREADY;
  output [1:0] S_AXI_CTRL_BRESP;
  output S_AXI_CTRL_BVALID;
  input S_AXI_CTRL_BREADY;
  input [31:0] S_AXI_CTRL_ARADDR;
  input S_AXI_CTRL_ARVALID;
  output S_AXI_CTRL_ARREADY;
  output [31:0] S_AXI_CTRL_RDATA;
  output [1:0] S_AXI_CTRL_RRESP;
  output S_AXI_CTRL_RVALID;
  input S_AXI_CTRL_RREADY;
endmodule

module microblaze_0_wrapper
  (
    CLK,
    RESET,
    MB_RESET,
    INTERRUPT,
    EXT_BRK,
    EXT_NM_BRK,
    DBG_STOP,
    MB_Halted,
    MB_Error,
    INSTR,
    IREADY,
    IWAIT,
    ICE,
    IUE,
    INSTR_ADDR,
    IFETCH,
    I_AS,
    IPLB_M_ABort,
    IPLB_M_ABus,
    IPLB_M_UABus,
    IPLB_M_BE,
    IPLB_M_busLock,
    IPLB_M_lockErr,
    IPLB_M_MSize,
    IPLB_M_priority,
    IPLB_M_rdBurst,
    IPLB_M_request,
    IPLB_M_RNW,
    IPLB_M_size,
    IPLB_M_TAttribute,
    IPLB_M_type,
    IPLB_M_wrBurst,
    IPLB_M_wrDBus,
    IPLB_MBusy,
    IPLB_MRdErr,
    IPLB_MWrErr,
    IPLB_MIRQ,
    IPLB_MWrBTerm,
    IPLB_MWrDAck,
    IPLB_MAddrAck,
    IPLB_MRdBTerm,
    IPLB_MRdDAck,
    IPLB_MRdDBus,
    IPLB_MRdWdAddr,
    IPLB_MRearbitrate,
    IPLB_MSSize,
    IPLB_MTimeout,
    DATA_READ,
    DREADY,
    DWAIT,
    DCE,
    DUE,
    DATA_WRITE,
    DATA_ADDR,
    D_AS,
    READ_STROBE,
    WRITE_STROBE,
    BYTE_ENABLE,
    DPLB_M_ABort,
    DPLB_M_ABus,
    DPLB_M_UABus,
    DPLB_M_BE,
    DPLB_M_busLock,
    DPLB_M_lockErr,
    DPLB_M_MSize,
    DPLB_M_priority,
    DPLB_M_rdBurst,
    DPLB_M_request,
    DPLB_M_RNW,
    DPLB_M_size,
    DPLB_M_TAttribute,
    DPLB_M_type,
    DPLB_M_wrBurst,
    DPLB_M_wrDBus,
    DPLB_MBusy,
    DPLB_MRdErr,
    DPLB_MWrErr,
    DPLB_MIRQ,
    DPLB_MWrBTerm,
    DPLB_MWrDAck,
    DPLB_MAddrAck,
    DPLB_MRdBTerm,
    DPLB_MRdDAck,
    DPLB_MRdDBus,
    DPLB_MRdWdAddr,
    DPLB_MRearbitrate,
    DPLB_MSSize,
    DPLB_MTimeout,
    M_AXI_IP_AWID,
    M_AXI_IP_AWADDR,
    M_AXI_IP_AWLEN,
    M_AXI_IP_AWSIZE,
    M_AXI_IP_AWBURST,
    M_AXI_IP_AWLOCK,
    M_AXI_IP_AWCACHE,
    M_AXI_IP_AWPROT,
    M_AXI_IP_AWQOS,
    M_AXI_IP_AWVALID,
    M_AXI_IP_AWREADY,
    M_AXI_IP_WDATA,
    M_AXI_IP_WSTRB,
    M_AXI_IP_WLAST,
    M_AXI_IP_WVALID,
    M_AXI_IP_WREADY,
    M_AXI_IP_BID,
    M_AXI_IP_BRESP,
    M_AXI_IP_BVALID,
    M_AXI_IP_BREADY,
    M_AXI_IP_ARID,
    M_AXI_IP_ARADDR,
    M_AXI_IP_ARLEN,
    M_AXI_IP_ARSIZE,
    M_AXI_IP_ARBURST,
    M_AXI_IP_ARLOCK,
    M_AXI_IP_ARCACHE,
    M_AXI_IP_ARPROT,
    M_AXI_IP_ARQOS,
    M_AXI_IP_ARVALID,
    M_AXI_IP_ARREADY,
    M_AXI_IP_RID,
    M_AXI_IP_RDATA,
    M_AXI_IP_RRESP,
    M_AXI_IP_RLAST,
    M_AXI_IP_RVALID,
    M_AXI_IP_RREADY,
    M_AXI_DP_AWID,
    M_AXI_DP_AWADDR,
    M_AXI_DP_AWLEN,
    M_AXI_DP_AWSIZE,
    M_AXI_DP_AWBURST,
    M_AXI_DP_AWLOCK,
    M_AXI_DP_AWCACHE,
    M_AXI_DP_AWPROT,
    M_AXI_DP_AWQOS,
    M_AXI_DP_AWVALID,
    M_AXI_DP_AWREADY,
    M_AXI_DP_WDATA,
    M_AXI_DP_WSTRB,
    M_AXI_DP_WLAST,
    M_AXI_DP_WVALID,
    M_AXI_DP_WREADY,
    M_AXI_DP_BID,
    M_AXI_DP_BRESP,
    M_AXI_DP_BVALID,
    M_AXI_DP_BREADY,
    M_AXI_DP_ARID,
    M_AXI_DP_ARADDR,
    M_AXI_DP_ARLEN,
    M_AXI_DP_ARSIZE,
    M_AXI_DP_ARBURST,
    M_AXI_DP_ARLOCK,
    M_AXI_DP_ARCACHE,
    M_AXI_DP_ARPROT,
    M_AXI_DP_ARQOS,
    M_AXI_DP_ARVALID,
    M_AXI_DP_ARREADY,
    M_AXI_DP_RID,
    M_AXI_DP_RDATA,
    M_AXI_DP_RRESP,
    M_AXI_DP_RLAST,
    M_AXI_DP_RVALID,
    M_AXI_DP_RREADY,
    M_AXI_IC_AWID,
    M_AXI_IC_AWADDR,
    M_AXI_IC_AWLEN,
    M_AXI_IC_AWSIZE,
    M_AXI_IC_AWBURST,
    M_AXI_IC_AWLOCK,
    M_AXI_IC_AWCACHE,
    M_AXI_IC_AWPROT,
    M_AXI_IC_AWQOS,
    M_AXI_IC_AWVALID,
    M_AXI_IC_AWREADY,
    M_AXI_IC_WDATA,
    M_AXI_IC_WSTRB,
    M_AXI_IC_WLAST,
    M_AXI_IC_WVALID,
    M_AXI_IC_WREADY,
    M_AXI_IC_BID,
    M_AXI_IC_BRESP,
    M_AXI_IC_BVALID,
    M_AXI_IC_BREADY,
    M_AXI_IC_ARID,
    M_AXI_IC_ARADDR,
    M_AXI_IC_ARLEN,
    M_AXI_IC_ARSIZE,
    M_AXI_IC_ARBURST,
    M_AXI_IC_ARLOCK,
    M_AXI_IC_ARCACHE,
    M_AXI_IC_ARPROT,
    M_AXI_IC_ARQOS,
    M_AXI_IC_ARVALID,
    M_AXI_IC_ARREADY,
    M_AXI_IC_RID,
    M_AXI_IC_RDATA,
    M_AXI_IC_RRESP,
    M_AXI_IC_RLAST,
    M_AXI_IC_RVALID,
    M_AXI_IC_RREADY,
    M_AXI_DC_AWID,
    M_AXI_DC_AWADDR,
    M_AXI_DC_AWLEN,
    M_AXI_DC_AWSIZE,
    M_AXI_DC_AWBURST,
    M_AXI_DC_AWLOCK,
    M_AXI_DC_AWCACHE,
    M_AXI_DC_AWPROT,
    M_AXI_DC_AWQOS,
    M_AXI_DC_AWVALID,
    M_AXI_DC_AWREADY,
    M_AXI_DC_WDATA,
    M_AXI_DC_WSTRB,
    M_AXI_DC_WLAST,
    M_AXI_DC_WVALID,
    M_AXI_DC_WREADY,
    M_AXI_DC_BID,
    M_AXI_DC_BRESP,
    M_AXI_DC_BVALID,
    M_AXI_DC_BREADY,
    M_AXI_DC_ARID,
    M_AXI_DC_ARADDR,
    M_AXI_DC_ARLEN,
    M_AXI_DC_ARSIZE,
    M_AXI_DC_ARBURST,
    M_AXI_DC_ARLOCK,
    M_AXI_DC_ARCACHE,
    M_AXI_DC_ARPROT,
    M_AXI_DC_ARQOS,
    M_AXI_DC_ARVALID,
    M_AXI_DC_ARREADY,
    M_AXI_DC_RID,
    M_AXI_DC_RDATA,
    M_AXI_DC_RRESP,
    M_AXI_DC_RLAST,
    M_AXI_DC_RVALID,
    M_AXI_DC_RREADY,
    DBG_CLK,
    DBG_TDI,
    DBG_TDO,
    DBG_REG_EN,
    DBG_SHIFT,
    DBG_CAPTURE,
    DBG_UPDATE,
    DEBUG_RST,
    Trace_Instruction,
    Trace_Valid_Instr,
    Trace_PC,
    Trace_Reg_Write,
    Trace_Reg_Addr,
    Trace_MSR_Reg,
    Trace_PID_Reg,
    Trace_New_Reg_Value,
    Trace_Exception_Taken,
    Trace_Exception_Kind,
    Trace_Jump_Taken,
    Trace_Delay_Slot,
    Trace_Data_Address,
    Trace_Data_Access,
    Trace_Data_Read,
    Trace_Data_Write,
    Trace_Data_Write_Value,
    Trace_Data_Byte_Enable,
    Trace_DCache_Req,
    Trace_DCache_Hit,
    Trace_DCache_Rdy,
    Trace_DCache_Read,
    Trace_ICache_Req,
    Trace_ICache_Hit,
    Trace_ICache_Rdy,
    Trace_OF_PipeRun,
    Trace_EX_PipeRun,
    Trace_MEM_PipeRun,
    Trace_MB_Halted,
    Trace_Jump_Hit,
    FSL0_S_CLK,
    FSL0_S_READ,
    FSL0_S_DATA,
    FSL0_S_CONTROL,
    FSL0_S_EXISTS,
    FSL0_M_CLK,
    FSL0_M_WRITE,
    FSL0_M_DATA,
    FSL0_M_CONTROL,
    FSL0_M_FULL,
    FSL1_S_CLK,
    FSL1_S_READ,
    FSL1_S_DATA,
    FSL1_S_CONTROL,
    FSL1_S_EXISTS,
    FSL1_M_CLK,
    FSL1_M_WRITE,
    FSL1_M_DATA,
    FSL1_M_CONTROL,
    FSL1_M_FULL,
    FSL2_S_CLK,
    FSL2_S_READ,
    FSL2_S_DATA,
    FSL2_S_CONTROL,
    FSL2_S_EXISTS,
    FSL2_M_CLK,
    FSL2_M_WRITE,
    FSL2_M_DATA,
    FSL2_M_CONTROL,
    FSL2_M_FULL,
    FSL3_S_CLK,
    FSL3_S_READ,
    FSL3_S_DATA,
    FSL3_S_CONTROL,
    FSL3_S_EXISTS,
    FSL3_M_CLK,
    FSL3_M_WRITE,
    FSL3_M_DATA,
    FSL3_M_CONTROL,
    FSL3_M_FULL,
    FSL4_S_CLK,
    FSL4_S_READ,
    FSL4_S_DATA,
    FSL4_S_CONTROL,
    FSL4_S_EXISTS,
    FSL4_M_CLK,
    FSL4_M_WRITE,
    FSL4_M_DATA,
    FSL4_M_CONTROL,
    FSL4_M_FULL,
    FSL5_S_CLK,
    FSL5_S_READ,
    FSL5_S_DATA,
    FSL5_S_CONTROL,
    FSL5_S_EXISTS,
    FSL5_M_CLK,
    FSL5_M_WRITE,
    FSL5_M_DATA,
    FSL5_M_CONTROL,
    FSL5_M_FULL,
    FSL6_S_CLK,
    FSL6_S_READ,
    FSL6_S_DATA,
    FSL6_S_CONTROL,
    FSL6_S_EXISTS,
    FSL6_M_CLK,
    FSL6_M_WRITE,
    FSL6_M_DATA,
    FSL6_M_CONTROL,
    FSL6_M_FULL,
    FSL7_S_CLK,
    FSL7_S_READ,
    FSL7_S_DATA,
    FSL7_S_CONTROL,
    FSL7_S_EXISTS,
    FSL7_M_CLK,
    FSL7_M_WRITE,
    FSL7_M_DATA,
    FSL7_M_CONTROL,
    FSL7_M_FULL,
    FSL8_S_CLK,
    FSL8_S_READ,
    FSL8_S_DATA,
    FSL8_S_CONTROL,
    FSL8_S_EXISTS,
    FSL8_M_CLK,
    FSL8_M_WRITE,
    FSL8_M_DATA,
    FSL8_M_CONTROL,
    FSL8_M_FULL,
    FSL9_S_CLK,
    FSL9_S_READ,
    FSL9_S_DATA,
    FSL9_S_CONTROL,
    FSL9_S_EXISTS,
    FSL9_M_CLK,
    FSL9_M_WRITE,
    FSL9_M_DATA,
    FSL9_M_CONTROL,
    FSL9_M_FULL,
    FSL10_S_CLK,
    FSL10_S_READ,
    FSL10_S_DATA,
    FSL10_S_CONTROL,
    FSL10_S_EXISTS,
    FSL10_M_CLK,
    FSL10_M_WRITE,
    FSL10_M_DATA,
    FSL10_M_CONTROL,
    FSL10_M_FULL,
    FSL11_S_CLK,
    FSL11_S_READ,
    FSL11_S_DATA,
    FSL11_S_CONTROL,
    FSL11_S_EXISTS,
    FSL11_M_CLK,
    FSL11_M_WRITE,
    FSL11_M_DATA,
    FSL11_M_CONTROL,
    FSL11_M_FULL,
    FSL12_S_CLK,
    FSL12_S_READ,
    FSL12_S_DATA,
    FSL12_S_CONTROL,
    FSL12_S_EXISTS,
    FSL12_M_CLK,
    FSL12_M_WRITE,
    FSL12_M_DATA,
    FSL12_M_CONTROL,
    FSL12_M_FULL,
    FSL13_S_CLK,
    FSL13_S_READ,
    FSL13_S_DATA,
    FSL13_S_CONTROL,
    FSL13_S_EXISTS,
    FSL13_M_CLK,
    FSL13_M_WRITE,
    FSL13_M_DATA,
    FSL13_M_CONTROL,
    FSL13_M_FULL,
    FSL14_S_CLK,
    FSL14_S_READ,
    FSL14_S_DATA,
    FSL14_S_CONTROL,
    FSL14_S_EXISTS,
    FSL14_M_CLK,
    FSL14_M_WRITE,
    FSL14_M_DATA,
    FSL14_M_CONTROL,
    FSL14_M_FULL,
    FSL15_S_CLK,
    FSL15_S_READ,
    FSL15_S_DATA,
    FSL15_S_CONTROL,
    FSL15_S_EXISTS,
    FSL15_M_CLK,
    FSL15_M_WRITE,
    FSL15_M_DATA,
    FSL15_M_CONTROL,
    FSL15_M_FULL,
    M0_AXIS_TLAST,
    M0_AXIS_TDATA,
    M0_AXIS_TVALID,
    M0_AXIS_TREADY,
    S0_AXIS_TLAST,
    S0_AXIS_TDATA,
    S0_AXIS_TVALID,
    S0_AXIS_TREADY,
    M1_AXIS_TLAST,
    M1_AXIS_TDATA,
    M1_AXIS_TVALID,
    M1_AXIS_TREADY,
    S1_AXIS_TLAST,
    S1_AXIS_TDATA,
    S1_AXIS_TVALID,
    S1_AXIS_TREADY,
    M2_AXIS_TLAST,
    M2_AXIS_TDATA,
    M2_AXIS_TVALID,
    M2_AXIS_TREADY,
    S2_AXIS_TLAST,
    S2_AXIS_TDATA,
    S2_AXIS_TVALID,
    S2_AXIS_TREADY,
    M3_AXIS_TLAST,
    M3_AXIS_TDATA,
    M3_AXIS_TVALID,
    M3_AXIS_TREADY,
    S3_AXIS_TLAST,
    S3_AXIS_TDATA,
    S3_AXIS_TVALID,
    S3_AXIS_TREADY,
    M4_AXIS_TLAST,
    M4_AXIS_TDATA,
    M4_AXIS_TVALID,
    M4_AXIS_TREADY,
    S4_AXIS_TLAST,
    S4_AXIS_TDATA,
    S4_AXIS_TVALID,
    S4_AXIS_TREADY,
    M5_AXIS_TLAST,
    M5_AXIS_TDATA,
    M5_AXIS_TVALID,
    M5_AXIS_TREADY,
    S5_AXIS_TLAST,
    S5_AXIS_TDATA,
    S5_AXIS_TVALID,
    S5_AXIS_TREADY,
    M6_AXIS_TLAST,
    M6_AXIS_TDATA,
    M6_AXIS_TVALID,
    M6_AXIS_TREADY,
    S6_AXIS_TLAST,
    S6_AXIS_TDATA,
    S6_AXIS_TVALID,
    S6_AXIS_TREADY,
    M7_AXIS_TLAST,
    M7_AXIS_TDATA,
    M7_AXIS_TVALID,
    M7_AXIS_TREADY,
    S7_AXIS_TLAST,
    S7_AXIS_TDATA,
    S7_AXIS_TVALID,
    S7_AXIS_TREADY,
    M8_AXIS_TLAST,
    M8_AXIS_TDATA,
    M8_AXIS_TVALID,
    M8_AXIS_TREADY,
    S8_AXIS_TLAST,
    S8_AXIS_TDATA,
    S8_AXIS_TVALID,
    S8_AXIS_TREADY,
    M9_AXIS_TLAST,
    M9_AXIS_TDATA,
    M9_AXIS_TVALID,
    M9_AXIS_TREADY,
    S9_AXIS_TLAST,
    S9_AXIS_TDATA,
    S9_AXIS_TVALID,
    S9_AXIS_TREADY,
    M10_AXIS_TLAST,
    M10_AXIS_TDATA,
    M10_AXIS_TVALID,
    M10_AXIS_TREADY,
    S10_AXIS_TLAST,
    S10_AXIS_TDATA,
    S10_AXIS_TVALID,
    S10_AXIS_TREADY,
    M11_AXIS_TLAST,
    M11_AXIS_TDATA,
    M11_AXIS_TVALID,
    M11_AXIS_TREADY,
    S11_AXIS_TLAST,
    S11_AXIS_TDATA,
    S11_AXIS_TVALID,
    S11_AXIS_TREADY,
    M12_AXIS_TLAST,
    M12_AXIS_TDATA,
    M12_AXIS_TVALID,
    M12_AXIS_TREADY,
    S12_AXIS_TLAST,
    S12_AXIS_TDATA,
    S12_AXIS_TVALID,
    S12_AXIS_TREADY,
    M13_AXIS_TLAST,
    M13_AXIS_TDATA,
    M13_AXIS_TVALID,
    M13_AXIS_TREADY,
    S13_AXIS_TLAST,
    S13_AXIS_TDATA,
    S13_AXIS_TVALID,
    S13_AXIS_TREADY,
    M14_AXIS_TLAST,
    M14_AXIS_TDATA,
    M14_AXIS_TVALID,
    M14_AXIS_TREADY,
    S14_AXIS_TLAST,
    S14_AXIS_TDATA,
    S14_AXIS_TVALID,
    S14_AXIS_TREADY,
    M15_AXIS_TLAST,
    M15_AXIS_TDATA,
    M15_AXIS_TVALID,
    M15_AXIS_TREADY,
    S15_AXIS_TLAST,
    S15_AXIS_TDATA,
    S15_AXIS_TVALID,
    S15_AXIS_TREADY,
    ICACHE_FSL_IN_CLK,
    ICACHE_FSL_IN_READ,
    ICACHE_FSL_IN_DATA,
    ICACHE_FSL_IN_CONTROL,
    ICACHE_FSL_IN_EXISTS,
    ICACHE_FSL_OUT_CLK,
    ICACHE_FSL_OUT_WRITE,
    ICACHE_FSL_OUT_DATA,
    ICACHE_FSL_OUT_CONTROL,
    ICACHE_FSL_OUT_FULL,
    DCACHE_FSL_IN_CLK,
    DCACHE_FSL_IN_READ,
    DCACHE_FSL_IN_DATA,
    DCACHE_FSL_IN_CONTROL,
    DCACHE_FSL_IN_EXISTS,
    DCACHE_FSL_OUT_CLK,
    DCACHE_FSL_OUT_WRITE,
    DCACHE_FSL_OUT_DATA,
    DCACHE_FSL_OUT_CONTROL,
    DCACHE_FSL_OUT_FULL
  );
  input CLK;
  input RESET;
  input MB_RESET;
  input INTERRUPT;
  input EXT_BRK;
  input EXT_NM_BRK;
  input DBG_STOP;
  output MB_Halted;
  output MB_Error;
  input [0:31] INSTR;
  input IREADY;
  input IWAIT;
  input ICE;
  input IUE;
  output [0:31] INSTR_ADDR;
  output IFETCH;
  output I_AS;
  output IPLB_M_ABort;
  output [0:31] IPLB_M_ABus;
  output [0:31] IPLB_M_UABus;
  output [0:3] IPLB_M_BE;
  output IPLB_M_busLock;
  output IPLB_M_lockErr;
  output [0:1] IPLB_M_MSize;
  output [0:1] IPLB_M_priority;
  output IPLB_M_rdBurst;
  output IPLB_M_request;
  output IPLB_M_RNW;
  output [0:3] IPLB_M_size;
  output [0:15] IPLB_M_TAttribute;
  output [0:2] IPLB_M_type;
  output IPLB_M_wrBurst;
  output [0:31] IPLB_M_wrDBus;
  input IPLB_MBusy;
  input IPLB_MRdErr;
  input IPLB_MWrErr;
  input IPLB_MIRQ;
  input IPLB_MWrBTerm;
  input IPLB_MWrDAck;
  input IPLB_MAddrAck;
  input IPLB_MRdBTerm;
  input IPLB_MRdDAck;
  input [0:31] IPLB_MRdDBus;
  input [0:3] IPLB_MRdWdAddr;
  input IPLB_MRearbitrate;
  input [0:1] IPLB_MSSize;
  input IPLB_MTimeout;
  input [0:31] DATA_READ;
  input DREADY;
  input DWAIT;
  input DCE;
  input DUE;
  output [0:31] DATA_WRITE;
  output [0:31] DATA_ADDR;
  output D_AS;
  output READ_STROBE;
  output WRITE_STROBE;
  output [0:3] BYTE_ENABLE;
  output DPLB_M_ABort;
  output [0:31] DPLB_M_ABus;
  output [0:31] DPLB_M_UABus;
  output [0:3] DPLB_M_BE;
  output DPLB_M_busLock;
  output DPLB_M_lockErr;
  output [0:1] DPLB_M_MSize;
  output [0:1] DPLB_M_priority;
  output DPLB_M_rdBurst;
  output DPLB_M_request;
  output DPLB_M_RNW;
  output [0:3] DPLB_M_size;
  output [0:15] DPLB_M_TAttribute;
  output [0:2] DPLB_M_type;
  output DPLB_M_wrBurst;
  output [0:31] DPLB_M_wrDBus;
  input DPLB_MBusy;
  input DPLB_MRdErr;
  input DPLB_MWrErr;
  input DPLB_MIRQ;
  input DPLB_MWrBTerm;
  input DPLB_MWrDAck;
  input DPLB_MAddrAck;
  input DPLB_MRdBTerm;
  input DPLB_MRdDAck;
  input [0:31] DPLB_MRdDBus;
  input [0:3] DPLB_MRdWdAddr;
  input DPLB_MRearbitrate;
  input [0:1] DPLB_MSSize;
  input DPLB_MTimeout;
  output [0:0] M_AXI_IP_AWID;
  output [31:0] M_AXI_IP_AWADDR;
  output [7:0] M_AXI_IP_AWLEN;
  output [2:0] M_AXI_IP_AWSIZE;
  output [1:0] M_AXI_IP_AWBURST;
  output M_AXI_IP_AWLOCK;
  output [3:0] M_AXI_IP_AWCACHE;
  output [2:0] M_AXI_IP_AWPROT;
  output [3:0] M_AXI_IP_AWQOS;
  output M_AXI_IP_AWVALID;
  input M_AXI_IP_AWREADY;
  output [31:0] M_AXI_IP_WDATA;
  output [3:0] M_AXI_IP_WSTRB;
  output M_AXI_IP_WLAST;
  output M_AXI_IP_WVALID;
  input M_AXI_IP_WREADY;
  input [0:0] M_AXI_IP_BID;
  input [1:0] M_AXI_IP_BRESP;
  input M_AXI_IP_BVALID;
  output M_AXI_IP_BREADY;
  output [0:0] M_AXI_IP_ARID;
  output [31:0] M_AXI_IP_ARADDR;
  output [7:0] M_AXI_IP_ARLEN;
  output [2:0] M_AXI_IP_ARSIZE;
  output [1:0] M_AXI_IP_ARBURST;
  output M_AXI_IP_ARLOCK;
  output [3:0] M_AXI_IP_ARCACHE;
  output [2:0] M_AXI_IP_ARPROT;
  output [3:0] M_AXI_IP_ARQOS;
  output M_AXI_IP_ARVALID;
  input M_AXI_IP_ARREADY;
  input [0:0] M_AXI_IP_RID;
  input [31:0] M_AXI_IP_RDATA;
  input [1:0] M_AXI_IP_RRESP;
  input M_AXI_IP_RLAST;
  input M_AXI_IP_RVALID;
  output M_AXI_IP_RREADY;
  output [0:0] M_AXI_DP_AWID;
  output [31:0] M_AXI_DP_AWADDR;
  output [7:0] M_AXI_DP_AWLEN;
  output [2:0] M_AXI_DP_AWSIZE;
  output [1:0] M_AXI_DP_AWBURST;
  output M_AXI_DP_AWLOCK;
  output [3:0] M_AXI_DP_AWCACHE;
  output [2:0] M_AXI_DP_AWPROT;
  output [3:0] M_AXI_DP_AWQOS;
  output M_AXI_DP_AWVALID;
  input M_AXI_DP_AWREADY;
  output [31:0] M_AXI_DP_WDATA;
  output [3:0] M_AXI_DP_WSTRB;
  output M_AXI_DP_WLAST;
  output M_AXI_DP_WVALID;
  input M_AXI_DP_WREADY;
  input [0:0] M_AXI_DP_BID;
  input [1:0] M_AXI_DP_BRESP;
  input M_AXI_DP_BVALID;
  output M_AXI_DP_BREADY;
  output [0:0] M_AXI_DP_ARID;
  output [31:0] M_AXI_DP_ARADDR;
  output [7:0] M_AXI_DP_ARLEN;
  output [2:0] M_AXI_DP_ARSIZE;
  output [1:0] M_AXI_DP_ARBURST;
  output M_AXI_DP_ARLOCK;
  output [3:0] M_AXI_DP_ARCACHE;
  output [2:0] M_AXI_DP_ARPROT;
  output [3:0] M_AXI_DP_ARQOS;
  output M_AXI_DP_ARVALID;
  input M_AXI_DP_ARREADY;
  input [0:0] M_AXI_DP_RID;
  input [31:0] M_AXI_DP_RDATA;
  input [1:0] M_AXI_DP_RRESP;
  input M_AXI_DP_RLAST;
  input M_AXI_DP_RVALID;
  output M_AXI_DP_RREADY;
  output [0:0] M_AXI_IC_AWID;
  output [31:0] M_AXI_IC_AWADDR;
  output [7:0] M_AXI_IC_AWLEN;
  output [2:0] M_AXI_IC_AWSIZE;
  output [1:0] M_AXI_IC_AWBURST;
  output M_AXI_IC_AWLOCK;
  output [3:0] M_AXI_IC_AWCACHE;
  output [2:0] M_AXI_IC_AWPROT;
  output [3:0] M_AXI_IC_AWQOS;
  output M_AXI_IC_AWVALID;
  input M_AXI_IC_AWREADY;
  output [31:0] M_AXI_IC_WDATA;
  output [3:0] M_AXI_IC_WSTRB;
  output M_AXI_IC_WLAST;
  output M_AXI_IC_WVALID;
  input M_AXI_IC_WREADY;
  input [0:0] M_AXI_IC_BID;
  input [1:0] M_AXI_IC_BRESP;
  input M_AXI_IC_BVALID;
  output M_AXI_IC_BREADY;
  output [0:0] M_AXI_IC_ARID;
  output [31:0] M_AXI_IC_ARADDR;
  output [7:0] M_AXI_IC_ARLEN;
  output [2:0] M_AXI_IC_ARSIZE;
  output [1:0] M_AXI_IC_ARBURST;
  output M_AXI_IC_ARLOCK;
  output [3:0] M_AXI_IC_ARCACHE;
  output [2:0] M_AXI_IC_ARPROT;
  output [3:0] M_AXI_IC_ARQOS;
  output M_AXI_IC_ARVALID;
  input M_AXI_IC_ARREADY;
  input [0:0] M_AXI_IC_RID;
  input [31:0] M_AXI_IC_RDATA;
  input [1:0] M_AXI_IC_RRESP;
  input M_AXI_IC_RLAST;
  input M_AXI_IC_RVALID;
  output M_AXI_IC_RREADY;
  output [0:0] M_AXI_DC_AWID;
  output [31:0] M_AXI_DC_AWADDR;
  output [7:0] M_AXI_DC_AWLEN;
  output [2:0] M_AXI_DC_AWSIZE;
  output [1:0] M_AXI_DC_AWBURST;
  output M_AXI_DC_AWLOCK;
  output [3:0] M_AXI_DC_AWCACHE;
  output [2:0] M_AXI_DC_AWPROT;
  output [3:0] M_AXI_DC_AWQOS;
  output M_AXI_DC_AWVALID;
  input M_AXI_DC_AWREADY;
  output [31:0] M_AXI_DC_WDATA;
  output [3:0] M_AXI_DC_WSTRB;
  output M_AXI_DC_WLAST;
  output M_AXI_DC_WVALID;
  input M_AXI_DC_WREADY;
  input [0:0] M_AXI_DC_BID;
  input [1:0] M_AXI_DC_BRESP;
  input M_AXI_DC_BVALID;
  output M_AXI_DC_BREADY;
  output [0:0] M_AXI_DC_ARID;
  output [31:0] M_AXI_DC_ARADDR;
  output [7:0] M_AXI_DC_ARLEN;
  output [2:0] M_AXI_DC_ARSIZE;
  output [1:0] M_AXI_DC_ARBURST;
  output M_AXI_DC_ARLOCK;
  output [3:0] M_AXI_DC_ARCACHE;
  output [2:0] M_AXI_DC_ARPROT;
  output [3:0] M_AXI_DC_ARQOS;
  output M_AXI_DC_ARVALID;
  input M_AXI_DC_ARREADY;
  input [0:0] M_AXI_DC_RID;
  input [31:0] M_AXI_DC_RDATA;
  input [1:0] M_AXI_DC_RRESP;
  input M_AXI_DC_RLAST;
  input M_AXI_DC_RVALID;
  output M_AXI_DC_RREADY;
  input DBG_CLK;
  input DBG_TDI;
  output DBG_TDO;
  input [0:7] DBG_REG_EN;
  input DBG_SHIFT;
  input DBG_CAPTURE;
  input DBG_UPDATE;
  input DEBUG_RST;
  output [0:31] Trace_Instruction;
  output Trace_Valid_Instr;
  output [0:31] Trace_PC;
  output Trace_Reg_Write;
  output [0:4] Trace_Reg_Addr;
  output [0:14] Trace_MSR_Reg;
  output [0:7] Trace_PID_Reg;
  output [0:31] Trace_New_Reg_Value;
  output Trace_Exception_Taken;
  output [0:4] Trace_Exception_Kind;
  output Trace_Jump_Taken;
  output Trace_Delay_Slot;
  output [0:31] Trace_Data_Address;
  output Trace_Data_Access;
  output Trace_Data_Read;
  output Trace_Data_Write;
  output [0:31] Trace_Data_Write_Value;
  output [0:3] Trace_Data_Byte_Enable;
  output Trace_DCache_Req;
  output Trace_DCache_Hit;
  output Trace_DCache_Rdy;
  output Trace_DCache_Read;
  output Trace_ICache_Req;
  output Trace_ICache_Hit;
  output Trace_ICache_Rdy;
  output Trace_OF_PipeRun;
  output Trace_EX_PipeRun;
  output Trace_MEM_PipeRun;
  output Trace_MB_Halted;
  output Trace_Jump_Hit;
  output FSL0_S_CLK;
  output FSL0_S_READ;
  input [0:31] FSL0_S_DATA;
  input FSL0_S_CONTROL;
  input FSL0_S_EXISTS;
  output FSL0_M_CLK;
  output FSL0_M_WRITE;
  output [0:31] FSL0_M_DATA;
  output FSL0_M_CONTROL;
  input FSL0_M_FULL;
  output FSL1_S_CLK;
  output FSL1_S_READ;
  input [0:31] FSL1_S_DATA;
  input FSL1_S_CONTROL;
  input FSL1_S_EXISTS;
  output FSL1_M_CLK;
  output FSL1_M_WRITE;
  output [0:31] FSL1_M_DATA;
  output FSL1_M_CONTROL;
  input FSL1_M_FULL;
  output FSL2_S_CLK;
  output FSL2_S_READ;
  input [0:31] FSL2_S_DATA;
  input FSL2_S_CONTROL;
  input FSL2_S_EXISTS;
  output FSL2_M_CLK;
  output FSL2_M_WRITE;
  output [0:31] FSL2_M_DATA;
  output FSL2_M_CONTROL;
  input FSL2_M_FULL;
  output FSL3_S_CLK;
  output FSL3_S_READ;
  input [0:31] FSL3_S_DATA;
  input FSL3_S_CONTROL;
  input FSL3_S_EXISTS;
  output FSL3_M_CLK;
  output FSL3_M_WRITE;
  output [0:31] FSL3_M_DATA;
  output FSL3_M_CONTROL;
  input FSL3_M_FULL;
  output FSL4_S_CLK;
  output FSL4_S_READ;
  input [0:31] FSL4_S_DATA;
  input FSL4_S_CONTROL;
  input FSL4_S_EXISTS;
  output FSL4_M_CLK;
  output FSL4_M_WRITE;
  output [0:31] FSL4_M_DATA;
  output FSL4_M_CONTROL;
  input FSL4_M_FULL;
  output FSL5_S_CLK;
  output FSL5_S_READ;
  input [0:31] FSL5_S_DATA;
  input FSL5_S_CONTROL;
  input FSL5_S_EXISTS;
  output FSL5_M_CLK;
  output FSL5_M_WRITE;
  output [0:31] FSL5_M_DATA;
  output FSL5_M_CONTROL;
  input FSL5_M_FULL;
  output FSL6_S_CLK;
  output FSL6_S_READ;
  input [0:31] FSL6_S_DATA;
  input FSL6_S_CONTROL;
  input FSL6_S_EXISTS;
  output FSL6_M_CLK;
  output FSL6_M_WRITE;
  output [0:31] FSL6_M_DATA;
  output FSL6_M_CONTROL;
  input FSL6_M_FULL;
  output FSL7_S_CLK;
  output FSL7_S_READ;
  input [0:31] FSL7_S_DATA;
  input FSL7_S_CONTROL;
  input FSL7_S_EXISTS;
  output FSL7_M_CLK;
  output FSL7_M_WRITE;
  output [0:31] FSL7_M_DATA;
  output FSL7_M_CONTROL;
  input FSL7_M_FULL;
  output FSL8_S_CLK;
  output FSL8_S_READ;
  input [0:31] FSL8_S_DATA;
  input FSL8_S_CONTROL;
  input FSL8_S_EXISTS;
  output FSL8_M_CLK;
  output FSL8_M_WRITE;
  output [0:31] FSL8_M_DATA;
  output FSL8_M_CONTROL;
  input FSL8_M_FULL;
  output FSL9_S_CLK;
  output FSL9_S_READ;
  input [0:31] FSL9_S_DATA;
  input FSL9_S_CONTROL;
  input FSL9_S_EXISTS;
  output FSL9_M_CLK;
  output FSL9_M_WRITE;
  output [0:31] FSL9_M_DATA;
  output FSL9_M_CONTROL;
  input FSL9_M_FULL;
  output FSL10_S_CLK;
  output FSL10_S_READ;
  input [0:31] FSL10_S_DATA;
  input FSL10_S_CONTROL;
  input FSL10_S_EXISTS;
  output FSL10_M_CLK;
  output FSL10_M_WRITE;
  output [0:31] FSL10_M_DATA;
  output FSL10_M_CONTROL;
  input FSL10_M_FULL;
  output FSL11_S_CLK;
  output FSL11_S_READ;
  input [0:31] FSL11_S_DATA;
  input FSL11_S_CONTROL;
  input FSL11_S_EXISTS;
  output FSL11_M_CLK;
  output FSL11_M_WRITE;
  output [0:31] FSL11_M_DATA;
  output FSL11_M_CONTROL;
  input FSL11_M_FULL;
  output FSL12_S_CLK;
  output FSL12_S_READ;
  input [0:31] FSL12_S_DATA;
  input FSL12_S_CONTROL;
  input FSL12_S_EXISTS;
  output FSL12_M_CLK;
  output FSL12_M_WRITE;
  output [0:31] FSL12_M_DATA;
  output FSL12_M_CONTROL;
  input FSL12_M_FULL;
  output FSL13_S_CLK;
  output FSL13_S_READ;
  input [0:31] FSL13_S_DATA;
  input FSL13_S_CONTROL;
  input FSL13_S_EXISTS;
  output FSL13_M_CLK;
  output FSL13_M_WRITE;
  output [0:31] FSL13_M_DATA;
  output FSL13_M_CONTROL;
  input FSL13_M_FULL;
  output FSL14_S_CLK;
  output FSL14_S_READ;
  input [0:31] FSL14_S_DATA;
  input FSL14_S_CONTROL;
  input FSL14_S_EXISTS;
  output FSL14_M_CLK;
  output FSL14_M_WRITE;
  output [0:31] FSL14_M_DATA;
  output FSL14_M_CONTROL;
  input FSL14_M_FULL;
  output FSL15_S_CLK;
  output FSL15_S_READ;
  input [0:31] FSL15_S_DATA;
  input FSL15_S_CONTROL;
  input FSL15_S_EXISTS;
  output FSL15_M_CLK;
  output FSL15_M_WRITE;
  output [0:31] FSL15_M_DATA;
  output FSL15_M_CONTROL;
  input FSL15_M_FULL;
  output M0_AXIS_TLAST;
  output [31:0] M0_AXIS_TDATA;
  output M0_AXIS_TVALID;
  input M0_AXIS_TREADY;
  input S0_AXIS_TLAST;
  input [31:0] S0_AXIS_TDATA;
  input S0_AXIS_TVALID;
  output S0_AXIS_TREADY;
  output M1_AXIS_TLAST;
  output [31:0] M1_AXIS_TDATA;
  output M1_AXIS_TVALID;
  input M1_AXIS_TREADY;
  input S1_AXIS_TLAST;
  input [31:0] S1_AXIS_TDATA;
  input S1_AXIS_TVALID;
  output S1_AXIS_TREADY;
  output M2_AXIS_TLAST;
  output [31:0] M2_AXIS_TDATA;
  output M2_AXIS_TVALID;
  input M2_AXIS_TREADY;
  input S2_AXIS_TLAST;
  input [31:0] S2_AXIS_TDATA;
  input S2_AXIS_TVALID;
  output S2_AXIS_TREADY;
  output M3_AXIS_TLAST;
  output [31:0] M3_AXIS_TDATA;
  output M3_AXIS_TVALID;
  input M3_AXIS_TREADY;
  input S3_AXIS_TLAST;
  input [31:0] S3_AXIS_TDATA;
  input S3_AXIS_TVALID;
  output S3_AXIS_TREADY;
  output M4_AXIS_TLAST;
  output [31:0] M4_AXIS_TDATA;
  output M4_AXIS_TVALID;
  input M4_AXIS_TREADY;
  input S4_AXIS_TLAST;
  input [31:0] S4_AXIS_TDATA;
  input S4_AXIS_TVALID;
  output S4_AXIS_TREADY;
  output M5_AXIS_TLAST;
  output [31:0] M5_AXIS_TDATA;
  output M5_AXIS_TVALID;
  input M5_AXIS_TREADY;
  input S5_AXIS_TLAST;
  input [31:0] S5_AXIS_TDATA;
  input S5_AXIS_TVALID;
  output S5_AXIS_TREADY;
  output M6_AXIS_TLAST;
  output [31:0] M6_AXIS_TDATA;
  output M6_AXIS_TVALID;
  input M6_AXIS_TREADY;
  input S6_AXIS_TLAST;
  input [31:0] S6_AXIS_TDATA;
  input S6_AXIS_TVALID;
  output S6_AXIS_TREADY;
  output M7_AXIS_TLAST;
  output [31:0] M7_AXIS_TDATA;
  output M7_AXIS_TVALID;
  input M7_AXIS_TREADY;
  input S7_AXIS_TLAST;
  input [31:0] S7_AXIS_TDATA;
  input S7_AXIS_TVALID;
  output S7_AXIS_TREADY;
  output M8_AXIS_TLAST;
  output [31:0] M8_AXIS_TDATA;
  output M8_AXIS_TVALID;
  input M8_AXIS_TREADY;
  input S8_AXIS_TLAST;
  input [31:0] S8_AXIS_TDATA;
  input S8_AXIS_TVALID;
  output S8_AXIS_TREADY;
  output M9_AXIS_TLAST;
  output [31:0] M9_AXIS_TDATA;
  output M9_AXIS_TVALID;
  input M9_AXIS_TREADY;
  input S9_AXIS_TLAST;
  input [31:0] S9_AXIS_TDATA;
  input S9_AXIS_TVALID;
  output S9_AXIS_TREADY;
  output M10_AXIS_TLAST;
  output [31:0] M10_AXIS_TDATA;
  output M10_AXIS_TVALID;
  input M10_AXIS_TREADY;
  input S10_AXIS_TLAST;
  input [31:0] S10_AXIS_TDATA;
  input S10_AXIS_TVALID;
  output S10_AXIS_TREADY;
  output M11_AXIS_TLAST;
  output [31:0] M11_AXIS_TDATA;
  output M11_AXIS_TVALID;
  input M11_AXIS_TREADY;
  input S11_AXIS_TLAST;
  input [31:0] S11_AXIS_TDATA;
  input S11_AXIS_TVALID;
  output S11_AXIS_TREADY;
  output M12_AXIS_TLAST;
  output [31:0] M12_AXIS_TDATA;
  output M12_AXIS_TVALID;
  input M12_AXIS_TREADY;
  input S12_AXIS_TLAST;
  input [31:0] S12_AXIS_TDATA;
  input S12_AXIS_TVALID;
  output S12_AXIS_TREADY;
  output M13_AXIS_TLAST;
  output [31:0] M13_AXIS_TDATA;
  output M13_AXIS_TVALID;
  input M13_AXIS_TREADY;
  input S13_AXIS_TLAST;
  input [31:0] S13_AXIS_TDATA;
  input S13_AXIS_TVALID;
  output S13_AXIS_TREADY;
  output M14_AXIS_TLAST;
  output [31:0] M14_AXIS_TDATA;
  output M14_AXIS_TVALID;
  input M14_AXIS_TREADY;
  input S14_AXIS_TLAST;
  input [31:0] S14_AXIS_TDATA;
  input S14_AXIS_TVALID;
  output S14_AXIS_TREADY;
  output M15_AXIS_TLAST;
  output [31:0] M15_AXIS_TDATA;
  output M15_AXIS_TVALID;
  input M15_AXIS_TREADY;
  input S15_AXIS_TLAST;
  input [31:0] S15_AXIS_TDATA;
  input S15_AXIS_TVALID;
  output S15_AXIS_TREADY;
  output ICACHE_FSL_IN_CLK;
  output ICACHE_FSL_IN_READ;
  input [0:31] ICACHE_FSL_IN_DATA;
  input ICACHE_FSL_IN_CONTROL;
  input ICACHE_FSL_IN_EXISTS;
  output ICACHE_FSL_OUT_CLK;
  output ICACHE_FSL_OUT_WRITE;
  output [0:31] ICACHE_FSL_OUT_DATA;
  output ICACHE_FSL_OUT_CONTROL;
  input ICACHE_FSL_OUT_FULL;
  output DCACHE_FSL_IN_CLK;
  output DCACHE_FSL_IN_READ;
  input [0:31] DCACHE_FSL_IN_DATA;
  input DCACHE_FSL_IN_CONTROL;
  input DCACHE_FSL_IN_EXISTS;
  output DCACHE_FSL_OUT_CLK;
  output DCACHE_FSL_OUT_WRITE;
  output [0:31] DCACHE_FSL_OUT_DATA;
  output DCACHE_FSL_OUT_CONTROL;
  input DCACHE_FSL_OUT_FULL;
endmodule

module microblaze_0_ilmb_wrapper
  (
    LMB_Clk,
    SYS_Rst,
    LMB_Rst,
    M_ABus,
    M_ReadStrobe,
    M_WriteStrobe,
    M_AddrStrobe,
    M_DBus,
    M_BE,
    Sl_DBus,
    Sl_Ready,
    LMB_ABus,
    LMB_ReadStrobe,
    LMB_WriteStrobe,
    LMB_AddrStrobe,
    LMB_ReadDBus,
    LMB_WriteDBus,
    LMB_Ready,
    LMB_BE
  );
  input LMB_Clk;
  input SYS_Rst;
  output LMB_Rst;
  input [0:31] M_ABus;
  input M_ReadStrobe;
  input M_WriteStrobe;
  input M_AddrStrobe;
  input [0:31] M_DBus;
  input [0:3] M_BE;
  input [0:31] Sl_DBus;
  input [0:0] Sl_Ready;
  output [0:31] LMB_ABus;
  output LMB_ReadStrobe;
  output LMB_WriteStrobe;
  output LMB_AddrStrobe;
  output [0:31] LMB_ReadDBus;
  output [0:31] LMB_WriteDBus;
  output LMB_Ready;
  output [0:3] LMB_BE;
endmodule

module microblaze_0_dlmb_wrapper
  (
    LMB_Clk,
    SYS_Rst,
    LMB_Rst,
    M_ABus,
    M_ReadStrobe,
    M_WriteStrobe,
    M_AddrStrobe,
    M_DBus,
    M_BE,
    Sl_DBus,
    Sl_Ready,
    LMB_ABus,
    LMB_ReadStrobe,
    LMB_WriteStrobe,
    LMB_AddrStrobe,
    LMB_ReadDBus,
    LMB_WriteDBus,
    LMB_Ready,
    LMB_BE
  );
  input LMB_Clk;
  input SYS_Rst;
  output LMB_Rst;
  input [0:31] M_ABus;
  input M_ReadStrobe;
  input M_WriteStrobe;
  input M_AddrStrobe;
  input [0:31] M_DBus;
  input [0:3] M_BE;
  input [0:31] Sl_DBus;
  input [0:0] Sl_Ready;
  output [0:31] LMB_ABus;
  output LMB_ReadStrobe;
  output LMB_WriteStrobe;
  output LMB_AddrStrobe;
  output [0:31] LMB_ReadDBus;
  output [0:31] LMB_WriteDBus;
  output LMB_Ready;
  output [0:3] LMB_BE;
endmodule

module microblaze_0_i_bram_ctrl_wrapper
  (
    LMB_Clk,
    LMB_Rst,
    LMB_ABus,
    LMB_WriteDBus,
    LMB_AddrStrobe,
    LMB_ReadStrobe,
    LMB_WriteStrobe,
    LMB_BE,
    Sl_DBus,
    Sl_Ready,
    BRAM_Rst_A,
    BRAM_Clk_A,
    BRAM_EN_A,
    BRAM_WEN_A,
    BRAM_Addr_A,
    BRAM_Din_A,
    BRAM_Dout_A
  );
  input LMB_Clk;
  input LMB_Rst;
  input [0:31] LMB_ABus;
  input [0:31] LMB_WriteDBus;
  input LMB_AddrStrobe;
  input LMB_ReadStrobe;
  input LMB_WriteStrobe;
  input [0:3] LMB_BE;
  output [0:31] Sl_DBus;
  output Sl_Ready;
  output BRAM_Rst_A;
  output BRAM_Clk_A;
  output BRAM_EN_A;
  output [0:3] BRAM_WEN_A;
  output [0:31] BRAM_Addr_A;
  input [0:31] BRAM_Din_A;
  output [0:31] BRAM_Dout_A;
endmodule

module microblaze_0_d_bram_ctrl_wrapper
  (
    LMB_Clk,
    LMB_Rst,
    LMB_ABus,
    LMB_WriteDBus,
    LMB_AddrStrobe,
    LMB_ReadStrobe,
    LMB_WriteStrobe,
    LMB_BE,
    Sl_DBus,
    Sl_Ready,
    BRAM_Rst_A,
    BRAM_Clk_A,
    BRAM_EN_A,
    BRAM_WEN_A,
    BRAM_Addr_A,
    BRAM_Din_A,
    BRAM_Dout_A
  );
  input LMB_Clk;
  input LMB_Rst;
  input [0:31] LMB_ABus;
  input [0:31] LMB_WriteDBus;
  input LMB_AddrStrobe;
  input LMB_ReadStrobe;
  input LMB_WriteStrobe;
  input [0:3] LMB_BE;
  output [0:31] Sl_DBus;
  output Sl_Ready;
  output BRAM_Rst_A;
  output BRAM_Clk_A;
  output BRAM_EN_A;
  output [0:3] BRAM_WEN_A;
  output [0:31] BRAM_Addr_A;
  input [0:31] BRAM_Din_A;
  output [0:31] BRAM_Dout_A;
endmodule

module microblaze_0_bram_block_wrapper
  (
    BRAM_Rst_A,
    BRAM_Clk_A,
    BRAM_EN_A,
    BRAM_WEN_A,
    BRAM_Addr_A,
    BRAM_Din_A,
    BRAM_Dout_A,
    BRAM_Rst_B,
    BRAM_Clk_B,
    BRAM_EN_B,
    BRAM_WEN_B,
    BRAM_Addr_B,
    BRAM_Din_B,
    BRAM_Dout_B
  );
  input BRAM_Rst_A;
  input BRAM_Clk_A;
  input BRAM_EN_A;
  input [0:3] BRAM_WEN_A;
  input [0:31] BRAM_Addr_A;
  output [0:31] BRAM_Din_A;
  input [0:31] BRAM_Dout_A;
  input BRAM_Rst_B;
  input BRAM_Clk_B;
  input BRAM_EN_B;
  input [0:3] BRAM_WEN_B;
  input [0:31] BRAM_Addr_B;
  output [0:31] BRAM_Din_B;
  input [0:31] BRAM_Dout_B;
endmodule

module reset_0_wrapper
  (
    Slowest_sync_clk,
    Ext_Reset_In,
    Aux_Reset_In,
    MB_Debug_Sys_Rst,
    Core_Reset_Req_0,
    Chip_Reset_Req_0,
    System_Reset_Req_0,
    Core_Reset_Req_1,
    Chip_Reset_Req_1,
    System_Reset_Req_1,
    Dcm_locked,
    RstcPPCresetcore_0,
    RstcPPCresetchip_0,
    RstcPPCresetsys_0,
    RstcPPCresetcore_1,
    RstcPPCresetchip_1,
    RstcPPCresetsys_1,
    MB_Reset,
    Bus_Struct_Reset,
    Peripheral_Reset,
    Interconnect_aresetn,
    Peripheral_aresetn
  );
  input Slowest_sync_clk;
  input Ext_Reset_In;
  input Aux_Reset_In;
  input MB_Debug_Sys_Rst;
  input Core_Reset_Req_0;
  input Chip_Reset_Req_0;
  input System_Reset_Req_0;
  input Core_Reset_Req_1;
  input Chip_Reset_Req_1;
  input System_Reset_Req_1;
  input Dcm_locked;
  output RstcPPCresetcore_0;
  output RstcPPCresetchip_0;
  output RstcPPCresetsys_0;
  output RstcPPCresetcore_1;
  output RstcPPCresetchip_1;
  output RstcPPCresetsys_1;
  output MB_Reset;
  output [0:0] Bus_Struct_Reset;
  output [0:0] Peripheral_Reset;
  output [0:0] Interconnect_aresetn;
  output [0:0] Peripheral_aresetn;
endmodule

module rs232_uart_1_wrapper
  (
    S_AXI_ACLK,
    S_AXI_ARESETN,
    Interrupt,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_AWREADY,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARVALID,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_RREADY,
    RX,
    TX
  );
  input S_AXI_ACLK;
  input S_AXI_ARESETN;
  output Interrupt;
  input [31:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  output S_AXI_AWREADY;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  input S_AXI_BREADY;
  input [31:0] S_AXI_ARADDR;
  input S_AXI_ARVALID;
  output S_AXI_ARREADY;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RVALID;
  input S_AXI_RREADY;
  input RX;
  output TX;
endmodule

module clock_generator_0_wrapper
  (
    CLKIN,
    CLKOUT0,
    CLKOUT1,
    CLKOUT2,
    CLKOUT3,
    CLKOUT4,
    CLKOUT5,
    CLKOUT6,
    CLKOUT7,
    CLKOUT8,
    CLKOUT9,
    CLKOUT10,
    CLKOUT11,
    CLKOUT12,
    CLKOUT13,
    CLKOUT14,
    CLKOUT15,
    CLKFBIN,
    CLKFBOUT,
    PSCLK,
    PSEN,
    PSINCDEC,
    PSDONE,
    RST,
    LOCKED
  );
  input CLKIN;
  output CLKOUT0;
  output CLKOUT1;
  output CLKOUT2;
  output CLKOUT3;
  output CLKOUT4;
  output CLKOUT5;
  output CLKOUT6;
  output CLKOUT7;
  output CLKOUT8;
  output CLKOUT9;
  output CLKOUT10;
  output CLKOUT11;
  output CLKOUT12;
  output CLKOUT13;
  output CLKOUT14;
  output CLKOUT15;
  input CLKFBIN;
  output CLKFBOUT;
  input PSCLK;
  input PSEN;
  input PSINCDEC;
  output PSDONE;
  input RST;
  output LOCKED;
endmodule

module nf10_10g_interface_0_wrapper
  (
    axi_aclk,
    axi_resetn,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tuser,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tlast,
    refclk,
    dclk,
    xaui_tx_l0_p,
    xaui_tx_l0_n,
    xaui_tx_l1_p,
    xaui_tx_l1_n,
    xaui_tx_l2_p,
    xaui_tx_l2_n,
    xaui_tx_l3_p,
    xaui_tx_l3_n,
    xaui_rx_l0_p,
    xaui_rx_l0_n,
    xaui_rx_l1_p,
    xaui_rx_l1_n,
    xaui_rx_l2_p,
    xaui_rx_l2_n,
    xaui_rx_l3_p,
    xaui_rx_l3_n
  );
  input axi_aclk;
  input axi_resetn;
  output [255:0] m_axis_tdata;
  output [31:0] m_axis_tstrb;
  output [127:0] m_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output m_axis_tlast;
  input [255:0] s_axis_tdata;
  input [31:0] s_axis_tstrb;
  input [127:0] s_axis_tuser;
  input s_axis_tvalid;
  output s_axis_tready;
  input s_axis_tlast;
  input refclk;
  input dclk;
  output xaui_tx_l0_p;
  output xaui_tx_l0_n;
  output xaui_tx_l1_p;
  output xaui_tx_l1_n;
  output xaui_tx_l2_p;
  output xaui_tx_l2_n;
  output xaui_tx_l3_p;
  output xaui_tx_l3_n;
  input xaui_rx_l0_p;
  input xaui_rx_l0_n;
  input xaui_rx_l1_p;
  input xaui_rx_l1_n;
  input xaui_rx_l2_p;
  input xaui_rx_l2_n;
  input xaui_rx_l3_p;
  input xaui_rx_l3_n;
endmodule

module nf10_10g_interface_1_wrapper
  (
    axi_aclk,
    axi_resetn,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tuser,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tlast,
    refclk,
    dclk,
    xaui_tx_l0_p,
    xaui_tx_l0_n,
    xaui_tx_l1_p,
    xaui_tx_l1_n,
    xaui_tx_l2_p,
    xaui_tx_l2_n,
    xaui_tx_l3_p,
    xaui_tx_l3_n,
    xaui_rx_l0_p,
    xaui_rx_l0_n,
    xaui_rx_l1_p,
    xaui_rx_l1_n,
    xaui_rx_l2_p,
    xaui_rx_l2_n,
    xaui_rx_l3_p,
    xaui_rx_l3_n
  );
  input axi_aclk;
  input axi_resetn;
  output [255:0] m_axis_tdata;
  output [31:0] m_axis_tstrb;
  output [127:0] m_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output m_axis_tlast;
  input [255:0] s_axis_tdata;
  input [31:0] s_axis_tstrb;
  input [127:0] s_axis_tuser;
  input s_axis_tvalid;
  output s_axis_tready;
  input s_axis_tlast;
  input refclk;
  input dclk;
  output xaui_tx_l0_p;
  output xaui_tx_l0_n;
  output xaui_tx_l1_p;
  output xaui_tx_l1_n;
  output xaui_tx_l2_p;
  output xaui_tx_l2_n;
  output xaui_tx_l3_p;
  output xaui_tx_l3_n;
  input xaui_rx_l0_p;
  input xaui_rx_l0_n;
  input xaui_rx_l1_p;
  input xaui_rx_l1_n;
  input xaui_rx_l2_p;
  input xaui_rx_l2_n;
  input xaui_rx_l3_p;
  input xaui_rx_l3_n;
endmodule

module nf10_10g_interface_2_wrapper
  (
    axi_aclk,
    axi_resetn,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tuser,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tlast,
    refclk,
    dclk,
    xaui_tx_l0_p,
    xaui_tx_l0_n,
    xaui_tx_l1_p,
    xaui_tx_l1_n,
    xaui_tx_l2_p,
    xaui_tx_l2_n,
    xaui_tx_l3_p,
    xaui_tx_l3_n,
    xaui_rx_l0_p,
    xaui_rx_l0_n,
    xaui_rx_l1_p,
    xaui_rx_l1_n,
    xaui_rx_l2_p,
    xaui_rx_l2_n,
    xaui_rx_l3_p,
    xaui_rx_l3_n
  );
  input axi_aclk;
  input axi_resetn;
  output [255:0] m_axis_tdata;
  output [31:0] m_axis_tstrb;
  output [127:0] m_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output m_axis_tlast;
  input [255:0] s_axis_tdata;
  input [31:0] s_axis_tstrb;
  input [127:0] s_axis_tuser;
  input s_axis_tvalid;
  output s_axis_tready;
  input s_axis_tlast;
  input refclk;
  input dclk;
  output xaui_tx_l0_p;
  output xaui_tx_l0_n;
  output xaui_tx_l1_p;
  output xaui_tx_l1_n;
  output xaui_tx_l2_p;
  output xaui_tx_l2_n;
  output xaui_tx_l3_p;
  output xaui_tx_l3_n;
  input xaui_rx_l0_p;
  input xaui_rx_l0_n;
  input xaui_rx_l1_p;
  input xaui_rx_l1_n;
  input xaui_rx_l2_p;
  input xaui_rx_l2_n;
  input xaui_rx_l3_p;
  input xaui_rx_l3_n;
endmodule

module nf10_10g_interface_3_wrapper
  (
    axi_aclk,
    axi_resetn,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tuser,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tlast,
    refclk,
    dclk,
    xaui_tx_l0_p,
    xaui_tx_l0_n,
    xaui_tx_l1_p,
    xaui_tx_l1_n,
    xaui_tx_l2_p,
    xaui_tx_l2_n,
    xaui_tx_l3_p,
    xaui_tx_l3_n,
    xaui_rx_l0_p,
    xaui_rx_l0_n,
    xaui_rx_l1_p,
    xaui_rx_l1_n,
    xaui_rx_l2_p,
    xaui_rx_l2_n,
    xaui_rx_l3_p,
    xaui_rx_l3_n
  );
  input axi_aclk;
  input axi_resetn;
  output [255:0] m_axis_tdata;
  output [31:0] m_axis_tstrb;
  output [127:0] m_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output m_axis_tlast;
  input [255:0] s_axis_tdata;
  input [31:0] s_axis_tstrb;
  input [127:0] s_axis_tuser;
  input s_axis_tvalid;
  output s_axis_tready;
  input s_axis_tlast;
  input refclk;
  input dclk;
  output xaui_tx_l0_p;
  output xaui_tx_l0_n;
  output xaui_tx_l1_p;
  output xaui_tx_l1_n;
  output xaui_tx_l2_p;
  output xaui_tx_l2_n;
  output xaui_tx_l3_p;
  output xaui_tx_l3_n;
  input xaui_rx_l0_p;
  input xaui_rx_l0_n;
  input xaui_rx_l1_p;
  input xaui_rx_l1_n;
  input xaui_rx_l2_p;
  input xaui_rx_l2_n;
  input xaui_rx_l3_p;
  input xaui_rx_l3_n;
endmodule

module diff_input_buf_0_wrapper
  (
    SINGLE_ENDED_INPUT,
    DIFF_INPUT_P,
    DIFF_INPUT_N
  );
  output SINGLE_ENDED_INPUT;
  input DIFF_INPUT_P;
  input DIFF_INPUT_N;
endmodule

module diff_input_buf_1_wrapper
  (
    SINGLE_ENDED_INPUT,
    DIFF_INPUT_P,
    DIFF_INPUT_N
  );
  output SINGLE_ENDED_INPUT;
  input DIFF_INPUT_P;
  input DIFF_INPUT_N;
endmodule

module diff_input_buf_2_wrapper
  (
    SINGLE_ENDED_INPUT,
    DIFF_INPUT_P,
    DIFF_INPUT_N
  );
  output SINGLE_ENDED_INPUT;
  input DIFF_INPUT_P;
  input DIFF_INPUT_N;
endmodule

module diff_input_buf_3_wrapper
  (
    SINGLE_ENDED_INPUT,
    DIFF_INPUT_P,
    DIFF_INPUT_N
  );
  output SINGLE_ENDED_INPUT;
  input DIFF_INPUT_P;
  input DIFF_INPUT_N;
endmodule

module nf10_mdio_0_wrapper
  (
    S_AXI_ACLK,
    S_AXI_ARESETN,
    IP2INTC_Irpt,
    S_AXI_AWID,
    S_AXI_AWADDR,
    S_AXI_AWLEN,
    S_AXI_AWSIZE,
    S_AXI_AWBURST,
    S_AXI_AWCACHE,
    S_AXI_AWVALID,
    S_AXI_AWREADY,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WLAST,
    S_AXI_WVALID,
    S_AXI_WREADY,
    S_AXI_BID,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_BREADY,
    S_AXI_ARID,
    S_AXI_ARADDR,
    S_AXI_ARLEN,
    S_AXI_ARSIZE,
    S_AXI_ARBURST,
    S_AXI_ARCACHE,
    S_AXI_ARVALID,
    S_AXI_ARREADY,
    S_AXI_RID,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RLAST,
    S_AXI_RVALID,
    S_AXI_RREADY,
    PHY_rst_n,
    PHY_MDC,
    PHY_MDIO_I,
    PHY_MDIO_O,
    PHY_MDIO_T
  );
  input S_AXI_ACLK;
  input S_AXI_ARESETN;
  output IP2INTC_Irpt;
  input [1:0] S_AXI_AWID;
  input [31:0] S_AXI_AWADDR;
  input [7:0] S_AXI_AWLEN;
  input [2:0] S_AXI_AWSIZE;
  input [1:0] S_AXI_AWBURST;
  input [3:0] S_AXI_AWCACHE;
  input S_AXI_AWVALID;
  output S_AXI_AWREADY;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WLAST;
  input S_AXI_WVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BID;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  input S_AXI_BREADY;
  input [1:0] S_AXI_ARID;
  input [31:0] S_AXI_ARADDR;
  input [7:0] S_AXI_ARLEN;
  input [2:0] S_AXI_ARSIZE;
  input [1:0] S_AXI_ARBURST;
  input [3:0] S_AXI_ARCACHE;
  input S_AXI_ARVALID;
  output S_AXI_ARREADY;
  output [1:0] S_AXI_RID;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RLAST;
  output S_AXI_RVALID;
  input S_AXI_RREADY;
  output PHY_rst_n;
  output PHY_MDC;
  input PHY_MDIO_I;
  output PHY_MDIO_O;
  output PHY_MDIO_T;
endmodule

module axi_timebase_wdt_0_wrapper
  (
    WDT_Reset,
    Timebase_Interrupt,
    WDT_Interrupt,
    Freeze,
    S_AXI_ACLK,
    S_AXI_ARESETN,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_AWREADY,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARVALID,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_RREADY
  );
  output WDT_Reset;
  output Timebase_Interrupt;
  output WDT_Interrupt;
  input Freeze;
  input S_AXI_ACLK;
  input S_AXI_ARESETN;
  input [31:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  output S_AXI_AWREADY;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  input S_AXI_BREADY;
  input [31:0] S_AXI_ARADDR;
  input S_AXI_ARVALID;
  output S_AXI_ARREADY;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RVALID;
  input S_AXI_RREADY;
endmodule

module nf10_input_arbiter_0_wrapper
  (
    axi_aclk,
    axi_resetn,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tlast,
    s_axis_tdata_0,
    s_axis_tstrb_0,
    s_axis_tuser_0,
    s_axis_tvalid_0,
    s_axis_tready_0,
    s_axis_tlast_0,
    s_axis_tdata_1,
    s_axis_tstrb_1,
    s_axis_tuser_1,
    s_axis_tvalid_1,
    s_axis_tready_1,
    s_axis_tlast_1,
    s_axis_tdata_2,
    s_axis_tstrb_2,
    s_axis_tuser_2,
    s_axis_tvalid_2,
    s_axis_tready_2,
    s_axis_tlast_2,
    s_axis_tdata_3,
    s_axis_tstrb_3,
    s_axis_tuser_3,
    s_axis_tvalid_3,
    s_axis_tready_3,
    s_axis_tlast_3,
    s_axis_tdata_4,
    s_axis_tstrb_4,
    s_axis_tuser_4,
    s_axis_tvalid_4,
    s_axis_tready_4,
    s_axis_tlast_4
  );
  input axi_aclk;
  input axi_resetn;
  output [255:0] m_axis_tdata;
  output [31:0] m_axis_tstrb;
  output [127:0] m_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output m_axis_tlast;
  input [255:0] s_axis_tdata_0;
  input [31:0] s_axis_tstrb_0;
  input [127:0] s_axis_tuser_0;
  input s_axis_tvalid_0;
  output s_axis_tready_0;
  input s_axis_tlast_0;
  input [255:0] s_axis_tdata_1;
  input [31:0] s_axis_tstrb_1;
  input [127:0] s_axis_tuser_1;
  input s_axis_tvalid_1;
  output s_axis_tready_1;
  input s_axis_tlast_1;
  input [255:0] s_axis_tdata_2;
  input [31:0] s_axis_tstrb_2;
  input [127:0] s_axis_tuser_2;
  input s_axis_tvalid_2;
  output s_axis_tready_2;
  input s_axis_tlast_2;
  input [255:0] s_axis_tdata_3;
  input [31:0] s_axis_tstrb_3;
  input [127:0] s_axis_tuser_3;
  input s_axis_tvalid_3;
  output s_axis_tready_3;
  input s_axis_tlast_3;
  input [255:0] s_axis_tdata_4;
  input [31:0] s_axis_tstrb_4;
  input [127:0] s_axis_tuser_4;
  input s_axis_tvalid_4;
  output s_axis_tready_4;
  input s_axis_tlast_4;
endmodule

module nf10_bram_output_queues_0_wrapper
  (
    axi_aclk,
    axi_resetn,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tuser,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tlast,
    m_axis_tdata_0,
    m_axis_tstrb_0,
    m_axis_tuser_0,
    m_axis_tvalid_0,
    m_axis_tready_0,
    m_axis_tlast_0,
    m_axis_tdata_1,
    m_axis_tstrb_1,
    m_axis_tuser_1,
    m_axis_tvalid_1,
    m_axis_tready_1,
    m_axis_tlast_1,
    m_axis_tdata_2,
    m_axis_tstrb_2,
    m_axis_tuser_2,
    m_axis_tvalid_2,
    m_axis_tready_2,
    m_axis_tlast_2,
    m_axis_tdata_3,
    m_axis_tstrb_3,
    m_axis_tuser_3,
    m_axis_tvalid_3,
    m_axis_tready_3,
    m_axis_tlast_3,
    m_axis_tdata_4,
    m_axis_tstrb_4,
    m_axis_tuser_4,
    m_axis_tvalid_4,
    m_axis_tready_4,
    m_axis_tlast_4
  );
  input axi_aclk;
  input axi_resetn;
  input [255:0] s_axis_tdata;
  input [31:0] s_axis_tstrb;
  input [127:0] s_axis_tuser;
  input s_axis_tvalid;
  output s_axis_tready;
  input s_axis_tlast;
  output [255:0] m_axis_tdata_0;
  output [31:0] m_axis_tstrb_0;
  output [127:0] m_axis_tuser_0;
  output m_axis_tvalid_0;
  input m_axis_tready_0;
  output m_axis_tlast_0;
  output [255:0] m_axis_tdata_1;
  output [31:0] m_axis_tstrb_1;
  output [127:0] m_axis_tuser_1;
  output m_axis_tvalid_1;
  input m_axis_tready_1;
  output m_axis_tlast_1;
  output [255:0] m_axis_tdata_2;
  output [31:0] m_axis_tstrb_2;
  output [127:0] m_axis_tuser_2;
  output m_axis_tvalid_2;
  input m_axis_tready_2;
  output m_axis_tlast_2;
  output [255:0] m_axis_tdata_3;
  output [31:0] m_axis_tstrb_3;
  output [127:0] m_axis_tuser_3;
  output m_axis_tvalid_3;
  input m_axis_tready_3;
  output m_axis_tlast_3;
  output [255:0] m_axis_tdata_4;
  output [31:0] m_axis_tstrb_4;
  output [127:0] m_axis_tuser_4;
  output m_axis_tvalid_4;
  input m_axis_tready_4;
  output m_axis_tlast_4;
endmodule

module dma_0_wrapper
  (
    reset_n,
    pcie_clk_p,
    pcie_clk_n,
    pci_exp_0_txp,
    pci_exp_0_txn,
    pci_exp_0_rxp,
    pci_exp_0_rxn,
    pci_exp_1_txp,
    pci_exp_1_txn,
    pci_exp_1_rxp,
    pci_exp_1_rxn,
    pci_exp_2_txp,
    pci_exp_2_txn,
    pci_exp_2_rxp,
    pci_exp_2_rxn,
    pci_exp_3_txp,
    pci_exp_3_txn,
    pci_exp_3_rxp,
    pci_exp_3_rxn,
    pci_exp_4_txp,
    pci_exp_4_txn,
    pci_exp_4_rxp,
    pci_exp_4_rxn,
    pci_exp_5_txp,
    pci_exp_5_txn,
    pci_exp_5_rxp,
    pci_exp_5_rxn,
    pci_exp_6_txp,
    pci_exp_6_txn,
    pci_exp_6_rxp,
    pci_exp_6_rxn,
    pci_exp_7_txp,
    pci_exp_7_txn,
    pci_exp_7_rxp,
    pci_exp_7_rxn,
    M_AXI_LITE_ACLK,
    M_AXI_LITE_ARESETN,
    M_AXI_LITE_AWADDR,
    M_AXI_LITE_AWVALID,
    M_AXI_LITE_AWREADY,
    M_AXI_LITE_WDATA,
    M_AXI_LITE_WSTRB,
    M_AXI_LITE_WVALID,
    M_AXI_LITE_WREADY,
    M_AXI_LITE_BRESP,
    M_AXI_LITE_BVALID,
    M_AXI_LITE_BREADY,
    M_AXI_LITE_ARADDR,
    M_AXI_LITE_ARVALID,
    M_AXI_LITE_ARREADY,
    M_AXI_LITE_RDATA,
    M_AXI_LITE_RRESP,
    M_AXI_LITE_RVALID,
    M_AXI_LITE_RREADY,
    S_AXI_ACLK,
    S_AXI_ARESETN,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_AWREADY,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARVALID,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_RREADY,
    M_AXIS_ACLK,
    M_AXIS_TDATA,
    M_AXIS_TSTRB,
    M_AXIS_TUSER,
    M_AXIS_TVALID,
    M_AXIS_TREADY,
    M_AXIS_TLAST,
    S_AXIS_ACLK,
    S_AXIS_TDATA,
    S_AXIS_TSTRB,
    S_AXIS_TUSER,
    S_AXIS_TVALID,
    S_AXIS_TREADY,
    S_AXIS_TLAST
  );
  input reset_n;
  input pcie_clk_p;
  input pcie_clk_n;
  output pci_exp_0_txp;
  output pci_exp_0_txn;
  input pci_exp_0_rxp;
  input pci_exp_0_rxn;
  output pci_exp_1_txp;
  output pci_exp_1_txn;
  input pci_exp_1_rxp;
  input pci_exp_1_rxn;
  output pci_exp_2_txp;
  output pci_exp_2_txn;
  input pci_exp_2_rxp;
  input pci_exp_2_rxn;
  output pci_exp_3_txp;
  output pci_exp_3_txn;
  input pci_exp_3_rxp;
  input pci_exp_3_rxn;
  output pci_exp_4_txp;
  output pci_exp_4_txn;
  input pci_exp_4_rxp;
  input pci_exp_4_rxn;
  output pci_exp_5_txp;
  output pci_exp_5_txn;
  input pci_exp_5_rxp;
  input pci_exp_5_rxn;
  output pci_exp_6_txp;
  output pci_exp_6_txn;
  input pci_exp_6_rxp;
  input pci_exp_6_rxn;
  output pci_exp_7_txp;
  output pci_exp_7_txn;
  input pci_exp_7_rxp;
  input pci_exp_7_rxn;
  input M_AXI_LITE_ACLK;
  input M_AXI_LITE_ARESETN;
  output [31:0] M_AXI_LITE_AWADDR;
  output M_AXI_LITE_AWVALID;
  input M_AXI_LITE_AWREADY;
  output [31:0] M_AXI_LITE_WDATA;
  output [3:0] M_AXI_LITE_WSTRB;
  output M_AXI_LITE_WVALID;
  input M_AXI_LITE_WREADY;
  input [1:0] M_AXI_LITE_BRESP;
  input M_AXI_LITE_BVALID;
  output M_AXI_LITE_BREADY;
  output [31:0] M_AXI_LITE_ARADDR;
  output M_AXI_LITE_ARVALID;
  input M_AXI_LITE_ARREADY;
  input [31:0] M_AXI_LITE_RDATA;
  input [1:0] M_AXI_LITE_RRESP;
  input M_AXI_LITE_RVALID;
  output M_AXI_LITE_RREADY;
  input S_AXI_ACLK;
  input S_AXI_ARESETN;
  input [31:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  output S_AXI_AWREADY;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  input S_AXI_BREADY;
  input [31:0] S_AXI_ARADDR;
  input S_AXI_ARVALID;
  output S_AXI_ARREADY;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RVALID;
  input S_AXI_RREADY;
  input M_AXIS_ACLK;
  output [255:0] M_AXIS_TDATA;
  output [31:0] M_AXIS_TSTRB;
  output [127:0] M_AXIS_TUSER;
  output M_AXIS_TVALID;
  input M_AXIS_TREADY;
  output M_AXIS_TLAST;
  input S_AXIS_ACLK;
  input [255:0] S_AXIS_TDATA;
  input [31:0] S_AXIS_TSTRB;
  input [127:0] S_AXIS_TUSER;
  input S_AXIS_TVALID;
  output S_AXIS_TREADY;
  input S_AXIS_TLAST;
endmodule

module nf10_axi_sim_transactor_0_wrapper
  (
    M_AXI_ACLK,
    M_AXI_ARESETN,
    M_AXI_AWADDR,
    M_AXI_AWVALID,
    M_AXI_AWREADY,
    M_AXI_WDATA,
    M_AXI_WSTRB,
    M_AXI_WVALID,
    M_AXI_WREADY,
    M_AXI_BRESP,
    M_AXI_BVALID,
    M_AXI_BREADY,
    M_AXI_ARADDR,
    M_AXI_ARVALID,
    M_AXI_ARREADY,
    M_AXI_RDATA,
    M_AXI_RRESP,
    M_AXI_RVALID,
    M_AXI_RREADY
  );
  input M_AXI_ACLK;
  input M_AXI_ARESETN;
  output [31:0] M_AXI_AWADDR;
  output M_AXI_AWVALID;
  input M_AXI_AWREADY;
  output [31:0] M_AXI_WDATA;
  output [3:0] M_AXI_WSTRB;
  output M_AXI_WVALID;
  input M_AXI_WREADY;
  input [1:0] M_AXI_BRESP;
  input M_AXI_BVALID;
  output M_AXI_BREADY;
  output [31:0] M_AXI_ARADDR;
  output M_AXI_ARVALID;
  input M_AXI_ARREADY;
  input [31:0] M_AXI_RDATA;
  input [1:0] M_AXI_RRESP;
  input M_AXI_RVALID;
  output M_AXI_RREADY;
endmodule

