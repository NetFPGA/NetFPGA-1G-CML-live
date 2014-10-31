-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        create_or_update_flows.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_cache
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *        This module checks if the flow exists. In that case it updates the flow-entry.
 -- *        Otherwise it creates a new flow-entry.
 -- *        If a TCP connection finishes (FIN or RST flag = '1') it indicates
 -- *        the export module to remove the flow-entry
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.netflow_cache_pack.all;

entity create_or_update_flows is
--generic (
----
--  ); 
port (
	ACLK  : in  std_logic;
	ARESETN  : in  std_logic;
	-- 5-tuple receive interface
	frame_five_tuple    : in   std_logic_vector(FIVE_TUPLE_WIDTH-1 downto 0);
	pkt_info    : in   std_logic_vector(PKT_INFO_WIDTH-1 downto 0);
	tuple_and_info_valid : in  std_logic;
	--RAM SIGNALS PORT_A
	ena : out std_logic;
	wea : out std_logic;
	hash_code_out : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	doa : in std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	dia : out std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	--Export accelerator
	export_now : out std_logic;
	export_this : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	flow_exported_ok : in std_logic;
	-- Output counter
	collision_counter : out std_logic_vector(32-1 downto 0)
	);

end create_or_update_flows;


architecture create_or_update_flows_arch of create_or_update_flows is

	-- Hash function component declaration
	component hash_function is
	generic (  
		INPUT_WIDTH : natural := FIVE_TUPLE_WIDTH;
		OUTPUT_WIDTH : natural := MEM_ADDR_WIDTH);
	port (
		hash_input  : in std_logic_vector(INPUT_WIDTH-1 downto 0);      
		hash_output : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)       
	);
	end component;
	
	-- Process's signals
	type create_update_fsm_type is (IDLE, REGISTER_STATE, READ_STATE, FLOW_LOOKUP_STATE, CREATE_FLOW, UPDATE_FLOW, COLLISION_PRESENT);
	signal create_update_fsm : create_update_fsm_type;

	-- Hash function's signals
	signal frame_five_tuple_reg : std_logic_vector(FIVE_TUPLE_WIDTH-1 downto 0);
	signal hash_code : std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);

	-- Input frame's signals
	signal frame_ip_total_length : std_logic_vector(IP_TOTAL_LENGTH_FIELD_WIDTH-1 downto 0);
	signal frame_timestamp : std_logic_vector(timestamp_WIDTH-1 downto 0);
	signal frame_tcp_flags : std_logic_vector(TCP_FLAGS_WIDTH-1 downto 0);
	
	-- Flow-entry's signals
	signal flow_pkt_counter: std_logic_vector(FRAME_COUNTER_WIDTH-1 downto 0);
	signal flow_byte_counter: std_logic_vector(BYTE_COUNTER_WIDTH-1 downto 0);
	signal flow_tcp_flags : std_logic_vector(TCP_FLAGS_WIDTH-1 downto 0);
	signal flow_initial_timestamp : std_logic_vector(timestamp_WIDTH-1 downto 0);
	signal flow_last_timestamp : std_logic_vector(timestamp_WIDTH-1 downto 0);

	--RAM SIGNALS PORTA
	signal reg_doa : std_logic_vector(MEM_DATA_WIDTH-1 downto 0);
	
	-- Others signals
	signal collision_counter_int : std_logic_vector(31 downto 0);

begin

collision_counter <= collision_counter_int;
hash_code_out <= hash_code;

create_or_update_flow: process(ACLK)
	variable flow_5_tuple : std_logic_vector(FIVE_TUPLE_WIDTH-1 downto 0);
	variable protocol : std_logic_vector(8-1 downto 0);
	variable fin_rst_flags : std_logic;
begin
	if (ACLK'event and ACLK = '1') then
		ena <= '0';
		wea <= '0';
		if (ARESETN = '0') then
			create_update_fsm <= IDLE;
			collision_counter_int <= (others => '0');
			export_now <= '0';
		else
			case create_update_fsm is
				when IDLE =>
					frame_five_tuple_reg <= frame_five_tuple;
					frame_ip_total_length <= pkt_info(16-1 downto 0);
					frame_timestamp <= pkt_info(48-1 downto 16);
					frame_tcp_flags <= pkt_info(56-1 downto 48);
					if (tuple_and_info_valid = '1') then     --the receiver machine've just receive a 5-tuple
						ena <= '1';                            --the address is on the port A address, in the next clk tick after ena = 1 is captured the memory's data'll appear on the doa
						create_update_fsm <= READ_STATE;
					end if;
				when READ_STATE =>
					create_update_fsm <= REGISTER_STATE;     -- Bram captured the "read enable" in this state, wait for the next tick to get the data
				when REGISTER_STATE =>
					reg_doa <= doa;		-- Register memory's output
					create_update_fsm <= FLOW_LOOKUP_STATE;
				when FLOW_LOOKUP_STATE =>
					flow_byte_counter <= reg_doa(32-1 downto 0) + frame_ip_total_length;
					flow_pkt_counter <= reg_doa(64-1 downto 32) + 1;
					flow_initial_timestamp <= reg_doa(128-1 downto 96);
					flow_tcp_flags <= reg_doa(136-1 downto 128) or frame_tcp_flags;
					flow_5_tuple := reg_doa(240-1 downto 136);
					if (reg_doa(MEM_ENTRY_STATUS_INDEX) = '1') then --if it's '1', then it has a flow on it
						if (flow_5_tuple /= frame_five_tuple_reg ) then     --check if no collision is present
							create_update_fsm <= COLLISION_PRESENT;                  -- collision
						else
							create_update_fsm <= UPDATE_FLOW;            -- frame 5-tuple matched flow-entry 5-tuple
						end if;
					else --No flow on memory
						create_update_fsm <= CREATE_FLOW;               -- create_flow
					end if;
					protocol := frame_five_tuple_reg(8-1 downto 0);
					fin_rst_flags := frame_tcp_flags(0) or frame_tcp_flags(2);
				when UPDATE_FLOW =>                                  -- update_flow
					-- Write back the updated flow-entry to memory
					ena <= '1';
					wea <= '1';
					dia <= '1' & frame_five_tuple_reg & flow_tcp_flags & flow_initial_timestamp & frame_timestamp & flow_pkt_counter & flow_byte_counter;
					-- Indicate to the export module that the flow is expired
					if (protocol = TCP and fin_rst_flags = '1') then
						export_now <= '1';
						export_this <= hash_code;
					end if;
					create_update_fsm <= IDLE;
				when CREATE_FLOW =>                                  -- create_flow
					ena <= '1';
					wea <= '1';
					dia <= '1' & frame_five_tuple_reg & frame_tcp_flags & frame_timestamp & frame_timestamp & conv_std_logic_vector(1,FRAME_COUNTER_WIDTH) & (x"0000" & frame_ip_total_length);
					if (protocol = TCP and fin_rst_flags = '1') then --condition to export (end of flow)
						export_now <= '1';
						export_this <= hash_code;
					end if;
					create_update_fsm <= IDLE;
				when COLLISION_PRESENT =>                              -- collision
					collision_counter_int <= collision_counter_int +1;
					create_update_fsm <= IDLE;
				when others =>
					create_update_fsm <= IDLE;
			end case;
			-- export_flow_now seen
			if (flow_exported_ok = '1') then
				export_now <= '0';
			end if;
		end if;
	end if;
end process create_or_update_flow;

------------------------------------------------------
-- Components instantiations
	hash_function_inst: hash_function
	generic map(  
		INPUT_WIDTH => FIVE_TUPLE_WIDTH,
		OUTPUT_WIDTH => MEM_ADDR_WIDTH)
	port map(
		hash_input => frame_five_tuple_reg,
		hash_output => hash_code);
------------------------------------------------------


end architecture create_or_update_flows_arch;
