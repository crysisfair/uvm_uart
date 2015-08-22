vlib work
vmap work work
vlog +acc -work work +incdir+$UVM_HOME/src -L mtiAvm -L mtiOvm -L mtiUvm -L mtiUpf -f ../sim/filelist/hello_world.f
vsim -c -sv_lib $UVM_HOME/lib/uvm_dpi -l ./work/vsim.log work.hello_world_example
run 100ns
