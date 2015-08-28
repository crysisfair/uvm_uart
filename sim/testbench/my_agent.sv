`ifndef _MY_AGENT
`define _MY_AGENT
class my_agent extends uvm_agent;
	function new(string name = "my agent demo", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	`uvm_component_utils(my_agent);

	my_driver drv;
	my_monitor m;
	my_sequencer sqr;

	uvm_analysis_port #(my_trans) ap; // this analysis_port is just a pointer to port of monitor, and donnot need initialise

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(is_active == UVM_ACTIVE)
		begin
			drv = my_driver::type_id::create("drv", this);
			sqr = my_sequencer::type_id::create("sqr", this);
		end
		m = my_monitor::type_id::create("m", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(is_active == UVM_ACTIVE)
		begin
			drv.seq_item_port.connect(sqr.seq_item_export);
		end
		ap = m.ap;
	endfunction

	virtual task main_phase(uvm_phase phase);
		super.main_phase(phase);
		if(is_active) m.is_input_monitor = 1;
	endtask : main_phase

endclass
`endif