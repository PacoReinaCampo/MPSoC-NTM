class driver extends uvm_driver #(reg_item);              
  `uvm_component_utils(driver)
  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual reg_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual reg_if)::get(this, "", "reg_vif", vif))
      `uvm_fatal("DRV", "Could not get vif")
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      reg_item m_item;
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(m_item);
      drive_item(m_item);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(reg_item m_item);
    vif.sel <= 1;
    vif.addr <= m_item.addr;
    vif.wr <= m_item.wr;
    vif.wdata <= m_item.wdata;
    @ (posedge vif.clk);
    while (!vif.ready)  begin
      `uvm_info("DRV", "Wait until ready is high", UVM_LOW)
      @(posedge vif.clk);
    end

    vif.sel <= 0;  
  endtask
endclass