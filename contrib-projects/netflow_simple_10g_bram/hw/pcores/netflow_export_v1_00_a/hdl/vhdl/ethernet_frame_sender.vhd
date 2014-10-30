-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        ethernet_frame_sender.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_export
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Waits for the NetFlow, UDP, IP and Ethernet packet to be ready.
 -- *          Reads the data to be sent from a Block Ram and generates the
 -- *          AXI4-Stream transactions to the 10G core user_interface.
 -- *          Signals back when the current frame has been sent and the Block
 -- *          Ram can be re-written.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
library work;
use work.netflow_export_pack.all;

entity ethernet_frame_sender is
generic (
	C_M_AXIS_TDATA_WIDTH : integer := 64
	);
port (
	ACLK : in std_logic;
	ARESETN : in std_logic;
	M_AXIS_TDATA       : out std_logic_vector (C_M_AXIS_TDATA_WIDTH-1 downto 0);
	M_AXIS_TSTRB       : out std_logic_vector (C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
	M_AXIS_TVALID      : out std_logic;
	M_AXIS_TREADY      : in  std_logic;
	M_AXIS_TLAST       : out std_logic;
	-- Input
	send_eth_frame : in std_logic;
	numb_of_transactions : in integer range 0 to 2**RAM_ADDR_WIDTH-1;
	numb_of_bytes : in integer range 0 to MAX_LENGTH_ETH_PACKET;	-- Total # of bytes to send to the 10GMAC core
	-- Ram port
	addr : out integer range 0 to 2**RAM_ADDR_WIDTH-1;
	do : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
	-- Output
	eth_frame_transmitted : out std_logic
	);
end ethernet_frame_sender;


architecture ethernet_frame_sender_arch of ethernet_frame_sender is

	signal M_AXIS_TDATA_rev : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
	signal last_tstrb : std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
	signal rd_index : integer range 0 to 2**RAM_ADDR_WIDTH-1;
	
	type ethernet_frame_sender_fsm_type is (IDLE_STATE, SEND_FRAME, LAST_TRANS);
	signal ethernet_frame_sender_fsm : ethernet_frame_sender_fsm_type;
begin

-- Reverse the byte order in order to simplify the code 
Rev_byte_order : for L in 0 to (C_M_AXIS_TDATA_WIDTH/8-1) generate
	M_AXIS_TDATA(C_M_AXIS_TDATA_WIDTH-L*8-1 downto C_M_AXIS_TDATA_WIDTH-(L+1)*8) <= M_AXIS_TDATA_rev((L+1)*8-1 downto L*8);
end generate Rev_byte_order ;


last_tstrb_process: process(ACLK)
	variable nub_of_bytes_in_last_trans : integer range 0 to C_M_AXIS_TDATA_WIDTH/8;
begin
	if (ACLK'event and ACLK = '1') then
		if (send_eth_frame = '1') then
			nub_of_bytes_in_last_trans := numb_of_bytes mod (C_M_AXIS_TDATA_WIDTH/8);		-- shift
			if (nub_of_bytes_in_last_trans = 0) then
				last_tstrb <= (others => '1');
			else
				last_tstrb <= (others => '0');
				for L in 0 to last_tstrb'high loop
					if (L < nub_of_bytes_in_last_trans) then
						last_tstrb(L) <= '1';
					end if;
				end loop;
			end if;
		end if;
	end if;
end process last_tstrb_process;
	
addr <= rd_index;
	
ethernet_frame_sender_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			M_AXIS_TLAST <= '0';
			M_AXIS_TVALID <= '0';
			M_AXIS_TSTRB <= (others => '0');
			M_AXIS_TDATA_rev <= (others => '0');
			eth_frame_transmitted <= '0';
			rd_index <= 0;
			ethernet_frame_sender_fsm <= IDLE_STATE;
		else
			M_AXIS_TLAST <= '0';
			M_AXIS_TVALID <= '0';
			M_AXIS_TDATA_rev <= do;
			case ethernet_frame_sender_fsm is
				when IDLE_STATE =>
					eth_frame_transmitted <= '0';
					M_AXIS_TSTRB <= (others => '1');
					if (send_eth_frame = '1') then
						rd_index <= rd_index +1;
						ethernet_frame_sender_fsm <= SEND_FRAME;
					end if;
				when SEND_FRAME =>
					if (M_AXIS_TREADY = '1') then
						rd_index <= rd_index +1;
						M_AXIS_TVALID <= '1';
					end if;
					if (rd_index = numb_of_transactions) then
						ethernet_frame_sender_fsm <= LAST_TRANS;
					end if;
				when LAST_TRANS =>
					M_AXIS_TSTRB <= last_tstrb;
					rd_index <= 0;
					if (M_AXIS_TREADY = '1') then
						M_AXIS_TVALID <= '1';
						M_AXIS_TLAST <= '1';
						eth_frame_transmitted <= '1';
						ethernet_frame_sender_fsm <= IDLE_STATE;
					end if;
			end case;
		end if;
	end if;
end process ethernet_frame_sender_process;
	
	
end architecture ethernet_frame_sender_arch;
