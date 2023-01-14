// The monitor has a virtual interface handle with which it can monitor
// the events happening on the interface. It sees new transactions and then
// captures information into a packet and sends it to the scoreboard
// using another mailbox.

class monitor;
  virtual reg_if vif;
  mailbox scb_mbx;  // Mailbox connected to scoreboard
  
  task run();
    $display ("T=%0t [Monitor] starting ...", $time);
    
    // Check forever at every clock edge to see if there is a 
    // valid transaction and if yes, capture info into a class
    // object and send it to the scoreboard when the transaction 
    // is over.
    forever begin
      @ (posedge vif.clk);
      if (vif.sel) begin
        reg_item item = new;
        item.addr = vif.addr;
        item.wr = vif.wr;
        item.wdata = vif.wdata;

        if (!vif.wr) begin
          @(posedge vif.clk);
          item.rdata = vif.rdata;
        end
        item.print("Monitor");
        scb_mbx.put(item);
      end
    end
  endtask
endclass