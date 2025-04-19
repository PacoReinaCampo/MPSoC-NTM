interface design_if (
  input bit clk
);

  // Declaration of signals
  logic rst;
  logic in;
  logic out;

  // Clocking block 
  clocking cb @(posedge clk);
    default input #1step output #3ns;
    input out;
    output in;
  endclocking
endinterface
