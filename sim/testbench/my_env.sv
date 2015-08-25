`ifndef _MY_ENV
`define _MY_ENV

class my_env extends uvm_env;
	my_agent i_ag;
	my_agent o_ag;

	`uvm_component_utils(my_env);

	function new (string name = "my_env_demo", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		i_ag = my_agent::type_id::create("i_ag", this);
		o_ag = my_agent::type_id::create("o_ag", this);
		i_ag.is_active = UVM_ACTIVE;
		o_ag.is_active = UVM_PASSIVE;
	endfunction
endclass

`endif