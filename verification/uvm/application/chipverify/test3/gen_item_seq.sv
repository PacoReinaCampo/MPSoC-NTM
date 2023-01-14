class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)
  function new(string name="gen_item_seq");
    super.new(name);
  endfunction

  rand int num;  // Config total number of items to be sent

  constraint c1 { soft num inside {[10:50]}; }

  virtual task body();
    for (int i = 0; i < num; i ++) begin
    Item m_item = Item::type_id::create("m_item");
    start_item(m_item);
    m_item.randomize();
      `uvm_info("SEQ", $sformatf("Generate new item: %s", m_item.convert2str()), UVM_HIGH)
      finish_item(m_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass