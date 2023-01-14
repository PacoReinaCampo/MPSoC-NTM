// The driver is responsible for driving transactions to the DUT 
// All it does is to get a transaction from the mailbox if it is 
// available and drive it out into the DUT interface.

class driver;
  virtual reg_if vif;
  event drv_done;
  mailbox drv_mbx;

  task run();
    $display ("T=%0t [Driver] starting ...", $time);
    @ (posedge vif.clk);

    // Try to get a new transaction every time and then assign 
    // packet contents to the interface. But do this only if the 
    // design is ready to accept new transactions
    forever begin
      reg_item item;

      $display ("T=%0t [Driver] waiting for item ...", $time);
      drv_mbx.get(item);      
      item.print("Driver");

      vif.sel   <= 1;
      vif.addr  <= item.addr;
      vif.wr    <= item.wr;
      vif.wdata <= item.wdata;

      @ (posedge vif.clk);

      while (!vif.ready)  begin
        $display ("T=%0t [Driver] wait until ready is high", $time);
        @(posedge vif.clk);
      end

      // When transfer is over, raise the done event
      vif.sel <= 0; ->drv_done;
    end   
  endtask
endclass