// The interface allows verification components to access DUT signals
// using a virtual interface handle

interface reg_if (input bit clk);
  logic        rstn;
  logic [ 7:0] addr;
  logic [15:0] wdata;
  logic [15:0] rdata;
  logic        wr;
  logic        sel;
  logic        ready;
endinterface