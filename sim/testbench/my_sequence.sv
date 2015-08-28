`ifndef _MY_SEQUENCE
`define _MY_SEQUENCE
class my_sequence extends uvm_sequence #(my_trans);
	my_trans m_trans;

	`uvm_object_utils(my_sequence);

	function new(string name = "null");
		super.new(name);
	endfunction : new

	virtual task body();
		repeat(10) 
		begin
			`uvm_do(m_trans);
		end
		#1000;
	endtask : body
 endclass : my_sequence
 `endif