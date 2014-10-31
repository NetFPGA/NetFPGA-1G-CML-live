// 64bit x WC_MAX Buffer featuring
//   1x WC_MAX   x 64bit read port
//   1x 2*WC_MAX x 32bit read port
//   1x 2*WC_MAX x 32bit write port

module nf10_axis_memcached_streambuffer #(
   parameter WC_MAX   = 190,
   parameter WC_WIDTH = 8    // must hold WC_MAX-1
) (
   input                 ACLK,

   input  [WC_WIDTH-1:0] rd64_addr,
   output [        63:0] rd64_data,

   input  [  WC_WIDTH:0] rd32_addr,
   output [        31:0] rd32_data,

   input  [  WC_WIDTH:0] wr32_addr,
   input  [        31:0] wr32_data,
   input                 wr32_en
);

reg [31:0] buffer_lo[WC_MAX-1:0];
reg [31:0] buffer_hi[WC_MAX-1:0];

reg [WC_WIDTH-1:0] rd64_addr_reg;
reg [WC_WIDTH-1:0] rd32_addr_reg;
reg                rd32_addr_lsb;

wire [WC_WIDTH-1:0] wr32_a = wr32_addr[WC_WIDTH:1];
wire wr32_lo = wr32_en & ~wr32_addr[0];
wire wr32_hi = wr32_en &  wr32_addr[0];

always @ (posedge ACLK) begin
   if(wr32_lo) buffer_lo[wr32_a] <= wr32_data;
   if(wr32_hi) buffer_hi[wr32_a] <= wr32_data;
   rd64_addr_reg <= rd64_addr;
   rd32_addr_reg <= rd32_addr[WC_WIDTH:1];
   rd32_addr_lsb <= rd32_addr[0];
end

assign rd32_data = rd32_addr_lsb ? buffer_hi[rd32_addr_reg] :
                                   buffer_lo[rd32_addr_reg] ;

assign rd64_data = {buffer_hi[rd64_addr_reg], buffer_lo[rd64_addr_reg]};

endmodule
