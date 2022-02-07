--------------------------------------------------------------------------------
--                                            __ _      _     _               --
--                                           / _(_)    | |   | |              --
--                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              --
--               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              --
--              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              --
--               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              --
--                  | |                                                       --
--                  |_|                                                       --
--                                                                            --
--                                                                            --
--              Peripheral-NTM for MPSoC                                      --
--              Neural Turing Machine for MPSoC                               --
--                                                                            --
--------------------------------------------------------------------------------

-- Copyright (c) 2020-2021 by the author(s)
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--------------------------------------------------------------------------------
-- Author(s):
--   Paco Reina Campo <pacoreinacampo@queenfield.tech>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.all;

library osvvm;
use osvvm.RandomPkg.all;
use osvvm.CoveragePkg.all;

entity ntm_intro_testbench is
end entity ntm_intro_testbench;

architecture ntm_intro_testbench_architecture of ntm_intro_testbench is

  component ntm_intro_adder_model is
    generic (
      DATA_SIZE : positive := 4
      );
    port (
      RST : in std_logic;
      CLK : in std_logic;

      DATA_A_IN : in  unsigned(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  unsigned(DATA_SIZE-1 downto 0);
      DATA_OUT  : out unsigned(DATA_SIZE downto 0)
      );
  end component ntm_intro_adder_model;

  -----------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------

  component ntm_intro_adder is
    generic (
      DATA_SIZE : positive := 4
      );
    port (
      RST : in std_logic;
      CLK : in std_logic;

      DATA_A_IN : in  unsigned(DATA_SIZE-1 downto 0);
      DATA_B_IN : in  unsigned(DATA_SIZE-1 downto 0);
      DATA_OUT  : out unsigned(DATA_SIZE downto 0)
      );
  end component ntm_intro_adder;

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  -- width of adder inputs
  constant C_ADDER_WIDTH : positive := 8;

  -- clock period
  constant C_CLK_PERIOD : time := 20 ns;

  -- how many bins should be generated
  constant C_MAX_BINS : natural := 16;

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- testbench signals
  signal clk_int : std_logic := '0';
  signal rst_int : std_logic := '0';

  signal s_adder1_in : unsigned(C_ADDER_WIDTH-1 downto 0);
  signal s_adder2_in : unsigned(C_ADDER_WIDTH-1 downto 0);

  signal s_adder0_out : unsigned(C_ADDER_WIDTH downto 0) := (others => '0');
  signal s_adder1_out : unsigned(C_ADDER_WIDTH downto 0) := (others => '0');

  -- coverage object of (protected) type CovPType
  shared variable sv_coverage : CovPType;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- global signals
  rst_int <= '1' after 100 ns;

  clk_int <= not(clk_int) after C_CLK_PERIOD/2;

  -- DUT 0: MODEL
  intro_adder_model : ntm_intro_adder_model
    generic map (
      DATA_SIZE => C_ADDER_WIDTH
      )
    port map (
      RST => rst_int,
      CLK => clk_int,

      DATA_A_IN => s_adder1_in,
      DATA_B_IN => s_adder2_in,
      DATA_OUT  => s_adder0_out
      );

  -- DUT 2: RTL
  intro_adder : ntm_intro_adder
    generic map (
      DATA_SIZE => C_ADDER_WIDTH
      )
    port map (
      RST => rst_int,
      CLK => clk_int,

      DATA_A_IN => s_adder1_in,
      DATA_B_IN => s_adder2_in,
      DATA_OUT  => s_adder1_out
      );

  -- stimulus & coverage of adder inputs
  StimCoverageP : process is
    -- holds the two random values from sv_coverage object
    variable v_adder_in : integer_vector(0 to 1);
  begin
    s_adder1_in <= (others => '0');
    s_adder2_in <= (others => '0');

    -- cross bins for all possible combinations (very slow on large vector widths):
    -- sv_coverage.AddCross(GenBin(0, 2**C_ADDER_WIDTH-1), GenBin(0, 2**C_ADDER_WIDTH-1));

    -- cross bins for maximum of C_MAX_BINS slices with same width:
    sv_coverage.AddCross(GenBin(0, 2**C_ADDER_WIDTH-1, C_MAX_BINS), GenBin(0, 2**C_ADDER_WIDTH-1, C_MAX_BINS));

    -- cross bins for corner cases (min against max):
    sv_coverage.AddCross(GenBin(0), GenBin(2**C_ADDER_WIDTH-1));
    sv_coverage.AddCross(GenBin(2**C_ADDER_WIDTH-1), GenBin(0));

    -- loop until reaching coverage goal
    while not sv_coverage.IsCovered loop
      wait until rising_edge(clk_int);
      -- generate random values depending on coverage hole
      v_adder_in  := sv_coverage.RandCovPoint;
      s_adder1_in <= to_unsigned(v_adder_in(0), C_ADDER_WIDTH);
      s_adder2_in <= to_unsigned(v_adder_in(1), C_ADDER_WIDTH);

      -- save generated random values in coverage object
      sv_coverage.ICover(v_adder_in);
    end loop;

    wait for 2*C_CLK_PERIOD;
    -- print coverage report
    report("CovBin Coverage details");
    sv_coverage.WriteBin;
    stop;
  end process StimCoverageP;

  -- check if outputs of both adders are equal
  CheckerP : process is
  begin
    wait until rising_edge(clk_int);
    assert s_adder0_out = s_adder1_out
      report "FAILURE: s_adder0_out (0x" & to_hstring(s_adder0_out) & ") & s_adder1_out (0x" & to_hstring(s_adder1_out) & ") are not equal!"
      severity failure;
  end process CheckerP;

end architecture ntm_intro_testbench_architecture;