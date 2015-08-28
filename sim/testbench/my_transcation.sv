`ifndef _MY_TRANSCATION
`define _MY_TRANSCATION

import uvm_pkg::*;

class my_trans extends uvm_sequence_item;
  rand bit[47:0]  dmac;
  rand bit[47:0]  smac;
  rand bit[15:0]  ether_type;
  rand byte       pload[];
  rand bit[31:0]  crc;

  constraint pload_cons {
    pload.size >= 46;
    pload.size <= 1500;
  };

  `uvm_object_utils_begin(my_trans)
    `uvm_field_int(dmac, UVM_ALL_ON)
    `uvm_field_int(smac, UVM_ALL_ON)
    `uvm_field_int(ether_type, UVM_ALL_ON)
    `uvm_field_array_int(pload, UVM_ALL_ON)
    `uvm_field_int(crc, UVM_ALL_ON)
  `uvm_object_utils_end


  function bit[31:0] calc_crc();
    return 32'h1234_5678_9098_7654;
  endfunction

  function void post_rand();
    crc = calc_crc();
  endfunction

  function new(string name = "my_trans_demo");
    super.new(name);
  endfunction

  function void my_print();
    $display("dmac = %0h", dmac);
    $display("smac = %0h", smac);
    $display("ether_type %0h", ether_type);
    for(int i = 0; i < pload.size; i++)
    begin
      $display("pload[%0h] = %0h", i, pload[i]);
    end
  endfunction

  function my_copy(my_trans tr);
    if(tr == null)
    begin
      `uvm_fatal("from trans copy", "param tr cannot be null");
    end

    dmac = tr.dmac;
    smac = tr.smac;
    pload = new [tr.pload.size()];
    for(int i = 0; i < pload.size(); i++)
    begin
      pload[i] = tr.pload[i];
    end
    crc = tr.crc;
  endfunction

  function bit my_compare(my_trans tr);
    bit result;

    if(tr == null)
    begin
      `uvm_fatal("from trans", "null trans!");
    end
    result = ((dmac == tr.dmac) &&
                (smac == tr.smac) &&
                (ether_type == tr.ether_type) &&
                (crc == tr.crc));
      if(pload.size() != tr.pload.size())
         result = 0;
      else 
         for(int i = 0; i < pload.size(); i++) begin
            if(pload[i] != tr.pload[i])
               result = 0;
         end
      return result; 

  endfunction : my_compare

endclass
`endif
