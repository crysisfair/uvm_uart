`ifndef MY_DRVIER_SV
`define MY_DRVIER_SV

`include "uvm_pkg.sv"
`include "my_transcation.sv"
import uvm_pkg::*;

interface my_rx_if(input clk, input rst_n);
  logic [7:0] rx_data;
  logic valid;
endinterface

interface my_tx_if(input clk, input rst_n);
  logic [7:0] tx_data;
  logic enable;
endinterface

class my_driver extends uvm_driver();

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
  extern virtual task drive_one_pk(my_transcation tr);
  extern virtual task push_data(ref bit[] p, int length, bit[] source);  

endclass
`endif


task my_driver::main_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("from my_driver main", "main phase is called", UVM_LOW);
  my_transcation tr;

  for(int i = 0; i < 255; i++)
  begin
    tr = new ("tr");
    assert(tr.randomize() with {pload.size == 160});
    drive_one_pk(tr);
  end
  phase.drop_objection(this);
endtask

task my_driver::push_data(ref bit[] p_target, int length, bit[] source);
  for(int i = 0; i < (length>>3); i++)
  begin
    p_target.push_back(source[7:0]);
    source = source >> 8;
  end
endtask

task my_driver::drive_one_pk(my_transcation tr);
  bit [47:0] tmp;
  bit [7:0] data_q[$];

  push_data(data_q, 48, tr.dmac);


endtask
