-------------------------------------------------------------------------------
-- nf10_axi_sim_transactor_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library nf10_axi_sim_transactor_v1_00_a;
use nf10_axi_sim_transactor_v1_00_a.all;

entity nf10_axi_sim_transactor_0_wrapper is
  port (
    M_AXI_ACLK : in std_logic;
    M_AXI_ARESETN : in std_logic;
    M_AXI_AWADDR : out std_logic_vector(31 downto 0);
    M_AXI_AWVALID : out std_logic;
    M_AXI_AWREADY : in std_logic;
    M_AXI_WDATA : out std_logic_vector(31 downto 0);
    M_AXI_WSTRB : out std_logic_vector(3 downto 0);
    M_AXI_WVALID : out std_logic;
    M_AXI_WREADY : in std_logic;
    M_AXI_BRESP : in std_logic_vector(1 downto 0);
    M_AXI_BVALID : in std_logic;
    M_AXI_BREADY : out std_logic;
    M_AXI_ARADDR : out std_logic_vector(31 downto 0);
    M_AXI_ARVALID : out std_logic;
    M_AXI_ARREADY : in std_logic;
    M_AXI_RDATA : in std_logic_vector(31 downto 0);
    M_AXI_RRESP : in std_logic_vector(1 downto 0);
    M_AXI_RVALID : in std_logic;
    M_AXI_RREADY : out std_logic
  );
end nf10_axi_sim_transactor_0_wrapper;

architecture STRUCTURE of nf10_axi_sim_transactor_0_wrapper is

  component nf10_axi_sim_transactor is
    generic (
      stim_file : STRING;
      log_file : STRING
    );
    port (
      M_AXI_ACLK : in std_logic;
      M_AXI_ARESETN : in std_logic;
      M_AXI_AWADDR : out std_logic_vector(31 downto 0);
      M_AXI_AWVALID : out std_logic;
      M_AXI_AWREADY : in std_logic;
      M_AXI_WDATA : out std_logic_vector(31 downto 0);
      M_AXI_WSTRB : out std_logic_vector(3 downto 0);
      M_AXI_WVALID : out std_logic;
      M_AXI_WREADY : in std_logic;
      M_AXI_BRESP : in std_logic_vector(1 downto 0);
      M_AXI_BVALID : in std_logic;
      M_AXI_BREADY : out std_logic;
      M_AXI_ARADDR : out std_logic_vector(31 downto 0);
      M_AXI_ARVALID : out std_logic;
      M_AXI_ARREADY : in std_logic;
      M_AXI_RDATA : in std_logic_vector(31 downto 0);
      M_AXI_RRESP : in std_logic_vector(1 downto 0);
      M_AXI_RVALID : in std_logic;
      M_AXI_RREADY : out std_logic
    );
  end component;

begin

  nf10_axi_sim_transactor_0 : nf10_axi_sim_transactor
    generic map (
      stim_file => "../../reg_stim.axi",
      log_file => "../../reg_stim.log"
    )
    port map (
      M_AXI_ACLK => M_AXI_ACLK,
      M_AXI_ARESETN => M_AXI_ARESETN,
      M_AXI_AWADDR => M_AXI_AWADDR,
      M_AXI_AWVALID => M_AXI_AWVALID,
      M_AXI_AWREADY => M_AXI_AWREADY,
      M_AXI_WDATA => M_AXI_WDATA,
      M_AXI_WSTRB => M_AXI_WSTRB,
      M_AXI_WVALID => M_AXI_WVALID,
      M_AXI_WREADY => M_AXI_WREADY,
      M_AXI_BRESP => M_AXI_BRESP,
      M_AXI_BVALID => M_AXI_BVALID,
      M_AXI_BREADY => M_AXI_BREADY,
      M_AXI_ARADDR => M_AXI_ARADDR,
      M_AXI_ARVALID => M_AXI_ARVALID,
      M_AXI_ARREADY => M_AXI_ARREADY,
      M_AXI_RDATA => M_AXI_RDATA,
      M_AXI_RRESP => M_AXI_RRESP,
      M_AXI_RVALID => M_AXI_RVALID,
      M_AXI_RREADY => M_AXI_RREADY
    );

end architecture STRUCTURE;

