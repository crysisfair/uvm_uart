`ifndef _BASE_TEST
`define _BASE_TEST
class base_test extends uvm_test;
	my_env env;
	`uvm_component_utils(base_test);

	function new(string name = "my base test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = my_env::type_id::create("env", this);
		uvm_config_db#(uvm_object_wrapper)::set(this, 
			"env.i_ag.sqr.main_phase",
			"default_phase",
			my_sequence::type_id::get());
	endfunction : build_phase

	virtual function void report_phase(uvm_phase phase);
		uvm_report_server server;
		int err_num;
		super.report_phase(phase);

		server = get_report_server();
		err_num  = server.get_severity_count(UVM_ERROR);

		if(err_num != 0) begin
			$display("==========TEST CASE FAILED==========");
		end
		else begin
			$display("==========TEST CASE SUCCESS==========");
		end
	endfunction : report_phase

	virtual function  void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		check_config_usage();
	endfunction : connect_phase
endclass : base_test
`endif