cd $(dirname $0)
rm -rf unittest_build
mkdir  unittest_build
cd     unittest_build
fuse -incremental -prj ../nf10_decap_tb.prj -o nf10_decap_tb.exe testbench
./nf10_decap_tb.exe -gui
