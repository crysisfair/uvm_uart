module dut(clk, rst_n, rxd, rx_dv, txd, tx_en);
  input clk, rst_n;
  input [7:0] rxd;
  input rx_dv;
  output reg [7:0] txd;
  output reg tx_en;

  always@(posedge clk or negedge rst_n)
  begin
    if(~rst_n)
    begin
      txd <= 8'b0;
      tx_en <= 1'b0;
    end
    else
    begin
      txd <= rxd;
      tx_en <= rx_dv;
    end
  end

  property trans;
    @(posedge clk) (rx_dv == 1'b1) |=> (tx_en == 1'b1);
  endproperty

  property datas;
    @(posedge clk) (rx_dv == 1'b1) |=> (txd == rxd);
  endproperty

  test_trans  : assert property (trans);
  test_data   : assert property (datas);
endmodule
