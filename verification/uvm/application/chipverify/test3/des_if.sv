// The interface allows verification components to access DUT signals
// using a virtual interface handle

interface des_if (input bit clk);
  logic rstn;
  logic in;
  logic out;

  clocking cb @(posedge clk);
    default input #1step output #3ns;
    input out;
    output in;
  endclocking
endinterface