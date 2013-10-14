//////////////////////////////////////////////////////////////////////////////
// vim:set shiftwidth=3 softtabstop=3 expandtab:
//
// Module: barrier_ctrl.v
// Project: NetFPGA-1G board testbench
// Description: Barrier control module. Aggregates barrier good notifications
// from individual modules and pushes out a global barrier good notification
// when all modules are ready.
//
///////////////////////////////////////////////////////////////////////////////

// `timescale 1 ns/1 ns
module nf10_barrier #(
   parameter NUM_PORTS = 4
)
(
   input [NUM_PORTS:0] activity_stim, 
   input [NUM_PORTS:0] activity_rec,
   input activity_trans_sim,
   input activity_trans_log,
   input [NUM_PORTS:0] barrier_req, 
   input barrier_req_trans,
   output reg barrier_proceed
);

// Time to wait before declaring the system "stuck" when we have a barrier
// and not all modules are ready to proceed.
//
parameter INACTIVITY_TIMEOUT = 1500;
time req_time;
reg timeout;
wire [NUM_PORTS:0] activity;
wire activity_trans;

assign activity = {activity_stim[4] || activity_rec[4],activity_stim[3] || activity_rec[3],activity_stim[2] || activity_rec[2],activity_stim[1] || activity_rec[1],activity_stim[0] || activity_rec[0]};

assign activity_trans = {activity_trans_sim || activity_trans_log};

initial
begin
   barrier_proceed = 0;
   timeout = 0;

   forever begin
      wait ({barrier_req, barrier_req_trans} != 'h0);

      req_time = $time;
      timeout = 0;
      #1;

      // Wait until either all ports are asserting a barrier request,
      // none of the ports are asserting a barrier request, or a timeout
      // occurs waiting for the barrier
      wait (({barrier_req, barrier_req_trans} === {(NUM_PORTS+2){1'b1}}) ||
            ({barrier_req, barrier_req_trans} === 'h0) || timeout);

      if (timeout == 1) begin
         $display($time," %m Error: timeout exceeded waiting for barrier");
         $finish;
      end
      else if ({barrier_req, barrier_req_trans} === {(NUM_PORTS+2){1'b1}}) begin
         // Barrier request from all modules

         barrier_proceed = 1;

         wait ({barrier_req, barrier_req_trans} === 'h0);

         barrier_proceed = 0;
      end      
   end  
end

initial
begin
   forever begin
      wait ({barrier_req, barrier_req_trans} != 'h0 && {activity, activity_trans} != 'h0);

      req_time = $time;
      #1;
   end
end

initial
begin
   forever begin
      
      if ({barrier_req, barrier_req_trans} != 'h0) begin
         while ({barrier_req, barrier_req_trans} != 'h0) begin
            #1;
            #(req_time + INACTIVITY_TIMEOUT - $time);
            if ({barrier_req, barrier_req_trans} != 'h0 && req_time + INACTIVITY_TIMEOUT <= $time)
               timeout = 1;
         end
      end
      else begin
         wait ({barrier_req, barrier_req_trans} != 'h0);
      end
   end
end

endmodule // barrier_ctrl
