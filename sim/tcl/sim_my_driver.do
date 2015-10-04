vlib work
vmap work work
set UVM_HOME D:/soft/questasim_10.2c/verilog_src/uvm-1.1d
vlog +acc -work work +incdir+$UVM_HOME/src +incdir+../sim/testbench -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUpf  -incr -f ../sim/filelist/my_driver.filelist
vsim -c -sv_lib $UVM_HOME/lib/uvm_dpi -l ./work/vsim_my_drive.log work.top_tb
add wave sim:/top_tb/u1/*
radix -hex
run 1ms
