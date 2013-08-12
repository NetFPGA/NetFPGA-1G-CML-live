#
# Example AXI4-Lite stimuli
#

# Four DWORD writes to MDIO (MAC) interface.  Each waits for completion.
7a000000, deadc0de, f, -.
7a000004, acce55ed, f, -.
7a000008, add1c7ed, f, -.
7a00000c, cafebabe, f, -.
7b000000, deadc0de, f, -.	# Ten DWORD writes to nic_output_port_loopup interface.  Each waits for completion.
7b000004, acce55ed, f, -.
7b000008, add1c7ed, f, -.
7b00000c, ca0ebabe, f, -.
7b000010, c0dedead, f, -.
7b000014, 55edacce, f, -.
7b000018, babeca1e, f, -.
7b00001c, abcde9ab, f, -.
7b000020, cde2abcd, f, -.
7b000024, e4abcde3, f, -.

# Four DWORD quick reads from the MDIO interface (without waits.)
-, -, -, 7a000000,
-, -, -, 7a000004,
-, -, -, 7a000008, 
-, -, -, 7a00000c,	# Never wrap addresses until after WAIT flag!
-, -, -, 7b000000,	# Ten DWORD quick reads from the nic_output_port_loopup interface (without waits.)
-, -, -, 7b000004,
-, -, -, 7b000008,
-, -, -, 7b00000c,
-, -, -, 7b000010,
-, -, -, 7b000014,
-, -, -, 7b000018,
-, -, -, 7b00001c,
-, -, -, 7b000020,
-, -, -, 7b000024.     # Never wrap addresses until after WAIT flag!
