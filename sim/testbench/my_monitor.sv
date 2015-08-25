`ifndef _MY_MONITOR
`define _MY_MONITOR

class my_monitor extends uvm_monitor;
	virtual my_rx_if rx_if;

	`uvm_component_utils(my_monitor);

	virtual function void build_phase(uvm_phase phase);
		super.new(phase);

		if(config_db#(virtual my_rx_if)::get(this, "", "rx_if", rx_if))
		begin
			`uvm_fatal("from my monitor", "rx interface must be set");
		end
	endfunction

	extern virtual task main_phase(uvm_phase phase);
	extern virtual task collect_one_pkt(my_trans tr);

endclass

task my_monitor::main_phase(uvm_phase phase);
	my_trans tr;
	while(1)
	begin
		tr = new ("recv tr");
		collect_one_pkt(tr);
	end
endtask

task my_monitor::collect_one_pkt(my_trans tr);
	bit[7:0] data_q[$];
	int psize;

	while(1)
	begin
		@(posedge rx_if.clk)
		if(rx_if.valid) break;
	end

	`uvm_info("from monitor", "start get trans", UVM_LOW);

	while(rx_if.valid)
	begin
		data_q.push_back(rx_if.rx_data);
		@(posedge rx_if.clk);
	end
	//pop dmac
   for(int i = 0; i < 6; i++) begin
      tr.dmac = {tr.dmac[39:0], data_q.pop_front()};
   end
   //pop smac
   for(int i = 0; i < 6; i++) begin
      tr.smac = {tr.smac[39:0], data_q.pop_front()};
   end
   //pop ether_type
   for(int i = 0; i < 2; i++) begin
      tr.ether_type = {tr.ether_type[7:0], data_q.pop_front()};
   end

   psize = data_q.size() - 4;
   tr.pload = new[psize];
   //pop payload
   for(int i = 0; i < psize; i++) begin
      tr.pload[i] = data_q.pop_front();
   end
   //pop crc
   for(int i = 0; i < 4; i++) begin
      tr.crc = {tr.crc[23:0], data_q.pop_front()};
   end
   `uvm_info("my_monitor", "end collect one pkt, print it:", UVM_LOW);
    tr.print();

endtask

`endif