-- ******************************************************************************
 -- *  Design:
 -- *        NetFlow_Simple_10G_Bram
 -- *  
 -- *  NetFPGA-10G http://www.netfpga.org
 -- *
 -- *  File:
 -- *        flow_encoding.vhd
 -- *
 -- *  Pcore:
 -- *        netflow_export
 -- *
 -- *  Authors:
 -- *        Marco Forconesi, Gustavo Sutter, Sergio Lopez-Buedo
 -- *
 -- *  Description:
 -- *          Receives expired flows from netflow_cache Pcore.
 -- *          Writes the received flows on a FIFO.
 -- *          Encodes up to N expired flows (For NetFlow v5 N = 30).
 -- *          Calculates the partial UDP checksum while the data is arriving.
 -- *          Signals when the NetFlow payload is ready to be sent.
 -- *          If N is not reached within 60 seconds (defined in NetFlow v5
 -- *          specification) this module sends the flows anyway.
-- ******************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.netflow_export_pack.all;

entity flow_encoding is
generic (
	C_S_AXIS_EXP_RECORDS_DATA_WIDTH : integer := 64;
	ACLK_FREQ : integer := 200000000;
	SIM_ONLY : integer := 0;
	ENCODING_TIMEOUT_IN_SECS : integer := 60
	);
port(
	ACLK : in std_logic;
	ARESETN : in std_logic;
	-- Exported flows receive interface
	S_AXIS_EXP_RECORDS_TDATA : in std_logic_vector(C_S_AXIS_EXP_RECORDS_DATA_WIDTH-1 downto 0);
	S_AXIS_EXP_RECORDS_TSTRB : in std_logic_vector(C_S_AXIS_EXP_RECORDS_DATA_WIDTH/8-1 downto 0);
	S_AXIS_EXP_RECORDS_TVALID : in std_logic;
	S_AXIS_EXP_RECORDS_TREADY : out std_logic;
	S_AXIS_EXP_RECORDS_TLAST : in std_logic;
	-- Output
	flow_encoding_ready :  out std_logic;
	flow_encoding_ready_ack : in std_logic;
	numb_of_records_out : out natural range 0 to MAX_NUMB_OF_FLOWS_PER_PACKET;
	udp_partial_checksum_out : out std_logic_vector(32-1 downto 0);
	-- Input FIFO's signals
	fifo_rst :  out std_logic;
	fifo_w_en :  out std_logic;
	fifo_full : in std_logic;
	fifo_din : out std_logic_vector(FIFO_DATA_WIDTH-1 downto 0)
	);
end flow_encoding;

architecture flow_encoding_arch of flow_encoding is

	constant ONE_HZ_MAX_COUNT : natural := ACLK_FREQ;
	
	-- Encoding_control_process's signals
	signal reset_counters : std_logic;
	type encoding_control_fsm_type is (RECV_RECORDS, DELIVER_BUNDLE_OF_RECORDS);
	signal encoding_control_fsm : encoding_control_fsm_type;
	
	-- Records_receiver_process's signals
	signal numb_of_records : natural range 0 to MAX_NUMB_OF_FLOWS_PER_PACKET;
	type flow_receiver_fsm_type is (s0, s1, s2, s3, s4, s5);
	signal flow_receiver_fsm : flow_receiver_fsm_type;
	signal rcv_flow_record : flow_record_type;
	signal new_flow : std_logic;
	signal flow_on_fifo_ack : std_logic;
	signal udp_chk_sum_int_ready_ack : std_logic;
	
	-- Time_counter_process's signals
	signal time_counter : natural range 0 to 255;
	signal divisor : natural  range 0 to ONE_HZ_MAX_COUNT;
	signal max_count : natural range 0 to ONE_HZ_MAX_COUNT;
	
	-- write_to_fifo's signals
	signal flow_on_fifo : std_logic;
	type wr_to_fifo_fsm_type is (s0, s1,s2);
	signal wr_to_fifo_fsm : wr_to_fifo_fsm_type;
	signal flow_on_one_std_logic_vector : std_logic_vector(NETFLOW_V5_RECORD_LENGTH*8-1 downto 0);
	

	-- UDP checksum calculation
	type chk_sum_fsm_type is (s0,s1,s2);
	signal chk_sum_fsm : chk_sum_fsm_type;
	signal udp_partial_checksum : std_logic_vector(32-1 downto 0);
	signal udp_chk_sum_int : std_logic_vector(32-1 downto 0);
	constant numb_of_addend : natural := NETFLOW_V5_RECORD_LENGTH*8/16; -- total # of 16-bits chunks to be added
	signal udp_chk_sum_int_ready : std_logic;
	
	
begin

max_count <= ONE_HZ_MAX_COUNT when (SIM_ONLY = 0) else ONE_HZ_MAX_COUNT/10000000;

time_counter_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then                    
			time_counter <= 0;
			divisor <= 0;
		else
			divisor <= divisor +1;
			if (reset_counters = '1' or numb_of_records = 0) then
				time_counter <= 0;
				divisor <= 0;
			elsif (new_flow = '1') then
				time_counter <= 0;
				divisor <= 0;
			elsif (divisor = max_count) then
				divisor <= 0;
				time_counter <= time_counter +1;
			end if;
		end if;	
	end if;	
end process time_counter_process; 

encoding_control_process: process(ACLK)
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			reset_counters <= '1';
			flow_encoding_ready <= '0';
			encoding_control_fsm <= RECV_RECORDS;
		else
			case encoding_control_fsm is
				when RECV_RECORDS =>
					if ( (numb_of_records = MAX_NUMB_OF_FLOWS_PER_PACKET) or (numb_of_records > 0 and time_counter >= ENCODING_TIMEOUT_IN_SECS ) ) then
						reset_counters <= '1';
						udp_partial_checksum_out <= udp_partial_checksum;
						numb_of_records_out <= numb_of_records;
						flow_encoding_ready <= '1';
						encoding_control_fsm <= DELIVER_BUNDLE_OF_RECORDS;
					else
						reset_counters <= '0';
					end if;
				when DELIVER_BUNDLE_OF_RECORDS =>
					if (flow_encoding_ready_ack = '1') then
						flow_encoding_ready <= '0';
						encoding_control_fsm <= RECV_RECORDS;
					end if;
			end case;
		end if;
	end if;
end process encoding_control_process;
	
records_receiver_process: process(ACLK)
	variable task2_ready : std_logic;
	variable task1_ready : std_logic;
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			numb_of_records <= 0;
			udp_partial_checksum <= (others => '0');
			new_flow <= '0';
			S_AXIS_EXP_RECORDS_TREADY <= '0';
			flow_on_fifo_ack <= '0';
			udp_chk_sum_int_ready_ack <= '0';
			task2_ready := '0';
			task1_ready := '0';
			flow_receiver_fsm <= s0;
		else					
			case flow_receiver_fsm is
				when s0 =>
					S_AXIS_EXP_RECORDS_TREADY <= '1';
					rcv_flow_record.byte_counter <= S_AXIS_EXP_RECORDS_TDATA(32-1 downto 0);
					rcv_flow_record.frame_counter <= S_AXIS_EXP_RECORDS_TDATA(64-1 downto 32);
					if (reset_counters = '1') then
						numb_of_records <= 0;
						udp_partial_checksum <= (others => '0');
						S_AXIS_EXP_RECORDS_TREADY <= '0';
					elsif (S_AXIS_EXP_RECORDS_TVALID = '1') then
						flow_receiver_fsm <= s1;
					end if;
				when s1 =>
					rcv_flow_record.last_time_stamp <= S_AXIS_EXP_RECORDS_TDATA(32-1 downto 0);
					rcv_flow_record.initial_time_stamp <= S_AXIS_EXP_RECORDS_TDATA(64-1 downto 32);
					if (S_AXIS_EXP_RECORDS_TVALID = '1') then
						flow_receiver_fsm <= s2;
					end if;
				when s2 =>
					rcv_flow_record.tcp_flags <= S_AXIS_EXP_RECORDS_TDATA(8-1 downto 0);
					rcv_flow_record.protocol <= S_AXIS_EXP_RECORDS_TDATA(16-1 downto 8);
					rcv_flow_record.dest_port <= S_AXIS_EXP_RECORDS_TDATA(32-1 downto 16);
					rcv_flow_record.src_port <= S_AXIS_EXP_RECORDS_TDATA(48-1 downto 32);
					rcv_flow_record.dest_ip(16-1 downto 0) <= S_AXIS_EXP_RECORDS_TDATA(64-1 downto 48);					if (S_AXIS_EXP_RECORDS_TVALID = '1') then
						flow_receiver_fsm <= s3;
					end if;
				when s3 =>
					rcv_flow_record.dest_ip(32-1 downto 16) <= S_AXIS_EXP_RECORDS_TDATA(16-1 downto 0);
					rcv_flow_record.src_ip <= S_AXIS_EXP_RECORDS_TDATA(48-1 downto 16);
					if (S_AXIS_EXP_RECORDS_TVALID = '1' and S_AXIS_EXP_RECORDS_TLAST = '1') then
						new_flow <= '1';
						S_AXIS_EXP_RECORDS_TREADY <= '0';
						flow_receiver_fsm <= s4;
					end if;
				when s4 =>
					new_flow <= '0';
					if (flow_on_fifo = '1') then
						task1_ready := '1';
					end if;
					if (udp_chk_sum_int_ready = '1') then
						task2_ready := '1';
					end if;
					if (task1_ready = '1' and task2_ready = '1') then
						flow_on_fifo_ack <= '1';
						udp_chk_sum_int_ready_ack <= '1';			
						numb_of_records <= numb_of_records +1;
						udp_partial_checksum <= std_logic_vector(unsigned(udp_partial_checksum) + unsigned(udp_chk_sum_int));
						flow_receiver_fsm <= s5;
					end if;
				when s5 =>		-- Process encoding_control_process captures the numb_of_records and takes an action
					flow_on_fifo_ack <= '0';
					udp_chk_sum_int_ready_ack <= '0';
					task1_ready := '0';
					task2_ready := '0';
					flow_receiver_fsm <= s0;
			end case;
		end if;
	end if;
end process records_receiver_process;


flow_on_one_std_logic_vector <= rcv_flow_record.src_ip & rcv_flow_record.dest_ip & zeros(60-1 downto 0) & x"1" & rcv_flow_record.frame_counter
															& rcv_flow_record.byte_counter & rcv_flow_record.initial_time_stamp & rcv_flow_record.last_time_stamp
															& rcv_flow_record.src_port & rcv_flow_record.dest_port & x"01" & rcv_flow_record.tcp_flags & rcv_flow_record.protocol & zeros(72-1 downto 0);

write_to_fifo: process(ACLK)
	variable vector_index : natural range 0 to NETFLOW_V5_RECORD_LENGTH*8;
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			vector_index := 0;
			flow_on_fifo <= '0';
			fifo_rst <= '1';
			fifo_w_en <= '0';
			wr_to_fifo_fsm <= s0;
		else
			fifo_rst <= '0';
			fifo_w_en <= '0';
			case wr_to_fifo_fsm is
				when s0 =>
					if (new_flow = '1') then
						wr_to_fifo_fsm <= s1;
					end if;
				when s1 =>
					fifo_w_en <= '1';
					fifo_din <= flow_on_one_std_logic_vector((NETFLOW_V5_RECORD_LENGTH*8-vector_index)-1 downto (NETFLOW_V5_RECORD_LENGTH*8-vector_index-FIFO_DATA_WIDTH));
					-- FSM control code
					vector_index := vector_index + FIFO_DATA_WIDTH;
					if (vector_index = NETFLOW_V5_RECORD_LENGTH*8) then
						flow_on_fifo <= '1';
						wr_to_fifo_fsm <= s2;
					end if;
				when s2 =>
					vector_index := 0;
					if (flow_on_fifo_ack = '1') then
						flow_on_fifo <= '0';
						wr_to_fifo_fsm <= s0;
					end if;
			end case;
		end if;
	end if;
end process write_to_fifo;

udp_chk_sum: process(ACLK)
	variable L : natural range 0 to numb_of_addend;
	variable check_sum_aux_vector : std_logic_vector(16-1 downto 0);
begin
	if (ACLK'event and ACLK = '1') then
		if (ARESETN = '0') then
			udp_chk_sum_int_ready <= '0';
			chk_sum_fsm <= s0;
		else
			case chk_sum_fsm is
				when s0 =>
					udp_chk_sum_int <= (others => '0');
					if (new_flow = '1') then
						chk_sum_fsm <= s1;
					end if;
					L := 0;
				when s1 =>
					-- UDP checksum calculation
					check_sum_aux_vector := flow_on_one_std_logic_vector((NETFLOW_V5_RECORD_LENGTH*8-L*16)-1 downto (NETFLOW_V5_RECORD_LENGTH*8-L*16-16));
					udp_chk_sum_int <= std_logic_vector(unsigned(udp_chk_sum_int) + unsigned(check_sum_aux_vector));
					L := L +1;
					if (L = numb_of_addend) then
						udp_chk_sum_int_ready <= '1';
						chk_sum_fsm <= s2;
					end if;
				when s2 =>
					if (udp_chk_sum_int_ready_ack = '1') then
						udp_chk_sum_int_ready <= '0';
						chk_sum_fsm <= s0;
					end if;
			end case;
		end if;
	end if;
end process udp_chk_sum;


end architecture flow_encoding_arch;