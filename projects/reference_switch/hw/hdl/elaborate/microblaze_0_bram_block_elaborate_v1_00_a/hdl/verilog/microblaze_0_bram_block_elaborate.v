//-----------------------------------------------------------------------------
// microblaze_0_bram_block_elaborate.v
//-----------------------------------------------------------------------------

(* keep_hierarchy = "yes" *)
module microblaze_0_bram_block_elaborate
  (
    BRAM_Rst_A,
    BRAM_Clk_A,
    BRAM_EN_A,
    BRAM_WEN_A,
    BRAM_Addr_A,
    BRAM_Din_A,
    BRAM_Dout_A,
    BRAM_Rst_B,
    BRAM_Clk_B,
    BRAM_EN_B,
    BRAM_WEN_B,
    BRAM_Addr_B,
    BRAM_Din_B,
    BRAM_Dout_B
  );
  parameter
    C_MEMSIZE = 'h4000,
    C_PORT_DWIDTH = 32,
    C_PORT_AWIDTH = 32,
    C_NUM_WE = 4,
    C_FAMILY = "virtex5";
  input BRAM_Rst_A;
  input BRAM_Clk_A;
  input BRAM_EN_A;
  input [0:C_NUM_WE-1] BRAM_WEN_A;
  input [0:C_PORT_AWIDTH-1] BRAM_Addr_A;
  output [0:C_PORT_DWIDTH-1] BRAM_Din_A;
  input [0:C_PORT_DWIDTH-1] BRAM_Dout_A;
  input BRAM_Rst_B;
  input BRAM_Clk_B;
  input BRAM_EN_B;
  input [0:C_NUM_WE-1] BRAM_WEN_B;
  input [0:C_PORT_AWIDTH-1] BRAM_Addr_B;
  output [0:C_PORT_DWIDTH-1] BRAM_Din_B;
  input [0:C_PORT_DWIDTH-1] BRAM_Dout_B;

  // Internal signals

  wire net_gnd0;
  wire [3:0] net_gnd4;
  wire [0:0] pgassign1;
  wire [0:2] pgassign2;
  wire [0:23] pgassign3;
  wire [15:0] pgassign4;
  wire [31:0] pgassign5;
  wire [31:0] pgassign6;
  wire [3:0] pgassign7;
  wire [15:0] pgassign8;
  wire [31:0] pgassign9;
  wire [31:0] pgassign10;
  wire [3:0] pgassign11;
  wire [15:0] pgassign12;
  wire [31:0] pgassign13;
  wire [31:0] pgassign14;
  wire [3:0] pgassign15;
  wire [15:0] pgassign16;
  wire [31:0] pgassign17;
  wire [31:0] pgassign18;
  wire [3:0] pgassign19;
  wire [15:0] pgassign20;
  wire [31:0] pgassign21;
  wire [31:0] pgassign22;
  wire [3:0] pgassign23;
  wire [15:0] pgassign24;
  wire [31:0] pgassign25;
  wire [31:0] pgassign26;
  wire [3:0] pgassign27;
  wire [15:0] pgassign28;
  wire [31:0] pgassign29;
  wire [31:0] pgassign30;
  wire [3:0] pgassign31;
  wire [15:0] pgassign32;
  wire [31:0] pgassign33;
  wire [31:0] pgassign34;
  wire [3:0] pgassign35;

  // Internal assignments

  assign pgassign1[0:0] = 1'b1;
  assign pgassign2[0:2] = 3'b000;
  assign pgassign3[0:23] = 24'b000000000000000000000000;
  assign pgassign4[15:15] = 1'b1;
  assign pgassign4[14:3] = BRAM_Addr_A[18:29];
  assign pgassign4[2:0] = 3'b000;
  assign pgassign5[31:8] = 24'b000000000000000000000000;
  assign pgassign5[7:0] = BRAM_Dout_A[0:7];
  assign BRAM_Din_A[0:7] = pgassign6[7:0];
  assign pgassign7[3:3] = BRAM_WEN_A[0:0];
  assign pgassign7[2:2] = BRAM_WEN_A[0:0];
  assign pgassign7[1:1] = BRAM_WEN_A[0:0];
  assign pgassign7[0:0] = BRAM_WEN_A[0:0];
  assign pgassign8[15:15] = 1'b1;
  assign pgassign8[14:3] = BRAM_Addr_B[18:29];
  assign pgassign8[2:0] = 3'b000;
  assign pgassign9[31:8] = 24'b000000000000000000000000;
  assign pgassign9[7:0] = BRAM_Dout_B[0:7];
  assign BRAM_Din_B[0:7] = pgassign10[7:0];
  assign pgassign11[3:3] = BRAM_WEN_B[0:0];
  assign pgassign11[2:2] = BRAM_WEN_B[0:0];
  assign pgassign11[1:1] = BRAM_WEN_B[0:0];
  assign pgassign11[0:0] = BRAM_WEN_B[0:0];
  assign pgassign12[15:15] = 1'b1;
  assign pgassign12[14:3] = BRAM_Addr_A[18:29];
  assign pgassign12[2:0] = 3'b000;
  assign pgassign13[31:8] = 24'b000000000000000000000000;
  assign pgassign13[7:0] = BRAM_Dout_A[8:15];
  assign BRAM_Din_A[8:15] = pgassign14[7:0];
  assign pgassign15[3:3] = BRAM_WEN_A[1:1];
  assign pgassign15[2:2] = BRAM_WEN_A[1:1];
  assign pgassign15[1:1] = BRAM_WEN_A[1:1];
  assign pgassign15[0:0] = BRAM_WEN_A[1:1];
  assign pgassign16[15:15] = 1'b1;
  assign pgassign16[14:3] = BRAM_Addr_B[18:29];
  assign pgassign16[2:0] = 3'b000;
  assign pgassign17[31:8] = 24'b000000000000000000000000;
  assign pgassign17[7:0] = BRAM_Dout_B[8:15];
  assign BRAM_Din_B[8:15] = pgassign18[7:0];
  assign pgassign19[3:3] = BRAM_WEN_B[1:1];
  assign pgassign19[2:2] = BRAM_WEN_B[1:1];
  assign pgassign19[1:1] = BRAM_WEN_B[1:1];
  assign pgassign19[0:0] = BRAM_WEN_B[1:1];
  assign pgassign20[15:15] = 1'b1;
  assign pgassign20[14:3] = BRAM_Addr_A[18:29];
  assign pgassign20[2:0] = 3'b000;
  assign pgassign21[31:8] = 24'b000000000000000000000000;
  assign pgassign21[7:0] = BRAM_Dout_A[16:23];
  assign BRAM_Din_A[16:23] = pgassign22[7:0];
  assign pgassign23[3:3] = BRAM_WEN_A[2:2];
  assign pgassign23[2:2] = BRAM_WEN_A[2:2];
  assign pgassign23[1:1] = BRAM_WEN_A[2:2];
  assign pgassign23[0:0] = BRAM_WEN_A[2:2];
  assign pgassign24[15:15] = 1'b1;
  assign pgassign24[14:3] = BRAM_Addr_B[18:29];
  assign pgassign24[2:0] = 3'b000;
  assign pgassign25[31:8] = 24'b000000000000000000000000;
  assign pgassign25[7:0] = BRAM_Dout_B[16:23];
  assign BRAM_Din_B[16:23] = pgassign26[7:0];
  assign pgassign27[3:3] = BRAM_WEN_B[2:2];
  assign pgassign27[2:2] = BRAM_WEN_B[2:2];
  assign pgassign27[1:1] = BRAM_WEN_B[2:2];
  assign pgassign27[0:0] = BRAM_WEN_B[2:2];
  assign pgassign28[15:15] = 1'b1;
  assign pgassign28[14:3] = BRAM_Addr_A[18:29];
  assign pgassign28[2:0] = 3'b000;
  assign pgassign29[31:8] = 24'b000000000000000000000000;
  assign pgassign29[7:0] = BRAM_Dout_A[24:31];
  assign BRAM_Din_A[24:31] = pgassign30[7:0];
  assign pgassign31[3:3] = BRAM_WEN_A[3:3];
  assign pgassign31[2:2] = BRAM_WEN_A[3:3];
  assign pgassign31[1:1] = BRAM_WEN_A[3:3];
  assign pgassign31[0:0] = BRAM_WEN_A[3:3];
  assign pgassign32[15:15] = 1'b1;
  assign pgassign32[14:3] = BRAM_Addr_B[18:29];
  assign pgassign32[2:0] = 3'b000;
  assign pgassign33[31:8] = 24'b000000000000000000000000;
  assign pgassign33[7:0] = BRAM_Dout_B[24:31];
  assign BRAM_Din_B[24:31] = pgassign34[7:0];
  assign pgassign35[3:3] = BRAM_WEN_B[3:3];
  assign pgassign35[2:2] = BRAM_WEN_B[3:3];
  assign pgassign35[1:1] = BRAM_WEN_B[3:3];
  assign pgassign35[0:0] = BRAM_WEN_B[3:3];
  assign net_gnd0 = 1'b0;
  assign net_gnd4[3:0] = 4'b0000;

  (* BMM_INFO = " " *)

  RAMB36
    #(
      .WRITE_MODE_A ( "WRITE_FIRST" ),
      .WRITE_MODE_B ( "WRITE_FIRST" ),
      .INIT_FILE ( "microblaze_0_bram_block_combined_0.mem" ),
      .READ_WIDTH_A ( 9 ),
      .READ_WIDTH_B ( 9 ),
      .WRITE_WIDTH_A ( 9 ),
      .WRITE_WIDTH_B ( 9 ),
      .RAM_EXTENSION_A ( "NONE" ),
      .RAM_EXTENSION_B ( "NONE" )
    )
    ramb36_0 (
      .ADDRA ( pgassign4 ),
      .CASCADEINLATA ( net_gnd0 ),
      .CASCADEINREGA ( net_gnd0 ),
      .CASCADEOUTLATA (  ),
      .CASCADEOUTREGA (  ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign5 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign6 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .SSRA ( BRAM_Rst_A ),
      .WEA ( pgassign7 ),
      .ADDRB ( pgassign8 ),
      .CASCADEINLATB ( net_gnd0 ),
      .CASCADEINREGB ( net_gnd0 ),
      .CASCADEOUTLATB (  ),
      .CASCADEOUTREGB (  ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign9 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign10 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .SSRB ( BRAM_Rst_B ),
      .WEB ( pgassign11 )
    );

  (* BMM_INFO = " " *)

  RAMB36
    #(
      .WRITE_MODE_A ( "WRITE_FIRST" ),
      .WRITE_MODE_B ( "WRITE_FIRST" ),
      .INIT_FILE ( "microblaze_0_bram_block_combined_1.mem" ),
      .READ_WIDTH_A ( 9 ),
      .READ_WIDTH_B ( 9 ),
      .WRITE_WIDTH_A ( 9 ),
      .WRITE_WIDTH_B ( 9 ),
      .RAM_EXTENSION_A ( "NONE" ),
      .RAM_EXTENSION_B ( "NONE" )
    )
    ramb36_1 (
      .ADDRA ( pgassign12 ),
      .CASCADEINLATA ( net_gnd0 ),
      .CASCADEINREGA ( net_gnd0 ),
      .CASCADEOUTLATA (  ),
      .CASCADEOUTREGA (  ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign13 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign14 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .SSRA ( BRAM_Rst_A ),
      .WEA ( pgassign15 ),
      .ADDRB ( pgassign16 ),
      .CASCADEINLATB ( net_gnd0 ),
      .CASCADEINREGB ( net_gnd0 ),
      .CASCADEOUTLATB (  ),
      .CASCADEOUTREGB (  ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign17 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign18 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .SSRB ( BRAM_Rst_B ),
      .WEB ( pgassign19 )
    );

  (* BMM_INFO = " " *)

  RAMB36
    #(
      .WRITE_MODE_A ( "WRITE_FIRST" ),
      .WRITE_MODE_B ( "WRITE_FIRST" ),
      .INIT_FILE ( "microblaze_0_bram_block_combined_2.mem" ),
      .READ_WIDTH_A ( 9 ),
      .READ_WIDTH_B ( 9 ),
      .WRITE_WIDTH_A ( 9 ),
      .WRITE_WIDTH_B ( 9 ),
      .RAM_EXTENSION_A ( "NONE" ),
      .RAM_EXTENSION_B ( "NONE" )
    )
    ramb36_2 (
      .ADDRA ( pgassign20 ),
      .CASCADEINLATA ( net_gnd0 ),
      .CASCADEINREGA ( net_gnd0 ),
      .CASCADEOUTLATA (  ),
      .CASCADEOUTREGA (  ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign21 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign22 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .SSRA ( BRAM_Rst_A ),
      .WEA ( pgassign23 ),
      .ADDRB ( pgassign24 ),
      .CASCADEINLATB ( net_gnd0 ),
      .CASCADEINREGB ( net_gnd0 ),
      .CASCADEOUTLATB (  ),
      .CASCADEOUTREGB (  ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign25 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign26 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .SSRB ( BRAM_Rst_B ),
      .WEB ( pgassign27 )
    );

  (* BMM_INFO = " " *)

  RAMB36
    #(
      .WRITE_MODE_A ( "WRITE_FIRST" ),
      .WRITE_MODE_B ( "WRITE_FIRST" ),
      .INIT_FILE ( "microblaze_0_bram_block_combined_3.mem" ),
      .READ_WIDTH_A ( 9 ),
      .READ_WIDTH_B ( 9 ),
      .WRITE_WIDTH_A ( 9 ),
      .WRITE_WIDTH_B ( 9 ),
      .RAM_EXTENSION_A ( "NONE" ),
      .RAM_EXTENSION_B ( "NONE" )
    )
    ramb36_3 (
      .ADDRA ( pgassign28 ),
      .CASCADEINLATA ( net_gnd0 ),
      .CASCADEINREGA ( net_gnd0 ),
      .CASCADEOUTLATA (  ),
      .CASCADEOUTREGA (  ),
      .CLKA ( BRAM_Clk_A ),
      .DIA ( pgassign29 ),
      .DIPA ( net_gnd4 ),
      .DOA ( pgassign30 ),
      .DOPA (  ),
      .ENA ( BRAM_EN_A ),
      .REGCEA ( net_gnd0 ),
      .SSRA ( BRAM_Rst_A ),
      .WEA ( pgassign31 ),
      .ADDRB ( pgassign32 ),
      .CASCADEINLATB ( net_gnd0 ),
      .CASCADEINREGB ( net_gnd0 ),
      .CASCADEOUTLATB (  ),
      .CASCADEOUTREGB (  ),
      .CLKB ( BRAM_Clk_B ),
      .DIB ( pgassign33 ),
      .DIPB ( net_gnd4 ),
      .DOB ( pgassign34 ),
      .DOPB (  ),
      .ENB ( BRAM_EN_B ),
      .REGCEB ( net_gnd0 ),
      .SSRB ( BRAM_Rst_B ),
      .WEB ( pgassign35 )
    );

endmodule

