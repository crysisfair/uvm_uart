`ifndef MY_DRVIER_SV
`define MY_DRVIER_SV

import uvm_pkg::*;

interface my_rx_if(input clk, input rst_n);
  logic [7:0] rx_data;
  logic valid;
endinterface

interface my_tx_if(input clk, input rst_n);
  logic [7:0] tx_data;
  logic enable;
endinterface

class my_driver extends uvm_driver;

  virtual my_rx_if rxif;
  `uvm_component_utils(my_driver);

  function new (string name = "my_first_driver", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("from my_driver new", "new is called", UVM_LOW);
    $display("name is %s", get_full_name());
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("from my_driver build_phase", "build phase is called", UVM_LOW);
    if(!uvm_config_db#(virtual my_rx_if)::get(this, "", "rxif", rxif))
    begin
      `uvm_fatal("from my_driver build_phase", "virtual interface not set for vif");
    end
  endfunction

  extern virtual task main_phase(uvm_phase phase);
  extern virtual task drive_one_pk(my_trans tr);

endclass
`endif


task my_driver::main_phase(uvm_phase phase);
  my_trans tr;
  phase.raise_objection(this);
  `uvm_info("from my_driver main", "main phase is called", UVM_LOW);

  rxif.rx_data <= 8'b0;
  rxif.valid <= 1'b0;

  for(int i = 0; i < 255; i++)
  begin
    tr = new ("tr");
    assert(tr.randomize() with { pload.size == 160; });
    drive_one_pk(tr);
  end

  repeat(5) @(posedge rxif.clk);
  phase.drop_objection(this);

endtask

task my_driver::drive_one_pk(my_trans tr);
  bit [47:0] tmp_data;
  bit [7:0] data_q[$]; 
  
  //push dmac to data_q
  tmp_data = tr.dmac;
  for(int i = 0; i < 6; i++) begin
     data_q.push_back(tmp_data[7:0]);
     tmp_data = (tmp_data >> 8);
  end

  //push smac to data_q
  tmp_data = tr.smac;
  for(int i = 0; i < 6; i++) begin
     data_q.push_back(tmp_data[7:0]);
     tmp_data = (tmp_data >> 8);
  end

  //push ether_type to data_q
  tmp_data = tr.ether_type;
  for(int i = 0; i < 2; i++) begin
     data_q.push_back(tmp_data[7:0]);
     tmp_data = (tmp_data >> 8);
  end

  //push payload to data_q
  for(int i = 0; i < tr.pload.size; i++) begin
     data_q.push_back(tr.pload[i]);
  end

  //push crc to data_q
  tmp_data = tr.crc;
  for(int i = 0; i < 4; i++) begin
     data_q.push_back(tmp_data[7:0]);
     tmp_data = (tmp_data >> 8);
  end
  `uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
  repeat(3) @(posedge rxif.clk);
   while(data_q.size() > 0) begin
     @(posedge rxif.clk);
     rxif.valid <= 1'b1;
     rxif.rx_data <= data_q.pop_front(); 
  end
  @(posedge rxif.clk);
  rxif.valid <= 1'b0;
  `uvm_info("my_driver", "end drive one pkt", UVM_LOW);

endtask
