// The environment is a container object simply to hold all verification 
// components together. This environment can then be reused later and all
// components in it would be automatically connected and available for use
// This is an environment without a generator.

class env;
  driver d0;           // Driver to design
  monitor m0;          // Monitor from design
  scoreboard s0;       // Scoreboard connected to monitor
  mailbox scb_mbx;     // Top level mailbox for SCB <-> MON 
  virtual reg_if vif;  // Virtual interface handle
  
  // Instantiate all testbench components
  function new();
    d0 = new;
    m0 = new;
    s0 = new;
    scb_mbx = new();
  endfunction
  
  // Assign handles and start all components so that 
  // they all become active and wait for transactions to be
  // available
  virtual task run();
    d0.vif = vif;
    m0.vif = vif;
    m0.scb_mbx = scb_mbx;
    s0.scb_mbx = scb_mbx;
    
    fork
      s0.run();
      d0.run();
      m0.run();
    join_any
  endtask
endclass