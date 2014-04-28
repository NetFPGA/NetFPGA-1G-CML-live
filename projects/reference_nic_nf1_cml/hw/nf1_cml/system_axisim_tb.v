//-----------------------------------------------------------------------------
// system_axisim_tb.v
//-----------------------------------------------------------------------------

`timescale 1 ps / 100 fs

`uselib lib=unisims_ver

// START USER CODE (Do not remove this line)

// User: Put your directives here. Code in this
//       section will not be overwritten.

// END USER CODE (Do not remove this line)

module system_axisim_tb
  (
  );

  // START USER CODE (Do not remove this line)

  // User: Put your signals here. Code in this
  //       section will not be overwritten.

  // END USER CODE (Do not remove this line)

  real clk_in_p_PERIOD = 5000.000000;
  real clk_in_n_PERIOD = 5000.000000;
  real reset_n_LENGTH = 80000;

  // Internal signals

  reg clk_in_n;
  reg clk_in_p;
  reg dma_0_pci_exp_0_rxn_pin;
  reg dma_0_pci_exp_0_rxp_pin;
  wire dma_0_pci_exp_0_txn_pin;
  wire dma_0_pci_exp_0_txp_pin;
  reg dma_0_pci_exp_1_rxn_pin;
  reg dma_0_pci_exp_1_rxp_pin;
  wire dma_0_pci_exp_1_txn_pin;
  wire dma_0_pci_exp_1_txp_pin;
  reg dma_0_pci_exp_2_rxn_pin;
  reg dma_0_pci_exp_2_rxp_pin;
  wire dma_0_pci_exp_2_txn_pin;
  wire dma_0_pci_exp_2_txp_pin;
  reg dma_0_pci_exp_3_rxn_pin;
  reg dma_0_pci_exp_3_rxp_pin;
  wire dma_0_pci_exp_3_txn_pin;
  wire dma_0_pci_exp_3_txp_pin;
  reg dma_0_pcie_clk_n_pin;
  reg dma_0_pcie_clk_p_pin;
  wire mdc;
  wire mdio;
  wire phy_rstn_1;
  wire phy_rstn_2;
  wire phy_rstn_3;
  wire phy_rstn_4;
  reg reset_n;
  reg rgmii_rx_ctl_1;
  reg rgmii_rx_ctl_2;
  reg rgmii_rx_ctl_3;
  reg rgmii_rx_ctl_4;
  reg rgmii_rxc_1;
  reg rgmii_rxc_2;
  reg rgmii_rxc_3;
  reg rgmii_rxc_4;
  reg [3:0] rgmii_rxd_1;
  reg [3:0] rgmii_rxd_2;
  reg [3:0] rgmii_rxd_3;
  reg [3:0] rgmii_rxd_4;
  wire rgmii_tx_ctl_1;
  wire rgmii_tx_ctl_2;
  wire rgmii_tx_ctl_3;
  wire rgmii_tx_ctl_4;
  wire rgmii_txc_1;
  wire rgmii_txc_2;
  wire rgmii_txc_3;
  wire rgmii_txc_4;
  wire [3:0] rgmii_txd_1;
  wire [3:0] rgmii_txd_2;
  wire [3:0] rgmii_txd_3;
  wire [3:0] rgmii_txd_4;
  reg uart_rx;
  wire uart_tx;
  reg util_ds_buf_0_IBUF_DS_P_pin;

  system_axisim
    dut (
      .uart_tx ( uart_tx ),
      .uart_rx ( uart_rx ),
      .reset_n ( reset_n ),
      .clk_in_p ( clk_in_p ),
      .clk_in_n ( clk_in_n ),
      .rgmii_tx_ctl_1 ( rgmii_tx_ctl_1 ),
      .rgmii_txd_1 ( rgmii_txd_1 ),
      .rgmii_rxd_1 ( rgmii_rxd_1 ),
      .rgmii_rxc_1 ( rgmii_rxc_1 ),
      .rgmii_rx_ctl_1 ( rgmii_rx_ctl_1 ),
      .rgmii_txc_1 ( rgmii_txc_1 ),
      .rgmii_tx_ctl_2 ( rgmii_tx_ctl_2 ),
      .rgmii_txd_2 ( rgmii_txd_2 ),
      .rgmii_rxd_2 ( rgmii_rxd_2 ),
      .rgmii_rxc_2 ( rgmii_rxc_2 ),
      .rgmii_rx_ctl_2 ( rgmii_rx_ctl_2 ),
      .rgmii_txc_2 ( rgmii_txc_2 ),
      .rgmii_tx_ctl_3 ( rgmii_tx_ctl_3 ),
      .rgmii_txd_3 ( rgmii_txd_3 ),
      .rgmii_rxd_3 ( rgmii_rxd_3 ),
      .rgmii_rxc_3 ( rgmii_rxc_3 ),
      .rgmii_rx_ctl_3 ( rgmii_rx_ctl_3 ),
      .rgmii_txc_3 ( rgmii_txc_3 ),
      .rgmii_txc_4 ( rgmii_txc_4 ),
      .rgmii_txd_4 ( rgmii_txd_4 ),
      .rgmii_rxd_4 ( rgmii_rxd_4 ),
      .rgmii_rxc_4 ( rgmii_rxc_4 ),
      .rgmii_rx_ctl_4 ( rgmii_rx_ctl_4 ),
      .rgmii_tx_ctl_4 ( rgmii_tx_ctl_4 ),
      .dma_0_pci_exp_1_txn_pin ( dma_0_pci_exp_1_txn_pin ),
      .dma_0_pci_exp_1_rxp_pin ( dma_0_pci_exp_1_rxp_pin ),
      .dma_0_pci_exp_0_txp_pin ( dma_0_pci_exp_0_txp_pin ),
      .dma_0_pci_exp_0_txn_pin ( dma_0_pci_exp_0_txn_pin ),
      .dma_0_pci_exp_0_rxn_pin ( dma_0_pci_exp_0_rxn_pin ),
      .dma_0_pci_exp_1_txp_pin ( dma_0_pci_exp_1_txp_pin ),
      .dma_0_pci_exp_1_rxn_pin ( dma_0_pci_exp_1_rxn_pin ),
      .dma_0_pci_exp_2_txp_pin ( dma_0_pci_exp_2_txp_pin ),
      .dma_0_pci_exp_2_txn_pin ( dma_0_pci_exp_2_txn_pin ),
      .dma_0_pci_exp_2_rxp_pin ( dma_0_pci_exp_2_rxp_pin ),
      .dma_0_pci_exp_2_rxn_pin ( dma_0_pci_exp_2_rxn_pin ),
      .dma_0_pci_exp_3_txp_pin ( dma_0_pci_exp_3_txp_pin ),
      .dma_0_pci_exp_3_txn_pin ( dma_0_pci_exp_3_txn_pin ),
      .dma_0_pci_exp_3_rxp_pin ( dma_0_pci_exp_3_rxp_pin ),
      .dma_0_pci_exp_3_rxn_pin ( dma_0_pci_exp_3_rxn_pin ),
      .dma_0_pci_exp_0_rxp_pin ( dma_0_pci_exp_0_rxp_pin ),
      .dma_0_pcie_clk_n_pin ( dma_0_pcie_clk_n_pin ),
      .dma_0_pcie_clk_p_pin ( dma_0_pcie_clk_p_pin ),
      .util_ds_buf_0_IBUF_DS_P_pin ( util_ds_buf_0_IBUF_DS_P_pin ),
      .mdc ( mdc ),
      .mdio ( mdio ),
      .phy_rstn_1 ( phy_rstn_1 ),
      .phy_rstn_2 ( phy_rstn_2 ),
      .phy_rstn_3 ( phy_rstn_3 ),
      .phy_rstn_4 ( phy_rstn_4 )
    );

  // Clock generator for clk_in_p

  initial
    begin
      clk_in_p = 1'b0;
      forever #(clk_in_p_PERIOD/2.00)
        clk_in_p = ~clk_in_p;
    end

  // Clock generator for clk_in_n

  initial
    begin
      clk_in_n = 1'b1;
      forever #(clk_in_n_PERIOD/2.00)
        clk_in_n = ~clk_in_n;
    end

  // Reset Generator for reset_n

  initial
    begin
      reset_n = 1'b0;
      #(reset_n_LENGTH) reset_n = ~reset_n;
    end

  // START USER CODE (Do not remove this line)

  // User: Put your stimulus here. Code in this
  //       section will not be overwritten.

  // END USER CODE (Do not remove this line)

endmodule

