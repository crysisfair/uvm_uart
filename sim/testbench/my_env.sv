`ifndef _MY_ENV
`define _MY_ENV

class my_env extends uvm_env;
	my_agent i_ag;
	my_agent o_ag;
	my_model mdl;

	uvm_tlm_analysis_fifo #(my_trans) agt_mdl_fifo;

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

		mdl = my_model::type_id::create("mdl", this);
		agt_mdl_fifo = new("agt_mdl_fifo", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		i_ag.ap.connect(agt_mdl_fifo.analysis_export);
		mdl.port.connect(agt_mdl_fifo.blocking_get_export);
	endfunction
endclass

`endif