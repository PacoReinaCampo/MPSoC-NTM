class peripheral_environment extends uvm_env;
  // Utility declaration
  `uvm_component_utils(peripheral_environment)

  // Constructor
  function new(string name = "peripheral_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Agent method instantiation
  peripheral_agent      agent;

  // ScoreBoard method instantiation
  peripheral_scoreboard scoreboard;

  // Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create agent method
    agent      = peripheral_agent::type_id::create("agent", this);

    // Create scoreboard method
    scoreboard = peripheral_scoreboard::type_id::create("scoreboard", this);
  endfunction

  // Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connecting the driver and sequencer port
    agent.monitor.mon_analysis_port.connect(scoreboard.m_analysis_imp);
  endfunction
endclass
