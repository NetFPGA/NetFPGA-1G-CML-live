-------------------------------------------------------------------------------
-- nf10_mdio_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library nf10_mdio_v1_00_a;
use nf10_mdio_v1_00_a.all;

entity nf10_mdio_0_wrapper is
  port (
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    IP2INTC_Irpt : out std_logic;
    S_AXI_AWID : in std_logic_vector(1 downto 0);
    S_AXI_AWADDR : in std_logic_vector(31 downto 0);
    S_AXI_AWLEN : in std_logic_vector(7 downto 0);
    S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
    S_AXI_AWBURST : in std_logic_vector(1 downto 0);
    S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_AWREADY : out std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WLAST : in std_logic;
    S_AXI_WVALID : in std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BID : out std_logic_vector(1 downto 0);
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARID : in std_logic_vector(1 downto 0);
    S_AXI_ARADDR : in std_logic_vector(31 downto 0);
    S_AXI_ARLEN : in std_logic_vector(7 downto 0);
    S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
    S_AXI_ARBURST : in std_logic_vector(1 downto 0);
    S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RID : out std_logic_vector(1 downto 0);
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RLAST : out std_logic;
    S_AXI_RVALID : out std_logic;
    S_AXI_RREADY : in std_logic;
    PHY_rst_n : out std_logic;
    PHY_MDC : out std_logic;
    PHY_MDIO_I : in std_logic;
    PHY_MDIO_O : out std_logic;
    PHY_MDIO_T : out std_logic
  );
end nf10_mdio_0_wrapper;

architecture STRUCTURE of nf10_mdio_0_wrapper is

  component nf10_mdio is
    generic (
      C_FAMILY : STRING;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_S_AXI_ACLK_PERIOD_PS : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ID_WIDTH : INTEGER;
      C_INCLUDE_MDIO : INTEGER
    );
    port (
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      IP2INTC_Irpt : out std_logic;
      S_AXI_AWID : in std_logic_vector((C_S_AXI_ID_WIDTH-1) downto 0);
      S_AXI_AWADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_AWLEN : in std_logic_vector(7 downto 0);
      S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
      S_AXI_AWBURST : in std_logic_vector(1 downto 0);
      S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WLAST : in std_logic;
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BID : out std_logic_vector((C_S_AXI_ID_WIDTH-1) downto 0);
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARID : in std_logic_vector((C_S_AXI_ID_WIDTH-1) downto 0);
      S_AXI_ARADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_ARLEN : in std_logic_vector(7 downto 0);
      S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
      S_AXI_ARBURST : in std_logic_vector(1 downto 0);
      S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RID : out std_logic_vector((C_S_AXI_ID_WIDTH-1) downto 0);
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RLAST : out std_logic;
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      PHY_rst_n : out std_logic;
      PHY_MDC : out std_logic;
      PHY_MDIO_I : in std_logic;
      PHY_MDIO_O : out std_logic;
      PHY_MDIO_T : out std_logic
    );
  end component;

begin

  nf10_mdio_0 : nf10_mdio
    generic map (
      C_FAMILY => "virtex5",
      C_BASEADDR => X"7a000000",
      C_HIGHADDR => X"7a00ffff",
      C_S_AXI_ACLK_PERIOD_PS => 10000,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ID_WIDTH => 2,
      C_INCLUDE_MDIO => 1
    )
    port map (
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      IP2INTC_Irpt => IP2INTC_Irpt,
      S_AXI_AWID => S_AXI_AWID,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWLEN => S_AXI_AWLEN,
      S_AXI_AWSIZE => S_AXI_AWSIZE,
      S_AXI_AWBURST => S_AXI_AWBURST,
      S_AXI_AWCACHE => S_AXI_AWCACHE,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WLAST => S_AXI_WLAST,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BID => S_AXI_BID,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARID => S_AXI_ARID,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARLEN => S_AXI_ARLEN,
      S_AXI_ARSIZE => S_AXI_ARSIZE,
      S_AXI_ARBURST => S_AXI_ARBURST,
      S_AXI_ARCACHE => S_AXI_ARCACHE,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RID => S_AXI_RID,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RLAST => S_AXI_RLAST,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      PHY_rst_n => PHY_rst_n,
      PHY_MDC => PHY_MDC,
      PHY_MDIO_I => PHY_MDIO_I,
      PHY_MDIO_O => PHY_MDIO_O,
      PHY_MDIO_T => PHY_MDIO_T
    );

end architecture STRUCTURE;

