interface switch_if (
  input bit clk
);
  logic        rstn;
  logic        vld;

  logic [ 7:0] addr;
  logic [15:0] data;

  logic [ 7:0] addr_a;
  logic [15:0] data_a;

  logic [ 7:0] addr_b;
  logic [15:0] data_b;
endinterface
