library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library axi_ethernetlite_v1_01_b;
use axi_ethernetlite_v1_01_b.mdio_if;

entity nf7_mdio_core is
    port (
        clk                             : in    std_logic;
	mdio_clk			: in	std_logic; -- 2.5 MHz max
        rst_n                           : in    std_logic;
        din                             : in    std_logic_vector(31 downto 0);
        rdce                            : in    std_logic_vector(3 downto 0);
        wrce                            : in    std_logic_vector(3 downto 0);
        rdack                           : out   std_logic;
        wrack                           : out   std_logic;
        dout                            : out   std_logic_vector(31 downto 0);
	mdio_i				: in	std_logic;
	mdio_o				: out	std_logic;
	mdio_t				: out	std_logic;
	mdc				: out	std_logic
    );
end entity;

architecture rtl of nf7_mdio_core is

   constant REG_IDX_ADDR		: integer   := 0;
   constant REG_IDX_WR			: integer   := 1;
   constant REG_IDX_RD			: integer   := 2;
   constant REG_IDX_CTRL		: integer   := 3;

   signal addr_reg			: std_logic_vector(10 downto 0) := (others => '0');
   signal wr_reg			: std_logic_vector(15 downto 0) := (others => '0');
   signal rd_reg			: std_logic_vector(15 downto 0) := (others => '0');
   signal ctrl_reg_0			: std_logic := '0';
   signal ctrl_reg_3			: std_logic := '0';
   signal mdio_done_i     		: std_logic;
   signal mdio_clk_i         		: std_logic;
   
begin

    process (clk)
    begin

-- mdio registers
        if rising_edge (clk) then
            if (rst_n = '0') then
                rdack    <= '0';
                wrack    <= '0';
                dout     <= (others => '0');
                addr_reg <= (others => '0');
                wr_reg   <= (others => '0');
                ctrl_reg_0 <= '0';
                ctrl_reg_3 <= '0';
            else
                rdack       <= '0';
                wrack       <= '0';
		addr_reg    <= addr_reg;
		wr_reg      <= wr_reg;
		ctrl_reg_3  <= ctrl_reg_3;
		ctrl_reg_0  <= ctrl_reg_0 and not mdio_done_i; -- mdio request clear

-- register writes 
                if (wrce(REG_IDX_ADDR) = '1') then
                    wrack   <= '1';
                    addr_reg <= din(10 downto 0);

                elsif (wrce(REG_IDX_WR) = '1') then
                    wrack   <= '1';
                    wr_reg  <= din(15 downto 0);

                elsif (wrce(REG_IDX_CTRL) = '1') then
                    wrack   <= '1';
                    ctrl_reg_0  <= din(0);
                    ctrl_reg_3  <= din(3);
                end if;

-- register reads
                if (rdce(REG_IDX_ADDR) = '1') then
                    rdack   <= '1';
                    dout(31 downto 11) <= (others => '0'); 
                    dout(10 downto 0)  <= addr_reg;

                elsif (rdce(REG_IDX_WR) = '1') then
                    rdack   <= '1';
                    dout(31 downto 16) <= (others => '0'); 
                    dout(15 downto 0)  <= wr_reg;

                elsif (rdce(REG_IDX_RD) = '1') then
                    rdack   <= '1';
                    dout(31 downto 16) <= (others => '0'); 
                    dout(15 downto 0)  <= rd_reg;

                elsif (rdce(REG_IDX_CTRL) = '1') then
                    rdack   <= '1';
                    dout(31 downto 4) <= (others => '0'); 
                    dout(3 downto 0)  <= ctrl_reg_3 & "00" & ctrl_reg_0;

                else
                    dout    <= (others => '0');
                end if;

            end if;
        end if;
    end process;

-- mdio interface

      mdio_if_i: entity axi_ethernetlite_v1_01_b.mdio_if
         port map (
            Clk            => clk,
            Rst            => not rst_n,
            MDIO_CLK       => mdio_clk,
            MDIO_en        => ctrl_reg_3,
            MDIO_OP        => addr_reg(10),
            MDIO_Req       => ctrl_reg_0,
            MDIO_PHY_AD    => addr_reg(9 downto 5),
            MDIO_REG_AD    => addr_reg(4 downto 0),
            MDIO_WR_DATA   => wr_reg,
            MDIO_RD_DATA   => rd_reg,
            PHY_MDIO_I     => mdio_i,
            PHY_MDIO_O     => mdio_o,
            PHY_MDIO_T     => mdio_t,
            PHY_MDC        => mdc,
            MDIO_done      => mdio_done_i
            );
end rtl;
