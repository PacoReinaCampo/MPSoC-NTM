class scoreboard;
  mailbox scb_mbx;

  task run();
    forever begin
      switch_item item;
      scb_mbx.get(item);

      if (item.addr inside {[0 : 'h3f]}) begin
        if (item.addr_a != item.addr | item.data_a != item.data) begin
          $display("T=%0t [Scoreboard] ERROR! Mismatch addr=0x%0h data=0x%0h addr_a=0x%0h data_a=0x%0h", $time, item.addr, item.data, item.addr_a, item.data_a);
        end else begin
          $display("T=%0t [Scoreboard] PASS! Mismatch addr=0x%0h data=0x%0h addr_a=0x%0h data_a=0x%0h", $time, item.addr, item.data, item.addr_a, item.data_a);
        end

      end else begin
        if (item.addr_b != item.addr | item.data_b != item.data) begin
          $display("T=%0t [Scoreboard] ERROR! Mismatch addr=0x%0h data=0x%0h addr_b=0x%0h data_b=0x%0h", $time, item.addr, item.data, item.addr_b, item.data_b);
        end else begin
          $display("T=%0t [Scoreboard] PASS! Mismatch addr=0x%0h data=0x%0h addr_b=0x%0h data_b=0x%0h", $time, item.addr, item.data, item.addr_b, item.data_b);
        end
      end
    end
  endtask
endclass
