`ifndef _MY_AGENT
`define _MY_AGENT
class my_agent extends uvm_agent;
	function new(string name = "my agent demo", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	`uvm_component_utils(my_agent);

	my_driver drv;
	my_monitor m;

	uvm_analysis_port #(my_trans) ap; // this analysis_port is just a pointer to port of monitor, and donnot need initialise

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(is_active == UVM_ACTIVE)
		begin
			drv = my_driver::type_id::create("drv", this);
		end
		m = my_monitor::type_id::create("m", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ap = m.ap;
	endfunction

endclass
`endif