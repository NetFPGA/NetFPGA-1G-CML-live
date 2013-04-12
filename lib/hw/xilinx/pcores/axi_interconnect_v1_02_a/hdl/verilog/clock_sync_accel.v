// -- (c) Copyright 2010 - 2011 Xilinx, Inc. All rights reserved.
// --
// -- This file contains confidential and proprietary information
// -- of Xilinx, Inc. and is protected under U.S. and 
// -- international copyright and other intellectual property
// -- laws.
// --
// -- DISCLAIMER
// -- This disclaimer is not a license and does not grant any
// -- rights to the materials distributed herewith. Except as
// -- otherwise provided in a valid license issued to you by
// -- Xilinx, and to the maximum extent permitted by applicable
// -- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// -- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// -- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// -- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// -- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// -- (2) Xilinx shall not be liable (whether in contract or tort,
// -- including negligence, or under any other theory of
// -- liability) for any loss or damage of any kind or nature
// -- related to, arising under or in connection with these
// -- materials, including for any direct, or any indirect,
// -- special, incidental, or consequential loss or damage
// -- (including loss of data, profits, goodwill, or any type of
// -- loss or damage suffered as a result of any action brought
// -- by a third party) even if such damage or loss was
// -- reasonably foreseeable or Xilinx had been advised of the
// -- possibility of the same.
// --
// -- CRITICAL APPLICATIONS
// -- Xilinx products are not designed or intended to be fail-
// -- safe, or for use in any application requiring fail-safe
// -- performance, such as life-support or safety devices or
// -- systems, Class III medical devices, nuclear facilities,
// -- applications related to the deployment of airbags, or any
// -- other applications that could lead to death, personal
// -- injury, or severe property or environmental damage
// -- (individually and collectively, "Critical
// -- Applications"). Customer assumes the sole risk and
// -- liability of any use of Xilinx products in Critical
// -- Applications, subject only to applicable laws and
// -- regulations governing limitations on product liability.
// --
// -- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// -- PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// Synchronous clock accelerator
//   Pipeline transfers for one generic AXI channel from a slower to faster clock domain
//   with integer-ratio clock frequency relationship.
//   Use 1-deep pipeline register (back-to-back transfers not possible on fast domain).
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   clock_sync_accel
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps

module clock_sync_accel #
  (
   parameter         C_FAMILY     = "virtex6",
   parameter integer C_DATA_WIDTH = 32,
   parameter integer C_MODE = 0  // 0 = Light-weight, 1 = Fully-registered
   )
  (
   // System Signals
   input wire ACLK,    // Interface clock from faster clock domain
   input wire ARESET,  // Sync'd to ACLK
   input wire SAMPLE,  // Sample-cycle strobe for slower clock domain

   // Slave side (slower clock domain, sync'd to SAMPLE=1 @ACLK)
   input  wire [C_DATA_WIDTH-1:0] S_PAYLOAD_DATA,
   input  wire S_VALID,
   output wire S_READY,

   // Master side (faster clock domain; sync'd to ACLK)
   output  wire [C_DATA_WIDTH-1:0] M_PAYLOAD_DATA,
   output wire M_VALID,
   input  wire M_READY
   );

  localparam [1:0] 
    ZERO = 2'b10,
    ONE  = 2'b11,
    TWO  = 2'b01;

  reg [C_DATA_WIDTH-1:0] storage_data1;
  reg [C_DATA_WIDTH-1:0] storage_data2;
  reg                    s_ready_i; //local signal of output
  reg                    m_valid_i; //local signal of output
  reg [1:0]              state;
  wire                   push;
  wire                   pop;
  reg                    areset_d1;

  // assign local signal to its output signal
  assign S_READY = s_ready_i;
  assign M_VALID = m_valid_i;
  assign M_PAYLOAD_DATA = storage_data1;
  assign push = SAMPLE & S_VALID & s_ready_i;
  assign pop = m_valid_i & M_READY;

  generate
    if (C_MODE == 0) begin : gen_mode_lightwt
      always @(posedge ACLK) begin
        if (s_ready_i) begin
          storage_data1 <= S_PAYLOAD_DATA;        
        end
      end
      
      always @(posedge ACLK) begin
        if (ARESET) begin
          s_ready_i <= 1'b0;
          m_valid_i <= 1'b0;
          areset_d1 <= 1'b1;
        end else begin
          if (SAMPLE) begin
            if (areset_d1) begin
              s_ready_i <= 1'b1;
            end else begin
              s_ready_i <= pop | (~m_valid_i & ~push);
            end
            areset_d1 <= 1'b0;
          end
          if (pop) begin
            m_valid_i <= 1'b0;
          end else if (push) begin
            m_valid_i <= 1'b1;
          end
        end
      end

    end else begin : gen_mode_fully_reg
    
      always @(posedge ACLK) begin
        if (s_ready_i) begin
          storage_data2 <= S_PAYLOAD_DATA;
        end
        if (pop | (state == ZERO)) begin
          storage_data1 <= s_ready_i ? S_PAYLOAD_DATA : storage_data2;
        end
      end
      
      always @(posedge ACLK) begin
        if (ARESET) begin
          s_ready_i <= 1'b0;
          m_valid_i <= 1'b0;
          state <= ZERO;
          areset_d1 <= 1'b1;
        end else begin
          case (state)
            ZERO: begin
              if (SAMPLE) begin
                if (~areset_d1) begin
                  s_ready_i <= 1'b1;
                  if (push) begin
                    m_valid_i <= 1'b1;
                    state <= ONE;
                  end
                end
                areset_d1 <= 1'b0;
              end
            end
            ONE: begin
              if (push & ~pop) begin
                state <= TWO;
              end else if (pop & ~push) begin
                m_valid_i <= 1'b0;
                state <= ZERO;
              end
              if (SAMPLE) begin
                s_ready_i <= pop | ~push;
              end
            end
            TWO: begin
              if (pop) begin
                state <= ONE;
                if (SAMPLE) begin
                  s_ready_i <= 1'b1;
                end
              end
            end
          endcase
        end
      end
    end  // gen_mode
  endgenerate
endmodule
