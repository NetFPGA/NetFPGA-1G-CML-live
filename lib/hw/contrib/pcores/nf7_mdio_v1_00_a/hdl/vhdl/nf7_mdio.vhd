library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.ipif_pkg.SLV64_ARRAY_TYPE;
use proc_common_v3_00_a.ipif_pkg.INTEGER_ARRAY_TYPE;
use proc_common_v3_00_a.ipif_pkg.calc_num_ce;

library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

library nf7_mdio_v1_00_a;
use nf7_mdio_v1_00_a.nf7_mdio_core;

entity nf7_mdio is
    generic (
        C_FAMILY                        : string            := "kintex7";
        C_S_AXI_ADDR_WIDTH              : integer           := 5;
        C_S_AXI_DATA_WIDTH              : integer range 32 to 128   := 32;
        C_NUM_PHY                       : integer range 1 to 32     := 4;
	C_BASEADDR                      : std_logic_vector(31 downto 0) := x"ffffffff";
	C_HIGHADDR                      : std_logic_vector(31 downto 0) := x"00000000";
	C_MDIO_CLK_DIV			: integer           := 100
    );
    port (
        S_AXI_ACLK                      : in    std_logic;
        S_AXI_ARESETN                   : in    std_logic;
        S_AXI_AWADDR                    : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWVALID                   : in    std_logic;
        S_AXI_AWREADY                   : out   std_logic;
        S_AXI_WDATA                     : in    std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB                     : in    std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID                    : in    std_logic;
        S_AXI_WREADY                    : out   std_logic;
        S_AXI_BRESP                     : out   std_logic_vector(1 downto 0);
        S_AXI_BVALID                    : out   std_logic;
        S_AXI_BREADY                    : in    std_logic;
        S_AXI_ARADDR                    : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARVALID                   : in    std_logic;
        S_AXI_ARREADY                   : out   std_logic;
        S_AXI_RDATA                     : out   std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP                     : out   std_logic_vector(1 downto 0);
        S_AXI_RVALID                    : out   std_logic;
        S_AXI_RREADY                    : in    std_logic;

	gtx_clk				: in    std_logic; -- need a consistent 125 MHz clock for phy_rstn
	mdio_clk			: in	std_logic;
	mdio				: inout	std_logic;	
	mdc				: out	std_logic;
	phy_rstn			: out   std_logic_vector(C_NUM_PHY - 1 downto 0)
    );
end entity;

architecture rtl of nf7_mdio is

    constant ZEROS                      : std_logic_vector(31 downto 0) := (others => '0');
    constant ONES                       : std_logic_vector(31 downto 0) := (others => '1');
    constant C_S_AXI_MIN_SIZE           : std_logic_vector(31 downto 0) := x"0000001f";
    constant C_USE_WSTRB                : integer := 0;
    constant C_DPHASE_TIMEOUT           : integer := 8;
    constant C_ARD_ADDR_RANGE_ARRAY     : SLV64_ARRAY_TYPE := (
        ZEROS & x"00000000",
        ZEROS & x"0000001f"
    );
    constant C_ARD_NUM_CE_ARRAY         : INTEGER_ARRAY_TYPE := (
        0 => 4
    );
    constant C_PHY_RESET_COUNT		: integer := 4194304; -- 2^22

    signal bus2ip_clk                   : std_logic;
    signal bus2ip_reset                 : std_logic;
    signal bus2ip_resetn                : std_logic;
    signal ip2bus_data                  : std_logic_vector((C_S_AXI_DATA_WIDTH-1)  downto 0):= (others  => '0');
    signal ip2bus_error                 : std_logic := '0';
    signal ip2bus_wrack                 : std_logic := '0';
    signal ip2bus_rdack                 : std_logic := '0';
    signal bus2ip_data                  : std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
    signal bus2ip_rdce                  : std_logic_vector(calc_num_ce(C_ARD_NUM_CE_ARRAY)-1 downto 0);
    signal bus2ip_wrce                  : std_logic_vector(calc_num_ce(C_ARD_NUM_CE_ARRAY)-1 downto 0);

    signal mdio_clk_cnt                 : integer;
    signal mdio_clk_i                   : std_logic;
    signal mdio_o                       : std_logic;
    signal mdio_i                       : std_logic;
    signal mdio_t                       : std_logic;
    signal phy_reset_count		: integer;

    component IOBUF
       port
       (
	I  : in    std_logic;
	IO : inout std_logic;
	O  : out   std_logic;
	T  : in    std_logic
       );
     end component;

begin

    axi_ipif_i : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
    generic map (
        C_S_AXI_DATA_WIDTH              => C_S_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH              => C_S_AXI_ADDR_WIDTH,
        C_S_AXI_MIN_SIZE                => C_S_AXI_MIN_SIZE,
        C_USE_WSTRB                     => C_USE_WSTRB,
        C_DPHASE_TIMEOUT                => C_DPHASE_TIMEOUT,
        C_ARD_ADDR_RANGE_ARRAY          => C_ARD_ADDR_RANGE_ARRAY,
        C_ARD_NUM_CE_ARRAY              => C_ARD_NUM_CE_ARRAY,
        C_FAMILY                        => C_FAMILY
    )
    port map (
        --System signals
        S_AXI_ACLK                      => S_AXI_ACLK,
        S_AXI_ARESETN                   => S_AXI_ARESETN,
        S_AXI_AWADDR                    => S_AXI_AWADDR,
        S_AXI_AWVALID                   => S_AXI_AWVALID,
        S_AXI_AWREADY                   => S_AXI_AWREADY,
        S_AXI_WDATA                     => S_AXI_WDATA,
        S_AXI_WSTRB                     => S_AXI_WSTRB,
        S_AXI_WVALID                    => S_AXI_WVALID,
        S_AXI_WREADY                    => S_AXI_WREADY,
        S_AXI_BRESP                     => S_AXI_BRESP,
        S_AXI_BVALID                    => S_AXI_BVALID,
        S_AXI_BREADY                    => S_AXI_BREADY,
        S_AXI_ARADDR                    => S_AXI_ARADDR,
        S_AXI_ARVALID                   => S_AXI_ARVALID,
        S_AXI_ARREADY                   => S_AXI_ARREADY,
        S_AXI_RDATA                     => S_AXI_RDATA,
        S_AXI_RRESP                     => S_AXI_RRESP,
        S_AXI_RVALID                    => S_AXI_RVALID,
        S_AXI_RREADY                    => S_AXI_RREADY,
        -- Controls to the IP/IPIF modules
        Bus2IP_Clk                      => bus2ip_clk,
        Bus2IP_Resetn                   => bus2ip_resetn,
        Bus2IP_Addr                     => open,
        Bus2IP_RNW                      => open,
        Bus2IP_BE                       => open,
        Bus2IP_CS                       => open,
        Bus2IP_RdCE                     => bus2ip_rdce,
        Bus2IP_WrCE                     => bus2ip_wrce,
        Bus2IP_Data                     => bus2ip_data,
        IP2Bus_Data                     => ip2bus_data,
        IP2Bus_WrAck                    => ip2bus_wrack,
        IP2Bus_RdAck                    => ip2bus_rdack,
        IP2Bus_Error                    => ip2bus_error
    );

    DEFAULT_DATA_GEN : if (C_S_AXI_DATA_WIDTH /= 32) generate
        ip2bus_data(C_S_AXI_DATA_WIDTH - 1 downto 32)   <= (others => '0');
    end generate;

    mdio_clk_divider : process (mdio_clk)
       begin
          if rising_edge(mdio_clk) then
          if (bus2ip_resetn = '0') then
             mdio_clk_cnt <= C_MDIO_CLK_DIV;
             mdio_clk_i <= '0';
          elsif (mdio_clk_cnt = 0) then
             mdio_clk_cnt <= C_MDIO_CLK_DIV;
             mdio_clk_i <= not mdio_clk_i;
          else
             mdio_clk_cnt <= mdio_clk_cnt - 1;   
          end if; 
       end if;
    end process;

    mdio_iobuf : IOBUF
    port map (
              I  => mdio_o,
              IO => mdio,
              O  => mdio_i,
              T  => mdio_t
             );

    nf7_mdio_core_i : entity nf7_mdio_v1_00_a.nf7_mdio_core 
    port map (
        clk                             => bus2ip_clk,
        rst_n                           => bus2ip_resetn,
        din                             => bus2ip_data(31 downto 0),
        rdce                            => bus2ip_rdce,
        wrce                            => bus2ip_wrce,
        rdack                           => ip2bus_rdack,
        wrack                           => ip2bus_wrack,
        dout                            => ip2bus_data(31 downto 0),

	mdio_clk			=> mdio_clk_i,
	mdio_i				=> mdio_i,
	mdio_o				=> mdio_o,
	mdio_t				=> mdio_t,
	mdc				=> mdc
    );

    -- using a C_PHY_RESET_COUNT that provides a 33 mS reset 
    -- with a 125 MHz gtx clock for the Realtek RTL8211 PHY
    phy_reset : process (gtx_clk)
       begin
       if rising_edge(gtx_clk) then
          if (bus2ip_resetn = '0') then
             phy_reset_count <= C_PHY_RESET_COUNT;
             phy_rstn <= ZEROS(C_NUM_PHY - 1 downto 0);
          elsif (phy_reset_count = 0) then
             phy_rstn <= ONES(C_NUM_PHY - 1 downto 0);
          else
             phy_reset_count <= phy_reset_count - 1;   
          end if; 
       end if;
    end process;

end rtl;
