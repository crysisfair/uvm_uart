`ifndef _MY_MONITOR
`define _MY_MONITOR

class my_monitor extends uvm_monitor;
	virtual my_rx_if vif;
	uvm_analysis_port #(my_trans) ap;
	bit is_input_monitor = 0;

	`uvm_component_utils(my_monitor);

	function new(string name = "my monitor demo", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(virtual my_rx_if)::get(this, "", "vif", vif))
		begin
			`uvm_fatal("from my monitor", "rx interface must be set");
		end
		ap = new("ap", this);// analysis_port must be new in build_phase, or it can be accessed directly from env
	endfunction

	extern virtual task main_phase(uvm_phase phase);
	extern virtual task collect_one_pkt(my_trans tr);

endclass

task my_monitor::main_phase(uvm_phase phase);
	my_trans tr;
	while(1)
	begin
		tr = new ("tr");
		collect_one_pkt(tr);
		ap.write(tr);
	end
endtask

task my_monitor::collect_one_pkt(my_trans tr);
	byte unsigned data_q[$];
	byte unsigned data_array[];
	logic [7:0] data;
	logic valid = 0;
	int data_size;

	while(1)
	begin
		@(posedge vif.clk)
		if(vif.valid) break;
	end

	while(vif.valid)
	begin
		data_q.push_back(vif.rx_data);
		@(posedge vif.clk);
	end
	data_size = data_q.size();
	data_array = new[data_size];
	for(int i = 0; i < data_size; i++)
	begin
		data_array[i] = data_q[i];
	end
	if(is_input_monitor)
	begin
		$display("input monitor, data_size %d", data_size);
	end
	else
	begin
		$display("output monitor, data_size %d", data_size);
	end
	tr.pload = new[data_size - 18];
	data_size = tr.unpack_bytes(data_array) / 8;
    //tr.print();
	if(is_input_monitor)
	begin
		`uvm_info("input monitor", "end collect one pkt", UVM_LOW);
	end
	else
	begin
		`uvm_info("output monitor", "end collect one pkt", UVM_LOW);
	end

endtask

`endif