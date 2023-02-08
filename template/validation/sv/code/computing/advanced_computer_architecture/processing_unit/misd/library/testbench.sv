module testbench;
  reg clk;

  always #10 clk =~ clk;
  switch_if  _if (clk);

  switch u0 (
    .clk   (clk),
    .rstn  (_if.rstn),
    .addr  (_if.addr),
    .data  (_if.data),
	.vld   (_if.vld),
	.addr_a(_if.addr_a),
	.data_a(_if.data_a),
	.addr_b(_if.addr_b),
	.data_b(_if.data_b)
  );

  test t0;

  initial begin
    {clk, _if.rstn} <= 0;

    // Apply reset and start stimulus
    #20 _if.rstn <= 1;
    t0 = new;
    t0.e0.vif = _if;
    t0.run();

    // Because multiple components and clock are running
    // in the background, we need to call $finish explicitly
    #50 $finish;
  end

  // System tasks to dump VCD waveform file
  initial begin
    $dumpvars;
    $dumpfile ("dump.vcd");
  end
endmodule