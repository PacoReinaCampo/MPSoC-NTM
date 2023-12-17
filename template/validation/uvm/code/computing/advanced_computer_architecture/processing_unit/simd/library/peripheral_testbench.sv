`include "uvm_macros.svh"
import uvm_pkg::*;

`include "design_if.sv"
`include "peripheral_test.sv"

module peripheral_testbench;
  // Clock declaration
  reg clk;

  // Clock Generation
  always #10 clk = ~clk;

  // Virtual interface
  design_if _if (clk);

  // DUT instantiation
  fsm dut (
    .clk(clk),
    .rst(_if.rst),

    .in (_if.in),
    .out(_if.out)
  );

  initial begin
    clk <= 0;

    // Passing the interface handle to lower heirarchy using set method
    uvm_config_db#(virtual design_if)::set(null, "uvm_test_top", "design_if", _if);

    // Calling TestCase
    run_test("peripheral_sample");
  end
endmodule
