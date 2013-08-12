#
# Example AXI4-Lite stimuli
#

# Four DWORD writes to MDIO (MAC) interface.  Each waits for completion.
7a000000, deadc0de, f, -.
7a000004, acce55ed, f, -.
7a000008, add1c7ed, f, -.
7a00000c, cafebabe, f, -.

# Four DWORD quick reads from the MDIO interface (without waits.)
-, -, -, 7a000000,
-, -, -, 7a000004,
-, -, -, 7a000008, 
-, -, -, 7a00000c.     # Never wrap addresses until after WAIT flag!
