`ifndef MY_DRVIER_SV
`define MY_DRVIER_SV

`include "uvm_pkg.sv"
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

endclass
`endif


task my_driver::main_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("from my_driver main", "main phase is called", UVM_LOW);
  rxif.rx_data<= 8'b0;
  rxif.valid <= 1'b0;

  while(rxif.rst_n == 1'b0)
    @(posedge rxif.clk);

  for(int i = 0; i < 255; i++)
  begin
    @(posedge rxif.clk)
    begin
      rxif.rx_data <= $urandom_range(0, 255);
      rxif.valid <= 1'b1;
      `uvm_info("from my_driver", "data direved", UVM_LOW);
      $display(i);
    end
  end

  @(posedge rxif.clk)
    rxif.rx_data<= 1'b0;

  phase.drop_objection(this);
endtask
