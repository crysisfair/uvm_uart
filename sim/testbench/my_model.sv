`ifndef _MY_MODEL
`define _MY_MODEL
class my_model extends uvm_component;

	uvm_blocking_get_port #(my_trans) port;
	uvm_analysis_port #(my_trans) ap;

	`uvm_component_utils(my_model);
	function new(string name="my model demo", uvm_component parent = null);
		super.new(name, parent);

		`uvm_info("from my model", "my model new is called", UVM_LOW);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("from my model", "my model build phase is called", UVM_LOW);
		port = new("port", this);
		ap = new("ap", this);
	endfunction

	extern virtual task main_phase(uvm_phase);
endclass

task my_model::main_phase(uvm_phase phase);
	my_trans tr;
	my_trans new_tr;
	super.main_phase(phase);
	`uvm_info("from my model", "my model main phase is called", UVM_LOW);
	while(1)
	begin
		port.get(tr);
		new_tr = new("new_tr");
		new_tr.copy(tr);
		`uvm_info("from my model", "get one trans, copy and display", UVM_LOW);
		ap.write(new_tr);
	end
endtask
`endif