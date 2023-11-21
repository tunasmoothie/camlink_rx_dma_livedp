module axis_video_overlay #
(   
    parameter DATA_WIDTH  = 24,
    parameter USER_WIDTH  = 1
)
(
    /*
     * AXIS input
     */
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axis_clk, ASSOCIATED_BUSIF S_AXIS_VID0:S_AXIS_VID1:M_AXIS, FREQ_HZ"  *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axis_clk CLK" *)
    input  wire                   axis_clk,
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME aresetn, POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    input  wire                   aresetn,
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID0 TDATA"   *)
    input  wire [DATA_WIDTH-1:0]  s_axis_tdata_vid0,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID0 TVALID"  *)
    input  wire                   s_axis_tvalid_vid0,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID0 TREADY"  *)
    output reg                    s_axis_tready_vid0,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID0 TLAST"   *)
    input  wire                   s_axis_tlast_vid0,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID0 TUSER"   *)
    input  wire [USER_WIDTH-1:0]  s_axis_tuser_vid0,
    
    
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID1 TDATA"   *)
    input  wire [DATA_WIDTH-1:0]  s_axis_tdata_vid1,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID1 TVALID"  *)
    input  wire                   s_axis_tvalid_vid1,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID1 TREADY"  *)
    output reg                    s_axis_tready_vid1,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID1 TLAST"   *)
    input  wire                   s_axis_tlast_vid1,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 S_AXIS_VID1 TUSER"   *)
    input  wire [USER_WIDTH-1:0]  s_axis_tuser_vid1,
    
    
    /*
     * AXIS ouptput
     */
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 M_AXIS TDATA"     *)
    output reg [DATA_WIDTH-1:0]  m_axis_tdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 M_AXIS TVALID"    *)
    output reg                   m_axis_tvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 M_AXIS TREADY"    *)
    input  wire                  m_axis_tready,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 M_AXIS TLAST"     *)
    output reg                   m_axis_tlast,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis_rtl:1.0 M_AXIS TUSER"     *)
    output reg [USER_WIDTH-1:0]  m_axis_tuser
    
);
   
   
   wire path_active = s_axis_tvalid_vid0 & s_axis_tvalid_vid1 & m_axis_tready;
   reg active_frame = 0;
   
   wire [7:0] pixel_R;
   wire [7:0] pixel_G;
   wire [7:0] pixel_B;
   
   assign pixel_R = (s_axis_tdata_vid0[23:16] + s_axis_tdata_vid1[23:16]) / 2;
   assign pixel_B = (s_axis_tdata_vid0[15:8]  + s_axis_tdata_vid1[15:8] ) / 2;
   assign pixel_G = (s_axis_tdata_vid0[7:0]   + s_axis_tdata_vid1[7:0]  ) / 2; 
   
    always @ (posedge axis_clk) begin
        active_frame <= ((s_axis_tuser_vid0 & s_axis_tuser_vid1) | (aresetn & active_frame));
    end    
   
   
   always @ (axis_clk) begin
       if (active_frame) begin
           s_axis_tready_vid0 = m_axis_tready & s_axis_tvalid_vid1 ;
           s_axis_tready_vid1 = m_axis_tready & s_axis_tvalid_vid0;
           
           if(s_axis_tvalid_vid0 & s_axis_tvalid_vid1 == 1)
               m_axis_tvalid = 1;
           else
               m_axis_tvalid = 0;
                         
           if(path_active) begin
               m_axis_tdata[23:16] = pixel_R;
               m_axis_tdata[15:8]  = pixel_B;
               m_axis_tdata[7:0]   = pixel_G;
           
               m_axis_tlast = s_axis_tlast_vid0 & s_axis_tlast_vid1;
               m_axis_tuser = s_axis_tuser_vid0 & s_axis_tlast_vid1;
           end    
           
       end
       else begin
           m_axis_tvalid = 0;
           if (s_axis_tuser_vid0 & s_axis_tuser_vid1 == 0) begin
               s_axis_tready_vid0 = 1;
               s_axis_tready_vid1 = 1;
           end
           else if (s_axis_tuser_vid0 == 1) begin
               s_axis_tready_vid0 = 0;
               s_axis_tready_vid1 = 1;
           end
           else begin
               s_axis_tready_vid0 = 1;
               s_axis_tready_vid1 = 0;
           end
       end

   


   end
    
endmodule