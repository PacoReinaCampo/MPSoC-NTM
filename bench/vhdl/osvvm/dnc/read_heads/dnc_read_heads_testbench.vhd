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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ntm_math_pkg.all;
use work.dnc_core_pkg.all;

entity dnc_memory_testbench is
end dnc_memory_testbench;

architecture dnc_memory_testbench_architecture of dnc_memory_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- FREE GATES
  -- CONTROL
  signal start_free_gates : std_logic;
  signal ready_free_gates : std_logic;

  -- DATA
  signal f_in_free_gates   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_free_gates : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_free_gates  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ KEYS
  -- CONTROL
  signal start_read_keys : std_logic;
  signal ready_read_keys : std_logic;

  -- DATA
  signal k_in_read_keys   : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_read_keys : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal k_out_read_keys  : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);

  -- READ MODES
  -- CONTROL
  signal start_read_modes : std_logic;
  signal ready_read_modes : std_logic;

  -- DATA
  signal pi_in_read_modes  : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal modulo_read_modes : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);
  signal pi_out_read_modes : std_logic_arithmetic_vector_vector(X-1 downto 0)(DATA_SIZE-1 downto 0);

  -- READ STRENGTHS
  -- CONTROL
  signal start_read_strengths : std_logic;
  signal ready_read_strengths : std_logic;

  -- DATA
  signal beta_in_read_strengths  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal modulo_read_strengths   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal beta_out_read_strengths : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -- FREE GATES
  free_gates : dnc_free_gates
    generic map (

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_free_gates,
      READY => ready_free_gates,

      -- DATA
      F_IN => f_in_free_gates,

      MODULO => modulo_free_gates,
      F_OUT  => f_out_free_gates
    );

  -- READ KEYS
  read_keys : dnc_read_keys
    generic map (
      X => X,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_keys,
      READY => ready_read_keys,

      -- DATA
      K_IN => k_in_read_keys,

      MODULO => modulo_read_keys,
      K_OUT  => k_out_read_keys
    );

  -- READ MODES
  read_modes : dnc_read_modes
    generic map (
      X => X,

      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_modes,
      READY => ready_read_modes,

      -- DATA
      PI_IN => pi_in_read_modes,

      MODULO => modulo_read_modes,
      PI_OUT => pi_out_read_modes
    );

  -- READ STRENGTHS
  read_strengths : dnc_read_strengths
    generic map (
      DATA_SIZE => DATA_SIZE
    )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_strengths,
      READY => ready_read_strengths,

      -- DATA
      BETA_IN => beta_in_read_strengths,

      MODULO   => modulo_read_strengths,
      BETA_OUT => beta_out_read_strengths
    );

end dnc_memory_testbench_architecture;