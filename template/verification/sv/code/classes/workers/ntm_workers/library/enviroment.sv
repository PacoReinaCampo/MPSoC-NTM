class enviroment;
  driver d0;      // Driver handle
  monitor m0;     // Monitor handle
  generator g0;   // Generator Handle
  scoreboard s0;  // Scoreboard handle

  mailbox drv_mbx;  // Connect GEN -> DRV
  mailbox scb_mbx;  // Connect MON -> SCB
  event drv_done;   // Indicates when driver is done

  virtual switch_if vif;  // Virtual interface handle

  function new();
    d0 = new;
    m0 = new;
    g0 = new;
    s0 = new;
    drv_mbx = new();
    scb_mbx = new();

    d0.drv_mbx = drv_mbx;
    g0.drv_mbx = drv_mbx;
    m0.scb_mbx = scb_mbx;
    s0.scb_mbx = scb_mbx;

    d0.drv_done = drv_done;
    g0.drv_done = drv_done;
  endfunction

  virtual task run();
    d0.vif = vif;
    m0.vif = vif;

    fork
      d0.run();
      m0.run();
      g0.run();
      s0.run();
    join_any
  endtask
endclass