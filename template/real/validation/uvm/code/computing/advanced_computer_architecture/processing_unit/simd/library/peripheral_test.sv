`include "peripheral_sequence_item.sv"
`include "peripheral_sequence.sv"
`include "peripheral_driver.sv"
`include "peripheral_monitor.sv"
`include "peripheral_scoreboard.sv"
`include "peripheral_agent.sv"
`include "peripheral_environment.sv"

class peripheral_test extends uvm_test;
  // Utility declaration
  `uvm_component_utils(peripheral_test)

  // Constructor
  function new(string name = "peripheral_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Environment method instantiation
  peripheral_environment               environment;

  bit                            [3:0] pattern     = 4'b1011;

  // Sequence method instantiation
  peripheral_sequence                  seq;

  // Virtual Interface
  virtual design_if                    vif;

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create environment method
    environment = peripheral_environment::type_id::create("environment", this);

    // Get virtual IF handle from top level and pass it to everything
    // in peripheral_environment level
    if (!uvm_config_db#(virtual design_if)::get(this, "", "design_if", vif)) begin
      `uvm_fatal("TEST", "Did not get vif")
    end

    uvm_config_db#(virtual design_if)::set(this, "environment.agent.*", "design_if", vif);

    // Setup pattern queue and place into config db
    uvm_config_db#(bit [3:0])::set(this, "*", "ref_pattern", pattern);

    // Create sequence method
    seq = peripheral_sequence::type_id::create("seq");

    // Randomize sequence method
    seq.randomize();
  endfunction

  // Run phase
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    apply_reset();
    seq.start(environment.agent.sequencer);
    #200;
    phase.drop_objection(this);
  endtask

  virtual task apply_reset();
    vif.rst <= 0;
    vif.in  <= 0;
    repeat (5) @(posedge vif.clk);
    vif.rst <= 1;
    repeat (10) @(posedge vif.clk);
  endtask
endclass
