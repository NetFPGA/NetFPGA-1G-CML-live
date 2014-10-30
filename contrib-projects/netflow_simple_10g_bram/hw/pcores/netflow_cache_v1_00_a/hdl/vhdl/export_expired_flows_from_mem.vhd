-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        export_expired_flows_from_mem.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *        This module checks if a flow has expired, removes it from
 -- *        the flow-table and writes it on a FIFO.
 -- *        A flow expires if:
 -- *         - It is inactive, i.e. time since the last
 -- *           packet matched the flow-entry > INACTIVE_TIMEOUT constant
 -- *         - It has been active for too long i.e. time since
 -- *           flow-entry creation > ACTIVE_TIMEOUT constant
 -- *         - If a TCP connection finishes (FIN or RST flag = '1')
 -- *        These conditions are described in the:
 -- *         NetFlow Services Solutions Guide. Technical report, 2007.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.netflow_cache_pack.all;

entity export_expired_flows_from_mem is
--generic (
----
--  );
port (
	ACLK  : in  std_logic;
	ARESETN  : in  std_logic;
	ACTIVE_TIMEOUT : in std_logic_vector(timestamp_WIDTH-1 downto 0);
	InACTIVE_TIMEOUT : in std_logic_vector(timestamp_WIDTH-1 downto 0);
	-- RAM SIGNALS PORTB
	enb : out std_logic;
	web : out std_logic;
	addrb : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	dob : in std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	dib : out std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	--Export accelerator
	export_now : in std_logic;
	export_this : in std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	timestamp_counter : in std_logic_vector(timestamp_WIDTH-1 downto 0);
	flow_exported_ok : out std_logic;
	-- flow output fifo
	fifo_exp_rst : out std_logic;
	fifo_w_exp_en : out std_logic;
	fifo_in_exp : out std_logic_vector(FIFO_DATA_WIDTH-1 downto 0);
	fifo_full_exp : in std_logic
  );

end export_expired_flows_from_mem;


architecture export_expired_flows_from_mem_arch of export_expired_flows_from_mem is

	type export_flows_fsm_type is (s0,READ_STATE,REGISTER_STATE,WR_ON_FIFO,CHK_CONDITION_STATE);
	signal export_flows_fsm : export_flows_fsm_type;

	signal linear_counter :  std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	signal reg_dob : std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	
	attribute keep : string;			-- This attribute are used for timining issues
	attribute keep of dob : signal is "TRUE";
	attribute keep of reg_dob : signal is "TRUE";


begin

dib <= (others => '0');	-- When a flow expires it is removed (flow-entry <= all_zeros)

-- Memory organization: Entry_status - 5-tuple - tcp_flags - Initial_timestamp - Last_timestamp - frame_counter - byte_counter


control_process: process(ACLK)
	variable protocol : std_logic_vector(8-1 downto 0);
	variable rst_fin_flags : std_logic;
	variable initial_timestamp : std_logic_vector(32-1 downto 0);
	variable last_timestamp : std_logic_vector(32-1 downto 0);
	variable export_immediately : std_logic;
begin
	if (ACLK'event and ACLK = '1') then
		enb <= '0';
		web <= '0';
		flow_exported_ok <= '0';
		fifo_exp_rst <= '0';
		fifo_w_exp_en <= '0';
		if (ARESETN = '0') then
			addrb <= (others => '0');
			linear_counter <= (others => '0');
			fifo_exp_rst <= '1';
			export_flows_fsm <= s0;
		else
			case export_flows_fsm is
				when s0 =>
					enb <= '1';			-- Always perform a read operation
					export_immediately := '0';
					if (export_now = '1') then 
						flow_exported_ok <= '1';
						addrb <= export_this;	-- Address from the Export accelerator mechanism
						export_immediately := '1';
					else
						addrb <= linear_counter; -- Read the flow table sequentially (using linear_counter)
					end if;
					export_flows_fsm <= READ_STATE;
				when READ_STATE =>
					export_flows_fsm <= REGISTER_STATE; -- wait 1 tick for the data out
				when REGISTER_STATE =>
					reg_dob <= dob;
					if (export_immediately = '1') then
						export_flows_fsm <= WR_ON_FIFO;
					else
						export_flows_fsm <= CHK_CONDITION_STATE;
					end if;
				when WR_ON_FIFO =>
					fifo_in_exp <= reg_dob(MEM_DATA_WIDTH-2 downto 0);	-- minus 2 because we don't export the ram entry status, because is always one :)
					if (fifo_full_exp = '0') then
						fifo_w_exp_en <= '1';
						enb <= '1';
						web <= '1';
						export_flows_fsm <= s0;
					end if;
				when CHK_CONDITION_STATE =>
					protocol := reg_dob(136+7 downto 136);
					rst_fin_flags := reg_dob(128) or reg_dob(130);
					initial_timestamp := reg_dob(128-1 downto 96);
					last_timestamp := reg_dob(96-1 downto 64);
					if (reg_dob(MEM_ENTRY_STATUS_INDEX) = '1') then
						if (protocol = TCP and rst_fin_flags = '1') then
							export_flows_fsm <= WR_ON_FIFO;                          -- TCP connection finished. In case the export accelerator mechanism was not seen 
						elsif((timestamp_counter - initial_timestamp) >= ACTIVE_TIMEOUT) then
							export_flows_fsm <= WR_ON_FIFO;  						-- Flow expires because it has been active for too long (to avoid registers overflow, according to: NetFlow Services Solutions Guide)
						elsif((timestamp_counter - last_timestamp) >= InACTIVE_TIMEOUT) then  
							export_flows_fsm <= WR_ON_FIFO;							 -- Flow expires because it has been inactive for too long (according to: NetFlow Services Solutions Guide)
						else
							linear_counter <= linear_counter +1;
							export_flows_fsm <= s0;
						end if;
					else
						linear_counter <= linear_counter +1;
						export_flows_fsm <= s0;
					end if;
				when others =>
			end case;
		end if;
	end if;
end process;

end architecture export_expired_flows_from_mem_arch;
