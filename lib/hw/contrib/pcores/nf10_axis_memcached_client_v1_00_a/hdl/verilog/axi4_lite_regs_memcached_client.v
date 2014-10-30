/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        axi4_lite_regs_memcached_client.v
 *
 *  Library:
 *        hw/std/pcores/nf10_axis_memcached_client
 *
 *  Author:
 *        Jeremia Baer
 *
 *  Description:
 *        AXI4-Lite for registers
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 Xilinx, Inc.
 *
 *  Licence:
 *        This file is part of the NetFPGA 10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package.  If not, see
 *        http://www.gnu.org/licenses/.
 *
 */

module axi4_lite_regs_memcached_client #(
   parameter [31:0] BASEADDR = 0,
   parameter        WC_MAX   = 190,
   parameter        WC_WIDTH = 8
) (
   // AXI4-Lite Interconnect
   input         ACLK,
   input         ARESETN,

   input  [31:0] AWADDR,
   input         AWVALID,
   output        AWREADY,

   input  [31:0] WDATA,
   input  [ 3:0] WSTRB,
   input         WVALID,
   output        WREADY,

   output [ 1:0] BRESP,
   output        BVALID,
   input         BREADY,

   input  [31:0] ARADDR,
   input         ARVALID,
   output        ARREADY,

   output [31:0] RDATA,
   output [ 1:0] RRESP,
   output        RVALID,
   input         RREADY,

   // Data for AXI4-Stream clocked packet generator/checker
   input         AXIS_ACLK,

   output        run,
   output        counter_reset,
   output [31:0] ifg,

   input  [31:0] tx_count,
   input  [31:0] rx_count,
   input  [31:0] err_count,

   output        oneshot_go,
   input         oneshot_done,
   input  [31:0] oneshot_latency,

   output [WC_WIDTH-1:0] tx_word_count,
   output [         7:0] tx_last_strobe,
   input  [WC_WIDTH-1:0] tx_word_index_next,
   output [        63:0] tx_word_data,

   output [WC_WIDTH-1:0] rx_word_count,
   output [         7:0] rx_last_strobe,
   input  [WC_WIDTH-1:0] rx_word_index_next,
   output [        63:0] rx_word_data,

   // Chipscope
   output         chipscope_clk,
   output [255:0] chipscope_data
);

// -------------------------------------------------------------------
// Status Registers (AXIS Clock Domain)
// -------------------------------------------------------------------

// Register Constants ------------------------------------------------
localparam [31:0] REG_RUN           = BASEADDR + 32'h00000000;
localparam [31:0] REG_COUNTER_RESET = BASEADDR + 32'h00000001;
localparam [31:0] REG_IFG           = BASEADDR + 32'h00000002;
localparam [31:0] REG_ONESHOT       = BASEADDR + 32'h00000003;
localparam [31:0] REG_TX_COUNT      = BASEADDR + 32'h00000010;
localparam [31:0] REG_RX_COUNT      = BASEADDR + 32'h00000011;
localparam [31:0] REG_ERR_COUNT     = BASEADDR + 32'h00000012;
localparam [31:0] REG_STREAMBLOCK   = BASEADDR + 32'h00000020;

localparam [ 1:0] AXI_RESP_OK     = 2'b00;
localparam [ 1:0] AXI_RESP_SLVERR = 2'b10;

// Control Registers -------------------------------------------------
reg        run_reg;
reg        counter_reset_reg;
reg [31:0] ifg_reg;

reg        oneshot_go_reg;
reg [30:0] latency;        // AXI Clock Domain
reg        latency_valid;  // AXI Clock Domain

// Statistic Regiters taken directly from input ----------------------

// TX/RX Buffers -----------------------------------------------------
reg  [WC_WIDTH-1:0] tx_word_count_reg;
reg  [         7:0] tx_last_strobe_reg;

wire [  WC_WIDTH:0] tx_wr_addr;
wire [        31:0] tx_wr_data;
wire                tx_wr_en;
wire [  WC_WIDTH:0] tx_rd_addr;
wire [        31:0] tx_rd_data;

nf10_axis_memcached_streambuffer #(
   .WC_MAX(WC_MAX),
   .WC_WIDTH(WC_WIDTH)
) tx_streambuffer (
   .ACLK(AXIS_ACLK),
   .rd64_addr(tx_word_index_next),
   .rd64_data(tx_word_data),
   .rd32_addr(tx_rd_addr),
   .rd32_data(tx_rd_data),
   .wr32_addr(tx_wr_addr),
   .wr32_data(tx_wr_data),
   .wr32_en(tx_wr_en)
);

reg  [WC_WIDTH-1:0] rx_word_count_reg;
reg  [         7:0] rx_last_strobe_reg;

wire [  WC_WIDTH:0] rx_wr_addr;
wire [        31:0] rx_wr_data;
wire                rx_wr_en;
wire [  WC_WIDTH:0] rx_rd_addr;
wire [        31:0] rx_rd_data;

nf10_axis_memcached_streambuffer #(
   .WC_MAX(WC_MAX),
   .WC_WIDTH(WC_WIDTH)
) rx_streambuffer (
   .ACLK(AXIS_ACLK),
   .rd64_addr(rx_word_index_next),
   .rd64_data(rx_word_data),
   .rd32_addr(rx_rd_addr),
   .rd32_data(rx_rd_data),
   .wr32_addr(rx_wr_addr),
   .wr32_data(rx_wr_data),
   .wr32_en(rx_wr_en)
);

// -------------------------------------------------------------------
// Output for packet generator/checker
// -------------------------------------------------------------------

assign run            = run_reg;
assign counter_reset  = counter_reset_reg;
assign ifg            = ifg_reg;

assign oneshot_go     = oneshot_go_reg;

assign tx_word_count  = tx_word_count_reg;
assign tx_last_strobe = tx_last_strobe_reg;

assign rx_word_count  = rx_word_count_reg;
assign rx_last_strobe = rx_last_strobe_reg;

// -------------------------------------------------------------------
// AXI-Lite Write Access
// -------------------------------------------------------------------

// Abstracting the communication protocol from AXI Lite --------------
reg  [31:0] write_address;
reg  [31:0] write_data;
reg         write_valid;

wire        write_queue_full;
wire        write_queue_empty;

localparam [1:0]
   WaitWrAddress = 0,
   WaitWrData    = 1,
   WrResponse    = 2;
reg [1:0] write_state;

assign AWREADY   = AWVALID & (write_state==WaitWrAddress);
assign WREADY    = WVALID & (write_state==WaitWrData) & ~write_queue_full;
wire wrAddrValid = (write_address==REG_RUN)           |
                   (write_address==REG_COUNTER_RESET) |
                   (write_address==REG_IFG)           |
                   (write_address==REG_STREAMBLOCK)   ;
assign BVALID    = (write_state==WrResponse);
assign BRESP     = wrAddrValid ? AXI_RESP_OK : AXI_RESP_SLVERR;

always @ (posedge ACLK)
   if(~ARESETN)                                  write_state <= WaitWrAddress;
   else if(write_state==WaitWrAddress & AWREADY) write_state <= WaitWrData;
   else if(write_state==WaitWrData & WREADY)     write_state <= WrResponse;
   else if(write_state==WrResponse & BREADY)     write_state <= WaitWrAddress;

always @ (posedge ACLK)
   if(~ARESETN)     write_address <= 0;
   else if(AWREADY) write_address <= AWADDR;

always @ (posedge ACLK)
   if(~ARESETN)    write_data <= 0;
   else if(WREADY) write_data <= WDATA;

always @ (posedge ACLK)
   if(~ARESETN)    write_valid <= 0;
   else if(WREADY) write_valid <= 1;
   else            write_valid <= 0;

// Clock domain crossing for control registers -----------------------
(* keep = "true" *) reg        run_reg_axil;
(* keep = "true" *) reg        run_reg_cross;
(* keep = "true" *) reg        counter_reset_reg_axil;
(* keep = "true" *) reg        counter_reset_reg_cross;
(* keep = "true" *) reg [31:0] ifg_reg_axil;
(* keep = "true" *) reg [31:0] ifg_reg_cross;
(* keep = "true" *) reg        oneshot_go_reg_axil;
(* keep = "true" *) reg        oneshot_go_reg_cross;

always @ (posedge ACLK) begin
   if(~ARESETN) begin
      run_reg_axil           <= 0;
      counter_reset_reg_axil <= 0;
      ifg_reg_axil           <= 10;
      oneshot_go_reg_axil    <= 0;
   end
   else if(write_valid) case(write_address)
      REG_RUN:           run_reg_axil           <= write_data[0];
      REG_COUNTER_RESET: counter_reset_reg_axil <= write_data[0];
      REG_IFG:           ifg_reg_axil           <= write_data;
      REG_ONESHOT:       oneshot_go_reg_axil    <= 1;
   endcase
   else begin
      oneshot_go_reg_axil <= 0;
   end
end

always @ (posedge AXIS_ACLK) begin
   if(~ARESETN) begin
      run_reg_cross           <= 0;
      run_reg                 <= 0;
      counter_reset_reg_cross <= 0;
      counter_reset_reg       <= 0;
      ifg_reg_cross           <= 10;
      ifg_reg                 <= 10;
      oneshot_go_reg_cross    <= 0;
      oneshot_go_reg          <= 0;
   end else begin
      run_reg_cross           <= run_reg_axil;
      run_reg                 <= run_reg_cross;
      counter_reset_reg_cross <= counter_reset_reg_axil;
      counter_reset_reg       <= counter_reset_reg_cross;
      ifg_reg_cross           <= ifg_reg_axil;
      ifg_reg                 <= ifg_reg_cross;
      oneshot_go_reg_cross    <= oneshot_go_reg_axil;
      oneshot_go_reg          <= oneshot_go_reg_cross;
   end
end

// Clock domain crossing for streambuffer updates: use FIFO. ---------
wire [31:0] axis_wdata;
wire        axis_wdata_valid;

assign axis_wdata_valid = ~write_queue_empty;

async_fifo_32_129 write_queue (
   .rst(~ARESETN),
   .wr_clk(ACLK),
   .rd_clk(AXIS_ACLK),
   .din(write_data),
   .wr_en(write_valid & write_address==REG_STREAMBLOCK),
   .rd_en(axis_wdata_valid),
   .dout(axis_wdata),
   .full(write_queue_full),
   .empty(write_queue_empty)
);

// Streamblock updates decoder
localparam DC_WIDTH = WC_WIDTH + 3; // DC_WIDTH needs to hold 4*WC_MAX + 4
localparam [DC_WIDTH-1:0]
   TX_WC   = 0,
   TX_STRB = 1,
   TX_LBUF = 2,
   TX_UBUF = TX_LBUF + 2*WC_MAX - 1,
   RX_WC   = TX_UBUF + 1,
   RX_STRB = RX_WC + 1,
   RX_LBUF = RX_STRB + 1,
   RX_UBUF = RX_LBUF + 2*WC_MAX - 1;
// Example for WC=32 (outdated)
// Word 0      : TX Word Count
// Word 1      : TX Strobe
// Word 2-65   : TX Buffer
// Word 66     : RX Word Count
// Word 67     : RX Strobe
// Word 68-131 : RX Buffer

reg [DC_WIDTH-1:0] write_decode;
always @ (posedge AXIS_ACLK)
   if(~ARESETN) write_decode <= 0;
   else if(axis_wdata_valid)
      if(write_decode != RX_UBUF) write_decode <= write_decode + 1;
      else                        write_decode <= 0;

always @ (posedge AXIS_ACLK)
   if(~ARESETN) begin
      tx_word_count_reg  <= 0;
      tx_last_strobe_reg <= 0;
      rx_word_count_reg  <= 0;
      rx_last_strobe_reg <= 0;
   end
   else if(axis_wdata_valid)
      if     (write_decode==TX_WC)   tx_word_count_reg  <= axis_wdata[WC_WIDTH-1:0];
      else if(write_decode==TX_STRB) tx_last_strobe_reg <= axis_wdata[         7:0];
      else if(write_decode==RX_WC)   rx_word_count_reg  <= axis_wdata[WC_WIDTH-1:0];
      else if(write_decode==RX_STRB) rx_last_strobe_reg <= axis_wdata[         7:0];

assign tx_wr_en = axis_wdata_valid & (write_decode >= TX_LBUF) & (write_decode < (TX_UBUF+1));
assign rx_wr_en = axis_wdata_valid & (write_decode >= RX_LBUF) & (write_decode < (RX_UBUF+1));
assign tx_wr_data = axis_wdata;
assign rx_wr_data = axis_wdata;
assign tx_wr_addr = (write_decode - TX_LBUF);
assign rx_wr_addr = (write_decode - RX_LBUF);

// -------------------------------------------------------------------
// AXI-Lite Read Access
// -------------------------------------------------------------------

// Statistics clock domain crossing ----------------------------------
(* keep = "true" *) reg  [31:0] tx_count_cross;
(* keep = "true" *) reg  [31:0] tx_count_axil;
(* keep = "true" *) reg  [31:0] rx_count_cross;
(* keep = "true" *) reg  [31:0] rx_count_axil;
(* keep = "true" *) reg  [31:0] err_count_cross;
(* keep = "true" *) reg  [31:0] err_count_axil;

always @ (posedge ACLK) begin
   tx_count_cross  <= tx_count;
   tx_count_axil   <= tx_count_cross;
   rx_count_cross  <= rx_count;
   rx_count_axil   <= rx_count_cross;
   err_count_cross <= err_count;
   err_count_axil  <= err_count_cross;
end

// Latency measurement -----------------------------------------------
// The result of a latency read is {latency_valid, latency[30:0]}.
// Whenever a latency measure is requested (oneshot_go_reg_axil),
// the latency_valid is deasserted. A queue is used to read back the
// new latency and latency_valid is reasserted.
wire [31:0] latup_data;
wire        latup_empty;
wire        latup_rd;

async_fifo_32_129 latency_update (
   .rst(~ARESETN),
   .wr_clk(AXIS_ACLK),
   .rd_clk(ACLK),
   .din(oneshot_latency),
   .wr_en(oneshot_done),
   .rd_en(latup_rd),
   .dout(latup_data),
   .full(/*none*/),
   .empty(latup_empty)
);

assign latup_rd = ~oneshot_go_reg_axil & ~latup_empty;
always @ (posedge ACLK)
   if(~ARESETN) begin
      latency_valid <= 0;
      latency       <= 0;
   end
   else if(oneshot_go_reg_axil) begin
      latency_valid <= 0;
   end
   else if(latup_rd) begin
      latency       <= latup_data[30:0];
      latency_valid <= 1;
   end

// Streamblock encoding over asynchronous FIFO. ----------------------
// Similiar to the decoder to update the streamblock. However, the
// FIFO is written one element at the time when a read request is
// issued only. To notifiy about a read request, a 'bubble' is put
// into the 'read_init'-queue. The decoder removes the bubble from the
// queue and puts the next element into the read queue.

// Init and data queue
wire        read_init_put;
wire        read_init_pop;
wire        read_init_full;
wire        read_init_empty;

wire [31:0] read_queue_din;
wire [31:0] read_queue_data;
wire        read_queue_read;
wire        read_queue_write;
wire        read_queue_full;
wire        read_queue_empty;

async_fifo_1_16 read_init (
   .rst(~ARESETN),
   .wr_clk(ACLK),
   .rd_clk(AXIS_ACLK),
   .din(1'b1),
   .wr_en(read_init_put),
   .rd_en(read_init_pop),
   .dout(/*none*/),
   .full(read_init_full),
   .empty(read_init_empty)
);

async_fifo_32_129 read_queue (
   .rst(~ARESETN),
   .wr_clk(AXIS_ACLK),
   .rd_clk(ACLK),
   .din(read_queue_din),
   .wr_en(read_queue_write),
   .rd_en(read_queue_read),
   .dout(read_queue_data),
   .full(read_queue_full),
   .empty(read_queue_empty)
);

// Data encoder
reg  [DC_WIDTH-1:0] read_decode;
wire                read_transmit;

assign read_transmit    = ~read_init_empty & ~read_queue_full;
assign read_init_pop    = read_transmit;
assign read_queue_write = read_transmit;

always @ (posedge AXIS_ACLK)
   if(~ARESETN)                  read_decode <= 0;
   else if(read_transmit)
      if(read_decode != RX_UBUF) read_decode <= read_decode + 1;
      else                       read_decode <= 0;

assign read_queue_din = (read_decode==TX_WC  )    ? tx_word_count_reg  :
                        (read_decode==TX_STRB)    ? tx_last_strobe_reg :
                        (read_decode==RX_WC  )    ? rx_word_count_reg  :
                        (read_decode==RX_STRB)    ? rx_last_strobe_reg :
                        (read_decode<(TX_UBUF+1)) ? tx_rd_data         :
                                                    rx_rd_data         ;

assign tx_rd_addr = read_transmit ? (read_decode - TX_LBUF + 1) :
                                    (read_decode - TX_LBUF)     ;
assign rx_rd_addr = read_transmit ? (read_decode - RX_LBUF + 1) :
                                    (read_decode - RX_LBUF)     ;

// State Machine for AXI4-lite read requests -------------------------
//   Statistics taken from registers
//   Streamblock taken from read_queue

localparam [1:0]
   RdWait = 0, // Wait for address
   RdInit = 1, // Statistics: Load reg. Streamblock: put bubble into init_q
   RdLoad = 2, // If streamblock, wait and load word from read_queue
   RdResp = 3; // Return the data
reg [1:0] read_state;

reg [31:0] read_addr;
reg [31:0] read_data;

wire read_statistics  = (read_addr==REG_TX_COUNT)  |
                        (read_addr==REG_RX_COUNT)  |
                        (read_addr==REG_ERR_COUNT) |
                        (read_addr==REG_ONESHOT)   ;
wire read_streamblock = (read_addr==REG_STREAMBLOCK);
wire read_invalid     = ~read_statistics & ~read_streamblock;

always @ (posedge ACLK)
   if(~ARESETN)                                                   read_state <= RdWait;
   else if(read_state==RdWait & ARVALID)                          read_state <= RdInit;
   else if(read_state==RdInit & read_statistics)                  read_state <= RdResp;
   else if(read_state==RdInit & read_streamblock & read_init_put) read_state <= RdLoad;
   else if(read_state==RdInit & read_invalid)                     read_state <= RdResp;
   else if(read_state==RdLoad & read_queue_read)                  read_state <= RdResp;
   else if(read_state==RdResp & RREADY)                           read_state <= RdWait;

assign ARREADY = (read_state==RdWait);
always @ (posedge ACLK)
   if(ARVALID & ARREADY) read_addr <= ARADDR;

assign read_init_put   = (read_state==RdInit & read_streamblock & ~read_init_full);
assign read_queue_read = (read_state==RdLoad & ~read_queue_empty);

always @ (posedge ACLK)
   if     (read_state==RdInit & read_addr==REG_TX_COUNT)  read_data <= tx_count_axil;
   else if(read_state==RdInit & read_addr==REG_RX_COUNT)  read_data <= rx_count_axil;
   else if(read_state==RdInit & read_addr==REG_ERR_COUNT) read_data <= err_count_axil;
   else if(read_state==RdInit & read_addr==REG_ONESHOT)   read_data <= {latency_valid, latency};
   else if(read_state==RdLoad & read_queue_read)          read_data <= read_queue_data;

assign RVALID = (read_state==RdResp);
assign RDATA  = read_data;
assign RRESP  = read_invalid ? AXI_RESP_SLVERR : AXI_RESP_OK;

// -------------------------------------------------------------------
// CHIPSCOPE
// -------------------------------------------------------------------

assign chipscope_clk = ACLK;
/*
assign chipscope_data = {
   read_queue_data,
   read_queue_empty,
   read_queue_read,
   read_init_full,
   read_init_put,

   read_invalid,
   read_streamblock,
   read_statistics,

   read_data,
   read_addr,
   read_state,

   RREADY,
   RVALID,
   RRESP,
   RDATA,
   ARREADY,
   ARVALID,
   ARADDR,

   write_queue_full,
   write_queue_empty,

   write_valid,
   write_data,
   write_address,
   write_state,

   BREADY,
   BVALID,
   BRESP,
   WREADY,
   WVALID,
   WDATA,
   AWREADY,
   AWVALID
};
*/

assign chipscope_data = {
   latup_rd,
   latup_empty,
   latup_data,
   latency_valid,
   latency,

   read_data,
   read_addr,
   read_state,

   oneshot_go_reg_axil,

   write_valid,
   write_data,
   write_address,
   write_state
};

endmodule
