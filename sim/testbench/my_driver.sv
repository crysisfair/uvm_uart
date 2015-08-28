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

class my_driver extends uvm_driver #(my_trans);

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

  rxif.rx_data <= 8'b0;
  rxif.valid <= 1'b0;

  while(~rxif.rst_n)
    @(posedge rxif.clk);

  while(1)
  begin
    seq_item_port.try_next_item(req);
    if(req == null)
      @(posedge rxif.clk);
    else
    begin
      drive_one_pk(req);
      seq_item_port.item_done();
    end
  end

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
