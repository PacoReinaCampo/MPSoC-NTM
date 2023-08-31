class monitor;
  virtual switch_if vif;
  mailbox           scb_mbx;
  semaphore         sema4;

  function new();
    sema4 = new(1);
  endfunction

  task run();
    $display("T=%0t [Monitor] starting ...", $time);

    // To get a pipeline effect of transfers, fork two threads
    // where each thread uses a semaphore for the address phase
    fork
      sample_port("Thread0");
      sample_port("Thread1");
    join
  endtask

  task sample_port(string tag = "");
    // This task monitors the interface for a complete 
    // transaction and pushes into the mailbox when the 
    // transaction is complete
    forever begin
      @(posedge vif.clk);
      if (vif.rstn & vif.vld) begin
        switch_item item = new;
        sema4.get();
        item.addr = vif.addr;
        item.data = vif.data;
        $display("T=%0t [Monitor] %s First part over", $time, tag);
        @(posedge vif.clk);
        sema4.put();
        item.addr_a = vif.addr_a;
        item.data_a = vif.data_a;
        item.addr_b = vif.addr_b;
        item.data_b = vif.data_b;
        $display("T=%0t [Monitor] %s Second part over", $time, tag);
        scb_mbx.put(item);
        item.print({"Monitor_", tag});
      end
    end
  endtask
endclass
