# set variables and create project
set project_name vivado_work
set hdl_dir hdl/verilog/xilinx
set ip_name pcie_7x

# keep this directory from filling up with old logs and journals
exec rm -f [glob -nocomplain *.backup.jou]
exec rm -f [glob -nocomplain *.backup.log]

create_project -force $ip_name $project_name

set_property part xc7k325tffg676-1 [current_project]

# add PCIe IP
set pcie_7x_xci [create_ip -name pcie_7x -vendor xilinx.com -library ip -version 3.1 -module_name pcie_7x]

# set desired PCIe properties
# allow remaining properties to default
set_property -dict [list \
 CONFIG.en_ext_clk         {false} \
 CONFIG.Maximum_Link_Width {X4} \
 CONFIG.mode_selection     {Basic} \
 CONFIG.Link_Speed         {2.5_GT/s} \
 CONFIG.Interface_Width    {64_bit} \
 CONFIG.Device_ID          {4244} \
 CONFIG.Max_Payload_Size   {512_bytes} \
 CONFIG.Trans_Buf_Pipeline {None} \
 CONFIG.Bar0_64bit         {true} \
 CONFIG.Bar0_Enabled       {true} \
 CONFIG.Bar0_Size          {8} \
 CONFIG.Bar2_64bit         {true} \
 CONFIG.Bar2_Enabled       {true} \
 CONFIG.Bar2_Size          {2} \
 CONFIG.Bar2_Scale         {Megabytes} \
 CONFIG.Bar2_Type          {Memory} \
 CONFIG.Base_Class_Menu    {Network_controller} \
 CONFIG.Class_Code_Base    {02} \
 CONFIG.Class_Code_Sub     {00} \
 CONFIG.PCIe_Debug_Ports   {false} \
 CONFIG.Subsystem_ID       {4244} \
 CONFIG.User_Clk_Freq      {125} \
 CONFIG.Sub_Class_Interface_Menu {Ethernet_controller} \
 ] [get_ips pcie_7x]

# generate PCIe synthesis files
generate_target synthesis [get_files $pcie_7x_xci]

exit
