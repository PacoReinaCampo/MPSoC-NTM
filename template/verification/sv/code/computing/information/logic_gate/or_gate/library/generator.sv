class generator;
  mailbox drv_mbx;
  event   drv_done;
  int     num       = 20;

  task run();
    for (int i = 0; i < num; i++) begin
      switch_item item = new;
      item.randomize();
      $display("T=%0t [Generator] Loop:%0d/%0d create next item", $time, i + 1, num);
      drv_mbx.put(item);
      @(drv_done);
    end
    $display("T=%0t [Generator] Done generation of %0d items", $time, num);
  endtask
endclass
