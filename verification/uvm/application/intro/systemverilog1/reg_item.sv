class reg_item;
  // This is the base transaction object that will be used
  // in the environment to initiate new transactions and 
  // capture transactions at DUT interface
  rand bit [ 7:0] addr;
  rand bit [15:0] wdata;

  bit [15:0] rdata;

  rand bit wr;

  // This function allows us to print contents of the data packet
  // so that it is easier to track in a logfile
  function void print(string tag="");
    $display ("T=%0t [%s] addr=0x%0h wr=%0d wdata=0x%0h rdata=0x%0h", $time, tag, addr, wr, wdata, rdata);
  endfunction
endclass