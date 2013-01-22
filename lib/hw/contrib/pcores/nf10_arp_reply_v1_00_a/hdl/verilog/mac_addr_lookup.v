module mac_addr_lookup
  #(
    // Master AXI Lite Data Width
    parameter DATA_WIDTH=32,
    parameter ADDR_WIDTH=32
    )
   (
    input [31:0] ip_addr,
    output reg [47:0] mac_addr,
    output reg lookup_success,

    input                        ACLK,
    input                        ARESETN,
    
    input [ADDR_WIDTH-1: 0]      AWADDR,
    input                        AWVALID,
    output reg                   AWREADY,
    
    input [DATA_WIDTH-1: 0]      WDATA,
    input [DATA_WIDTH/8-1: 0]    WSTRB,
    input                        WVALID,
    output reg                   WREADY,
    
    output reg [1:0]             BRESP,
    output reg                   BVALID,
    input                        BREADY,
    
    input [ADDR_WIDTH-1: 0]      ARADDR,
    input                        ARVALID,
    output reg                   ARREADY,
    
    output reg [DATA_WIDTH-1: 0] RDATA, 
    output reg [1:0]             RRESP,
    output reg                   RVALID,
    input                        RREADY
    );

   localparam AXI_RESP_OK = 2'b00;
   localparam AXI_RESP_SLVERR = 2'b10;
   
   localparam WRITE_IDLE = 0;
   localparam WRITE_RESPONSE = 1;
   localparam WRITE_DATA = 2;

   localparam READ_IDLE = 0;
   localparam READ_RESPONSE = 1;

   localparam IP_REG_0 = 8'h00;
   localparam IP_REG_1 = 8'h10;
   localparam IP_REG_2 = 8'h20;
   localparam IP_REG_3 = 8'h30;
   localparam MAC_REG_0_0 = 8'h01;
   localparam MAC_REG_0_1 = 8'h02;
   localparam MAC_REG_1_0 = 8'h11;
   localparam MAC_REG_1_1 = 8'h12;
   localparam MAC_REG_2_0 = 8'h21;
   localparam MAC_REG_2_1 = 8'h22;
   localparam MAC_REG_3_0 = 8'h31;
   localparam MAC_REG_3_1 = 8'h32;

   reg [1:0]                     write_state, write_state_next;
   reg [1:0]                     read_state, read_state_next;
   reg [ADDR_WIDTH-1:0]          read_addr, read_addr_next;
   reg [ADDR_WIDTH-1:0]          write_addr, write_addr_next;
   reg [1:0]                     BRESP_next;

   reg [31:0]                    ip_reg_0, ip_reg_0_next;
   reg [31:0]                    ip_reg_1, ip_reg_1_next;
   reg [31:0]                    ip_reg_2, ip_reg_2_next;
   reg [31:0]                    ip_reg_3, ip_reg_3_next;
   reg [47:0]                    mac_reg_0, mac_reg_0_next;
   reg [47:0]                    mac_reg_1, mac_reg_1_next;
   reg [47:0]                    mac_reg_2, mac_reg_2_next;
   reg [47:0]                    mac_reg_3, mac_reg_3_next;
   
   always @(*) begin
      read_state_next = read_state;   
      ARREADY = 1'b1;
      read_addr_next = read_addr;
      RDATA = 0; 
      RRESP = AXI_RESP_OK;
      RVALID = 1'b0;
      
      case(read_state)
        READ_IDLE: begin
           if(ARVALID) begin
              read_addr_next = ARADDR;
              read_state_next = READ_RESPONSE;
           end
        end        
        
        READ_RESPONSE: begin
           RVALID = 1'b1;
           ARREADY = 1'b0;

           if(read_addr[7:0] == IP_REG_0) begin
              RDATA = ip_reg_0;
           end
           else if(read_addr[7:0] == IP_REG_1) begin
              RDATA = ip_reg_1;
           end
           else if(read_addr[7:0] == IP_REG_2) begin
              RDATA = ip_reg_2;
           end
           else if(read_addr[7:0] == IP_REG_3) begin
              RDATA = ip_reg_3;
           end
           else if(read_addr[7:0] == MAC_REG_0_0) begin
              RDATA = mac_reg_0[31:0];
           end
           else if(read_addr[7:0] == MAC_REG_0_1) begin
              RDATA[31:16] = 16'h0;
              RDATA[15:0] = mac_reg_0[47:32];
           end
           else if(read_addr[7:0] == MAC_REG_1_0) begin
              RDATA = mac_reg_1[31:0];
           end
           else if(read_addr[7:0] == MAC_REG_1_1) begin
              RDATA[31:16] = 16'h0;
              RDATA[15:0] = mac_reg_1[47:32];
           end
           else if(read_addr[7:0] == MAC_REG_2_0) begin
              RDATA = mac_reg_2[31:0];
           end
           else if(read_addr[7:0] == MAC_REG_2_1) begin
              RDATA[31:16] = 16'h0;
              RDATA[15:0] = mac_reg_2[47:32];
           end
           else if(read_addr[7:0] == MAC_REG_3_0) begin
              RDATA = mac_reg_3[31:0];
           end
           else if(read_addr[7:0] == MAC_REG_3_1) begin
              RDATA[31:16] = 16'h0;
              RDATA[15:0] = mac_reg_3[47:32];
           end
           else begin
              RRESP = AXI_RESP_SLVERR;
           end

           if(RREADY) begin
              read_state_next = READ_IDLE;
           end
        end
      endcase
   end
   
   always @(*) begin
      write_state_next = write_state;
      write_addr_next = write_addr;

      AWREADY = 1'b1;
      WREADY = 1'b0;
      BVALID = 1'b0;  
      BRESP_next = BRESP;

      ip_reg_0_next = ip_reg_0;
      ip_reg_1_next = ip_reg_1;
      ip_reg_2_next = ip_reg_2;
      ip_reg_3_next = ip_reg_3;
      mac_reg_0_next = mac_reg_0;
      mac_reg_1_next = mac_reg_1;
      mac_reg_2_next = mac_reg_2;
      mac_reg_3_next = mac_reg_3;

      case(write_state)
        WRITE_IDLE: begin
           write_addr_next = AWADDR;
           if(AWVALID) begin
              write_state_next = WRITE_DATA;
           end
        end
        WRITE_DATA: begin
           AWREADY = 1'b0;
           WREADY = 1'b1;
           if(WVALID) begin
              if(write_addr[7:0] == IP_REG_0) begin
                 ip_reg_0_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_REG_1) begin
                 ip_reg_1_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_REG_2) begin
                 ip_reg_2_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == IP_REG_3) begin
                 ip_reg_3_next = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_0_0) begin
                 mac_reg_0_next[31:0] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_0_1) begin
                 mac_reg_0_next[47:32] = WDATA[15:0];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_1_0) begin
                 mac_reg_1_next[31:0] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_1_1) begin
                 mac_reg_1_next[47:32] = WDATA[15:0];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_2_0) begin
                 mac_reg_2_next[31:0] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_2_1) begin
                 mac_reg_2_next[47:32] = WDATA[15:0];
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_3_0) begin
                 mac_reg_3_next[31:0] = WDATA;
                 BRESP_next = AXI_RESP_OK;
              end
              else if(write_addr[7:0] == MAC_REG_3_1) begin
                 mac_reg_3_next[47:32] = WDATA[15:0];
                 BRESP_next = AXI_RESP_OK;
              end
              else begin
                 BRESP_next = AXI_RESP_SLVERR;
              end
              write_state_next = WRITE_RESPONSE;
           end
        end
        WRITE_RESPONSE: begin
           AWREADY = 1'b0;
           BVALID = 1'b1;
           if(BREADY) begin                    
              write_state_next = WRITE_IDLE;
           end
        end
      endcase
   end

   always @(posedge ACLK) begin
      if(~ARESETN) begin
         write_state <= WRITE_IDLE;
         read_state <= READ_IDLE;
         read_addr <= 0;
         write_addr <= 0;
         BRESP <= AXI_RESP_OK;

         ip_reg_0 <= 32'h6401A8C0;
         ip_reg_1 <= 32'h6501A8C0;
         ip_reg_2 <= 32'h6601A8C0;
         ip_reg_3 <= 32'h6701A8C0;
         mac_reg_0 <= 48'h112233445566;
         mac_reg_1 <= 48'h223344556677;
         mac_reg_2 <= 48'h334455667788;
         mac_reg_3 <= 48'h445566778899;

      end
      else begin
         write_state <= write_state_next;
         read_state <= read_state_next;
         read_addr <= read_addr_next;
         write_addr <= write_addr_next;
         BRESP <= BRESP_next;

         ip_reg_0 <= ip_reg_0_next;
         ip_reg_1 <= ip_reg_1_next;
         ip_reg_2 <= ip_reg_2_next;
         ip_reg_3 <= ip_reg_3_next;
         mac_reg_0 <= mac_reg_0_next;
         mac_reg_1 <= mac_reg_1_next;
         mac_reg_2 <= mac_reg_2_next;
         mac_reg_3 <= mac_reg_3_next;

      end
   end

   always @(*) begin
      lookup_success = 0;
      if(ip_addr==ip_reg_0) begin
         lookup_success = 1;
         mac_addr = mac_reg_0;
      end
      else if(ip_addr==ip_reg_1) begin
         lookup_success = 1;
         mac_addr = mac_reg_1;
      end
      else if(ip_addr==ip_reg_2) begin
         lookup_success = 1;
         mac_addr = mac_reg_2;
      end
      else if(ip_addr==ip_reg_3) begin
         lookup_success = 1;
         mac_addr = mac_reg_3;
      end
   end
endmodule
