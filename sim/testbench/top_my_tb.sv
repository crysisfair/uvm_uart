`include "uvm_macros.svh"
import uvm_pkg::*;

`include "my_transcation.sv"
`include "my_sequence.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_model.sv"
`include "my_scoreboard.sv"
`include "my_env.sv"
`include "base_test.sv"

module top_tb;

  reg clk, rst_n, rx_dv;
  reg [7:0] rxd;
  wire [7:0] txd;
  wire tx_en;
  
  my_rx_if in_if(clk, rst_n);
  my_rx_if out_if(clk, rst_n);
  dut u1(clk, rst_n, in_if.rx_data, in_if.valid, out_if.rx_data, out_if.valid);
  
  initial
  begin
    run_test("base_test");
  end

  initial
  begin
    uvm_config_db#(virtual my_rx_if)::set(null, "uvm_test_top.env.i_ag.drv", "rxif", in_if);
    uvm_config_db#(virtual my_rx_if)::set(null, "uvm_test_top.env.i_ag.m", "vif", in_if);
    uvm_config_db#(virtual my_rx_if)::set(null, "uvm_test_top.env.o_ag.m", "vif", out_if);
  end
  
  always #10 clk <= ~clk;
  
  initial
  begin
    clk = 1'b0;
    rst_n = 1'b1;
    #50
    rst_n = 1'b0;
    #20
    rst_n = 1'b1;
  end
endmodule
