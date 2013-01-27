///////////////////////////////////////////////////////////////////////////////
// vim:set shiftwidth=3 softtabstop=3 expandtab:
// $Id: op_lut_hdr_parser.v 5240 2009-03-14 01:50:42Z grg $
//
// Module: op_lut_hdr_parser.v
// Project: NF2.1
// Description: Checks if the packet is arriving from the CPU or not
//
///////////////////////////////////////////////////////////////////////////////

  module op_lut_hdr_parser
    #(parameter C_S_AXIS_DATA_WIDTH=256,
      parameter C_S_AXIS_TUSER_WIDTH=128,
      parameter NUM_QUEUES = 8,
      parameter NUM_QUEUES_WIDTH = log2(NUM_QUEUES)
      )
   (// --- Interface to the previous stage
    input  [C_S_AXIS_DATA_WIDTH-1:0]   tdata,
    input  [C_S_AXIS_TUSER_WIDTH-1:0]  tuser,
    input		 	       valid,
    input  			       tlast,

    // --- Interface to process block
    output                             is_from_cpu,
    output     [NUM_QUEUES-1:0]        to_cpu_output_port,   // where to send pkts this pkt if it has to go to the CPU
    output     [NUM_QUEUES-1:0]        from_cpu_output_port, // where to send this pkt if it is coming from the CPU
    output     [NUM_QUEUES_WIDTH-1:0]  input_port_num,
    input                              rd_hdr_parser,
    output                             is_from_cpu_vld,

    // --- Misc

    input                              reset,
    input                              clk
   );

   function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
   endfunction // log2

   //------------------ Internal Parameter ---------------------------

   localparam PARSE_HDRS = 0;
   localparam WAIT_EOP   = 1;
   localparam C_AXIS_SRC_PORT_POS = 16;
   localparam C_AXIS_DST_PORT_POS = 24;


   //---------------------- Wires/Regs -------------------------------
   reg                                 state, state_next;
   reg                                 wr_en;
   wire                                empty;

   wire                                is_from_cpu_found;
   wire [NUM_QUEUES-1:0]               to_cpu_output_port_result;
   wire [NUM_QUEUES-1:0]               from_cpu_output_port_result;
   wire [NUM_QUEUES-1:0]               in_port;
   reg  [NUM_QUEUES_WIDTH-1:0]	       in_port_num; 	

   //----------------------- Modules ---------------------------------
   fallthrough_small_fifo #(.WIDTH(1 + 2*NUM_QUEUES + NUM_QUEUES_WIDTH), .MAX_DEPTH_BITS(2))
      is_from_cpu_fifo
        (.din ({is_from_cpu_found, to_cpu_output_port_result, from_cpu_output_port_result, in_port_num}),     // Data in
         .wr_en (wr_en),             // Write enable
         .rd_en (rd_hdr_parser),       // Read the next word
         .dout ({is_from_cpu, to_cpu_output_port, from_cpu_output_port, input_port_num}),
         .full (),
         .nearly_full (),
         .prog_full (),
         .empty (empty),
         .reset (reset),
         .clk (clk)
         );

   //------------------------ Logic ----------------------------------
   assign is_from_cpu_vld = !empty;

   assign in_port = tuser[C_AXIS_SRC_PORT_POS+NUM_QUEUES-1:C_AXIS_SRC_PORT_POS];
   assign is_from_cpu_found = |(in_port & {(NUM_QUEUES/2){2'b10}});
   assign to_cpu_output_port_result = {in_port[NUM_QUEUES-2:0], 1'b0}; // odd numbers are CPU ports
   assign from_cpu_output_port_result = {1'b0, in_port[NUM_QUEUES-1:1]};// even numbers are MAC ports

   always @(*) begin
       in_port_num = 0;
       case (in_port)
            8'b0000_0001: in_port_num = 0;
            8'b0000_0010: in_port_num = 1;
            8'b0000_0100: in_port_num = 2;
            8'b0000_1000: in_port_num = 3;
            8'b0001_0000: in_port_num = 4;
            8'b0010_0000: in_port_num = 5;
            8'b0100_0000: in_port_num = 6;
            8'b1000_0000: in_port_num = 7;
            default     : in_port_num = 0;
        endcase
     end


   always@(*) begin
      state_next = state;
      wr_en = 0;
      case(state)
        PARSE_HDRS: begin
           if(valid) begin
	      state_next = WAIT_EOP;
              wr_en = 1;
           end
        end

        WAIT_EOP: begin
           if(valid && tlast) begin
              state_next = PARSE_HDRS;
           end
        end
      endcase // case(state)
   end // always@ (*)

   always @(posedge clk) begin
      if(reset) begin
         state <= PARSE_HDRS;
      end
      else begin
         state <= state_next;
      end
   end

endmodule // eth_parser
