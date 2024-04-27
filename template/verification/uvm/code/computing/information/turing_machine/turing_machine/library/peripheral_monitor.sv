class peripheral_monitor extends uvm_monitor;
  // Utility declaration
  `uvm_component_utils(peripheral_monitor)

  // Constructor
  function new(string name = "peripheral_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // UVM analysis port
  uvm_analysis_port #(peripheral_sequence_item) mon_analysis_port;

  // Virtual Interface
  virtual design_if                             vif;

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual design_if)::get(this, "", "design_if", vif)) begin
      `uvm_fatal("MONITOR", "Could not get vif")
    end

    mon_analysis_port = new("mon_analysis_port", this);
  endfunction

  // Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // This task monitors the interface for a complete 
    // transaction and writes into analysis port when complete
    forever begin
      @(vif.cb);
      if (vif.rst) begin
        // Create sequence item method
        peripheral_sequence_item item = peripheral_sequence_item::type_id::create("item");

        item.in  = vif.in;
        item.out = vif.cb.out;
        mon_analysis_port.write(item);
        `uvm_info("MONITOR", $sformatf("Saw item %s", item.convert2str()), UVM_HIGH)
      end
    end
  endtask
endclass
