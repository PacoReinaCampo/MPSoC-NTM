// This is the base transaction object that will be used
// in the environment to initiate new transactions and 
// capture transactions at DUT interface

class switch_item extends uvm_sequence_item;
  rand bit [ 7:0] addr;
  rand bit [15:0] data;

  bit [ 7:0] addr_a;
  bit [15:0] data_a;
  bit [ 7:0] addr_b;
  bit [15:0] data_b;

  // Use utility macros to implement standard functions
  // like print, copy, clone, etc
  `uvm_object_utils_begin(switch_item)
  `uvm_field_int (addr, UVM_DEFAULT)
  `uvm_field_int (data, UVM_DEFAULT)
  `uvm_field_int (addr_a, UVM_DEFAULT)
  `uvm_field_int (data_a, UVM_DEFAULT)
  `uvm_field_int (addr_b, UVM_DEFAULT)
  `uvm_field_int (data_b, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "switch_item");
    super.new(name);
  endfunction
endclass