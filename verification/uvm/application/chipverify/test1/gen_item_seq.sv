class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)
  function new(string name="gen_item_seq");
    super.new(name);
  endfunction

  rand int num;  // Configure total number of items to be sent

  constraint c1 { soft num inside {[2:5]}; }

  virtual task body();
    for (int i = 0; i < num; i ++) begin
      reg_item m_item = reg_item::type_id::create("m_item");
      start_item(m_item);
      m_item.randomize();
      `uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
      m_item.print();
      finish_item(m_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass