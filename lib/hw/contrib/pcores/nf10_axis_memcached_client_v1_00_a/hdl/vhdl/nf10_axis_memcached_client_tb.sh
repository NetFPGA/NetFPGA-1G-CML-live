cd $(dirname $0)
rm -rf unittest_build
mkdir  unittest_build
cd     unittest_build
fuse -incremental -prj ../nf10_axis_memcached_client_tb.prj -o nf10_axis_memcached_client_tb.exe work.testbed 
./nf10_axis_memcached_client_tb.exe -tclbatch ../nf10_axis_memcached_client_tb.tcl
