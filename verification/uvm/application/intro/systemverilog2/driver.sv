// The driver is responsible for driving transactions to the DUT 
// All it does is to get a transaction from the mailbox if it is 
// available and drive it out into the DUT interface.

class driver;
  virtual switch_if vif;
  event drv_done;
  mailbox drv_mbx;

  task run();
    $display ("T=%0t [Driver] starting ...", $time);
    @ (posedge vif.clk);

    // Try to get a new transaction every time and then assign 
    // packet contents to the interface. But do this only if the 
    // design is ready to accept new transactions
    forever begin
      switch_item item;

      $display ("T=%0t [Driver] waiting for item ...", $time);
      drv_mbx.get(item);      
      item.print("Driver");

      vif.vld  <= 1;
      vif.addr <= item.addr;
      vif.data <= item.data;

      // When transfer is over, raise the done event
      @ (posedge vif.clk);
      vif.vld <= 0; ->drv_done;
    end   
  endtask
endclass