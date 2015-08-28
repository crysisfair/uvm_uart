`ifndef _MY_SEQUENCE
`define _MY_SEQUENCE
class my_sequence extends uvm_sequence #(my_trans);
	my_trans m_trans;

	`uvm_object_utils(my_sequence);

	function new(string name = "null");
		super.new(name);
	endfunction : new

	virtual task body();
	if(starting_phase !=null)
		starting_phase.raise_objection(this);
	repeat(10) 
		begin
			`uvm_do(m_trans);
		end
		#1000;
	if(starting_phase !=null)
		starting_phase.drop_objection(this);
	endtask : body
 endclass : my_sequence
 `endif