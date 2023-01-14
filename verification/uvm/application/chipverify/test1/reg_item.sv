class reg_item extends uvm_sequence_item;
  rand bit [`ADDR_WIDTH-1:0] addr;
  rand bit [`DATA_WIDTH-1:0] wdata;

  rand bit wr;

  bit [`DATA_WIDTH-1:0] rdata;  

  // Use utility macros to implement standard functions
  // like print, copy, clone, etc
  `uvm_object_utils_begin(reg_item)
  `uvm_field_int (addr, UVM_DEFAULT)
  `uvm_field_int (wdata, UVM_DEFAULT)
  `uvm_field_int (rdata, UVM_DEFAULT)
  `uvm_field_int (wr, UVM_DEFAULT)
  `uvm_object_utils_end

  virtual function string convert2str();
    return $sformatf("addr=0x%0h wr=0x%0h wdata=0x%0h rdata=0x%0h", addr, wr, wdata, rdata);
  endfunction

  function new(string name = "reg_item");
    super.new(name);
  endfunction
endclass