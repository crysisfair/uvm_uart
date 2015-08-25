`include "uvm_macros.svh"
import uvm_pkg::*;

`include "my_transcation.sv"
`include "my_driver.sv"
`include "my_env.sv"

module top_tb;

  reg clk, rst_n, rx_dv;
  reg [7:0] rxd;
  wire [7:0] txd;
  wire tx_en;
  
  my_rx_if in_if(clk, rst_n);
  dut u1(clk, rst_n, in_if.rx_data, in_if.valid, txd, tx_en);
  
  initial
  begin
    run_test("my_env");
  end

  initial
  begin
    uvm_config_db#(virtual my_rx_if)::set(null, "uvm_test_top.drv", "rxif", in_if);
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
