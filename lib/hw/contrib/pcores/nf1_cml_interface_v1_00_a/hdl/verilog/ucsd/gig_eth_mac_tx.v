///////////////////////////////////////////////////////////////////////////////
//
// Gigabit Ethernet MAC: TX logic
//
// Author: Erik Rubow
//
// ----------------------------------------------------------------------------
//
// Gigabit Ethernet MAC: TX logic
//
// Adapted to AXIS MAC Interface for NetFPGA-1G-CML 
//
// Author: Tinghui WANG
//
// Copyright (C) 2013 Digilent Inc.
//
///////////////////////////////////////////////////////////////////////////////

module gig_eth_mac_tx
#(
  parameter MAX_FRAME_SIZE_STANDARD = 1522,
  parameter MAX_FRAME_SIZE_JUMBO = 9022
)
(
  // Reset, clocks
  input  wire reset,    // asynchronous
  input  wire tx_clk,

  // Configuration
  input  wire conf_tx_en,
  input  wire conf_tx_no_gen_crc,
  input  wire conf_tx_jumbo_en,

  // TX Client Interface
  // Modified for AXIS Interface 
  input  wire [7:0] tx_axis_mac_tdata,
  input  wire tx_axis_mac_tvalid,
  input  wire tx_axis_mac_tlast,
  input  wire tx_axis_mac_tuser,
  output wire tx_axis_mac_tready,
 
  // TX GMII Interface
  output wire [7:0] gmii_txd,
  output wire gmii_txen,
  output wire gmii_txer
);

  //-------- Localparams --------//
  // note: "data" for our purposes includes the Ethernet header,
  // since this MAC knows nothing about the header
  localparam TX_IFG             = 4'd0;
  localparam TX_READY           = 4'd1;
  localparam TX_ONE_CYCLE_DELAY = 4'd2;
  localparam TX_PREAMBLE        = 4'd3;
  localparam TX_DATA            = 4'd4;
  localparam TX_PAD             = 4'd5;
  localparam TX_CRC             = 4'd6;
  localparam TX_CORRUPT_FRAME   = 4'd7;
  localparam TX_WAIT_FOR_END    = 4'd8;

  //-------- Wires/regs --------//
  reg  [7:0] tx_axis_mac_tdata_in_reg;
  reg  [7:0] tx_axis_mac_tdata_int_reg;
  reg  tx_axis_mac_tvalid_in_reg;

  reg  tx_axis_mac_tready_out_reg;
  wire tx_axis_mac_tready_out_reg_next;
  reg  [7:0] gmii_txd_out_reg;
  reg  [7:0] gmii_txd_out_reg_next;
  reg  gmii_txen_out_reg;
  wire gmii_txen_out_reg_next;
  reg  gmii_txer_out_reg;
  wire gmii_txer_out_reg_next;

  reg  conf_tx_en_reg;
  reg  conf_tx_en_reg_next;
  reg  conf_tx_no_gen_crc_reg;
  reg  conf_tx_no_gen_crc_reg_next;
  reg  conf_tx_jumbo_en_reg;
  reg  conf_tx_jumbo_en_reg_next;

  reg  [3:0] tx_state;
  reg  [3:0] tx_state_next;
  reg  [13:0] tx_counter;
  reg  [13:0] tx_counter_next;
  reg  [13:0] max_data_length;
  wire [13:0] min_data_length;

  wire tx_crc_init;
  wire tx_crc_en;
  wire tx_crc_rd;
  wire [7:0] tx_crc_val;
  wire [7:0] tx_crc_frame_data;

  //-------- Instantiated modules --------//
  CRC_gen tx_crc_gen (
    .Reset       (reset),
    .Clk         (tx_clk),
    .Init        (tx_crc_init),
    .Frame_data  (tx_crc_frame_data),
    .Data_en     (tx_crc_en),
    .CRC_rd      (tx_crc_rd),
    .CRC_end     (),
    .CRC_out     (tx_crc_val)
  );

  //-------- Combinational logic --------//

  // outputs
  assign tx_axis_mac_tready = tx_axis_mac_tready_out_reg && tx_axis_mac_tvalid;
  assign gmii_txen = gmii_txen_out_reg;
  assign gmii_txer = gmii_txer_out_reg;
  assign gmii_txd = gmii_txd_out_reg;

  // GMII txen and txer signals
  assign gmii_txen_out_reg_next = tx_state == TX_PREAMBLE || tx_state == TX_DATA || tx_state == TX_PAD || tx_state == TX_CRC || tx_state == TX_CORRUPT_FRAME;
  assign gmii_txer_out_reg_next = tx_state == TX_CORRUPT_FRAME;
  
  // AXIS Control Signals
  assign tx_axis_mac_tready_out_reg_next = tx_state_next == TX_ONE_CYCLE_DELAY || tx_state == TX_ONE_CYCLE_DELAY || tx_state_next == TX_DATA;

  // GMII txd logic
  always @* begin
    if (tx_state == TX_PREAMBLE && tx_counter == 8)
      gmii_txd_out_reg_next = 8'b11010101;
    else if (tx_state == TX_PREAMBLE)
      gmii_txd_out_reg_next = 8'b01010101;
    else if (tx_state == TX_DATA)
      gmii_txd_out_reg_next = tx_axis_mac_tdata_int_reg;
    else if (tx_crc_rd)
      gmii_txd_out_reg_next = tx_crc_val;
    else
      gmii_txd_out_reg_next = 8'b00000000;
  end

  // signals for crc module
  assign tx_crc_init = tx_state == TX_PREAMBLE && tx_counter == 7;
  assign tx_crc_en = tx_state == TX_DATA || tx_state == TX_PAD;
  assign tx_crc_rd = tx_state == TX_CRC;
  assign tx_crc_frame_data = (tx_state == TX_PAD) ? 8'h00 : tx_axis_mac_tdata_int_reg;

  // update configuration between packets
  always @* begin
    if (tx_state == TX_READY || tx_state == TX_IFG) begin
      conf_tx_en_reg_next = conf_tx_en;
      conf_tx_no_gen_crc_reg_next = conf_tx_no_gen_crc;
      conf_tx_jumbo_en_reg_next = conf_tx_jumbo_en;
    end
    else begin
      conf_tx_en_reg_next = conf_tx_en_reg;
      conf_tx_no_gen_crc_reg_next = conf_tx_no_gen_crc_reg;
      conf_tx_jumbo_en_reg_next = conf_tx_jumbo_en_reg;
    end
  end

  always @* begin
    case ({conf_tx_jumbo_en_reg, conf_tx_no_gen_crc_reg})
      2'b00: max_data_length = MAX_FRAME_SIZE_STANDARD - 4;
      2'b01: max_data_length = MAX_FRAME_SIZE_STANDARD;
      2'b10: max_data_length = MAX_FRAME_SIZE_JUMBO - 4;
      2'b11: max_data_length = MAX_FRAME_SIZE_JUMBO;
    endcase
  end

  assign min_data_length = (conf_tx_no_gen_crc_reg ? 64 : 60);

  // count cycles in each state, but don't reset counter in TX_PAD
  // and don't count while disabled (count is important for TX_IFG)
  always @* begin
    if (!conf_tx_en_reg || (tx_state_next != tx_state && tx_state_next != TX_PAD))
      tx_counter_next = 1;
    else
      tx_counter_next = tx_counter + 1;
  end

  // state machine
  always @* begin
    if (!conf_tx_en_reg)
      tx_state_next = TX_IFG;
    else begin
      tx_state_next = tx_state;
  	  // AXIS: whenever tuser is asserted, frame is corrupted
      if (tx_axis_mac_tvalid && tx_axis_mac_tuser)
        tx_state_next = TX_CORRUPT_FRAME;
      else begin
        case (tx_state)
          TX_READY: begin
            if (tx_axis_mac_tvalid_in_reg)
              tx_state_next = TX_ONE_CYCLE_DELAY;
          end
          TX_ONE_CYCLE_DELAY: begin
            tx_state_next = TX_PREAMBLE;
          end
          TX_PREAMBLE: begin
            if (tx_counter == 8)
              tx_state_next = TX_DATA;
          end
          TX_DATA: begin
            if (tx_counter > max_data_length)
              tx_state_next = TX_CORRUPT_FRAME;
            else if (!tx_axis_mac_tvalid_in_reg) begin
              if (tx_counter < min_data_length)
                tx_state_next = TX_PAD;
              else if (conf_tx_no_gen_crc_reg)
                tx_state_next = TX_IFG;
              else
                tx_state_next = TX_CRC;
            end
          end
          TX_PAD: begin
            if (tx_counter == min_data_length) begin
              if (conf_tx_no_gen_crc_reg)
                tx_state_next = TX_IFG;
              else
                tx_state_next = TX_CRC;
            end
          end
          TX_CRC: begin
            if (tx_counter == 4)
              tx_state_next = TX_IFG;
          end
          TX_CORRUPT_FRAME: begin
            if (!tx_axis_mac_tvalid_in_reg)
              tx_state_next = TX_IFG;
            else // wait until client stops transmitting current frame
              tx_state_next = TX_WAIT_FOR_END;
          end
          TX_WAIT_FOR_END: begin
            if (!tx_axis_mac_tvalid_in_reg)
              tx_state_next = TX_IFG;
          end
          TX_IFG: begin
            if (tx_counter == 11)
              tx_state_next = TX_READY;
          end
        endcase
      end
    end
  end

  //-------- Sequential logic --------//
  always @(posedge tx_clk or posedge reset) begin
    if (reset) begin
      tx_axis_mac_tdata_in_reg    <= 8'h00;
      tx_axis_mac_tdata_int_reg   <= 8'h00;
      tx_axis_mac_tvalid_in_reg   <= 1'b0;
      tx_axis_mac_tready_out_reg  <= 1'b0;
      gmii_txd_out_reg            <= 8'h00;
      gmii_txen_out_reg           <= 1'b0;
      gmii_txer_out_reg           <= 1'b0;
      conf_tx_en_reg              <= 1'b0;
      conf_tx_no_gen_crc_reg      <= 1'b0;
      conf_tx_jumbo_en_reg        <= 1'b0;
      tx_state                    <= TX_IFG;
      tx_counter                  <= 0;
    end
    else begin
	  if(tx_axis_mac_tready_out_reg == 1)
      begin
	      tx_axis_mac_tdata_in_reg    <= tx_axis_mac_tdata;
    	  tx_axis_mac_tdata_int_reg   <= tx_axis_mac_tdata_in_reg;
	  end
      tx_axis_mac_tvalid_in_reg   <= tx_axis_mac_tvalid;
      tx_axis_mac_tready_out_reg  <= tx_axis_mac_tready_out_reg_next;
      gmii_txd_out_reg            <= gmii_txd_out_reg_next;
      gmii_txen_out_reg           <= gmii_txen_out_reg_next;
      gmii_txer_out_reg           <= gmii_txer_out_reg_next;
      conf_tx_en_reg              <= conf_tx_en_reg_next;
      conf_tx_no_gen_crc_reg      <= conf_tx_no_gen_crc_reg_next;
      conf_tx_jumbo_en_reg        <= conf_tx_jumbo_en_reg_next;
      tx_state                    <= tx_state_next;
      tx_counter                  <= tx_counter_next;
    end
  end

endmodule

