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

entity dnc_read_heads_testbench is
end dnc_read_heads_testbench;

architecture dnc_read_heads_testbench_architecture of dnc_read_heads_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -- FREE GATES
  -- CONTROL
  signal f_in_enable_free_gates  : std_logic;
  signal f_out_enable_free_gates : std_logic;

  signal start_free_gates : std_logic;
  signal ready_free_gates : std_logic;

  -- DATA
  signal size_r_in_free_gates : std_logic_vector(DATA_SIZE-1 downto 0);

  signal f_in_free_gates  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal f_out_free_gates : std_logic;

  -- READ KEYS
  -- CONTROL
  signal k_in_i_enable_read_keys : std_logic;
  signal k_in_k_enable_read_keys : std_logic;

  signal k_out_i_enable_read_keys : std_logic;
  signal k_out_k_enable_read_keys : std_logic;

  signal start_read_keys : std_logic;
  signal ready_read_keys : std_logic;

  -- DATA
  signal size_r_in_read_keys : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_w_in_read_keys : std_logic_vector(DATA_SIZE-1 downto 0);

  signal k_in_read_keys  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal k_out_read_keys : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ MODES
  -- CONTROL
  signal pi_in_enable_read_modes : std_logic;

  signal pi_out_enable_read_modes : std_logic;

  signal start_read_modes : std_logic;
  signal ready_read_modes : std_logic;

  -- DATA
  signal size_r_in_read_modes : std_logic_vector(DATA_SIZE-1 downto 0);

  signal pi_in_read_modes  : std_logic_vector(DATA_SIZE-1 downto 0);
  signal pi_out_read_modes : std_logic_vector(DATA_SIZE-1 downto 0);

  -- READ STRENGTHS
  -- CONTROL
  signal beta_in_enable_read_strengths  : std_logic;
  signal beta_out_enable_read_strengths : std_logic;

  signal start_read_strengths : std_logic;
  signal ready_read_strengths : std_logic;

  -- DATA
  signal size_r_in_read_strengths : std_logic_vector(DATA_SIZE-1 downto 0);

  signal beta_in_read_strengths  : std_logic_vector(DATA_SIZE-1 downto 0);
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

      F_IN_ENABLE => f_in_enable_free_gates,

      F_OUT_ENABLE => f_out_enable_free_gates,

      -- DATA
      SIZE_R_IN => size_r_in_free_gates,

      F_IN => f_in_free_gates,

      F_OUT => f_out_free_gates
      );

  -- READ KEYS
  read_keys : dnc_read_keys
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_keys,
      READY => ready_read_keys,

      K_IN_I_ENABLE => k_in_i_enable_read_keys,
      K_IN_K_ENABLE => k_in_k_enable_read_keys,

      K_OUT_I_ENABLE => k_out_i_enable_read_keys,
      K_OUT_K_ENABLE => k_out_k_enable_read_keys,

      -- DATA
      SIZE_R_IN => size_r_in_read_keys,
      SIZE_W_IN => size_w_in_read_keys,

      K_IN => k_in_read_keys,

      K_OUT => k_out_read_keys
      );

  -- READ MODES
  read_modes : dnc_read_modes
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_read_modes,
      READY => ready_read_modes,

      PI_IN_ENABLE => pi_in_enable_read_modes,

      PI_OUT_ENABLE => pi_out_enable_read_modes,

      -- DATA
      SIZE_R_IN => size_r_in_free_gates,

      PI_IN => pi_in_read_modes,

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

      BETA_IN_ENABLE  => beta_in_enable_read_strengths,
      BETA_OUT_ENABLE => beta_out_enable_read_strengths,

      -- DATA
      SIZE_R_IN => size_r_in_free_gates,

      BETA_IN => beta_in_read_strengths,

      BETA_OUT => beta_out_read_strengths
      );

end dnc_read_heads_testbench_architecture;
