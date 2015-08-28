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

  for(int i = 0; i < 10; i++)
  begin
    tr = new ("tr");
    assert(tr.randomize() with { pload.size == 160; });
    drive_one_pk(tr);
  end

  repeat(5) @(posedge rxif.clk);
  phase.drop_objection(this);

endtask

task my_driver::drive_one_pk(my_trans tr);
  byte unsigned data_q[];
  int data_size;

  data_size = tr.pack_bytes(data_q) / 8;
  $display("drv trans data_size  %d", data_size);
  repeat(3) @(posedge rxif.clk);
  for(int i = 0; i < data_size; i++)
  begin
    @(posedge rxif.clk);
    rxif.valid <= 1'b1;
    rxif.rx_data <= data_q[i];
  end

  @(posedge rxif.clk);
  rxif.valid <= 1'b0;
  `uvm_info("my_driver", "end drive one pkt", UVM_LOW);

endtask
