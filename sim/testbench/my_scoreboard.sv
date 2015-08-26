`ifndef _MY_SCOREBOARD
`define _MY_SCOREBOARD

class my_score extends uvm_scoreboard;
	`uvm_component_utils(my_score);

	uvm_blocking_get_port #(my_trans) act_port;
	uvm_blocking_get_port #(my_trans) exp_port;
	my_trans exp_queue[$];

	function  new(string name = "my scoreboard demo", uvm_component parent = null);
		super.new(name, parent);
	endfunction :  new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		act_port = new("act_port", this);
		exp_port = new("exp_port", this);
	endfunction : build_phase

	virtual task main_phase(uvm_phase phase);
		my_trans get_expect, get_actual, tmp_trans;
		bit result;

		fork
			while(1)
			begin
				exp_port.get(get_expect);
			end
			while(1)
			begin
				exp_queue.push_back(get_expect);
			end
			while(1)
			begin
				act_port.get(get_actual);
				if(exp_queue.size() > 0)
				begin
					tmp_trans = exp_queue.pop_front();
					result = get_actual.compare(tmp_trans);
					if(result)
					begin
						`uvm_info("from scoreboard", "compare OK!", UVM_LOW);
					end
					else
					begin
						`uvm_error("from scoreboar", "compare ERROR");
					end
				end
				else
				begin
					`uvm_error("from scoreboard", "received from DUT, but no pkt from model");
				end
			end
		join
	endtask
endclass : my_score

`endif