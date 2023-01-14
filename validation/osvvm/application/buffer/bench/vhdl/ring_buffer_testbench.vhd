library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library osvvm;
use osvvm.RandomPkg.all;
use osvvm.CoveragePkg.all;

use work.ring_buffer_pkg.all;

entity ring_buffer_testbench is
end ring_buffer_testbench; 

architecture simulation of ring_buffer_testbench is

  constant clock_period : time := 10 ns;

  constant RAM_WIDTH : natural := 16;
  constant RAM_DEPTH : natural := 256;

  -- DUT signals
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';

  signal wr_en      : std_logic := '0';
  signal wr_data    : std_logic_vector(RAM_WIDTH - 1 downto 0) := (others => '0');
  signal rd_en      : std_logic := '0';
  signal rd_valid   : std_logic;
  signal rd_data    : std_logic_vector(RAM_WIDTH - 1 downto 0);
  signal empty      : std_logic;
  signal empty_next : std_logic;
  signal full       : std_logic;
  signal full_next  : std_logic;
  signal fill_count : integer range RAM_DEPTH downto 0;

  -- OSVVM variables
  shared variable rv : RandomPType;
  shared variable bin1, bin2, bin3, bin4, bin5, bin6 : CovPType;

  -- Testbench FIFO that emulates the DUT
  shared variable fifo : LinkedList;

  -- Testbench FIFO signals
  signal fifo_out : integer;
  signal fifo_out_valid : std_logic := '0';

begin

  dut : entity work.ring_buffer(rtl)
    generic map (
      RAM_WIDTH => RAM_WIDTH,
      RAM_DEPTH => RAM_DEPTH
    )
    port map (
      clk => clk,
      rst => rst,

      wr_en      => wr_en,
      wr_data    => wr_data,
      rd_en      => rd_en,
      rd_valid   => rd_valid,
      rd_data    => rd_data,
      empty      => empty,
      empty_next => empty_next,
      full       => full,
      full_next  => full_next,
      fill_count => fill_count
    );

  clk <= not clk after clock_period/2;

  process_sequencer : process
  begin
    -- Set up coverage bins
    bin1.AddBins("Write while empty", ONE_BIN);
    bin2.AddBins("Read while full", ONE_BIN);
    bin3.AddBins("Read and write while almost empty", ONE_BIN);
    bin4.AddBins("Read and write while almost full", ONE_BIN);
    bin5.AddBins("Read without write when almost empty", ONE_BIN);
    bin6.AddBins("Write without read when almost full", ONE_BIN);

    wait until rising_edge(clk);
    wait until rising_edge(clk);
    rst <= '0';
    wait until rising_edge(clk);

    loop
      wait until rising_edge(clk);

      -- Collect coverage data
      bin1.ICover(to_integer(wr_en = '1' and empty = '1'));
      bin2.ICover(to_integer(rd_en = '1' and full = '1'));
      bin3.ICover(to_integer(rd_en = '1' and wr_en = '1' and empty = '0' and empty_next = '1'));
      bin4.ICover(to_integer(rd_en = '1' and wr_en = '1' and full = '0' and full_next = '1'));
      bin5.ICover(to_integer(rd_en = '1' and wr_en = '0' and empty = '0' and empty_next = '1'));
      bin6.ICover(to_integer(rd_en = '0' and wr_en = '1' and full = '0' and full_next = '1'));

      -- Stop the test when all coverage goals have been met
      exit when
        bin1.IsCovered and
        bin2.IsCovered and
        bin3.IsCovered and
        bin4.IsCovered and
        bin5.IsCovered and
        bin6.IsCovered;
    end loop;

    report("Coverage goals met");

    -- Make sure that the DUT is empty before terminating the test
    wr_en <= force '0';
    rd_en <= force '1';
    loop
      wait until rising_edge(clk);
      exit when empty = '1';
    end loop;

    -- Print coverage data
    bin1.WriteBin;
    bin2.WriteBin;
    bin3.WriteBin;
    bin4.WriteBin;
    bin5.WriteBin;
    bin6.WriteBin;

    finish;
  end process;

  -- Generate random input
  process_write : process
  begin
    wr_en <= rv.RandSlv(1)(1) and not rst;

    for i in 0 to rv.RandInt(0, 2*RAM_DEPTH) loop
      wr_data <= rv.RandSlv(RAM_WIDTH);
      wait until rising_edge(clk);
    end loop;
  end process;

  -- Perform random reads
  process_read : process
  begin
    rd_en <= rv.RandSlv(1)(1) and not rst;

    for i in 0 to rv.RandInt(0, 2*RAM_DEPTH) loop
      wait until rising_edge(clk);
    end loop;
  end process;

  -- Emulate the DUT
  process_behavioral_model : process
  begin
    wait until rising_edge(clk) and rst = '0';

    -- Emulate a write
    if wr_en = '1' and full = '0' then
      fifo.Push(to_integer(unsigned(wr_data)));
      report "Push " & integer'image(to_integer(unsigned(wr_data)));
    end if;

    -- Emulate a read
    if rd_en = '1' and empty = '0' then
      fifo_out <= fifo.Pop;
      fifo_out_valid <= '1';
    else
      fifo_out_valid <= '0';
    end if;

  end process;

  -- Check that the output from the DUT matches the behavioral model
  process_verify : process
  begin
    wait until rising_edge(clk) and rst = '0';

    -- Check that DUT and TB FIFO are reporting empty simultaneously
    assert (empty = '1' and fifo.IsEmpty) or (empty = '0' and not fifo.IsEmpty)
      report "empty=" & std_logic'image(empty) & " while fifo.IsEmpty=" & boolean'image(fifo.IsEmpty)
      severity failure;

    -- Check that the valid signals are matching
    assert rd_valid = fifo_out_valid
      report "rd_valid=" & std_logic'image(rd_valid) & " while fifo_out_valid=" & std_logic'image(fifo_out_valid)
      severity failure;

    -- Check that the output from the DUT matches the TB FIFO
    if rd_valid then
      assert fifo_out = to_integer(unsigned(rd_data))
        report "rd_data=" & integer'image(to_integer(unsigned(rd_data))) & " while fifo_out=" & integer'image(fifo_out)
        severity failure;
        report "Pop " & integer'image(fifo_out);
    end if;

  end process;

end architecture;
