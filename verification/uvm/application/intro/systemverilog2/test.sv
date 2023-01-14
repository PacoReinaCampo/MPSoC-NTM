// Test class instantiates the environment and starts it.

class test;
  env e0;

  function new();
    e0 = new;
  endfunction

  task run();
    e0.run();
  endtask
endclass