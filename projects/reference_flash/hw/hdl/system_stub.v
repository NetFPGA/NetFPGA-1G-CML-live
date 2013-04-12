//-----------------------------------------------------------------------------
// system_stub.v
//-----------------------------------------------------------------------------

module system_stub
  (
    RESET,
    RS232_Uart_1_sout,
    RS232_Uart_1_sin,
    CLK,
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
    pcie_top_0_pci_exp_0_txn_pin,
    axi_emc_0_Mem_A_pin,
    axi_emc_0_Mem_CEN_pin,
    axi_emc_0_Mem_OEN_pin,
    axi_emc_0_Mem_WEN_pin,
    axi_emc_0_Mem_DQ_pin,
    axi_cfg_fpga_0_GPIO_IO_pin
  );
  input RESET;
  output RS232_Uart_1_sout;
  input RS232_Uart_1_sin;
  input CLK;
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
  output [23:0] axi_emc_0_Mem_A_pin;
  output [0:0] axi_emc_0_Mem_CEN_pin;
  output [0:0] axi_emc_0_Mem_OEN_pin;
  output axi_emc_0_Mem_WEN_pin;
  inout [31:0] axi_emc_0_Mem_DQ_pin;
  inout [0:0] axi_cfg_fpga_0_GPIO_IO_pin;

  (* BOX_TYPE = "user_black_box" *)
  system
    system_i (
      .RESET ( RESET ),
      .RS232_Uart_1_sout ( RS232_Uart_1_sout ),
      .RS232_Uart_1_sin ( RS232_Uart_1_sin ),
      .CLK ( CLK ),
      .pcie_clk_p ( pcie_clk_p ),
      .pcie_top_0_pci_exp_0_txp_pin ( pcie_top_0_pci_exp_0_txp_pin ),
      .pcie_clk_n ( pcie_clk_n ),
      .pcie_top_0_pci_exp_0_rxp_pin ( pcie_top_0_pci_exp_0_rxp_pin ),
      .pcie_top_0_pci_exp_0_rxn_pin ( pcie_top_0_pci_exp_0_rxn_pin ),
      .pcie_top_0_pci_exp_1_txp_pin ( pcie_top_0_pci_exp_1_txp_pin ),
      .pcie_top_0_pci_exp_1_txn_pin ( pcie_top_0_pci_exp_1_txn_pin ),
      .pcie_top_0_pci_exp_1_rxp_pin ( pcie_top_0_pci_exp_1_rxp_pin ),
      .pcie_top_0_pci_exp_1_rxn_pin ( pcie_top_0_pci_exp_1_rxn_pin ),
      .pcie_top_0_pci_exp_4_txp_pin ( pcie_top_0_pci_exp_4_txp_pin ),
      .pcie_top_0_pci_exp_2_txp_pin ( pcie_top_0_pci_exp_2_txp_pin ),
      .pcie_top_0_pci_exp_2_txn_pin ( pcie_top_0_pci_exp_2_txn_pin ),
      .pcie_top_0_pci_exp_2_rxp_pin ( pcie_top_0_pci_exp_2_rxp_pin ),
      .pcie_top_0_pci_exp_2_rxn_pin ( pcie_top_0_pci_exp_2_rxn_pin ),
      .pcie_top_0_pci_exp_3_txp_pin ( pcie_top_0_pci_exp_3_txp_pin ),
      .pcie_top_0_pci_exp_3_txn_pin ( pcie_top_0_pci_exp_3_txn_pin ),
      .pcie_top_0_pci_exp_3_rxp_pin ( pcie_top_0_pci_exp_3_rxp_pin ),
      .pcie_top_0_pci_exp_3_rxn_pin ( pcie_top_0_pci_exp_3_rxn_pin ),
      .pcie_top_0_pci_exp_4_txn_pin ( pcie_top_0_pci_exp_4_txn_pin ),
      .pcie_top_0_pci_exp_4_rxp_pin ( pcie_top_0_pci_exp_4_rxp_pin ),
      .pcie_top_0_pci_exp_4_rxn_pin ( pcie_top_0_pci_exp_4_rxn_pin ),
      .pcie_top_0_pci_exp_5_txp_pin ( pcie_top_0_pci_exp_5_txp_pin ),
      .pcie_top_0_pci_exp_5_txn_pin ( pcie_top_0_pci_exp_5_txn_pin ),
      .pcie_top_0_pci_exp_5_rxp_pin ( pcie_top_0_pci_exp_5_rxp_pin ),
      .pcie_top_0_pci_exp_5_rxn_pin ( pcie_top_0_pci_exp_5_rxn_pin ),
      .pcie_top_0_pci_exp_6_txp_pin ( pcie_top_0_pci_exp_6_txp_pin ),
      .pcie_top_0_pci_exp_6_txn_pin ( pcie_top_0_pci_exp_6_txn_pin ),
      .pcie_top_0_pci_exp_6_rxp_pin ( pcie_top_0_pci_exp_6_rxp_pin ),
      .pcie_top_0_pci_exp_6_rxn_pin ( pcie_top_0_pci_exp_6_rxn_pin ),
      .pcie_top_0_pci_exp_7_txn_pin ( pcie_top_0_pci_exp_7_txn_pin ),
      .pcie_top_0_pci_exp_7_txp_pin ( pcie_top_0_pci_exp_7_txp_pin ),
      .pcie_top_0_pci_exp_7_rxn_pin ( pcie_top_0_pci_exp_7_rxn_pin ),
      .pcie_top_0_pci_exp_7_rxp_pin ( pcie_top_0_pci_exp_7_rxp_pin ),
      .pcie_top_0_pci_exp_0_txn_pin ( pcie_top_0_pci_exp_0_txn_pin ),
      .axi_emc_0_Mem_A_pin ( axi_emc_0_Mem_A_pin ),
      .axi_emc_0_Mem_CEN_pin ( axi_emc_0_Mem_CEN_pin[0:0] ),
      .axi_emc_0_Mem_OEN_pin ( axi_emc_0_Mem_OEN_pin[0:0] ),
      .axi_emc_0_Mem_WEN_pin ( axi_emc_0_Mem_WEN_pin ),
      .axi_emc_0_Mem_DQ_pin ( axi_emc_0_Mem_DQ_pin ),
      .axi_cfg_fpga_0_GPIO_IO_pin ( axi_cfg_fpga_0_GPIO_IO_pin[0:0] )
    );

endmodule

module system
  (
    RESET,
    RS232_Uart_1_sout,
    RS232_Uart_1_sin,
    CLK,
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
    pcie_top_0_pci_exp_0_txn_pin,
    axi_emc_0_Mem_A_pin,
    axi_emc_0_Mem_CEN_pin,
    axi_emc_0_Mem_OEN_pin,
    axi_emc_0_Mem_WEN_pin,
    axi_emc_0_Mem_DQ_pin,
    axi_cfg_fpga_0_GPIO_IO_pin
  );
  input RESET;
  output RS232_Uart_1_sout;
  input RS232_Uart_1_sin;
  input CLK;
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
  output [23:0] axi_emc_0_Mem_A_pin;
  output [0:0] axi_emc_0_Mem_CEN_pin;
  output [0:0] axi_emc_0_Mem_OEN_pin;
  output axi_emc_0_Mem_WEN_pin;
  inout [31:0] axi_emc_0_Mem_DQ_pin;
  inout [0:0] axi_cfg_fpga_0_GPIO_IO_pin;
endmodule

