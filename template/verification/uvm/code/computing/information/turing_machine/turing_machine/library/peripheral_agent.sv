class peripheral_agent extends uvm_agent;
  // Utility declaration
  `uvm_component_utils(peripheral_agent)

  // Constructor
  function new(string name = "peripheral_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Driver method instantiation
  peripheral_driver                         driver;

  // Monitor method instantiation
  peripheral_monitor                        monitor;

  // Sequencer method instantiation
  uvm_sequencer #(peripheral_sequence_item) sequencer;

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create sequencer method
    sequencer = uvm_sequencer#(peripheral_sequence_item)::type_id::create("sequencer", this);

    // Create driver method
    driver    = peripheral_driver::type_id::create("driver", this);

    // Create monitor method
    monitor   = peripheral_monitor::type_id::create("monitor", this);
  endfunction

  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connecting the driver and sequencer port
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass
