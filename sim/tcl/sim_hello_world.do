set UVM_HOME H:/soft/modeltech_10.0c/uvm-1.1d
vlog +incdir+$UVM_HOME/src -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUpf ../sim/testbench/hello_word.sv
vsim -c -sv_lib $UVM_HOME/lib/uvm_dpi -l ./work/vsim.log work.hello_world_example
run 100ns
