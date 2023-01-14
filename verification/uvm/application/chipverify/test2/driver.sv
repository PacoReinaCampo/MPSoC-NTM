class driver extends uvm_driver #(switch_item);              
  `uvm_component_utils(driver)
  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual switch_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual switch_if)::get(this, "", "switch_vif", vif))
      `uvm_fatal("DRV", "Could not get vif")
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      switch_item m_item;
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(m_item);
      drive_item(m_item);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(switch_item m_item);
    vif.vld  <= 1;
    vif.addr <= m_item.addr;
    vif.data <= m_item.data;

    @ (posedge vif.clk);
    vif.vld <= 0;
  endtask
endclass