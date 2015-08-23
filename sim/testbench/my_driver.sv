`ifndef MY_DRVIER_SV
`define MY_DRVIER_SV

`include "uvm_pkg.sv"
import uvm_pkg::*;

class my_driver extends uvm_driver();

  `uvm_component_utils(my_driver);
  function new (string name = "my_first_driver", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("from my_driver new", "new is called", UVM_LOW);
    $display("name is %s", get_full_name());
  endfunction

  extern virtual task main_phase(uvm_phase phase);

endclass
`endif

task my_driver::main_phase(uvm_phase phase);
  phase.raise_objection(this);
  `uvm_info("from my_driver main", "main phase is called", UVM_LOW);
  top_tb.rxd <= 8'b0;
  top_tb.rx_dv <= 1'b0;

  while(top_tb.rst_n == 1'b0)
    @(posedge top_tb.clk);

  for(int i = 0; i < 255; i++)
  begin
    @(posedge top_tb.clk)
    begin
      top_tb.rxd <= $urandom_range(0, 255);
      top_tb.rx_dv <= 1'b1;
      `uvm_info("from my_driver", "data direved", UVM_LOW);
      $display(i);
    end
  end

  @(posedge top_tb.clk)
    top_tb.rx_dv <= 1'b0;

  phase.drop_objection(this);
endtask
