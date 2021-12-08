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

use work.ntm_math_pkg.all;
use work.dnc_write_heads_pkg.all;

entity dnc_write_heads_stimulus is
  generic (
    -- SYSTEM-SIZE
    DATA_SIZE  : integer := 512;
    INDEX_SIZE : integer := 128;

    X : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- x in 0 to X-1
    Y : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- y in 0 to Y-1
    N : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- j in 0 to N-1
    W : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- k in 0 to W-1
    L : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE));  -- l in 0 to L-1
    R : std_logic_vector(DATA_SIZE-1 downto 0) := std_logic_vector(to_unsigned(64, DATA_SIZE))   -- i in 0 to R-1
    );
  port (
    -- GLOBAL
    CLK : out std_logic;
    RST : out std_logic;

    -- ALLOCATION GATE
    -- CONTROL
    DNC_ALLOCATION_GATE_START : out std_logic;
    DNC_ALLOCATION_GATE_READY : in  std_logic;

    -- DATA
    DNC_ALLOCATION_GATE_GA_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_ALLOCATION_GATE_GA_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- ERASE VECTOR
    -- CONTROL
    DNC_ERASE_VECTOR_START : out std_logic;
    DNC_ERASE_VECTOR_READY : in  std_logic;

    DNC_ERASE_VECTOR_E_IN_ENABLE : out std_logic;

    DNC_ERASE_VECTOR_E_OUT_ENABLE : in std_logic;

    -- DATA
    DNC_ERASE_VECTOR_SIZE_W_IN : out std_logic_vector(INDEX_SIZE-1 downto 0);

    DNC_ERASE_VECTOR_E_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_ERASE_VECTOR_E_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- WRITE GATE
    -- CONTROL
    DNC_WRITE_GATE_START : out std_logic;
    DNC_WRITE_GATE_READY : in  std_logic;

    -- DATA
    DNC_WRITE_GATE_GW_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_WRITE_GATE_GW_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- WRITE KEY
    -- CONTROL
    DNC_WRITE_KEY_START : out std_logic;
    DNC_WRITE_KEY_READY : in  std_logic;

    DNC_WRITE_KEY_K_IN_ENABLE : out std_logic;

    DNC_WRITE_KEY_K_OUT_ENABLE : in std_logic;

    -- DATA
    DNC_WRITE_KEY_SIZE_W_IN : out std_logic_vector(INDEX_SIZE-1 downto 0);

    DNC_WRITE_KEY_K_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_WRITE_KEY_K_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- WRITE STRENGTH
    -- CONTROL
    DNC_WRITE_STRENGTH_START : out std_logic;
    DNC_WRITE_STRENGTH_READY : in  std_logic;

    -- DATA
    DNC_WRITE_STRENGTH_BETA_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_WRITE_STRENGTH_BETA_OUT : in std_logic_vector(DATA_SIZE-1 downto 0);

    -- WRITE VECTOR
    -- CONTROL
    DNC_WRITE_VECTOR_START : out std_logic;
    DNC_WRITE_VECTOR_READY : in  std_logic;

    DNC_WRITE_VECTOR_V_IN_ENABLE : out std_logic;

    DNC_WRITE_VECTOR_V_OUT_ENABLE : in std_logic;

    -- DATA
    DNC_WRITE_VECTOR_SIZE_W_IN : out std_logic_vector(INDEX_SIZE-1 downto 0);

    DNC_WRITE_VECTOR_V_IN : out std_logic_vector(DATA_SIZE-1 downto 0);

    DNC_WRITE_VECTOR_V_OUT : in std_logic_vector(DATA_SIZE-1 downto 0)
    );
end entity;

architecture dnc_write_heads_stimulus_architecture of dnc_write_heads_stimulus is

  -----------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------

  constant PERIOD : time := 10 ns;

  constant WAITING : time := 50 ns;
  constant WORKING : time := 1 ms;

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal clk_int : std_logic;
  signal rst_int : std_logic;

  -- CONTROL
  signal start_int : std_logic;

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- clk generation
  clk_process : process
  begin
    clk_int <= '1';
    wait for PERIOD/2;

    clk_int <= '0';
    wait for PERIOD/2;
  end process;

  -- rst generation
  rst_process : process
  begin
    rst_int <= '0';
    wait for WAITING;

    rst_int <= '1';
    wait for WORKING;
  end process;

  -- start generation
  start_process : process
  begin
    start_int <= '0';
    wait for WAITING;

    start_int <= '1';
    wait for PERIOD;

    start_int <= '0';
    wait for WORKING;
  end process;

  -----------------------------------------------------------------------
  -- STIMULUS
  -----------------------------------------------------------------------

  main_test : process
  begin

    if (STIMULUS_DNC_WRITE_HEADS_TEST) then

      -------------------------------------------------------------------
      MONITOR_TEST <= "STIMULUS_DNC_WRITE_HEADS_TEST           ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_DNC_WRITE_HEADS_CASE_0         ";
      -------------------------------------------------------------------

      -------------------------------------------------------------------
      MONITOR_CASE <= "STIMULUS_DNC_WRITE_HEADS_CASE_1         ";
      -------------------------------------------------------------------

    end if;

    assert false
      report "END OF TEST"
      severity failure;

  end process main_test;

end architecture;
