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

entity ntm_arithmetic_testbench is
end ntm_arithmetic_testbench;

architecture ntm_arithmetic_testbench_architecture of ntm_arithmetic_testbench is

  -----------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------

  -- GLOBAL
  signal CLK : std_logic;
  signal RST : std_logic;

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR MOD
  -- CONTROL
  signal start_scalar_mod : std_logic;
  signal ready_scalar_mod : std_logic;

  -- DATA
  signal modulo_in_scalar_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_mod  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ADDER
  -- CONTROL
  signal start_scalar_adder : std_logic;
  signal ready_scalar_adder : std_logic;

  signal operation_scalar_adder : std_logic;

  -- DATA
  signal modulo_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR MULTIPLIER
  -- CONTROL
  signal start_scalar_multiplier : std_logic;
  signal ready_scalar_multiplier : std_logic;

  -- DATA
  signal modulo_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR INVERTER
  -- CONTROL
  signal start_scalar_inverter : std_logic;
  signal ready_scalar_inverter : std_logic;

  -- DATA
  signal modulo_in_scalar_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR DIVIDER
  -- CONTROL
  signal start_scalar_divider : std_logic;
  signal ready_scalar_divider : std_logic;

  -- DATA
  signal modulo_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR EXPONENTIATOR
  -- CONTROL
  signal start_scalar_exponentiator : std_logic;
  signal ready_scalar_exponentiator : std_logic;

  -- DATA
  signal modulo_in_scalar_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR ROOT
  -- CONTROL
  signal start_scalar_root : std_logic;
  signal ready_scalar_root : std_logic;

  -- DATA
  signal modulo_in_scalar_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_scalar_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_scalar_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_root  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- SCALAR LOGARITHM
  signal start_scalar_logarithm : std_logic;
  signal ready_scalar_logarithm : std_logic;

  -- CONTROL
  -- DATA
  signal modulo_in_scalar_logarithm : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_scalar_logarithm   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_scalar_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- VECTOR MOD
  -- CONTROL
  signal start_vector_mod : std_logic;
  signal ready_vector_mod : std_logic;

  signal data_in_enable_vector_mod : std_logic;

  signal data_out_enable_vector_mod : std_logic;

  -- DATA
  signal modulo_in_vector_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_mod  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ADDER
  -- CONTROL
  signal start_vector_adder : std_logic;
  signal ready_vector_adder : std_logic;

  signal operation_vector_adder : std_logic;

  signal data_a_in_enable_vector_adder : std_logic;
  signal data_b_in_enable_vector_adder : std_logic;

  signal data_out_enable_vector_adder : std_logic;

  -- DATA
  signal modulo_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_adder   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR MULTIPLIER
  -- CONTROL
  signal start_vector_multiplier : std_logic;
  signal ready_vector_multiplier : std_logic;

  signal data_a_in_enable_vector_multiplier : std_logic;
  signal data_b_in_enable_vector_multiplier : std_logic;

  signal data_out_enable_vector_multiplier : std_logic;

  -- DATA
  signal modulo_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_multiplier   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR INVERTER
  -- CONTROL
  signal start_vector_inverter : std_logic;
  signal ready_vector_inverter : std_logic;

  signal data_in_enable_vector_inverter : std_logic;

  signal data_out_enable_vector_inverter : std_logic;

  -- DATA
  signal modulo_in_vector_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR DIVIDER
  -- CONTROL
  signal start_vector_divider : std_logic;
  signal ready_vector_divider : std_logic;

  signal data_a_in_enable_vector_divider : std_logic;
  signal data_b_in_enable_vector_divider : std_logic;

  signal data_out_enable_vector_divider : std_logic;

  -- DATA
  signal modulo_in_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_divider   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR EXPONENTIATOR
  -- CONTROL
  signal start_vector_exponentiator : std_logic;
  signal ready_vector_exponentiator : std_logic;

  signal data_a_in_enable_vector_exponentiator : std_logic;
  signal data_b_in_enable_vector_exponentiator : std_logic;

  signal data_out_enable_vector_exponentiator : std_logic;

  -- DATA
  signal modulo_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_exponentiator   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR ROOT
  -- CONTROL
  signal start_vector_root : std_logic;
  signal ready_vector_root : std_logic;

  signal data_a_in_enable_vector_root : std_logic;
  signal data_b_in_enable_vector_root : std_logic;

  signal data_out_enable_vector_root : std_logic;

  -- DATA
  signal modulo_in_vector_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_root   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_vector_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_vector_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_root  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- VECTOR LOGARITHM
  -- CONTROL
  signal start_vector_logarithm : std_logic;
  signal ready_vector_logarithm : std_logic;

  signal data_in_enable_vector_logarithm : std_logic;

  signal data_out_enable_vector_logarithm : std_logic;

  -- DATA
  signal modulo_in_vector_logarithm : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_in_vector_logarithm   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_vector_logarithm   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_vector_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

  -- MATRIX MOD
  -- CONTROL
  signal start_matrix_mod : std_logic;
  signal ready_matrix_mod : std_logic;

  signal data_in_i_enable_matrix_mod : std_logic;
  signal data_in_j_enable_matrix_mod : std_logic;

  signal data_out_i_enable_matrix_mod : std_logic;
  signal data_out_j_enable_matrix_mod : std_logic;

  -- DATA
  signal modulo_in_matrix_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_mod : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_mod   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_mod  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX ADDER
  -- CONTROL
  signal start_matrix_adder : std_logic;
  signal ready_matrix_adder : std_logic;

  signal operation_matrix_adder : std_logic;

  signal data_a_in_i_matrix_adder : std_logic;
  signal data_a_in_j_matrix_adder : std_logic;
  signal data_b_in_i_matrix_adder : std_logic;
  signal data_b_in_j_matrix_adder : std_logic;

  signal data_out_i_enable_matrix_adder : std_logic;
  signal data_out_j_enable_matrix_adder : std_logic;

  -- DATA
  signal modulo_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_adder : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_adder  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX MULTIPLIER
  -- CONTROL
  signal start_matrix_multiplier : std_logic;
  signal ready_matrix_multiplier : std_logic;

  signal data_a_in_i_matrix_multiplier : std_logic;
  signal data_a_in_j_matrix_multiplier : std_logic;
  signal data_b_in_i_matrix_multiplier : std_logic;
  signal data_b_in_j_matrix_multiplier : std_logic;

  signal data_out_i_enable_matrix_multiplier : std_logic;
  signal data_out_j_enable_matrix_multiplier : std_logic;

  -- DATA
  signal modulo_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_multiplier : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_multiplier  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX INVERTER
  -- CONTROL
  signal start_matrix_inverter : std_logic;
  signal ready_matrix_inverter : std_logic;

  signal data_in_i_enable_matrix_inverter : std_logic;
  signal data_in_j_enable_matrix_inverter : std_logic;

  signal data_out_i_enable_matrix_inverter : std_logic;
  signal data_out_j_enable_matrix_inverter : std_logic;

  -- DATA
  signal modulo_in_matrix_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_inverter : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_inverter   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_inverter  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX DIVIDER
  -- CONTROL
  signal start_matrix_divider : std_logic;
  signal ready_matrix_divider : std_logic;

  signal data_a_in_i_enable_matrix_divider : std_logic;
  signal data_a_in_j_enable_matrix_divider : std_logic;
  signal data_b_in_i_enable_matrix_divider : std_logic;
  signal data_b_in_j_enable_matrix_divider : std_logic;

  signal data_out_i_enable_enable_matrix_divider : std_logic;
  signal data_out_j_enable_enable_matrix_divider : std_logic;

  -- DATA
  signal modulo_in_matrix_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_divider : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_divider  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX EXPONENTIATOR
  -- CONTROL
  signal start_matrix_exponentiator : std_logic;
  signal ready_matrix_exponentiator : std_logic;

  signal data_a_in_i_enable_matrix_exponentiator : std_logic;
  signal data_a_in_j_enable_matrix_exponentiator : std_logic;
  signal data_b_in_i_enable_matrix_exponentiator : std_logic;
  signal data_b_in_j_enable_matrix_exponentiator : std_logic;

  signal data_out_i_enable_matrix_exponentiator : std_logic;
  signal data_out_j_enable_matrix_exponentiator : std_logic;

  -- DATA
  signal modulo_in_matrix_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_exponentiator : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_exponentiator  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX ROOT
  -- CONTROL
  signal start_matrix_root : std_logic;
  signal ready_matrix_root : std_logic;

  signal data_a_in_i_enable_matrix_root : std_logic;
  signal data_a_in_j_enable_matrix_root : std_logic;
  signal data_b_in_i_enable_matrix_root : std_logic;
  signal data_b_in_j_enable_matrix_root : std_logic;

  signal data_out_i_enable_enable_matrix_root : std_logic;
  signal data_out_j_enable_enable_matrix_root : std_logic;

  -- DATA
  signal modulo_in_matrix_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_a_in_matrix_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_b_in_matrix_root : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_root  : std_logic_vector(DATA_SIZE-1 downto 0);

  -- MATRIX LOGARITHM
  -- CONTROL
  signal start_matrix_logarithm : std_logic;
  signal ready_matrix_logarithm : std_logic;

  signal data_in_i_enable_matrix_logarithm : std_logic;
  signal data_in_j_enable_matrix_logarithm : std_logic;

  signal data_out_i_enable_matrix_logarithm : std_logic;
  signal data_out_j_enable_matrix_logarithm : std_logic;

  -- DATA
  signal modulo_in_matrix_logarithm : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_i_in_matrix_logarithm : std_logic_vector(DATA_SIZE-1 downto 0);
  signal size_j_in_matrix_logarithm : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_in_matrix_logarithm   : std_logic_vector(DATA_SIZE-1 downto 0);
  signal data_out_matrix_logarithm  : std_logic_vector(DATA_SIZE-1 downto 0);

begin

  -----------------------------------------------------------------------
  -- Body
  -----------------------------------------------------------------------

  -----------------------------------------------------------------------
  -- SCALAR
  -----------------------------------------------------------------------

  -- SCALAR MOD
  scalar_mod : ntm_scalar_mod
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_mod,
      READY => ready_scalar_mod,

      -- DATA
      MODULO_IN => modulo_in_scalar_mod,
      DATA_IN   => data_in_scalar_mod,
      DATA_OUT  => data_out_scalar_mod
      );

  -- SCALAR ADDER
  scalar_adder : ntm_scalar_adder
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_adder,
      READY => ready_scalar_adder,

      OPERATION => operation_scalar_adder,

      -- DATA
      MODULO_IN => modulo_in_scalar_adder,
      DATA_A_IN => data_a_in_scalar_adder,
      DATA_B_IN => data_b_in_scalar_adder,
      DATA_OUT  => data_out_scalar_adder
      );

  -- SCALAR MULTIPLIER
  scalar_multiplier : ntm_scalar_multiplier
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_multiplier,
      READY => ready_scalar_adder,

      -- DATA
      MODULO_IN => modulo_in_scalar_multiplier,
      DATA_A_IN => data_a_in_scalar_multiplier,
      DATA_B_IN => data_b_in_scalar_multiplier,
      DATA_OUT  => data_out_scalar_multiplier
      );

  -- SCALAR INVERTER
  scalar_inverter : ntm_scalar_inverter
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_inverter,
      READY => ready_scalar_inverter,

      -- DATA
      MODULO_IN => modulo_in_scalar_inverter,
      DATA_IN   => data_in_scalar_inverter,
      DATA_OUT  => data_out_scalar_inverter
      );

  -- SCALAR DIVIDER
  scalar_divider : ntm_scalar_divider
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_divider,
      READY => ready_scalar_divider,

      -- DATA
      MODULO_IN => modulo_in_scalar_divider,
      DATA_A_IN => data_a_in_scalar_divider,
      DATA_B_IN => data_b_in_scalar_divider,
      DATA_OUT  => data_out_scalar_divider
      );

  -- SCALAR EXPONENTIATOR
  scalar_exponentiator : ntm_scalar_exponentiator
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_exponentiator,
      READY => ready_scalar_exponentiator,

      -- DATA
      MODULO_IN => modulo_in_scalar_exponentiator,
      DATA_A_IN => data_a_in_scalar_exponentiator,
      DATA_B_IN => data_b_in_scalar_exponentiator,
      DATA_OUT  => data_out_scalar_exponentiator
      );

  -- SCALAR ROOT
  scalar_root : ntm_scalar_root
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_root,
      READY => ready_scalar_root,

      -- DATA
      MODULO_IN => modulo_in_scalar_root,
      DATA_A_IN => data_a_in_scalar_root,
      DATA_B_IN => data_b_in_scalar_root,
      DATA_OUT  => data_out_scalar_root
      );

  -- SCALAR LOGARITHM
  scalar_logarithm : ntm_scalar_logarithm
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_scalar_logarithm,
      READY => ready_scalar_logarithm,

      -- DATA
      MODULO_IN => modulo_in_scalar_logarithm,
      DATA_IN   => data_in_scalar_logarithm,
      DATA_OUT  => data_out_scalar_logarithm
      );

  -----------------------------------------------------------------------
  -- VECTOR
  -----------------------------------------------------------------------

  -- VECTOR MOD
  vector_mod : ntm_vector_mod
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_mod,
      READY => ready_vector_mod,

      DATA_IN_ENABLE => data_in_enable_vector_mod,

      DATA_OUT_ENABLE => data_out_enable_vector_mod,

      -- DATA
      MODULO_IN => modulo_in_vector_mod,
      SIZE_IN   => size_in_vector_mod,
      DATA_IN   => data_in_vector_mod,
      DATA_OUT  => data_out_vector_mod
      );

  -- VECTOR ADDER
  vector_adder : ntm_vector_adder
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_adder,
      READY => ready_vector_adder,

      OPERATION => operation_vector_adder,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_adder,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_adder,

      DATA_OUT_ENABLE => data_out_enable_vector_adder,

      -- DATA
      MODULO_IN => modulo_in_vector_adder,
      SIZE_IN   => size_in_vector_adder,
      DATA_A_IN => data_a_in_vector_adder,
      DATA_B_IN => data_b_in_vector_adder,
      DATA_OUT  => data_out_vector_adder
      );

  -- VECTOR MULTIPLIER
  vector_multiplier : ntm_vector_multiplier
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_multiplier,
      READY => ready_vector_multiplier,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_multiplier,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_multiplier,

      DATA_OUT_ENABLE => data_out_enable_vector_multiplier,

      -- DATA
      MODULO_IN => modulo_in_vector_multiplier,
      SIZE_IN   => size_in_vector_multiplier,
      DATA_A_IN => data_a_in_vector_multiplier,
      DATA_B_IN => data_b_in_vector_multiplier,
      DATA_OUT  => data_out_vector_multiplier
      );

  -- VECTOR INVERTER
  vector_inverter : ntm_vector_inverter
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_inverter,
      READY => ready_vector_inverter,

      DATA_IN_ENABLE => data_in_enable_vector_inverter,

      DATA_OUT_ENABLE => data_out_enable_vector_inverter,

      -- DATA
      MODULO_IN => modulo_in_vector_inverter,
      SIZE_IN   => size_in_vector_inverter,
      DATA_IN   => data_in_vector_inverter,
      DATA_OUT  => data_out_vector_inverter
      );

  -- VECTOR DIVIDER
  vector_divider : ntm_vector_divider
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_divider,
      READY => ready_vector_divider,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_divider,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_divider,

      DATA_OUT_ENABLE => data_out_enable_vector_divider,

      -- DATA
      MODULO_IN => modulo_in_vector_divider,
      SIZE_IN   => size_in_vector_divider,
      DATA_A_IN => data_a_in_vector_divider,
      DATA_B_IN => data_b_in_vector_divider,
      DATA_OUT  => data_out_vector_divider
      );

  -- VECTOR EXPONENTIATOR
  vector_exponentiator : ntm_vector_exponentiator
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_exponentiator,
      READY => ready_vector_exponentiator,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_exponentiator,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_exponentiator,

      DATA_OUT_ENABLE => data_out_enable_vector_exponentiator,

      -- DATA
      MODULO_IN => modulo_in_vector_exponentiator,
      SIZE_IN   => size_in_vector_exponentiator,
      DATA_A_IN => data_a_in_vector_exponentiator,
      DATA_B_IN => data_b_in_vector_exponentiator,
      DATA_OUT  => data_out_vector_exponentiator
      );

  -- VECTOR ROOT
  vector_root : ntm_vector_root
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_root,
      READY => ready_vector_root,

      DATA_A_IN_ENABLE => data_a_in_enable_vector_root,
      DATA_B_IN_ENABLE => data_b_in_enable_vector_root,

      DATA_OUT_ENABLE => data_out_enable_vector_root,

      -- DATA
      MODULO_IN => modulo_in_vector_root,
      SIZE_IN   => size_in_vector_root,
      DATA_A_IN => data_a_in_vector_root,
      DATA_B_IN => data_b_in_vector_root,
      DATA_OUT  => data_out_vector_root
      );

  -- VECTOR LOGARITHM
  vector_logarithm : ntm_vector_logarithm
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_vector_logarithm,
      READY => ready_vector_logarithm,

      DATA_IN_ENABLE => data_in_enable_vector_logarithm,

      DATA_OUT_ENABLE => data_out_enable_vector_logarithm,

      -- DATA
      MODULO_IN => modulo_in_vector_logarithm,
      SIZE_IN   => size_in_vector_logarithm,
      DATA_IN   => data_in_vector_logarithm,
      DATA_OUT  => data_out_vector_logarithm
      );

  -----------------------------------------------------------------------
  -- MATRIX
  -----------------------------------------------------------------------

  -- MATRIX MOD
  matrix_mod : ntm_matrix_mod
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_mod,
      READY => ready_matrix_mod,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_mod,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_mod,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_mod,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_mod,

      -- DATA
      MODULO_IN => modulo_in_matrix_mod,
      SIZE_I_IN => size_i_in_matrix_mod,
      SIZE_J_IN => size_j_in_matrix_mod,
      DATA_IN   => data_in_matrix_mod,
      DATA_OUT  => data_out_matrix_mod
      );

  -- MATRIX ADDER
  matrix_adder : ntm_matrix_adder
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_adder,
      READY => ready_matrix_adder,

      OPERATION => operation_matrix_adder,

      DATA_A_IN_I_ENABLE => data_a_in_i_matrix_adder,
      DATA_A_IN_J_ENABLE => data_a_in_j_matrix_adder,
      DATA_B_IN_I_ENABLE => data_b_in_i_matrix_adder,
      DATA_B_IN_J_ENABLE => data_b_in_j_matrix_adder,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_adder,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_adder,

      -- DATA
      MODULO_IN => modulo_in_matrix_adder,
      SIZE_I_IN => size_i_in_matrix_adder,
      SIZE_J_IN => size_j_in_matrix_adder,
      DATA_A_IN => data_a_in_matrix_adder,
      DATA_B_IN => data_b_in_matrix_adder,
      DATA_OUT  => data_out_matrix_adder
      );

  -- MATRIX MULTIPLIER
  matrix_multiplier : ntm_matrix_multiplier
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_multiplier,
      READY => ready_matrix_multiplier,

      DATA_A_IN_I_ENABLE => data_a_in_i_matrix_multiplier,
      DATA_A_IN_J_ENABLE => data_a_in_j_matrix_multiplier,
      DATA_B_IN_I_ENABLE => data_b_in_i_matrix_multiplier,
      DATA_B_IN_J_ENABLE => data_b_in_j_matrix_multiplier,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_multiplier,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_multiplier,

      -- DATA
      MODULO_IN => modulo_in_matrix_multiplier,
      SIZE_I_IN => size_i_in_matrix_multiplier,
      SIZE_J_IN => size_j_in_matrix_multiplier,
      DATA_A_IN => data_a_in_matrix_multiplier,
      DATA_B_IN => data_b_in_matrix_multiplier,
      DATA_OUT  => data_out_matrix_multiplier
      );

  -- MATRIX INVERTER
  matrix_inverter : ntm_matrix_inverter
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_inverter,
      READY => ready_matrix_inverter,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_inverter,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_inverter,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_inverter,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_inverter,

      -- DATA
      MODULO_IN => modulo_in_matrix_inverter,
      SIZE_I_IN => size_i_in_matrix_inverter,
      SIZE_J_IN => size_j_in_matrix_inverter,
      DATA_IN   => data_in_matrix_inverter,
      DATA_OUT  => data_out_matrix_inverter
      );

  -- MATRIX DIVIDER
  matrix_divider : ntm_matrix_divider
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_divider,
      READY => ready_matrix_divider,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_divider,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_divider,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_divider,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_divider,

      DATA_OUT_I_ENABLE => data_out_i_enable_enable_matrix_divider,
      DATA_OUT_J_ENABLE => data_out_j_enable_enable_matrix_divider,

      -- DATA
      MODULO_IN => modulo_in_matrix_divider,
      SIZE_I_IN => size_i_in_matrix_divider,
      SIZE_J_IN => size_j_in_matrix_divider,
      DATA_A_IN => data_a_in_matrix_divider,
      DATA_B_IN => data_b_in_matrix_divider,
      DATA_OUT  => data_out_matrix_divider
      );

  -- MATRIX EXPONENTIATOR
  matrix_exponentiator : ntm_matrix_exponentiator
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_exponentiator,
      READY => ready_matrix_exponentiator,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_exponentiator,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_exponentiator,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_exponentiator,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_exponentiator,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_exponentiator,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_exponentiator,

      -- DATA
      MODULO_IN => modulo_in_matrix_exponentiator,
      SIZE_I_IN => size_i_in_matrix_exponentiator,
      SIZE_J_IN => size_j_in_matrix_exponentiator,
      DATA_A_IN => data_a_in_matrix_exponentiator,
      DATA_B_IN => data_b_in_matrix_exponentiator,
      DATA_OUT  => data_out_matrix_exponentiator
      );

  -- MATRIX ROOT
  matrix_root : ntm_matrix_root
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_root,
      READY => ready_matrix_root,

      DATA_A_IN_I_ENABLE => data_a_in_i_enable_matrix_root,
      DATA_A_IN_J_ENABLE => data_a_in_j_enable_matrix_root,
      DATA_B_IN_I_ENABLE => data_b_in_i_enable_matrix_root,
      DATA_B_IN_J_ENABLE => data_b_in_j_enable_matrix_root,

      DATA_OUT_I_ENABLE => data_out_i_enable_enable_matrix_root,
      DATA_OUT_J_ENABLE => data_out_j_enable_enable_matrix_root,

      -- DATA
      MODULO_IN => modulo_in_matrix_root,
      SIZE_I_IN => size_i_in_matrix_root,
      SIZE_J_IN => size_j_in_matrix_root,
      DATA_A_IN => data_a_in_matrix_root,
      DATA_B_IN => data_b_in_matrix_root,
      DATA_OUT  => data_out_matrix_root
      );

  -- MATRIX LOGARITHM
  matrix_logarithm : ntm_matrix_logarithm
    generic map (
      DATA_SIZE => DATA_SIZE
      )
    port map (
      -- GLOBAL
      CLK => CLK,
      RST => RST,

      -- CONTROL
      START => start_matrix_logarithm,
      READY => ready_matrix_logarithm,

      DATA_IN_I_ENABLE => data_in_i_enable_matrix_logarithm,
      DATA_IN_J_ENABLE => data_in_j_enable_matrix_logarithm,

      DATA_OUT_I_ENABLE => data_out_i_enable_matrix_logarithm,
      DATA_OUT_J_ENABLE => data_out_j_enable_matrix_logarithm,

      -- DATA
      MODULO_IN => modulo_in_matrix_logarithm,
      SIZE_I_IN => size_i_in_matrix_logarithm,
      SIZE_J_IN => size_j_in_matrix_logarithm,
      DATA_IN   => data_in_matrix_logarithm,
      DATA_OUT  => data_out_matrix_logarithm
      );

end ntm_arithmetic_testbench_architecture;
