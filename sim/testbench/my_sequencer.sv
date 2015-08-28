`ifndef  _MY_SEQUENCER
`define _MY_SEQUENCER
class my_sequencer extends uvm_sequencer #(my_trans);
	function new(string name = "my sequencer demo", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	`uvm_component_utils(my_sequencer);
endclass
`endif